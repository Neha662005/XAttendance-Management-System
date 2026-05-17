package com.attendance.model;

public class Shift {

    private int    id;
    private int    orgId;
    private String name;
    private String startTime;
    private String endTime;
    private int    graceMinutes;
    private boolean isActive;
    private int    employeeCount;

    public Shift() {}

    public String getTimeRange() {
        return startTime + " — " + endTime;
    }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getOrgId() { return orgId; }
    public void setOrgId(int orgId) { this.orgId = orgId; }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public String getStartTime() { return startTime; }
    public void setStartTime(String startTime) { this.startTime = startTime; }

    public String getEndTime() { return endTime; }
    public void setEndTime(String endTime) { this.endTime = endTime; }

    public int getGraceMinutes() { return graceMinutes; }
    public void setGraceMinutes(int graceMinutes) { this.graceMinutes = graceMinutes; }

    public boolean isActive() { return isActive; }
    public void setActive(boolean active) { isActive = active; }

    public int getEmployeeCount() { return employeeCount; }
    public void setEmployeeCount(int employeeCount) { this.employeeCount = employeeCount; }
}