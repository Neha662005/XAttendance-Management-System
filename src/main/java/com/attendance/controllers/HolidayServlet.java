package com.attendance.controllers;

import com.attendance.model.Holiday;
import com.attendance.model.User;
import com.attendance.service.AuditService;
import com.attendance.service.HolidayService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.Date;
import java.util.List;

/**
 * HolidayServlet manages public holidays.
 *
 * GET  /holiday                  → list all holidays
 * POST /holiday?action=add       → add holiday
 * POST /holiday?action=delete    → delete holiday
 */
@WebServlet("/holiday")
public class HolidayServlet extends HttpServlet {

    private HolidayService holidayService;

    @Override
    public void init() {
        holidayService = new HolidayService();
    }

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        User user = (User) session.getAttribute("loggedInUser");

        if (!user.canManageHolidays()) {
            response.sendRedirect(
                request.getContextPath() + "/dashboard");
            return;
        }

        List<Holiday> holidays =
            holidayService.getHolidaysByOrg(user.getOrgId());

        request.setAttribute("holidays",    holidays);
        request.setAttribute("pageTitle",   "Holidays");
        request.setAttribute("pageSubtitle",
            holidays.size() + " holidays this year");

        request.getRequestDispatcher(
            "/WEB-INF/pages/holiday/index.jsp")
            .forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        User user   = (User) session.getAttribute("loggedInUser");
        String action = request.getParameter("action");

        if (!user.canManageHolidays()) {
            response.sendRedirect(
                request.getContextPath() + "/dashboard");
            return;
        }

        switch (action == null ? "" : action) {

            case "add": {
                String name    = request.getParameter("name");
                String dateStr = request.getParameter("holidayDate");
                String desc    = request.getParameter("description");

                if (name == null || name.trim().isEmpty() ||
                    dateStr == null || dateStr.isEmpty()) {
                    session.setAttribute("flashError",
                        "Holiday name and date are required.");
                    break;
                }

                Holiday h = new Holiday();
                h.setOrgId(user.getOrgId());
                h.setName(name.trim());
                h.setHolidayDate(Date.valueOf(dateStr));
                h.setDescription(desc);

                boolean ok = holidayService.addHoliday(h);
                if (ok) {
                    AuditService.log(user.getId(),
                        "HOLIDAY_ADDED",
                        "holidays", 0,
                        null, name + " on " + dateStr,
                        request.getRemoteAddr());
                    session.setAttribute("flashMessage",
                        "Holiday \"" + name + "\" added.");
                } else {
                    session.setAttribute("flashError",
                        "Could not add holiday.");
                }
                break;
            }

            case "delete": {
                String idStr = request.getParameter("holidayId");
                if (idStr == null) {
                    session.setAttribute("flashError",
                        "Invalid request.");
                    break;
                }
                int id = Integer.parseInt(idStr);
                boolean ok = holidayService.deleteHoliday(id);
                if (ok) {
                    session.setAttribute("flashMessage",
                        "Holiday deleted.");
                } else {
                    session.setAttribute("flashError",
                        "Could not delete holiday.");
                }
                break;
            }

            default:
                session.setAttribute("flashError",
                    "Unknown action.");
        }

        response.sendRedirect(
            request.getContextPath() + "/holiday");
    }
}