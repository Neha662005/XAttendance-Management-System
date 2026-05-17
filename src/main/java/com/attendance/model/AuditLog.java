package com.attendance.model;

import java.sql.Timestamp;

public class AuditLog {

    private int       id;
    private int       userId;
    private String    userName;
    private String    action;
    private String    tableName;
    private int       recordId;
    private String    oldValue;
    private String    newValue;
    private String    ipAddress;
    private Timestamp createdAt;

    public AuditLog() {}

    public String getCreatedDateFormatted() {
        if (createdAt == null) return "—";
        return createdAt.toString().substring(0, 16).replace("T", " ");
    }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }

    public String getUserName() { return userName; }
    public void setUserName(String userName) { this.userName = userName; }

    public String getAction() { return action; }
    public void setAction(String action) { this.action = action; }

    public String getTableName() { return tableName; }
    public void setTableName(String tableName) { this.tableName = tableName; }

    public int getRecordId() { return recordId; }
    public void setRecordId(int recordId) { this.recordId = recordId; }

    public String getOldValue() { return oldValue; }
    public void setOldValue(String oldValue) { this.oldValue = oldValue; }

    public String getNewValue() { return newValue; }
    public void setNewValue(String newValue) { this.newValue = newValue; }

    public String getIpAddress() { return ipAddress; }
    public void setIpAddress(String ipAddress) { this.ipAddress = ipAddress; }

    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }
}