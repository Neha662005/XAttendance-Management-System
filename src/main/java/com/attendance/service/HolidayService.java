package com.attendance.service;

import com.attendance.config.DBConfig;
import com.attendance.model.Holiday;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class HolidayService {

    public List<Holiday> getHolidaysByOrg(int orgId) {
        List<Holiday> list = new ArrayList<>();
        String q =
            "SELECT * FROM holidays WHERE org_id = ? " +
            "ORDER BY holiday_date ASC";
        try (Connection c = DBConfig.getConnection();
             PreparedStatement s = c.prepareStatement(q)) {
            s.setInt(1, orgId);
            ResultSet rs = s.executeQuery();
            while (rs.next()) list.add(mapRow(rs));
        } catch (SQLException e) {
            System.err.println("Get holidays error: " + e.getMessage());
        }
        return list;
    }

    public boolean addHoliday(Holiday holiday) {
        String q =
            "INSERT INTO holidays (org_id, name, holiday_date, description) " +
            "VALUES (?, ?, ?, ?)";
        try (Connection c = DBConfig.getConnection();
             PreparedStatement s = c.prepareStatement(q)) {
            s.setInt(1, holiday.getOrgId());
            s.setString(2, holiday.getName().trim());
            s.setDate(3, holiday.getHolidayDate());
            s.setString(4, holiday.getDescription());
            return s.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("Add holiday error: " + e.getMessage());
            return false;
        }
    }

    public boolean deleteHoliday(int id) {
        String q = "DELETE FROM holidays WHERE id = ?";
        try (Connection c = DBConfig.getConnection();
             PreparedStatement s = c.prepareStatement(q)) {
            s.setInt(1, id);
            return s.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("Delete holiday error: " + e.getMessage());
            return false;
        }
    }

    public boolean isTodayHoliday(int orgId) {
        String q =
            "SELECT COUNT(*) FROM holidays " +
            "WHERE org_id = ? AND holiday_date = CURDATE()";
        try (Connection c = DBConfig.getConnection();
             PreparedStatement s = c.prepareStatement(q)) {
            s.setInt(1, orgId);
            ResultSet rs = s.executeQuery();
            if (rs.next()) return rs.getInt(1) > 0;
        } catch (SQLException e) {
            System.err.println("Holiday check error: " + e.getMessage());
        }
        return false;
    }

    private Holiday mapRow(ResultSet rs) throws SQLException {
        Holiday h = new Holiday();
        h.setId(rs.getInt("id"));
        h.setOrgId(rs.getInt("org_id"));
        h.setName(rs.getString("name"));
        h.setHolidayDate(rs.getDate("holiday_date"));
        h.setDescription(rs.getString("description"));
        return h;
    }
}