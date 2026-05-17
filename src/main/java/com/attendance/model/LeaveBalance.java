package com.attendance.model;

public class LeaveBalance {

    private int    id;
    private int    userId;
    private int    leaveTypeId;
    private String leaveTypeName;
    private int    year;
    private int    totalDays;
    private int    usedDays;

    public LeaveBalance() {}

    // ── Computed ─────────────────────────────────────────────────────────────

    public int getRemainingDays() {
        return Math.max(0, totalDays - usedDays);
    }

    public int getUsedPercent() {
        if (totalDays == 0) return 0;
        return Math.min(100, (int) ((usedDays * 100.0) / totalDays));
    }

    public String getProgressColor() {
        int pct = getUsedPercent();
        if (pct >= 90) return "progress-danger";
        if (pct >= 60) return "progress-warning";
        return "progress-normal";
    }

    // ── Getters and Setters ──────────────────────────────────────────────────

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }

    public int getLeaveTypeId() { return leaveTypeId; }
    public void setLeaveTypeId(int leaveTypeId) { this.leaveTypeId = leaveTypeId; }

    public String getLeaveTypeName() { return leaveTypeName; }
    public void setLeaveTypeName(String leaveTypeName) { this.leaveTypeName = leaveTypeName; }

    public int getYear() { return year; }
    public void setYear(int year) { this.year = year; }

    public int getTotalDays() { return totalDays; }
    public void setTotalDays(int totalDays) { this.totalDays = totalDays; }

    public int getUsedDays() { return usedDays; }
    public void setUsedDays(int usedDays) { this.usedDays = usedDays; }
}