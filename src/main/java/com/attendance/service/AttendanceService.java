package com.attendance.service;

import com.attendance.config.DBConfig;
import com.attendance.model.AttendanceRecord;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class AttendanceService {

    // ── Check In ─────────────────────────────────────────────────────────────

    public boolean checkIn(int userId) {
        String checkQuery =
            "SELECT id FROM attendance_records " +
            "WHERE user_id = ? AND attendance_date = CURDATE()";

        String insertQuery =
            "INSERT INTO attendance_records " +
            "(user_id, shift_id, check_in, attendance_date, status) " +
            "SELECT ?, u.shift_id, NOW(), CURDATE(), " +
            "CASE WHEN s.id IS NOT NULL AND " +
            "     TIME(NOW()) > ADDTIME(s.start_time, " +
            "     SEC_TO_TIME(s.grace_minutes * 60)) " +
            "     THEN 'LATE' ELSE 'PRESENT' END " +
            "FROM users u " +
            "LEFT JOIN shifts s ON u.shift_id = s.id " +
            "WHERE u.id = ?";

        try (Connection conn = DBConfig.getConnection()) {

            PreparedStatement check = conn.prepareStatement(checkQuery);
            check.setInt(1, userId);
            if (check.executeQuery().next()) {
                return false; // already checked in
            }

            PreparedStatement insert = conn.prepareStatement(insertQuery);
            insert.setInt(1, userId);
            insert.setInt(2, userId);
            return insert.executeUpdate() > 0;

        } catch (SQLException e) {
            System.err.println("Check-in error: " + e.getMessage());
            return false;
        }
    }

    // ── Check Out ────────────────────────────────────────────────────────────

    public boolean checkOut(int userId) {
        String query =
            "UPDATE attendance_records ar " +
            "JOIN users u ON ar.user_id = u.id " +
            "LEFT JOIN shifts s ON u.shift_id = s.id " +
            "SET ar.check_out = NOW(), " +
            "    ar.overtime_minutes = GREATEST(0, " +
            "        TIMESTAMPDIFF(MINUTE, " +
            "            CONCAT(ar.attendance_date, ' ', " +
            "            IFNULL(s.end_time, '17:00:00')), NOW()" +
            "        )) " +
            "WHERE ar.user_id = ? " +
            "AND ar.attendance_date = CURDATE() " +
            "AND ar.check_out IS NULL";

        try (Connection conn = DBConfig.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setInt(1, userId);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("Check-out error: " + e.getMessage());
            return false;
        }
    }

    // ── Break ────────────────────────────────────────────────────────────────

    public boolean startBreak(int userId) {
        String query =
            "UPDATE attendance_records " +
            "SET break_start = NOW() " +
            "WHERE user_id = ? " +
            "AND attendance_date = CURDATE() " +
            "AND check_in IS NOT NULL " +
            "AND check_out IS NULL " +
            "AND break_start IS NULL";

        try (Connection conn = DBConfig.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setInt(1, userId);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("Break start error: " + e.getMessage());
            return false;
        }
    }

    public boolean endBreak(int userId) {
        String query =
            "UPDATE attendance_records " +
            "SET break_end = NOW() " +
            "WHERE user_id = ? " +
            "AND attendance_date = CURDATE() " +
            "AND break_start IS NOT NULL " +
            "AND break_end IS NULL";

        try (Connection conn = DBConfig.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setInt(1, userId);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("Break end error: " + e.getMessage());
            return false;
        }
    }

    // ── Today's Record ───────────────────────────────────────────────────────

    public AttendanceRecord getTodayRecord(int userId) {
        String query =
            "SELECT ar.*, u.full_name, d.name AS dept_name, " +
            "       s.name AS shift_name " +
            "FROM attendance_records ar " +
            "JOIN users u ON ar.user_id = u.id " +
            "LEFT JOIN departments d ON u.dept_id  = d.id " +
            "LEFT JOIN shifts      s ON ar.shift_id = s.id " +
            "WHERE ar.user_id = ? AND ar.attendance_date = CURDATE()";

        try (Connection conn = DBConfig.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setInt(1, userId);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) return mapRow(rs);
        } catch (SQLException e) {
            System.err.println("Today record error: " + e.getMessage());
        }
        return null;
    }

    // ── History ──────────────────────────────────────────────────────────────

    public List<AttendanceRecord> getHistory(int userId,
                                              String fromDate,
                                              String toDate) {
        List<AttendanceRecord> list = new ArrayList<>();
        String query =
            "SELECT ar.*, u.full_name, d.name AS dept_name, " +
            "       s.name AS shift_name " +
            "FROM attendance_records ar " +
            "JOIN users u ON ar.user_id = u.id " +
            "LEFT JOIN departments d ON u.dept_id  = d.id " +
            "LEFT JOIN shifts      s ON ar.shift_id = s.id " +
            "WHERE ar.user_id = ? " +
            "AND ar.attendance_date BETWEEN ? AND ? " +
            "ORDER BY ar.attendance_date DESC";

        try (Connection conn = DBConfig.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setInt(1, userId);
            stmt.setString(2, fromDate);
            stmt.setString(3, toDate);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) list.add(mapRow(rs));
        } catch (SQLException e) {
            System.err.println("History error: " + e.getMessage());
        }
        return list;
    }

    // ── Org Daily Report ─────────────────────────────────────────────────────

    public List<AttendanceRecord> getDailyReport(int orgId, String date) {
        List<AttendanceRecord> list = new ArrayList<>();
        String query =
            "SELECT ar.*, u.full_name, d.name AS dept_name, " +
            "       s.name AS shift_name " +
            "FROM attendance_records ar " +
            "JOIN users u ON ar.user_id = u.id " +
            "LEFT JOIN departments d ON u.dept_id  = d.id " +
            "LEFT JOIN shifts      s ON ar.shift_id = s.id " +
            "WHERE u.org_id = ? AND ar.attendance_date = ? " +
            "ORDER BY u.full_name ASC";

        try (Connection conn = DBConfig.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setInt(1, orgId);
            stmt.setString(2, date);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) list.add(mapRow(rs));
        } catch (SQLException e) {
            System.err.println("Daily report error: " + e.getMessage());
        }
        return list;
    }

    // ── Monthly Report ───────────────────────────────────────────────────────

    public List<AttendanceRecord> getMonthlyReport(int orgId,
                                                    String fromDate,
                                                    String toDate) {
        List<AttendanceRecord> list = new ArrayList<>();
        String query =
            "SELECT ar.*, u.full_name, d.name AS dept_name, " +
            "       s.name AS shift_name " +
            "FROM attendance_records ar " +
            "JOIN users u ON ar.user_id = u.id " +
            "LEFT JOIN departments d ON u.dept_id  = d.id " +
            "LEFT JOIN shifts      s ON ar.shift_id = s.id " +
            "WHERE u.org_id = ? " +
            "AND ar.attendance_date BETWEEN ? AND ? " +
            "ORDER BY ar.attendance_date DESC, u.full_name ASC";

        try (Connection conn = DBConfig.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setInt(1, orgId);
            stmt.setString(2, fromDate);
            stmt.setString(3, toDate);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) list.add(mapRow(rs));
        } catch (SQLException e) {
            System.err.println("Monthly report error: " + e.getMessage());
        }
        return list;
    }

    // ── Dashboard Stats ──────────────────────────────────────────────────────

    public int getPresentTodayCount(int orgId) {
        return countQuery(
            "SELECT COUNT(*) FROM attendance_records ar " +
            "JOIN users u ON ar.user_id = u.id " +
            "WHERE u.org_id = ? AND ar.attendance_date = CURDATE() " +
            "AND ar.status IN ('PRESENT','LATE')", orgId);
    }

    public int getOnLeaveTodayCount(int orgId) {
        return countQuery(
            "SELECT COUNT(*) FROM attendance_records ar " +
            "JOIN users u ON ar.user_id = u.id " +
            "WHERE u.org_id = ? AND ar.attendance_date = CURDATE() " +
            "AND ar.status = 'ON_LEAVE'", orgId);
    }

    public int getLateTodayCount(int orgId) {
        return countQuery(
            "SELECT COUNT(*) FROM attendance_records ar " +
            "JOIN users u ON ar.user_id = u.id " +
            "WHERE u.org_id = ? AND ar.attendance_date = CURDATE() " +
            "AND ar.status = 'LATE'", orgId);
    }

    private int countQuery(String q, int orgId) {
        try (Connection c = DBConfig.getConnection();
             PreparedStatement s = c.prepareStatement(q)) {
            s.setInt(1, orgId);
            ResultSet rs = s.executeQuery();
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) {
            System.err.println("Count error: " + e.getMessage());
        }
        return 0;
    }

    // ── Row Mapper ───────────────────────────────────────────────────────────

    private AttendanceRecord mapRow(ResultSet rs) throws SQLException {
        AttendanceRecord r = new AttendanceRecord();
        r.setId(rs.getInt("id"));
        r.setUserId(rs.getInt("user_id"));
        r.setShiftId(rs.getInt("shift_id"));
        r.setUserFullName(rs.getString("full_name"));
        r.setCheckIn(rs.getTimestamp("check_in"));
        r.setCheckOut(rs.getTimestamp("check_out"));
        r.setBreakStart(rs.getTimestamp("break_start"));
        r.setBreakEnd(rs.getTimestamp("break_end"));
        r.setAttendanceDate(rs.getDate("attendance_date"));
        r.setStatus(rs.getString("status"));
        r.setOvertimeMinutes(rs.getInt("overtime_minutes"));
        r.setRemarks(rs.getString("remarks"));
        try { r.setDepartmentName(rs.getString("dept_name")); }
        catch (SQLException ignored) {}
        try { r.setShiftName(rs.getString("shift_name")); }
        catch (SQLException ignored) {}
        return r;
    }
}