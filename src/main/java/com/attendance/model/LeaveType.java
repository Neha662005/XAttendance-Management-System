package com.attendance.model;

public class LeaveType {

    private int     id;
    private int     orgId;
    private String  name;
    private int     daysAllowed;
    private boolean isPaid;

    public LeaveType() {}

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getOrgId() { return orgId; }
    public void setOrgId(int orgId) { this.orgId = orgId; }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public int getDaysAllowed() { return daysAllowed; }
    public void setDaysAllowed(int daysAllowed) { this.daysAllowed = daysAllowed; }

    public boolean isPaid() { return isPaid; }
    public void setPaid(boolean paid) { isPaid = paid; }
}