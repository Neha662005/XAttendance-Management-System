package com.attendance.model;

import java.sql.Date;

public class Holiday {

    private int    id;
    private int    orgId;
    private String name;
    private Date   holidayDate;
    private String description;

    public Holiday() {}

    public String getFormattedDate() {
        if (holidayDate == null) return "—";
        return holidayDate.toString();
    }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getOrgId() { return orgId; }
    public void setOrgId(int orgId) { this.orgId = orgId; }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public Date getHolidayDate() { return holidayDate; }
    public void setHolidayDate(Date holidayDate) { this.holidayDate = holidayDate; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }
}