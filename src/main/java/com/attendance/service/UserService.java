package com.attendance.service;

import com.attendance.config.DBConfig;
import com.attendance.model.User;
import org.mindrot.jbcrypt.BCrypt;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class UserService {

    // ── Login ────────────────────────────────────────────────────────────────

    /**
     * Validates credentials.
     * Checks brute-force lock before password verification.
     * Returns User on success, null on failure.
     */
    public User login(String email, String password) {
        String query =
            "SELECT u.*, d.name AS dept_name, s.name AS shift_name " +
            "FROM users u " +
            "LEFT JOIN departments d ON u.dept_id  = d.id " +
            "LEFT JOIN shifts      s ON u.shift_id = s.id " +
            "WHERE u.email = ? AND u.is_active = TRUE";

        try (Connection conn = DBConfig.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {

            stmt.setString(1, email.trim().toLowerCase());
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                // Check brute-force lock
                Timestamp locked = rs.getTimestamp("locked_until");
                if (locked != null &&
                    locked.after(new Timestamp(System.currentTimeMillis()))) {
                    return null; // still locked
                }

                String hash = rs.getString("password_hash");
                if (BCrypt.checkpw(password, hash)) {
                    resetFailedAttempts(rs.getInt("id"));
                    return mapRow(rs);
                } else {
                    incrementFailedAttempts(rs.getInt("id"));
                    return null;
                }
            }

        } catch (SQLException e) {
            System.err.println("Login error: " + e.getMessage());
        }
        return null;
    }

    private void incrementFailedAttempts(int userId) {
        String q = "UPDATE users " +
                   "SET failed_attempts = failed_attempts + 1, " +
                   "    locked_until = CASE " +
                   "        WHEN failed_attempts + 1 >= 5 " +
                   "        THEN DATE_ADD(NOW(), INTERVAL 15 MINUTE) " +
                   "        ELSE locked_until END " +
                   "WHERE id = ?";
        try (Connection c = DBConfig.getConnection();
             PreparedStatement s = c.prepareStatement(q)) {
            s.setInt(1, userId);
            s.executeUpdate();
        } catch (SQLException e) {
            System.err.println("Increment attempts error: " + e.getMessage());
        }
    }

    private void resetFailedAttempts(int userId) {
        String q = "UPDATE users SET failed_attempts=0, locked_until=NULL WHERE id=?";
        try (Connection c = DBConfig.getConnection();
             PreparedStatement s = c.prepareStatement(q)) {
            s.setInt(1, userId);
            s.executeUpdate();
        } catch (SQLException e) {
            System.err.println("Reset attempts error: " + e.getMessage());
        }
    }

    /**
     * Returns true if the account is currently locked.
     */
    public boolean isAccountLocked(String email) {
        String q = "SELECT locked_until FROM users WHERE email = ?";
        try (Connection c = DBConfig.getConnection();
             PreparedStatement s = c.prepareStatement(q)) {
            s.setString(1, email.trim().toLowerCase());
            ResultSet rs = s.executeQuery();
            if (rs.next()) {
                Timestamp locked = rs.getTimestamp("locked_until");
                return locked != null &&
                       locked.after(new Timestamp(System.currentTimeMillis()));
            }
        } catch (SQLException e) {
            System.err.println("Lock check error: " + e.getMessage());
        }
        return false;
    }

    // ── Register ─────────────────────────────────────────────────────────────

    /**
     * Hashes the password and inserts a new user.
     * Returns true on success.
     */
    public boolean registerUser(User user) {
        String q =
            "INSERT INTO users " +
            "(org_id, dept_id, shift_id, full_name, email, " +
            " password_hash, role, employee_id, phone, designation) " +
            "VALUES (?, ?, ?, ?, ?, ?, 'EMPLOYEE', ?, ?, ?)";

        String hash = BCrypt.hashpw(user.getPasswordHash(), BCrypt.gensalt(12));

        try (Connection c = DBConfig.getConnection();
             PreparedStatement s = c.prepareStatement(q)) {

            s.setInt(1, user.getOrgId());
            s.setInt(2, user.getDeptId());
            s.setInt(3, user.getShiftId());
            s.setString(4, user.getFullName().trim());
            s.setString(5, user.getEmail().trim().toLowerCase());
            s.setString(6, hash);
            s.setString(7, user.getEmployeeId());
            s.setString(8, user.getPhone());
            s.setString(9, user.getDesignation());

            return s.executeUpdate() > 0;

        } catch (SQLException e) {
            System.err.println("Register error: " + e.getMessage());
            return false;
        }
    }

    /**
     * Returns true if the email is already registered.
     */
    public boolean emailExists(String email) {
        String q = "SELECT id FROM users WHERE email = ?";
        try (Connection c = DBConfig.getConnection();
             PreparedStatement s = c.prepareStatement(q)) {
            s.setString(1, email.trim().toLowerCase());
            return s.executeQuery().next();
        } catch (SQLException e) {
            System.err.println("Email check error: " + e.getMessage());
            return false;
        }
    }

    // ── Fetch ─────────────────────────────────────────────────────────────────

    public List<User> getUsersByOrg(int orgId) {
        List<User> list = new ArrayList<>();
        String q =
            "SELECT u.*, d.name AS dept_name, s.name AS shift_name " +
            "FROM users u " +
            "LEFT JOIN departments d ON u.dept_id  = d.id " +
            "LEFT JOIN shifts      s ON u.shift_id = s.id " +
            "WHERE u.org_id = ? ORDER BY u.full_name ASC";

        try (Connection c = DBConfig.getConnection();
             PreparedStatement s = c.prepareStatement(q)) {
            s.setInt(1, orgId);
            ResultSet rs = s.executeQuery();
            while (rs.next()) list.add(mapRow(rs));
        } catch (SQLException e) {
            System.err.println("Get users error: " + e.getMessage());
        }
        return list;
    }

    public User getUserById(int id) {
        String q =
            "SELECT u.*, d.name AS dept_name, s.name AS shift_name " +
            "FROM users u " +
            "LEFT JOIN departments d ON u.dept_id  = d.id " +
            "LEFT JOIN shifts      s ON u.shift_id = s.id " +
            "WHERE u.id = ?";

        try (Connection c = DBConfig.getConnection();
             PreparedStatement s = c.prepareStatement(q)) {
            s.setInt(1, id);
            ResultSet rs = s.executeQuery();
            if (rs.next()) return mapRow(rs);
        } catch (SQLException e) {
            System.err.println("Get user error: " + e.getMessage());
        }
        return null;
    }

    // ── Update ────────────────────────────────────────────────────────────────

    public boolean setActiveStatus(int userId, boolean active) {
        String q = "UPDATE users SET is_active = ? WHERE id = ?";
        try (Connection c = DBConfig.getConnection();
             PreparedStatement s = c.prepareStatement(q)) {
            s.setBoolean(1, active);
            s.setInt(2, userId);
            return s.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("Set status error: " + e.getMessage());
            return false;
        }
    }

    public boolean updateRole(int userId, String role) {
        String q = "UPDATE users SET role = ? WHERE id = ?";
        try (Connection c = DBConfig.getConnection();
             PreparedStatement s = c.prepareStatement(q)) {
            s.setString(1, role);
            s.setInt(2, userId);
            return s.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("Update role error: " + e.getMessage());
            return false;
        }
    }

    // ── Stats ─────────────────────────────────────────────────────────────────

    public int getTotalEmployees(int orgId) {
        String q = "SELECT COUNT(*) FROM users WHERE org_id=? AND is_active=TRUE";
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

    // ── Row mapper ────────────────────────────────────────────────────────────

    private User mapRow(ResultSet rs) throws SQLException {
        User u = new User();
        u.setId(rs.getInt("id"));
        u.setOrgId(rs.getInt("org_id"));
        u.setDeptId(rs.getInt("dept_id"));
        u.setShiftId(rs.getInt("shift_id"));
        u.setFullName(rs.getString("full_name"));
        u.setEmail(rs.getString("email"));
        u.setPasswordHash(rs.getString("password_hash"));
        u.setRole(rs.getString("role"));
        u.setEmployeeId(rs.getString("employee_id"));
        u.setPhone(rs.getString("phone"));
        u.setDesignation(rs.getString("designation"));
        u.setActive(rs.getBoolean("is_active"));
        u.setFailedAttempts(rs.getInt("failed_attempts"));
        u.setLockedUntil(rs.getTimestamp("locked_until"));
        u.setCreatedAt(rs.getTimestamp("created_at"));
        try { u.setDepartmentName(rs.getString("dept_name"));  } catch (SQLException ignored) {}
        try { u.setShiftName(rs.getString("shift_name"));      } catch (SQLException ignored) {}
        return u;
    }
    
    /**
     * Updates a user's profile information.
     * Returns true if the update succeeded.
     */
    public boolean updateProfile(int userId, String fullName,
                                  String phone, String designation) {
        String q = "UPDATE users " +
                   "SET full_name=?, phone=?, designation=? " +
                   "WHERE id=?";
        try (Connection c = DBConfig.getConnection();
             PreparedStatement s = c.prepareStatement(q)) {
            s.setString(1, fullName);
            s.setString(2, phone);
            s.setString(3, designation);
            s.setInt(4, userId);
            return s.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("Update profile error: " + e.getMessage());
            return false;
        }
    }

    /**
     * Updates a user's password with a fresh BCrypt hash.
     * Returns true if the update succeeded.
     */
    public boolean updatePassword(int userId, String newPassword) {
        String hash = BCrypt.hashpw(newPassword, BCrypt.gensalt(12));
        String q = "UPDATE users SET password_hash=? WHERE id=?";
        try (Connection c = DBConfig.getConnection();
             PreparedStatement s = c.prepareStatement(q)) {
            s.setString(1, hash);
            s.setInt(2, userId);
            return s.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("Update password error: " + e.getMessage());
            return false;
        }
    }
}