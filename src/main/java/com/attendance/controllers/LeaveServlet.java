package com.attendance.controllers;

import com.attendance.model.*;
import com.attendance.service.*;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.Date;
import java.util.List;

/**
 * LeaveServlet handles all leave workflows.
 *
 * GET  /leave                   → apply form + balances + history
 * GET  /leave?action=approve    → pending approvals (admin/hr/manager)
 * POST /leave?action=apply      → submit new leave request
 * POST /leave?action=approve    → approve a request
 * POST /leave?action=reject     → reject a request
 */
@WebServlet("/leave")
public class LeaveServlet extends HttpServlet {

    private LeaveService leaveService;

    @Override
    public void init() {
        leaveService = new LeaveService();
    }

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        User user   = (User) session.getAttribute("loggedInUser");
        String action = request.getParameter("action");

        if ("approve".equals(action)) {

            // Block employees
            if (!user.canApproveLeave()) {
                response.sendRedirect(
                    request.getContextPath() + "/dashboard");
                return;
            }

            List<LeaveRequest> pending =
                leaveService.getPendingLeavesByOrg(user.getOrgId());

            request.setAttribute("pendingLeaves", pending);
            request.setAttribute("pageTitle",
                "Leave Approvals");
            request.setAttribute("pageSubtitle",
                pending.size() + " pending request(s)");

            request.getRequestDispatcher(
                "/WEB-INF/pages/leave/approval.jsp")
                .forward(request, response);

        } else {

            // Apply page — load types, balances, history
            List<LeaveType>    types    =
                leaveService.getLeaveTypes(user.getOrgId());
            List<LeaveBalance> balances =
                leaveService.getBalances(user.getId());
            List<LeaveRequest> myLeaves =
                leaveService.getLeavesByUser(user.getId());

            request.setAttribute("leaveTypes", types);
            request.setAttribute("balances",   balances);
            request.setAttribute("myLeaves",   myLeaves);
            request.setAttribute("pageTitle",  "Leave Request");
            request.setAttribute("pageSubtitle",
                "Apply for leave and view your history");

            request.getRequestDispatcher(
                "/WEB-INF/pages/leave/apply.jsp")
                .forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        User user   = (User) session.getAttribute("loggedInUser");
        String action = request.getParameter("action");

        // ── Apply ─────────────────────────────────────────────────────────
        if ("apply".equals(action)) {

            String leaveTypeIdStr = request.getParameter("leaveTypeId");
            String fromDateStr    = request.getParameter("fromDate");
            String toDateStr      = request.getParameter("toDate");
            String reason         = request.getParameter("reason");

            // Validation
            if (isEmpty(leaveTypeIdStr) ||
                isEmpty(fromDateStr)    ||
                isEmpty(toDateStr)) {
                session.setAttribute("flashError",
                    "Please fill in all required fields.");
                response.sendRedirect(
                    request.getContextPath() + "/leave");
                return;
            }

            if (fromDateStr.compareTo(toDateStr) > 0) {
                session.setAttribute("flashError",
                    "From date cannot be after the to date.");
                response.sendRedirect(
                    request.getContextPath() + "/leave");
                return;
            }

            // Calculate total days
            Date from  = Date.valueOf(fromDateStr);
            Date to    = Date.valueOf(toDateStr);
            long diff  = to.getTime() - from.getTime();
            int  days  = (int)(diff / (1000 * 60 * 60 * 24)) + 1;

            LeaveRequest leave = new LeaveRequest();
            leave.setUserId(user.getId());
            leave.setLeaveTypeId(
                Integer.parseInt(leaveTypeIdStr));
            leave.setFromDate(from);
            leave.setToDate(to);
            leave.setTotalDays(days);
            leave.setReason(reason);

            boolean ok = leaveService.applyLeave(leave);

            if (ok) {
                AuditService.log(user.getId(),
                    "LEAVE_APPLIED",
                    "leave_requests", 0,
                    null, days + " days",
                    request.getRemoteAddr());
                session.setAttribute("flashMessage",
                    "Leave request submitted successfully. " +
                    "Awaiting approval.");
            } else {
                session.setAttribute("flashError",
                    "Could not submit request. " +
                    "You may have insufficient leave balance.");
            }

            response.sendRedirect(
                request.getContextPath() + "/leave");
            return;
        }

        // ── Approve ───────────────────────────────────────────────────────
        if ("approve".equals(action)) {

            if (!user.canApproveLeave()) {
                response.sendRedirect(
                    request.getContextPath() + "/dashboard");
                return;
            }

            String leaveIdStr = request.getParameter("leaveId");
            String note       = request.getParameter("approvalNote");

            if (isEmpty(leaveIdStr)) {
                session.setAttribute("flashError", "Invalid request.");
                response.sendRedirect(
                    request.getContextPath() + "/leave?action=approve");
                return;
            }

            int leaveId = Integer.parseInt(leaveIdStr);
            boolean ok  = leaveService.updateLeaveStatus(
                leaveId, "APPROVED", user.getId(), note);

            if (ok) {
                AuditService.log(user.getId(),
                    "LEAVE_APPROVED",
                    "leave_requests", leaveId,
                    "PENDING", "APPROVED",
                    request.getRemoteAddr());
                session.setAttribute("flashMessage",
                    "Leave request approved successfully.");
            } else {
                session.setAttribute("flashError",
                    "Could not approve request. " +
                    "It may have already been actioned.");
            }

            response.sendRedirect(
                request.getContextPath() + "/leave?action=approve");
            return;
        }

        // ── Reject ────────────────────────────────────────────────────────
        if ("reject".equals(action)) {

            if (!user.canApproveLeave()) {
                response.sendRedirect(
                    request.getContextPath() + "/dashboard");
                return;
            }

            String leaveIdStr = request.getParameter("leaveId");
            String note       = request.getParameter("approvalNote");

            if (isEmpty(leaveIdStr)) {
                session.setAttribute("flashError", "Invalid request.");
                response.sendRedirect(
                    request.getContextPath() + "/leave?action=approve");
                return;
            }

            int leaveId = Integer.parseInt(leaveIdStr);
            boolean ok  = leaveService.updateLeaveStatus(
                leaveId, "REJECTED", user.getId(), note);

            if (ok) {
                AuditService.log(user.getId(),
                    "LEAVE_REJECTED",
                    "leave_requests", leaveId,
                    "PENDING", "REJECTED",
                    request.getRemoteAddr());
                session.setAttribute("flashMessage",
                    "Leave request rejected.");
            } else {
                session.setAttribute("flashError",
                    "Could not reject request. " +
                    "It may have already been actioned.");
            }

            response.sendRedirect(
                request.getContextPath() + "/leave?action=approve");
            return;
        }

        response.sendRedirect(
            request.getContextPath() + "/leave");
    }

    private boolean isEmpty(String s) {
        return s == null || s.trim().isEmpty();
    }
}