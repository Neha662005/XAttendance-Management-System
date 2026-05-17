package com.attendance.controllers;

import com.attendance.config.DBConfig;
import com.attendance.model.User;
import com.attendance.service.AuditService;
import com.attendance.service.UserService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * RegisterServlet handles new user self-registration.
 *
 * GET  /register → show registration form with org dropdown
 * POST /register → validate, create account, redirect to login
 */
@WebServlet("/register")
public class RegisterServlet extends HttpServlet {

    private UserService userService;

    @Override
    public void init() {
        userService = new UserService();
    }

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        // Already logged in
        HttpSession session = request.getSession(false);
        if (session != null && session.getAttribute("loggedInUser") != null) {
            response.sendRedirect(request.getContextPath() + "/dashboard");
            return;
        }

        loadOrganizations(request);
        request.getRequestDispatcher("/WEB-INF/pages/auth/register.jsp")
               .forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        String fullName    = request.getParameter("fullName");
        String email       = request.getParameter("email");
        String password    = request.getParameter("password");
        String confirmPass = request.getParameter("confirmPassword");
        String phone       = request.getParameter("phone");
        String employeeId  = request.getParameter("employeeId");
        String designation = request.getParameter("designation");
        String orgIdStr    = request.getParameter("orgId");
        String deptIdStr   = request.getParameter("deptId");
        String shiftIdStr  = request.getParameter("shiftId");

        // ── Validation ────────────────────────────────────────────────────────

        if (isEmpty(fullName) || isEmpty(email) ||
            isEmpty(password) || isEmpty(orgIdStr)) {
            setError(request, "Please fill in all required fields.",
                     fullName, email, phone, employeeId, designation, orgIdStr);
            forwardBack(request, response);
            return;
        }

        if (!email.matches("^[\\w.+-]+@[\\w.-]+\\.[a-zA-Z]{2,}$")) {
            setError(request, "Please enter a valid email address.",
                     fullName, email, phone, employeeId, designation, orgIdStr);
            forwardBack(request, response);
            return;
        }

        if (password.length() < 8) {
            setError(request,
                     "Password must be at least 8 characters long.",
                     fullName, email, phone, employeeId, designation, orgIdStr);
            forwardBack(request, response);
            return;
        }

        if (!password.equals(confirmPass)) {
            setError(request, "Passwords do not match. Please try again.",
                     fullName, email, phone, employeeId, designation, orgIdStr);
            forwardBack(request, response);
            return;
        }

        if (userService.emailExists(email.trim())) {
            setError(request,
                     "An account with this email already exists. " +
                     "Please sign in instead.",
                     fullName, email, phone, employeeId, designation, orgIdStr);
            forwardBack(request, response);
            return;
        }

        // ── Build and save ────────────────────────────────────────────────────

        try {
            int orgId   = Integer.parseInt(orgIdStr);
            int deptId  = (deptIdStr  != null && !deptIdStr.isEmpty())
                          ? Integer.parseInt(deptIdStr) : 0;
            int shiftId = (shiftIdStr != null && !shiftIdStr.isEmpty())
                          ? Integer.parseInt(shiftIdStr) : 0;

            User user = new User();
            user.setFullName(fullName.trim());
            user.setEmail(email.trim().toLowerCase());
            user.setPasswordHash(password);
            user.setPhone(phone       != null ? phone.trim()       : "");
            user.setEmployeeId(employeeId != null ? employeeId.trim() : "");
            user.setDesignation(designation != null ? designation.trim() : "");
            user.setOrgId(orgId);
            user.setDeptId(deptId);
            user.setShiftId(shiftId);

            boolean ok = userService.registerUser(user);

            if (ok) {
                AuditService.log(0,
                    "USER_REGISTERED: " + email,
                    request.getRemoteAddr());

                request.getSession(true)
                       .setAttribute("flashMessage",
                           "Account created successfully! Please sign in.");
                response.sendRedirect(request.getContextPath() + "/auth");

            } else {
                setError(request,
                    "Registration failed. Please try again.",
                    fullName, email, phone, employeeId, designation, orgIdStr);
                forwardBack(request, response);
            }

        } catch (NumberFormatException e) {
            setError(request, "Invalid organization or department selected.",
                     fullName, email, phone, employeeId, designation, orgIdStr);
            forwardBack(request, response);
        }
    }

    // ── Helpers ───────────────────────────────────────────────────────────────

    private boolean isEmpty(String s) {
        return s == null || s.trim().isEmpty();
    }

    private void setError(HttpServletRequest req, String msg,
                          String fullName, String email, String phone,
                          String empId, String designation, String orgId) {
        req.setAttribute("errorMessage",    msg);
        req.setAttribute("prevFullName",    fullName);
        req.setAttribute("prevEmail",       email);
        req.setAttribute("prevPhone",       phone);
        req.setAttribute("prevEmployeeId",  empId);
        req.setAttribute("prevDesignation", designation);
        req.setAttribute("prevOrgId",       orgId);
        loadOrganizations(req);
    }

    private void forwardBack(HttpServletRequest req,
                             HttpServletResponse res)
            throws ServletException, IOException {
        req.getRequestDispatcher("/WEB-INF/pages/auth/register.jsp")
           .forward(req, res);
    }

    private void loadOrganizations(HttpServletRequest request) {
        List<String[]> orgs = new ArrayList<>();
        String q = "SELECT id, name FROM organizations " +
                   "WHERE is_active = TRUE ORDER BY name ASC";
        try (Connection c = DBConfig.getConnection();
             PreparedStatement s = c.prepareStatement(q)) {
            ResultSet rs = s.executeQuery();
            while (rs.next()) {
                orgs.add(new String[]{
                    rs.getString("id"),
                    rs.getString("name")
                });
            }
        } catch (SQLException e) {
            System.err.println("Load orgs error: " + e.getMessage());
        }
        request.setAttribute("organizations", orgs);
    }
}