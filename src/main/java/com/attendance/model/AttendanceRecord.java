package com.attendance.model;

import java.sql.Date;
import java.sql.Timestamp;

public class AttendanceRecord {

    private int       id;
    private int       userId;
    private int       shiftId;
    private String    userFullName;
    private String    departmentName;
    private String    shiftName;
    private Timestamp checkIn;
    private Timestamp checkOut;
    private Timestamp breakStart;
    private Timestamp breakEnd;
    private Date      attendanceDate;
    private String    status;
    private int       overtimeMinutes;
    private String    remarks;

    public AttendanceRecord() {}

    // ── Computed helpers ─────────────────────────────────────────────────────

    public String getFormattedCheckIn() {
        if (checkIn == null) return "—";
        return checkIn.toString().substring(11, 16);
    }

    public String getFormattedCheckOut() {
        if (checkOut == null) return "Not yet";
        return checkOut.toString().substring(11, 16);
    }

    public String getFormattedBreakStart() {
        if (breakStart == null) return "—";
        return breakStart.toString().substring(11, 16);
    }

    public String getFormattedBreakEnd() {
        if (breakEnd == null) return "—";
        return breakEnd.toString().substring(11, 16);
    }

    public String getOvertimeFormatted() {
        if (overtimeMinutes <= 0) return "—";
        int hours   = overtimeMinutes / 60;
        int minutes = overtimeMinutes % 60;
        if (hours == 0) return minutes + "m";
        return hours + "h " + minutes + "m";
    }

    public String getStatusBadgeClass() {
        if (status == null) return "badge-default";
        switch (status) {
            case "PRESENT":  return "badge-present";
            case "ABSENT":   return "badge-absent";
            case "LATE":     return "badge-late";
            case "HALF_DAY": return "badge-half";
            case "ON_LEAVE": return "badge-leave";
            case "HOLIDAY":  return "badge-holiday";
            default:         return "badge-default";
        }
    }

    // ── Getters and Setters ──────────────────────────────────────────────────

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }

    public int getShiftId() { return shiftId; }
    public void setShiftId(int shiftId) { this.shiftId = shiftId; }

    public String getUserFullName() { return userFullName; }
    public void setUserFullName(String userFullName) { this.userFullName = userFullName; }

    public String getDepartmentName() { return departmentName; }
    public void setDepartmentName(String departmentName) { this.departmentName = departmentName; }

    public String getShiftName() { return shiftName; }
    public void setShiftName(String shiftName) { this.shiftName = shiftName; }

    public Timestamp getCheckIn() { return checkIn; }
    public void setCheckIn(Timestamp checkIn) { this.checkIn = checkIn; }

    public Timestamp getCheckOut() { return checkOut; }
    public void setCheckOut(Timestamp checkOut) { this.checkOut = checkOut; }

    public Timestamp getBreakStart() { return breakStart; }
    public void setBreakStart(Timestamp breakStart) { this.breakStart = breakStart; }

    public Timestamp getBreakEnd() { return breakEnd; }
    public void setBreakEnd(Timestamp breakEnd) { this.breakEnd = breakEnd; }

    public Date getAttendanceDate() { return attendanceDate; }
    public void setAttendanceDate(Date attendanceDate) { this.attendanceDate = attendanceDate; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public int getOvertimeMinutes() { return overtimeMinutes; }
    public void setOvertimeMinutes(int overtimeMinutes) { this.overtimeMinutes = overtimeMinutes; }

    public String getRemarks() { return remarks; }
    public void setRemarks(String remarks) { this.remarks = remarks; }
}