package com.attendance.controllers;

import com.attendance.model.AuditLog;
import com.attendance.model.User;
import com.attendance.service.AuditService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;

/**
 * AuditServlet displays the audit log.
 *
 * GET /audit          → show last 200 entries
 * GET /audit?limit=N  → show last N entries
 */
@WebServlet("/audit")
public class AuditServlet extends HttpServlet {

    private AuditService auditService;

    @Override
    public void init() {
        auditService = new AuditService();
    }

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        User user = (User) session.getAttribute("loggedInUser");

        if (!user.canViewAuditLog()) {
            response.sendRedirect(
                request.getContextPath() + "/dashboard");
            return;
        }

        String limitStr = request.getParameter("limit");
        int limit = 200;
        try {
            if (limitStr != null && !limitStr.isEmpty()) {
                limit = Integer.parseInt(limitStr);
            }
        } catch (NumberFormatException ignored) {}

        List<AuditLog> logs =
            auditService.getLogs(user.getOrgId(), limit);

        request.setAttribute("logs",        logs);
        request.setAttribute("limit",       limit);
        request.setAttribute("pageTitle",   "Audit Log");
        request.setAttribute("pageSubtitle",
            "Last " + logs.size() + " system actions");

        request.getRequestDispatcher(
            "/WEB-INF/pages/audit/index.jsp")
            .forward(request, response);
    }
}