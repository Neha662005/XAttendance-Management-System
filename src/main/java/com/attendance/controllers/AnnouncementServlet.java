package com.attendance.controllers;

import com.attendance.model.Announcement;
import com.attendance.model.User;
import com.attendance.service.AnnouncementService;
import com.attendance.service.AuditService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;

/**
 * AnnouncementServlet manages system announcements.
 *
 * GET  /announcements               → list all announcements
 * POST /announcements?action=add    → create new announcement
 * POST /announcements?action=toggle → activate / deactivate
 * POST /announcements?action=delete → delete announcement
 */
@WebServlet("/announcements")
public class AnnouncementServlet extends HttpServlet {

    private AnnouncementService announcementService;

    @Override
    public void init() {
        announcementService = new AnnouncementService();
    }

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        User user = (User) session.getAttribute("loggedInUser");

        if (!user.canManageAnnouncements()) {
            response.sendRedirect(
                request.getContextPath() + "/dashboard");
            return;
        }

        List<Announcement> announcements =
            announcementService.getAllAnnouncements(user.getOrgId());

        request.setAttribute("announcements", announcements);
        request.setAttribute("pageTitle",     "Announcements");
        request.setAttribute("pageSubtitle",
            announcements.size() + " announcements");

        request.getRequestDispatcher(
            "/WEB-INF/pages/announcements/index.jsp")
            .forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        User user   = (User) session.getAttribute("loggedInUser");
        String action = request.getParameter("action");

        if (!user.canManageAnnouncements()) {
            response.sendRedirect(
                request.getContextPath() + "/dashboard");
            return;
        }

        switch (action == null ? "" : action) {

            case "add": {
                String title   = request.getParameter("title");
                String message = request.getParameter("message");

                if (isEmpty(title) || isEmpty(message)) {
                    session.setAttribute("flashError",
                        "Title and message are required.");
                    break;
                }

                Announcement a = new Announcement();
                a.setOrgId(user.getOrgId());
                a.setCreatedBy(user.getId());
                a.setTitle(title.trim());
                a.setMessage(message.trim());

                boolean ok = announcementService.addAnnouncement(a);
                if (ok) {
                    AuditService.log(user.getId(),
                        "ANNOUNCEMENT_ADDED",
                        "announcements", 0,
                        null, title,
                        request.getRemoteAddr());
                    session.setAttribute("flashMessage",
                        "Announcement published successfully.");
                } else {
                    session.setAttribute("flashError",
                        "Could not publish announcement.");
                }
                break;
            }

            case "toggle": {
                String idStr     = request.getParameter("announcementId");
                String activeStr = request.getParameter("active");
                if (isEmpty(idStr)) {
                    session.setAttribute("flashError", "Invalid request.");
                    break;
                }
                boolean active = "true".equals(activeStr);
                int id = Integer.parseInt(idStr);
                boolean ok = announcementService.toggleActive(id, active);
                if (ok) {
                    session.setAttribute("flashMessage",
                        "Announcement " +
                        (active ? "activated." : "deactivated."));
                } else {
                    session.setAttribute("flashError",
                        "Could not update announcement.");
                }
                break;
            }

            case "delete": {
                String idStr = request.getParameter("announcementId");
                if (isEmpty(idStr)) {
                    session.setAttribute("flashError", "Invalid request.");
                    break;
                }
                int id = Integer.parseInt(idStr);
                boolean ok = announcementService.deleteAnnouncement(id);
                if (ok) {
                    session.setAttribute("flashMessage",
                        "Announcement deleted.");
                } else {
                    session.setAttribute("flashError",
                        "Could not delete announcement.");
                }
                break;
            }

            default:
                session.setAttribute("flashError", "Unknown action.");
        }

        response.sendRedirect(
            request.getContextPath() + "/announcements");
    }

    private boolean isEmpty(String s) {
        return s == null || s.trim().isEmpty();
    }
}