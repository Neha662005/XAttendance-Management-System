package com.attendance.model;

import java.sql.Timestamp;

public class User {

    private int       id;
    private int       orgId;
    private int       deptId;
    private int       shiftId;
    private int       managerId;
    private String    fullName;
    private String    email;
    private String    passwordHash;
    private String    role;
    private String    employeeId;
    private String    phone;
    private String    designation;
    private boolean   isActive;
    private int       failedAttempts;
    private Timestamp lockedUntil;
    private Timestamp createdAt;

    // Joined fields — not columns in users table
    // populated by JOINs in service queries
    private String departmentName;
    private String shiftName;
    private String managerName;

    public User() {}

    // ── Role checks ──────────────────────────────────────────────────────────

    public boolean isSuperAdmin() {
        return "SUPER_ADMIN".equals(role);
    }

    public boolean isAdmin() {
        // SUPER_ADMIN can do everything an ADMIN can
        return "ADMIN".equals(role) || "SUPER_ADMIN".equals(role);
    }

    public boolean isHR() {
        return "HR".equals(role);
    }

    public boolean isManager() {
        return "MANAGER".equals(role);
    }

    public boolean isEmployee() {
        return "EMPLOYEE".equals(role);
    }

    // ── Permission helpers ───────────────────────────────────────────────────

    public boolean canApproveLeave() {
        return isAdmin() || isHR() || isManager();
    }

    public boolean canViewReports() {
        return isAdmin() || isHR() || isManager();
    }

    public boolean canManageUsers() {
        return isAdmin() || isHR();
    }

    public boolean canManageDepartments() {
        return isAdmin();
    }

    public boolean canManageShifts() {
        return isAdmin();
    }

    public boolean canManageHolidays() {
        return isAdmin() || isHR();
    }

    public boolean canManageAnnouncements() {
        return isAdmin() || isHR();
    }

    public boolean canViewAuditLog() {
        return isAdmin();
    }

    // ── Display helper ───────────────────────────────────────────────────────

    public String getInitials() {
        if (fullName == null || fullName.isEmpty()) return "?";
        String[] parts = fullName.trim().split("\\s+");
        if (parts.length == 1) return parts[0].substring(0, 1).toUpperCase();
        return (parts[0].substring(0, 1) + parts[parts.length - 1].substring(0, 1)).toUpperCase();
    }

    public String getRoleDisplay() {
        if (role == null) return "";
        return role.replace("_", " ");
    }

    // ── Getters and Setters ──────────────────────────────────────────────────

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getOrgId() { return orgId; }
    public void setOrgId(int orgId) { this.orgId = orgId; }

    public int getDeptId() { return deptId; }
    public void setDeptId(int deptId) { this.deptId = deptId; }

    public int getShiftId() { return shiftId; }
    public void setShiftId(int shiftId) { this.shiftId = shiftId; }

    public int getManagerId() { return managerId; }
    public void setManagerId(int managerId) { this.managerId = managerId; }

    public String getFullName() { return fullName; }
    public void setFullName(String fullName) { this.fullName = fullName; }

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }

    public String getPasswordHash() { return passwordHash; }
    public void setPasswordHash(String passwordHash) { this.passwordHash = passwordHash; }

    public String getRole() { return role; }
    public void setRole(String role) { this.role = role; }

    public String getEmployeeId() { return employeeId; }
    public void setEmployeeId(String employeeId) { this.employeeId = employeeId; }

    public String getPhone() { return phone; }
    public void setPhone(String phone) { this.phone = phone; }

    public String getDesignation() { return designation; }
    public void setDesignation(String designation) { this.designation = designation; }

    public boolean isActive() { return isActive; }
    public void setActive(boolean active) { isActive = active; }

    public int getFailedAttempts() { return failedAttempts; }
    public void setFailedAttempts(int failedAttempts) { this.failedAttempts = failedAttempts; }

    public Timestamp getLockedUntil() { return lockedUntil; }
    public void setLockedUntil(Timestamp lockedUntil) { this.lockedUntil = lockedUntil; }

    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }

    public String getDepartmentName() { return departmentName; }
    public void setDepartmentName(String departmentName) { this.departmentName = departmentName; }

    public String getShiftName() { return shiftName; }
    public void setShiftName(String shiftName) { this.shiftName = shiftName; }

    public String getManagerName() { return managerName; }
    public void setManagerName(String managerName) { this.managerName = managerName; }
}