package com.attendance.service;

import com.attendance.config.DBConfig;
import com.attendance.model.Shift;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ShiftService {

    public List<Shift> getShiftsByOrg(int orgId) {
        List<Shift> list = new ArrayList<>();
        String q =
            "SELECT s.*, COUNT(u.id) AS emp_count " +
            "FROM shifts s " +
            "LEFT JOIN users u ON u.shift_id = s.id AND u.is_active = TRUE " +
            "WHERE s.org_id = ? " +
            "GROUP BY s.id ORDER BY s.name ASC";

        try (Connection c = DBConfig.getConnection();
             PreparedStatement stmt = c.prepareStatement(q)) {
            stmt.setInt(1, orgId);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                Shift s = new Shift();
                s.setId(rs.getInt("id"));
                s.setOrgId(rs.getInt("org_id"));
                s.setName(rs.getString("name"));
                s.setStartTime(rs.getString("start_time"));
                s.setEndTime(rs.getString("end_time"));
                s.setGraceMinutes(rs.getInt("grace_minutes"));
                s.setActive(rs.getBoolean("is_active"));
                s.setEmployeeCount(rs.getInt("emp_count"));
                list.add(s);
            }
        } catch (SQLException e) {
            System.err.println("Get shifts error: " + e.getMessage());
        }
        return list;
    }

    public boolean addShift(Shift shift) {
        String q =
            "INSERT INTO shifts " +
            "(org_id, name, start_time, end_time, grace_minutes) " +
            "VALUES (?, ?, ?, ?, ?)";
        try (Connection c = DBConfig.getConnection();
             PreparedStatement s = c.prepareStatement(q)) {
            s.setInt(1, shift.getOrgId());
            s.setString(2, shift.getName().trim());
            s.setString(3, shift.getStartTime());
            s.setString(4, shift.getEndTime());
            s.setInt(5, shift.getGraceMinutes());
            return s.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("Add shift error: " + e.getMessage());
            return false;
        }
    }

    public boolean updateShift(Shift shift) {
        String q =
            "UPDATE shifts " +
            "SET name=?, start_time=?, end_time=?, grace_minutes=? " +
            "WHERE id=?";
        try (Connection c = DBConfig.getConnection();
             PreparedStatement s = c.prepareStatement(q)) {
            s.setString(1, shift.getName().trim());
            s.setString(2, shift.getStartTime());
            s.setString(3, shift.getEndTime());
            s.setInt(4, shift.getGraceMinutes());
            s.setInt(5, shift.getId());
            return s.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("Update shift error: " + e.getMessage());
            return false;
        }
    }

    public boolean toggleActive(int shiftId, boolean active) {
        String q = "UPDATE shifts SET is_active=? WHERE id=?";
        try (Connection c = DBConfig.getConnection();
             PreparedStatement s = c.prepareStatement(q)) {
            s.setBoolean(1, active);
            s.setInt(2, shiftId);
            return s.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("Toggle shift error: " + e.getMessage());
            return false;
        }
    }

    public Shift getShiftById(int id) {
        String q = "SELECT * FROM shifts WHERE id = ?";
        try (Connection c = DBConfig.getConnection();
             PreparedStatement stmt = c.prepareStatement(q)) {
            stmt.setInt(1, id);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                Shift s = new Shift();
                s.setId(rs.getInt("id"));
                s.setOrgId(rs.getInt("org_id"));
                s.setName(rs.getString("name"));
                s.setStartTime(rs.getString("start_time"));
                s.setEndTime(rs.getString("end_time"));
                s.setGraceMinutes(rs.getInt("grace_minutes"));
                s.setActive(rs.getBoolean("is_active"));
                return s;
            }
        } catch (SQLException e) {
            System.err.println("Get shift error: " + e.getMessage());
        }
        return null;
    }
}