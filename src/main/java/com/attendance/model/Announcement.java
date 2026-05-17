package com.attendance.model;

import java.sql.Timestamp;

public class Announcement {

    private int       id;
    private int       orgId;
    private int       createdBy;
    private String    createdByName;
    private String    title;
    private String    message;
    private boolean   isActive;
    private Timestamp createdAt;

    public Announcement() {}

    public String getCreatedDateFormatted() {
        if (createdAt == null) return "—";
        return createdAt.toString().substring(0, 10);
    }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getOrgId() { return orgId; }
    public void setOrgId(int orgId) { this.orgId = orgId; }

    public int getCreatedBy() { return createdBy; }
    public void setCreatedBy(int createdBy) { this.createdBy = createdBy; }

    public String getCreatedByName() { return createdByName; }
    public void setCreatedByName(String createdByName) { this.createdByName = createdByName; }

    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }

    public String getMessage() { return message; }
    public void setMessage(String message) { this.message = message; }

    public boolean isActive() { return isActive; }
    public void setActive(boolean active) { isActive = active; }

    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }
}