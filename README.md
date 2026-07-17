# Attendance Management System

![Java](https://img.shields.io/badge/Java-17-orange)
![Jakarta EE](https://img.shields.io/badge/Jakarta%20EE-Servlets%20%26%20JSP-blue)
![MySQL](https://img.shields.io/badge/MySQL-8.0-blue)
![Maven](https://img.shields.io/badge/Maven-3.8+-red)
![Tomcat](https://img.shields.io/badge/Tomcat-10.1-yellow)
![Architecture](https://img.shields.io/badge/Architecture-MVC-success)

A secure, role-based **Attendance Management System** built using **Java EE (Servlets & JSP)** following the **Model-View-Controller (MVC)** architecture. The system digitizes attendance tracking, leave management, and workforce administration for organizations such as schools, colleges, companies, hospitals, and NGOs.

---

# Table of Contents

- [Overview](#-overview)
- [Features](#-features)
- [User Roles](#-user-roles)
- [Tech Stack](#-tech-stack)
- [Architecture](#-architecture)
- [Project Structure](#-project-structure)
- [Database Schema](#-database-schema)
- [Installation](#-installation)
- [Screenshots](#-screenshots)
- [CRUD Modules](#-crud-modules)
- [Testing](#-testing)
- [Challenges](#-challenges)
- [SWOT Analysis](#-swot-analysis)
- [Future Enhancements](#-future-enhancements)
- [Author](#-author)
- [License](#-license)

---

# Overview

Traditional attendance systems rely on paper registers or spreadsheets, making record management slow, error-prone, and difficult to audit.

This project provides a centralized web application that allows organizations to:

- Record employee attendance
- Manage leave requests
- Maintain departments and shifts
- Generate reports
- Track user activities
- Secure data using authentication and role-based authorization

---

# Features

- Secure Login using BCrypt Password Hashing
- Role-Based Access Control
- Check-In / Check-Out Attendance
- Leave Request & Approval Workflow
- Department Management
- Shift Management
- Holiday Management
- Organization Announcements
- Attendance Reports
- Audit Logging
- Responsive Interface
- 📁 CSV Report Export

---

# User Roles

| Role | Responsibilities |
|------|------------------|
| Super Admin | Platform management |
| Administrator | Manage users, departments, holidays, announcements |
| HR | Leave approval, payroll reports |
| Manager | Team attendance monitoring |
| Employee | Attendance marking and leave requests |

---

# Tech Stack

| Category | Technology |
|-----------|------------|
| Language | Java 17 |
| Backend | Jakarta EE (Servlets, JSP, JDBC) |
| Frontend | HTML5, CSS3, JavaScript, JSTL |
| Database | MySQL 8 |
| Server | Apache Tomcat 10.1 |
| Build Tool | Maven |
| IDE | Eclipse IDE |
| Security | BCrypt |
| Architecture | MVC |

---

# Architecture

The application follows the **Model-View-Controller (MVC)** architecture.

```
Browser
    │
    ▼
Authentication Filter
    │
    ▼
Controllers (Servlets)
    │
    ▼
Service Layer
    │
    ▼
MySQL Database
    ▲
    │
Models (POJOs)
    │
    ▼
JSP Views
```

---

# Project Structure

```text
AttendanceManagementSystem
│
├── src
│   ├── main
│   │   ├── java
│   │   │   └── com.attendance
│   │   │       ├── config
│   │   │       ├── controllers
│   │   │       ├── filter
│   │   │       ├── model
│   │   │       └── service
│   │   │
│   │   └── webapp
│   │       ├── WEB-INF
│   │       │   └── pages
│   │       └── assets
│   │
│   ├── pom.xml
│   └── README.md
```

---

# Database Schema

The project contains **11 core tables**.

| Table | Purpose |
|--------|----------|
| users | User accounts |
| attendance_record | Attendance records |
| leave_request | Leave applications |
| leave_balance | Leave balance |
| leave_types | Leave categories |
| department | Departments |
| shifts | Shift details |
| organizations | Organization data |
| holiday | Holiday calendar |
| announcement | Announcements |
| audit_log | System activity logs |

---

# Installation

## Prerequisites

- Java 17
- MySQL 8
- Apache Tomcat 10.1
- Apache Maven
- Eclipse IDE

## Clone Repository

```bash
git clone https://github.com/yourusername/attendance-management-system.git
```

## Configure Database

Create a MySQL database.

```sql
attendance_db
```

Update database credentials inside:

```text
DBConfig.java
```

Build project

```bash
mvn clean package
```

Deploy the generated WAR file to Tomcat.

Open:

```
http://localhost:8080/AttendanceManagementSystem/
```

---

# Screenshots

Add screenshots inside a `screenshots/` folder.

- Login Page
- Registration Page
- Dashboard
- Attendance
- Leave Request
- Leave Approval
- Reports
- Departments
- Shifts
- Holidays
- Users
- Announcements
- Audit Logs

---

# CRUD Modules

| Module | Create | Read | Update | Delete |
|----------|:------:|:----:|:------:|:------:|
| Users | ✅ | ✅ | ✅ | ❌ |
| Departments | ✅ | ✅ | ✅ | ✅ |
| Shifts | ✅ | ✅ | ✅ | ✅ |
| Holidays | ✅ | ✅ | ✅ | ✅ |
| Attendance | ✅ | ✅ | ❌ | ❌ |
| Leave Requests | ✅ | ✅ | ✅ | ❌ |
| Announcements | ✅ | ✅ | ✅ | ✅ |

---

# Testing

### Functional Testing

- Login
- Registration
- Attendance
- Leave Workflow
- User Management

### Validation Testing

- Email validation
- Password validation
- Required fields
- Date validation

### Exception Testing

- Invalid login
- Unauthorized access
- Database connection failure
- Duplicate attendance prevention

---

# Challenges

- Implementing complete MVC architecture
- Preventing duplicate attendance records
- Managing role-based permissions
- Secure password encryption using BCrypt
- Dynamic department and shift loading

---

# SWOT Analysis

| Strengths | Weaknesses |
|------------|------------|
| Secure authentication | No mobile app |
| MVC architecture | Limited analytics |
| Modular design | Manual reporting |
| Audit logging | Single language support |

| Opportunities | Threats |
|---------------|----------|
| Mobile application | SaaS competitors |
| AI attendance prediction | Privacy regulations |
| Cloud deployment | Server downtime |
| Multi-language support | Browser compatibility |

---

# Future Enhancements

- Mobile Application
- Biometric Authentication
- Interactive Dashboard
- Real-time Notifications
- Multi-language Support
- Cloud Deployment
- AI Attendance Analytics
- Email & SMS Notifications

---

# Author

**Neha K.C. (Khatri)**

---

# License

This project is submitted as academic coursework.

- Educational purposes only.
- Commercial use is not permitted.
- © 2026 Neha K.C. All Rights Reserved.

---

# Acknowledgements

- London Metropolitan University
- ISMT College
- Apache Software Foundation
- Eclipse Foundation
- Oracle Java
- MySQL Community
- Open Source Community

---

⭐ **If you found this project useful, consider giving it a star!**
