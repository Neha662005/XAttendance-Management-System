package com.attendance.controllers;

import com.attendance.config.DBConfig;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.*;

/**
 * Returns departments and shifts as JSON for a given org.
 * Called by the register page JavaScript.
 * GET /getDepartments?orgId=1
 */
@WebServlet("/getDepartments")
public class GetDepartmentsServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        String orgIdStr = request.getParameter("orgId");
        PrintWriter out = response.getWriter();

        if (orgIdStr == null || orgIdStr.trim().isEmpty()) {
            out.print("{\"departments\":[],\"shifts\":[]}");
            return;
        }

        int orgId;
        try {
            orgId = Integer.parseInt(orgIdStr);
        } catch (NumberFormatException e) {
            out.print("{\"departments\":[],\"shifts\":[]}");
            return;
        }

        StringBuilder json = new StringBuilder("{");

        // Departments
        json.append("\"departments\":[");
        String dq = "SELECT id, name FROM departments " +
                    "WHERE org_id = ? ORDER BY name ASC";
        try (Connection c = DBConfig.getConnection();
             PreparedStatement s = c.prepareStatement(dq)) {
            s.setInt(1, orgId);
            ResultSet rs = s.executeQuery();
            boolean first = true;
            while (rs.next()) {
                if (!first) json.append(",");
                json.append("{\"id\":").append(rs.getInt("id"))
                    .append(",\"name\":\"")
                    .append(escape(rs.getString("name")))
                    .append("\"}");
                first = false;
            }
        } catch (SQLException e) {
            System.err.println("Dept fetch error: " + e.getMessage());
        }
        json.append("],");

        // Shifts
        json.append("\"shifts\":[");
        String sq = "SELECT id, name, start_time, end_time " +
                    "FROM shifts WHERE org_id=? AND is_active=TRUE " +
                    "ORDER BY name ASC";
        try (Connection c = DBConfig.getConnection();
             PreparedStatement s = c.prepareStatement(sq)) {
            s.setInt(1, orgId);
            ResultSet rs = s.executeQuery();
            boolean first = true;
            while (rs.next()) {
                if (!first) json.append(",");
                json.append("{\"id\":").append(rs.getInt("id"))
                    .append(",\"name\":\"")
                    .append(escape(rs.getString("name")))
                    .append("\",\"time\":\"")
                    .append(rs.getString("start_time"))
                    .append(" - ")
                    .append(rs.getString("end_time"))
                    .append("\"}");
                first = false;
            }
        } catch (SQLException e) {
            System.err.println("Shift fetch error: " + e.getMessage());
        }
        json.append("]}");

        out.print(json.toString());
    }

    private String escape(String s) {
        if (s == null) return "";
        return s.replace("\\", "\\\\")
                .replace("\"", "\\\"");
    }
}