package com.attendance.service;

import com.attendance.config.DBConfig;
import com.attendance.model.LeaveRequest;
import com.attendance.model.LeaveType;
import com.attendance.model.LeaveBalance;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class LeaveService {

    // ── Leave Types ──────────────────────────────────────────────────────────

    /**
     * Returns all leave types for an organization.
     */
    public List<LeaveType> getLeaveTypes(int orgId) {
        List<LeaveType> list = new ArrayList<>();
        String q = "SELECT * FROM leave_types WHERE org_id = ? ORDER BY name ASC";
        try (Connection c = DBConfig.getConnection();
             PreparedStatement s = c.prepareStatement(q)) {
            s.setInt(1, orgId);
            ResultSet rs = s.executeQuery();
            while (rs.next()) {
                LeaveType lt = new LeaveType();
                lt.setId(rs.getInt("id"));
                lt.setOrgId(rs.getInt("org_id"));
                lt.setName(rs.getString("name"));
                lt.setDaysAllowed(rs.getInt("days_allowed"));
                lt.setPaid(rs.getBoolean("is_paid"));
                list.add(lt);
            }
        } catch (SQLException e) {
            System.err.println("Leave types error: " + e.getMessage());
        }
        return list;
    }

    // ── Leave Balances ───────────────────────────────────────────────────────

    /**
     * Returns leave balances for a user for the current year.
     */
    public List<LeaveBalance> getBalances(int userId) {
        List<LeaveBalance> list = new ArrayList<>();
        String q =
            "SELECT lb.*, lt.name AS leave_type_name " +
            "FROM leave_balances lb " +
            "JOIN leave_types lt ON lb.leave_type_id = lt.id " +
            "WHERE lb.user_id = ? AND lb.year = YEAR(CURDATE()) " +
            "ORDER BY lt.name ASC";

        try (Connection c = DBConfig.getConnection();
             PreparedStatement s = c.prepareStatement(q)) {
            s.setInt(1, userId);
            ResultSet rs = s.executeQuery();
            while (rs.next()) {
                LeaveBalance lb = new LeaveBalance();
                lb.setId(rs.getInt("id"));
                lb.setUserId(rs.getInt("user_id"));
                lb.setLeaveTypeId(rs.getInt("leave_type_id"));
                lb.setLeaveTypeName(rs.getString("leave_type_name"));
                lb.setYear(rs.getInt("year"));
                lb.setTotalDays(rs.getInt("total_days"));
                lb.setUsedDays(rs.getInt("used_days"));
                list.add(lb);
            }
        } catch (SQLException e) {
            System.err.println("Balances error: " + e.getMessage());
        }
        return list;
    }

    /**
     * Returns remaining days for a specific leave type and user.
     */
    public int getRemainingDays(int userId, int leaveTypeId) {
        String q =
            "SELECT (total_days - used_days) AS remaining " +
            "FROM leave_balances " +
            "WHERE user_id = ? AND leave_type_id = ? AND year = YEAR(CURDATE())";
        try (Connection c = DBConfig.getConnection();
             PreparedStatement s = c.prepareStatement(q)) {
            s.setInt(1, userId);
            s.setInt(2, leaveTypeId);
            ResultSet rs = s.executeQuery();
            if (rs.next()) return rs.getInt("remaining");
        } catch (SQLException e) {
            System.err.println("Remaining days error: " + e.getMessage());
        }
        return 0;
    }

    // ── Apply Leave ──────────────────────────────────────────────────────────

    /**
     * Submits a new leave request with PENDING status.
     * Returns false if insufficient balance.
     */
    public boolean applyLeave(LeaveRequest leave) {
        // Check balance first
        int remaining = getRemainingDays(
            leave.getUserId(), leave.getLeaveTypeId());
        if (remaining < leave.getTotalDays()) {
            return false;
        }

        String q =
            "INSERT INTO leave_requests " +
            "(user_id, leave_type_id, from_date, to_date, " +
            " total_days, reason, status) " +
            "VALUES (?, ?, ?, ?, ?, ?, 'PENDING')";

        try (Connection c = DBConfig.getConnection();
             PreparedStatement s = c.prepareStatement(q)) {
            s.setInt(1, leave.getUserId());
            s.setInt(2, leave.getLeaveTypeId());
            s.setDate(3, leave.getFromDate());
            s.setDate(4, leave.getToDate());
            s.setInt(5, leave.getTotalDays());
            s.setString(6, leave.getReason());
            return s.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("Apply leave error: " + e.getMessage());
            return false;
        }
    }

    // ── My Leave History ─────────────────────────────────────────────────────

    /**
     * Returns all leave requests for a specific user.
     */
    public List<LeaveRequest> getLeavesByUser(int userId) {
        List<LeaveRequest> list = new ArrayList<>();
        String q =
            "SELECT lr.*, u.full_name, lt.name AS leave_type_name " +
            "FROM leave_requests lr " +
            "JOIN users u ON lr.user_id = u.id " +
            "JOIN leave_types lt ON lr.leave_type_id = lt.id " +
            "WHERE lr.user_id = ? " +
            "ORDER BY lr.applied_at DESC";

        try (Connection c = DBConfig.getConnection();
             PreparedStatement s = c.prepareStatement(q)) {
            s.setInt(1, userId);
            ResultSet rs = s.executeQuery();
            while (rs.next()) list.add(mapRow(rs));
        } catch (SQLException e) {
            System.err.println("User leaves error: " + e.getMessage());
        }
        return list;
    }

    // ── Pending Leaves (for approval) ────────────────────────────────────────

    /**
     * Returns all PENDING leave requests for an organization.
     * Used by admin, manager, and hr approval screens.
     */
    public List<LeaveRequest> getPendingLeavesByOrg(int orgId) {
        List<LeaveRequest> list = new ArrayList<>();
        String q =
            "SELECT lr.*, u.full_name, d.name AS dept_name, " +
            "       lt.name AS leave_type_name " +
            "FROM leave_requests lr " +
            "JOIN users u ON lr.user_id = u.id " +
            "JOIN leave_types lt ON lr.leave_type_id = lt.id " +
            "LEFT JOIN departments d ON u.dept_id = d.id " +
            "WHERE u.org_id = ? AND lr.status = 'PENDING' " +
            "ORDER BY lr.applied_at ASC";

        try (Connection c = DBConfig.getConnection();
             PreparedStatement s = c.prepareStatement(q)) {
            s.setInt(1, orgId);
            ResultSet rs = s.executeQuery();
            while (rs.next()) list.add(mapRow(rs));
        } catch (SQLException e) {
            System.err.println("Pending leaves error: " + e.getMessage());
        }
        return list;
    }

    // ── Approve / Reject ─────────────────────────────────────────────────────

    /**
     * Approves or rejects a leave request.
     * If approved, deducts from the user's leave balance.
     * Returns false if the request is not in PENDING status.
     */
    public boolean updateLeaveStatus(int leaveId, String newStatus,
                                     int approvedById, String note) {
        // Get the leave request details first
        LeaveRequest leave = getLeaveById(leaveId);
        if (leave == null || !"PENDING".equals(leave.getStatus())) {
            return false;
        }

        String q =
            "UPDATE leave_requests " +
            "SET status = ?, approved_by = ?, " +
            "    approval_note = ?, actioned_at = NOW() " +
            "WHERE id = ? AND status = 'PENDING'";

        try (Connection c = DBConfig.getConnection();
             PreparedStatement s = c.prepareStatement(q)) {
            s.setString(1, newStatus);
            s.setInt(2, approvedById);
            s.setString(3, note);
            s.setInt(4, leaveId);
            boolean ok = s.executeUpdate() > 0;

            // Deduct balance if approved
            if (ok && "APPROVED".equals(newStatus)) {
                deductBalance(leave.getUserId(),
                              leave.getLeaveTypeId(),
                              leave.getTotalDays());
            }

            return ok;

        } catch (SQLException e) {
            System.err.println("Update leave status error: " + e.getMessage());
            return false;
        }
    }

    /**
     * Deducts used days from the leave balance.
     */
    private void deductBalance(int userId, int leaveTypeId, int days) {
        String q =
            "UPDATE leave_balances " +
            "SET used_days = used_days + ? " +
            "WHERE user_id = ? AND leave_type_id = ? " +
            "AND year = YEAR(CURDATE())";
        try (Connection c = DBConfig.getConnection();
             PreparedStatement s = c.prepareStatement(q)) {
            s.setInt(1, days);
            s.setInt(2, userId);
            s.setInt(3, leaveTypeId);
            s.executeUpdate();
        } catch (SQLException e) {
            System.err.println("Deduct balance error: " + e.getMessage());
        }
    }

    /**
     * Returns a single leave request by ID.
     */
    public LeaveRequest getLeaveById(int leaveId) {
        String q =
            "SELECT lr.*, u.full_name, lt.name AS leave_type_name " +
            "FROM leave_requests lr " +
            "JOIN users u ON lr.user_id = u.id " +
            "JOIN leave_types lt ON lr.leave_type_id = lt.id " +
            "WHERE lr.id = ?";
        try (Connection c = DBConfig.getConnection();
             PreparedStatement s = c.prepareStatement(q)) {
            s.setInt(1, leaveId);
            ResultSet rs = s.executeQuery();
            if (rs.next()) return mapRow(rs);
        } catch (SQLException e) {
            System.err.println("Get leave by ID error: " + e.getMessage());
        }
        return null;
    }

    // ── Dashboard Stat ───────────────────────────────────────────────────────

    /**
     * Returns count of pending leave requests for an org.
     */
    public int getPendingCount(int orgId) {
        String q =
            "SELECT COUNT(*) FROM leave_requests lr " +
            "JOIN users u ON lr.user_id = u.id " +
            "WHERE u.org_id = ? AND lr.status = 'PENDING'";
        try (Connection c = DBConfig.getConnection();
             PreparedStatement s = c.prepareStatement(q)) {
            s.setInt(1, orgId);
            ResultSet rs = s.executeQuery();
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) {
            System.err.println("Pending count error: " + e.getMessage());
        }
        return 0;
    }

    // ── Row Mapper ───────────────────────────────────────────────────────────

    private LeaveRequest mapRow(ResultSet rs) throws SQLException {
        LeaveRequest lr = new LeaveRequest();
        lr.setId(rs.getInt("id"));
        lr.setUserId(rs.getInt("user_id"));
        lr.setLeaveTypeId(rs.getInt("leave_type_id"));
        lr.setUserName(rs.getString("full_name"));
        lr.setLeaveTypeName(rs.getString("leave_type_name"));
        lr.setFromDate(rs.getDate("from_date"));
        lr.setToDate(rs.getDate("to_date"));
        lr.setTotalDays(rs.getInt("total_days"));
        lr.setReason(rs.getString("reason"));
        lr.setStatus(rs.getString("status"));
        lr.setApprovedBy(rs.getInt("approved_by"));
        lr.setApprovalNote(rs.getString("approval_note"));
        lr.setAppliedAt(rs.getTimestamp("applied_at"));
        lr.setActionedAt(rs.getTimestamp("actioned_at"));
        try { lr.setDepartmentName(rs.getString("dept_name")); }
        catch (SQLException ignored) {}
        return lr;
    }
}