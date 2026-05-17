package com.attendance.controllers;

import com.attendance.model.AttendanceRecord;
import com.attendance.model.User;
import com.attendance.service.AttendanceService;
import com.attendance.service.AuditService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

/**
 * AttendanceServlet handles all attendance actions.
 *
 * GET  /attendance                  → mark attendance page
 * GET  /attendance?action=history   → attendance history page
 * POST /attendance?action=checkin   → record check-in
 * POST /attendance?action=checkout  → record check-out
 * POST /attendance?action=startbreak → record break start
 * POST /attendance?action=endbreak  → record break end
 */
@WebServlet("/attendance")
public class AttendanceServlet extends HttpServlet {

    private AttendanceService attendanceService;

    @Override
    public void init() {
        attendanceService = new AttendanceService();
    }

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        User user = (User) session.getAttribute("loggedInUser");
        String action = request.getParameter("action");

        if ("history".equals(action)) {

            // Default date range — current month
            String fromDate = request.getParameter("fromDate");
            String toDate   = request.getParameter("toDate");

            if (fromDate == null || fromDate.isEmpty()) {
                fromDate = new SimpleDateFormat("yyyy-MM-01")
                               .format(new Date());
            }
            if (toDate == null || toDate.isEmpty()) {
                toDate = new SimpleDateFormat("yyyy-MM-dd")
                             .format(new Date());
            }

            List<AttendanceRecord> history =
                attendanceService.getHistory(
                    user.getId(), fromDate, toDate);

            request.setAttribute("history",   history);
            request.setAttribute("fromDate",  fromDate);
            request.setAttribute("toDate",    toDate);
            request.setAttribute("pageTitle", "Attendance History");
            request.setAttribute("pageSubtitle",
                "Your attendance records");

            request.getRequestDispatcher(
                "/WEB-INF/pages/attendance/history.jsp")
                .forward(request, response);

        } else {

            // Mark attendance page — show today's record
            AttendanceRecord todayRecord =
                attendanceService.getTodayRecord(user.getId());

            request.setAttribute("todayRecord", todayRecord);
            request.setAttribute("pageTitle",   "Mark Attendance");
            request.setAttribute("pageSubtitle",
                new SimpleDateFormat("EEEE, dd MMMM yyyy")
                    .format(new Date()));

            request.getRequestDispatcher(
                "/WEB-INF/pages/attendance/mark.jsp")
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

        switch (action == null ? "" : action) {

            case "checkin": {
                boolean ok = attendanceService.checkIn(user.getId());
                if (ok) {
                    AuditService.log(user.getId(),
                        "ATTENDANCE_CHECKIN",
                        request.getRemoteAddr());
                    session.setAttribute("flashMessage",
                        "Checked in successfully. Have a great day!");
                } else {
                    session.setAttribute("flashError",
                        "You have already checked in today.");
                }
                response.sendRedirect(
                    request.getContextPath() + "/dashboard");
                break;
            }

            case "checkout": {
                boolean ok = attendanceService.checkOut(user.getId());
                if (ok) {
                    AuditService.log(user.getId(),
                        "ATTENDANCE_CHECKOUT",
                        request.getRemoteAddr());
                    session.setAttribute("flashMessage",
                        "Checked out successfully. See you tomorrow!");
                } else {
                    session.setAttribute("flashError",
                        "No check-in found for today, or " +
                        "you have already checked out.");
                }
                response.sendRedirect(
                    request.getContextPath() + "/dashboard");
                break;
            }

            case "startbreak": {
                boolean ok = attendanceService.startBreak(user.getId());
                if (ok) {
                    session.setAttribute("flashMessage",
                        "Break started. Enjoy your break!");
                } else {
                    session.setAttribute("flashError",
                        "Could not start break. " +
                        "Please check in first.");
                }
                response.sendRedirect(
                    request.getContextPath() + "/dashboard");
                break;
            }

            case "endbreak": {
                boolean ok = attendanceService.endBreak(user.getId());
                if (ok) {
                    session.setAttribute("flashMessage",
                        "Break ended. Welcome back!");
                } else {
                    session.setAttribute("flashError",
                        "No active break found.");
                }
                response.sendRedirect(
                    request.getContextPath() + "/dashboard");
                break;
            }

            default:
                response.sendRedirect(
                    request.getContextPath() + "/attendance");
        }
    }
}