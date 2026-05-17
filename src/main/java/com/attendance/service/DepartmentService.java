package com.attendance.service;

import com.attendance.config.DBConfig;
import com.attendance.model.Department;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class DepartmentService {

    public List<Department> getDepartmentsByOrg(int orgId) {
        List<Department> list = new ArrayList<>();
        String q =
            "SELECT d.*, COUNT(u.id) AS emp_count " +
            "FROM departments d " +
            "LEFT JOIN users u ON u.dept_id = d.id AND u.is_active = TRUE " +
            "WHERE d.org_id = ? " +
            "GROUP BY d.id ORDER BY d.name ASC";

        try (Connection c = DBConfig.getConnection();
             PreparedStatement s = c.prepareStatement(q)) {
            s.setInt(1, orgId);
            ResultSet rs = s.executeQuery();
            while (rs.next()) {
                Department d = new Department();
                d.setId(rs.getInt("id"));
                d.setOrgId(rs.getInt("org_id"));
                d.setName(rs.getString("name"));
                d.setDescription(rs.getString("description"));
                d.setCreatedAt(rs.getTimestamp("created_at"));
                d.setEmployeeCount(rs.getInt("emp_count"));
                list.add(d);
            }
        } catch (SQLException e) {
            System.err.println("Get depts error: " + e.getMessage());
        }
        return list;
    }

    public boolean addDepartment(Department dept) {
        String q =
            "INSERT INTO departments (org_id, name, description) " +
            "VALUES (?, ?, ?)";
        try (Connection c = DBConfig.getConnection();
             PreparedStatement s = c.prepareStatement(q)) {
            s.setInt(1, dept.getOrgId());
            s.setString(2, dept.getName().trim());
            s.setString(3, dept.getDescription());
            return s.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("Add dept error: " + e.getMessage());
            return false;
        }
    }

    public boolean updateDepartment(Department dept) {
        String q =
            "UPDATE departments SET name=?, description=? WHERE id=?";
        try (Connection c = DBConfig.getConnection();
             PreparedStatement s = c.prepareStatement(q)) {
            s.setString(1, dept.getName().trim());
            s.setString(2, dept.getDescription());
            s.setInt(3, dept.getId());
            return s.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("Update dept error: " + e.getMessage());
            return false;
        }
    }

    public boolean deleteDepartment(int id) {
        // Only delete if no active employees are in it
        String check =
            "SELECT COUNT(*) FROM users " +
            "WHERE dept_id = ? AND is_active = TRUE";
        try (Connection c = DBConfig.getConnection();
             PreparedStatement cs = c.prepareStatement(check)) {
            cs.setInt(1, id);
            ResultSet rs = cs.executeQuery();
            if (rs.next() && rs.getInt(1) > 0) {
                return false; // has employees
            }
        } catch (SQLException e) {
            System.err.println("Check dept error: " + e.getMessage());
            return false;
        }

        String q = "DELETE FROM departments WHERE id = ?";
        try (Connection c = DBConfig.getConnection();
             PreparedStatement s = c.prepareStatement(q)) {
            s.setInt(1, id);
            return s.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("Delete dept error: " + e.getMessage());
            return false;
        }
    }

    public Department getDepartmentById(int id) {
        String q = "SELECT * FROM departments WHERE id = ?";
        try (Connection c = DBConfig.getConnection();
             PreparedStatement s = c.prepareStatement(q)) {
            s.setInt(1, id);
            ResultSet rs = s.executeQuery();
            if (rs.next()) {
                Department d = new Department();
                d.setId(rs.getInt("id"));
                d.setOrgId(rs.getInt("org_id"));
                d.setName(rs.getString("name"));
                d.setDescription(rs.getString("description"));
                d.setCreatedAt(rs.getTimestamp("created_at"));
                return d;
            }
        } catch (SQLException e) {
            System.err.println("Get dept error: " + e.getMessage());
        }
        return null;
    }
}