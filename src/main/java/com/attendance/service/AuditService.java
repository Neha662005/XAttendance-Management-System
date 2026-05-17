package com.attendance.service;

import com.attendance.config.DBConfig;
import com.attendance.model.AuditLog;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * AuditService logs every important action.
 * Call AuditService.log() from any servlet after a state change.
 */
public class AuditService {

    /**
     * Full log — stores old and new values for changes.
     */
    public static void log(int userId, String action, String tableName,
                           int recordId, String oldValue, String newValue,
                           String ipAddress) {
        String query = "INSERT INTO audit_log " +
                       "(user_id, action, table_name, record_id, " +
                       " old_value, new_value, ip_address) " +
                       "VALUES (?, ?, ?, ?, ?, ?, ?)";

        try (Connection conn = DBConfig.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {

            stmt.setInt(1, userId);
            stmt.setString(2, action);
            stmt.setString(3, tableName);
            stmt.setInt(4, recordId);
            stmt.setString(5, oldValue);
            stmt.setString(6, newValue);
            stmt.setString(7, ipAddress);
            stmt.executeUpdate();

        } catch (SQLException e) {
            System.err.println("Audit log error: " + e.getMessage());
        }
    }

    /**
     * Simple log — for login, logout, and other
     * actions that don't involve a specific record.
     */
    public static void log(int userId, String action, String ipAddress) {
        log(userId, action, null, 0, null, null, ipAddress);
    }

    /**
     * Returns recent audit logs for an organization.
     */
    public List<AuditLog> getLogs(int orgId, int limit) {
        List<AuditLog> logs = new ArrayList<>();
        String query =
            "SELECT a.*, u.full_name AS user_name " +
            "FROM audit_log a " +
            "LEFT JOIN users u ON a.user_id = u.id " +
            "WHERE u.org_id = ? OR a.user_id IS NULL " +
            "ORDER BY a.created_at DESC LIMIT ?";

        try (Connection conn = DBConfig.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {

            stmt.setInt(1, orgId);
            stmt.setInt(2, limit);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                AuditLog log = new AuditLog();
                log.setId(rs.getInt("id"));
                log.setUserId(rs.getInt("user_id"));
                log.setUserName(rs.getString("user_name"));
                log.setAction(rs.getString("action"));
                log.setTableName(rs.getString("table_name"));
                log.setRecordId(rs.getInt("record_id"));
                log.setOldValue(rs.getString("old_value"));
                log.setNewValue(rs.getString("new_value"));
                log.setIpAddress(rs.getString("ip_address"));
                log.setCreatedAt(rs.getTimestamp("created_at"));
                logs.add(log);
            }

        } catch (SQLException e) {
            System.err.println("Get audit logs error: " + e.getMessage());
        }
        return logs;
    }
}