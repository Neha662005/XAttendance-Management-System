package com.attendance.controllers;

import com.attendance.model.User;
import com.attendance.service.UserService;
import com.attendance.service.AuditService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

/**
 * ProfileServlet handles the user's own profile page.
 *
 * GET  /profile              → show profile page
 * POST /profile?action=update → update name, phone, designation
 * POST /profile?action=password → change password
 */
@WebServlet("/profile")
public class ProfileServlet extends HttpServlet {

    private UserService userService;

    @Override
    public void init() {
        userService = new UserService();
    }

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        User user = (User) session.getAttribute("loggedInUser");

        // Refresh user from DB to get latest data
        User freshUser = userService.getUserById(user.getId());
        if (freshUser != null) {
            session.setAttribute("loggedInUser", freshUser);
            user = freshUser;
        }

        request.setAttribute("pageTitle",   "My Profile");
        request.setAttribute("pageSubtitle", user.getDesignation() != null
            ? user.getDesignation() : "");

        request.getRequestDispatcher(
            "/WEB-INF/pages/profile/index.jsp")
            .forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        User user   = (User) session.getAttribute("loggedInUser");
        String action = request.getParameter("action");

        // ── Update profile info ──────────────────────────────────────────────
        if ("update".equals(action)) {
            String fullName    = request.getParameter("fullName");
            String phone       = request.getParameter("phone");
            String designation = request.getParameter("designation");

            if (fullName == null || fullName.trim().isEmpty()) {
                session.setAttribute("flashError",
                    "Full name cannot be empty.");
                response.sendRedirect(
                    request.getContextPath() + "/profile");
                return;
            }

            boolean ok = userService.updateProfile(
                user.getId(),
                fullName.trim(),
                phone    != null ? phone.trim()       : "",
                designation != null ? designation.trim() : ""
            );

            if (ok) {
                // Refresh session with updated data
                User updated = userService.getUserById(user.getId());
                if (updated != null) {
                    session.setAttribute("loggedInUser", updated);
                }
                AuditService.log(user.getId(),
                    "PROFILE_UPDATED",
                    request.getRemoteAddr());
                session.setAttribute("flashMessage",
                    "Profile updated successfully.");
            } else {
                session.setAttribute("flashError",
                    "Could not update profile. Please try again.");
            }

            response.sendRedirect(
                request.getContextPath() + "/profile");
            return;
        }

        // ── Change password ──────────────────────────────────────────────────
        if ("password".equals(action)) {
            String currentPass = request.getParameter("currentPassword");
            String newPass     = request.getParameter("newPassword");
            String confirmPass = request.getParameter("confirmPassword");

            if (isEmpty(currentPass) || isEmpty(newPass) ||
                isEmpty(confirmPass)) {
                session.setAttribute("flashError",
                    "Please fill in all password fields.");
                response.sendRedirect(
                    request.getContextPath() + "/profile");
                return;
            }

            if (newPass.length() < 8) {
                session.setAttribute("flashError",
                    "New password must be at least 8 characters.");
                response.sendRedirect(
                    request.getContextPath() + "/profile");
                return;
            }

            if (!newPass.equals(confirmPass)) {
                session.setAttribute("flashError",
                    "New passwords do not match.");
                response.sendRedirect(
                    request.getContextPath() + "/profile");
                return;
            }

            // Verify current password first
            User verified = userService.login(
                user.getEmail(), currentPass);

            if (verified == null) {
                session.setAttribute("flashError",
                    "Current password is incorrect.");
                response.sendRedirect(
                    request.getContextPath() + "/profile");
                return;
            }

            boolean ok = userService.updatePassword(
                user.getId(), newPass);

            if (ok) {
                AuditService.log(user.getId(),
                    "PASSWORD_CHANGED",
                    request.getRemoteAddr());
                session.setAttribute("flashMessage",
                    "Password changed successfully.");
            } else {
                session.setAttribute("flashError",
                    "Could not change password. Please try again.");
            }

            response.sendRedirect(
                request.getContextPath() + "/profile");
            return;
        }

        response.sendRedirect(
            request.getContextPath() + "/profile");
    }

    private boolean isEmpty(String s) {
        return s == null || s.trim().isEmpty();
    }
}