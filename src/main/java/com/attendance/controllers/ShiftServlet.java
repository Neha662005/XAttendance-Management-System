package com.attendance.controllers;

import com.attendance.model.Shift;
import com.attendance.model.User;
import com.attendance.service.AuditService;
import com.attendance.service.ShiftService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;

/**
 * ShiftServlet manages work shifts.
 *
 * GET  /shift                    → list all shifts
 * POST /shift?action=add         → add shift
 * POST /shift?action=edit        → edit shift
 * POST /shift?action=toggle      → activate / deactivate
 */
@WebServlet("/shift")
public class ShiftServlet extends HttpServlet {

    private ShiftService shiftService;

    @Override
    public void init() {
        shiftService = new ShiftService();
    }

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        User user = (User) session.getAttribute("loggedInUser");

        if (!user.canManageShifts()) {
            response.sendRedirect(
                request.getContextPath() + "/dashboard");
            return;
        }

        List<Shift> shifts =
            shiftService.getShiftsByOrg(user.getOrgId());

        request.setAttribute("shifts",      shifts);
        request.setAttribute("pageTitle",   "Shifts");
        request.setAttribute("pageSubtitle",
            shifts.size() + " shifts configured");

        request.getRequestDispatcher(
            "/WEB-INF/pages/shift/index.jsp")
            .forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        User user   = (User) session.getAttribute("loggedInUser");
        String action = request.getParameter("action");

        if (!user.canManageShifts()) {
            response.sendRedirect(
                request.getContextPath() + "/dashboard");
            return;
        }

        switch (action == null ? "" : action) {

            case "add": {
                String name    = request.getParameter("name");
                String start   = request.getParameter("startTime");
                String end     = request.getParameter("endTime");
                String graceStr= request.getParameter("graceMinutes");

                if (name == null || name.trim().isEmpty() ||
                    start == null || end == null) {
                    session.setAttribute("flashError",
                        "Please fill in all required fields.");
                    break;
                }

                Shift s = new Shift();
                s.setOrgId(user.getOrgId());
                s.setName(name.trim());
                s.setStartTime(start);
                s.setEndTime(end);
                s.setGraceMinutes(graceStr != null &&
                    !graceStr.isEmpty()
                    ? Integer.parseInt(graceStr) : 15);

                boolean ok = shiftService.addShift(s);
                if (ok) {
                    session.setAttribute("flashMessage",
                        "Shift \"" + name + "\" added.");
                } else {
                    session.setAttribute("flashError",
                        "Could not add shift.");
                }
                break;
            }

            case "edit": {
                String idStr   = request.getParameter("shiftId");
                String name    = request.getParameter("name");
                String start   = request.getParameter("startTime");
                String end     = request.getParameter("endTime");
                String graceStr= request.getParameter("graceMinutes");

                if (idStr == null || name == null ||
                    name.trim().isEmpty()) {
                    session.setAttribute("flashError",
                        "Invalid request.");
                    break;
                }

                Shift s = new Shift();
                s.setId(Integer.parseInt(idStr));
                s.setName(name.trim());
                s.setStartTime(start);
                s.setEndTime(end);
                s.setGraceMinutes(graceStr != null &&
                    !graceStr.isEmpty()
                    ? Integer.parseInt(graceStr) : 15);

                boolean ok = shiftService.updateShift(s);
                if (ok) {
                    session.setAttribute("flashMessage",
                        "Shift updated successfully.");
                } else {
                    session.setAttribute("flashError",
                        "Could not update shift.");
                }
                break;
            }

            case "toggle": {
                String idStr     = request.getParameter("shiftId");
                String activeStr = request.getParameter("active");
                if (idStr == null) {
                    session.setAttribute("flashError",
                        "Invalid request.");
                    break;
                }
                boolean active = "true".equals(activeStr);
                boolean ok = shiftService.toggleActive(
                    Integer.parseInt(idStr), active);
                if (ok) {
                    session.setAttribute("flashMessage",
                        "Shift " + (active
                            ? "activated." : "deactivated."));
                } else {
                    session.setAttribute("flashError",
                        "Could not update shift status.");
                }
                break;
            }

            default:
                session.setAttribute("flashError",
                    "Unknown action.");
        }

        response.sendRedirect(
            request.getContextPath() + "/shift");
    }
}