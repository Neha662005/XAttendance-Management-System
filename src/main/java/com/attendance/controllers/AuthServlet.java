package com.attendance.controllers;

import com.attendance.model.User;
import com.attendance.service.AuditService;
import com.attendance.service.UserService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

/**
 * AuthServlet handles login and logout.
 *
 * GET  /auth              → show login page
 * GET  /auth?action=logout → invalidate session and redirect
 * POST /auth              → validate credentials and create session
 */
@WebServlet("/auth")
public class AuthServlet extends HttpServlet {

    private UserService userService;

    @Override
    public void init() {
        userService = new UserService();
    }

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");

        // Logout
        if ("logout".equals(action)) {
            HttpSession session = request.getSession(false);
            if (session != null) {
                User user = (User) session.getAttribute("loggedInUser");
                if (user != null) {
                    AuditService.log(
                        user.getId(), "USER_LOGOUT",
                        request.getRemoteAddr()
                    );
                }
                session.invalidate();
            }
            response.sendRedirect(request.getContextPath() + "/auth");
            return;
        }

        // Already logged in → go to dashboard
        HttpSession session = request.getSession(false);
        if (session != null && session.getAttribute("loggedInUser") != null) {
            response.sendRedirect(request.getContextPath() + "/dashboard");
            return;
        }

        request.getRequestDispatcher("/WEB-INF/pages/auth/login.jsp")
               .forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        String email    = request.getParameter("email");
        String password = request.getParameter("password");

        // Empty field check
        if (isEmpty(email) || isEmpty(password)) {
            request.setAttribute("errorMessage",
                "Please enter both email and password.");
            request.setAttribute("prevEmail", email);
            request.getRequestDispatcher("/WEB-INF/pages/auth/login.jsp")
                   .forward(request, response);
            return;
        }

        // Brute-force lock check
        if (userService.isAccountLocked(email.trim())) {
            request.setAttribute("errorMessage",
                "Your account is temporarily locked due to too many " +
                "failed attempts. Please try again in 15 minutes.");
            request.setAttribute("prevEmail", email);
            request.getRequestDispatcher("/WEB-INF/pages/auth/login.jsp")
                   .forward(request, response);
            return;
        }

        // Attempt login
        User user = userService.login(email.trim(), password);

        if (user != null) {
            HttpSession session = request.getSession(true);
            session.setAttribute("loggedInUser", user);
            session.setAttribute("userId",       user.getId());
            session.setAttribute("userRole",     user.getRole());
            session.setAttribute("orgId",        user.getOrgId());
            session.setMaxInactiveInterval(60 * 60); // 1 hour

            AuditService.log(
                user.getId(), "USER_LOGIN",
                request.getRemoteAddr()
            );

            response.sendRedirect(request.getContextPath() + "/dashboard");

        } else {
            request.setAttribute("errorMessage",
                "Invalid email or password. Please try again.");
            request.setAttribute("prevEmail", email);
            request.getRequestDispatcher("/WEB-INF/pages/auth/login.jsp")
                   .forward(request, response);
        }
    }

    private boolean isEmpty(String s) {
        return s == null || s.trim().isEmpty();
    }
}