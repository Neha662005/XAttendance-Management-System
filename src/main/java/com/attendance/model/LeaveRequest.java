package com.attendance.model;

import java.sql.Date;
import java.sql.Timestamp;

public class LeaveRequest {

    private int       id;
    private int       userId;
    private int       leaveTypeId;
    private String    userName;
    private String    departmentName;
    private String    leaveTypeName;
    private String    approvedByName;
    private Date      fromDate;
    private Date      toDate;
    private int       totalDays;
    private String    reason;
    private String    status;
    private int       approvedBy;
    private String    approvalNote;
    private Timestamp appliedAt;
    private Timestamp actionedAt;

    public LeaveRequest() {}

    // ── Computed helpers ─────────────────────────────────────────────────────

    public String getStatusBadgeClass() {
        if (status == null) return "badge-default";
        switch (status) {
            case "APPROVED":  return "badge-approved";
            case "REJECTED":  return "badge-rejected";
            case "CANCELLED": return "badge-cancelled";
            default:          return "badge-pending";
        }
    }

    public String getAppliedDateFormatted() {
        if (appliedAt == null) return "—";
        return appliedAt.toString().substring(0, 10);
    }

    // ── Getters and Setters ──────────────────────────────────────────────────

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }

    public int getLeaveTypeId() { return leaveTypeId; }
    public void setLeaveTypeId(int leaveTypeId) { this.leaveTypeId = leaveTypeId; }

    public String getUserName() { return userName; }
    public void setUserName(String userName) { this.userName = userName; }

    public String getDepartmentName() { return departmentName; }
    public void setDepartmentName(String departmentName) { this.departmentName = departmentName; }

    public String getLeaveTypeName() { return leaveTypeName; }
    public void setLeaveTypeName(String leaveTypeName) { this.leaveTypeName = leaveTypeName; }

    public String getApprovedByName() { return approvedByName; }
    public void setApprovedByName(String approvedByName) { this.approvedByName = approvedByName; }

    public Date getFromDate() { return fromDate; }
    public void setFromDate(Date fromDate) { this.fromDate = fromDate; }

    public Date getToDate() { return toDate; }
    public void setToDate(Date toDate) { this.toDate = toDate; }

    public int getTotalDays() { return totalDays; }
    public void setTotalDays(int totalDays) { this.totalDays = totalDays; }

    public String getReason() { return reason; }
    public void setReason(String reason) { this.reason = reason; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public int getApprovedBy() { return approvedBy; }
    public void setApprovedBy(int approvedBy) { this.approvedBy = approvedBy; }

    public String getApprovalNote() { return approvalNote; }
    public void setApprovalNote(String approvalNote) { this.approvalNote = approvalNote; }

    public Timestamp getAppliedAt() { return appliedAt; }
    public void setAppliedAt(Timestamp appliedAt) { this.appliedAt = appliedAt; }

    public Timestamp getActionedAt() { return actionedAt; }
    public void setActionedAt(Timestamp actionedAt) { this.actionedAt = actionedAt; }
}