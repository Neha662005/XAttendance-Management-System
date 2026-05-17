package com.attendance.service;

import com.attendance.config.DBConfig;
import com.attendance.model.Announcement;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class AnnouncementService {

    /**
     * Returns all active announcements for an org.
     * Shown on the dashboard for all users.
     */
    public List<Announcement> getActiveAnnouncements(int orgId) {
        List<Announcement> list = new ArrayList<>();
        String q =
            "SELECT a.*, u.full_name AS created_by_name " +
            "FROM announcements a " +
            "JOIN users u ON a.created_by = u.id " +
            "WHERE a.org_id = ? AND a.is_active = TRUE " +
            "ORDER BY a.created_at DESC";

        try (Connection c = DBConfig.getConnection();
             PreparedStatement s = c.prepareStatement(q)) {
            s.setInt(1, orgId);
            ResultSet rs = s.executeQuery();
            while (rs.next()) list.add(mapRow(rs));
        } catch (SQLException e) {
            System.err.println("Get announcements error: " + e.getMessage());
        }
        return list;
    }

    /**
     * Returns all announcements for admin management view.
     */
    public List<Announcement> getAllAnnouncements(int orgId) {
        List<Announcement> list = new ArrayList<>();
        String q =
            "SELECT a.*, u.full_name AS created_by_name " +
            "FROM announcements a " +
            "JOIN users u ON a.created_by = u.id " +
            "WHERE a.org_id = ? " +
            "ORDER BY a.created_at DESC";

        try (Connection c = DBConfig.getConnection();
             PreparedStatement s = c.prepareStatement(q)) {
            s.setInt(1, orgId);
            ResultSet rs = s.executeQuery();
            while (rs.next()) list.add(mapRow(rs));
        } catch (SQLException e) {
            System.err.println("Get all announcements error: " + e.getMessage());
        }
        return list;
    }

    public boolean addAnnouncement(Announcement a) {
        String q =
            "INSERT INTO announcements " +
            "(org_id, created_by, title, message, is_active) " +
            "VALUES (?, ?, ?, ?, TRUE)";
        try (Connection c = DBConfig.getConnection();
             PreparedStatement s = c.prepareStatement(q)) {
            s.setInt(1, a.getOrgId());
            s.setInt(2, a.getCreatedBy());
            s.setString(3, a.getTitle().trim());
            s.setString(4, a.getMessage().trim());
            return s.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("Add announcement error: " + e.getMessage());
            return false;
        }
    }

    public boolean toggleActive(int id, boolean active) {
        String q = "UPDATE announcements SET is_active=? WHERE id=?";
        try (Connection c = DBConfig.getConnection();
             PreparedStatement s = c.prepareStatement(q)) {
            s.setBoolean(1, active);
            s.setInt(2, id);
            return s.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("Toggle announcement error: " + e.getMessage());
            return false;
        }
    }

    public boolean deleteAnnouncement(int id) {
        String q = "DELETE FROM announcements WHERE id = ?";
        try (Connection c = DBConfig.getConnection();
             PreparedStatement s = c.prepareStatement(q)) {
            s.setInt(1, id);
            return s.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("Delete announcement error: " + e.getMessage());
            return false;
        }
    }

    private Announcement mapRow(ResultSet rs) throws SQLException {
        Announcement a = new Announcement();
        a.setId(rs.getInt("id"));
        a.setOrgId(rs.getInt("org_id"));
        a.setCreatedBy(rs.getInt("created_by"));
        a.setCreatedByName(rs.getString("created_by_name"));
        a.setTitle(rs.getString("title"));
        a.setMessage(rs.getString("message"));
        a.setActive(rs.getBoolean("is_active"));
        a.setCreatedAt(rs.getTimestamp("created_at"));
        return a;
    }
}