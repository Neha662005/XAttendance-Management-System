package com.attendance.controllers;

import com.attendance.model.User;
import com.attendance.service.AuditService;
import com.attendance.service.UserService;
import com.attendance.service.DepartmentService;
import com.attendance.service.ShiftService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;

/**
 * UserServlet manages users within an organization.
 *
 * GET  /users                    → list all users
 * POST /users?action=activate    → activate a user
 * POST /users?action=deactivate  → deactivate a user
 * POST /users?action=role        → change user role
 */
@WebServlet("/users")
public class UserServlet extends HttpServlet {

    private UserService       userService;
    private DepartmentService deptService;
    private ShiftService      shiftService;

    @Override
    public void init() {
        userService  = new UserService();
        deptService  = new DepartmentService();
        shiftService = new ShiftService();
    }

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        User admin = (User) session.getAttribute("loggedInUser");

        if (!admin.canManageUsers()) {
            response.sendRedirect(
                request.getContextPath() + "/dashboard");
            return;
        }

        List<User> users =
            userService.getUsersByOrg(admin.getOrgId());

        request.setAttribute("users",       users);
        request.setAttribute("pageTitle",   "Manage Users");
        request.setAttribute("pageSubtitle",
            users.size() + " users in your organization");

        request.getRequestDispatcher(
            "/WEB-INF/pages/users/list.jsp")
            .forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        User admin  = (User) session.getAttribute("loggedInUser");
        String action = request.getParameter("action");
        String userIdStr = request.getParameter("userId");

        if (!admin.canManageUsers() || userIdStr == null) {
            response.sendRedirect(
                request.getContextPath() + "/dashboard");
            return;
        }

        int targetId = Integer.parseInt(userIdStr);

        // Prevent self-modification
        if (targetId == admin.getId()) {
            session.setAttribute("flashError",
                "You cannot modify your own account.");
            response.sendRedirect(
                request.getContextPath() + "/users");
            return;
        }

        switch (action == null ? "" : action) {

            case "activate": {
                boolean ok =
                    userService.setActiveStatus(targetId, true);
                if (ok) {
                    AuditService.log(admin.getId(),
                        "USER_ACTIVATED",
                        "users", targetId,
                        "inactive", "active",
                        request.getRemoteAddr());
                    session.setAttribute("flashMessage",
                        "User account activated successfully.");
                } else {
                    session.setAttribute("flashError",
                        "Could not activate user.");
                }
                break;
            }

            case "deactivate": {
                boolean ok =
                    userService.setActiveStatus(targetId, false);
                if (ok) {
                    AuditService.log(admin.getId(),
                        "USER_DEACTIVATED",
                        "users", targetId,
                        "active", "inactive",
                        request.getRemoteAddr());
                    session.setAttribute("flashMessage",
                        "User account deactivated.");
                } else {
                    session.setAttribute("flashError",
                        "Could not deactivate user.");
                }
                break;
            }

            case "role": {
                if (!admin.isAdmin()) {
                    session.setAttribute("flashError",
                        "Only admins can change roles.");
                    break;
                }
                String newRole = request.getParameter("role");
                if (newRole == null || newRole.isEmpty()) {
                    session.setAttribute("flashError",
                        "Invalid role selected.");
                    break;
                }
                boolean ok =
                    userService.updateRole(targetId, newRole);
                if (ok) {
                    AuditService.log(admin.getId(),
                        "USER_ROLE_CHANGED",
                        "users", targetId,
                        null, newRole,
                        request.getRemoteAddr());
                    session.setAttribute("flashMessage",
                        "User role updated to " + newRole + ".");
                } else {
                    session.setAttribute("flashError",
                        "Could not update role.");
                }
                break;
            }

            default:
                session.setAttribute("flashError",
                    "Unknown action.");
        }

        response.sendRedirect(
            request.getContextPath() + "/users");
    }
}