Many organizations still rely on manual paper registers and scattered spreadsheets for tracking attendance — methods that are inefficient, error-prone, and difficult to audit. The Generic Attendance Management System solves this by bringing attendance recording, leave management, and user administration into a single secure, scalable, role-based platform.

🎯 Purpose
Replace paper registers and spreadsheet tracking with a centralized digital platform
Provide real-time visibility into attendance, leave, and workforce data
Be industry-agnostic — usable by schools, companies, hospitals, NGOs, and more
Automate timestamp recording with database-level constraints to prevent duplicate entries
👥 Intended Audience
Role	Capabilities
Super Admin	Full platform control, multi-organization management
Administrator	Org-level settings, departments, shifts, holidays, announcements, user accounts
HR	Leave policies, approvals, balances, payroll reports
Manager	Team attendance monitoring, leave approvals
Employee	Check-in/out, leave applications, history viewing
✨ Key Features
🔐 Secure Authentication — BCrypt password hashing + HttpSession management
🛡️ Role-Based Access Control — Admin, HR, Manager, Employee roles
⏰ Daily Attendance — Check-in / Check-out / Break tracking with DB timestamps
📝 Leave Workflow — Request → Approve/Reject → Balance updates
👥 User Management — Activate/deactivate accounts, change roles
🏢 Department & Shift Management — Configurable organizational structure
🎉 Holiday Management — Auto-detection of public holidays
📢 Announcements — Broadcast messages to employee dashboards
📊 Reports & Analytics — CSV export, date-range filtering, summary cards
🔍 Audit Logs — Full traceability of system actions
🎨 Responsive UI — Works seamlessly on mobile and desktop
🛠️ Tech Stack
Layer	Technology
Language	Java 17
Backend	Jakarta EE (Servlets, JSP, JDBC)
Frontend	HTML5, CSS3, JavaScript, JSTL
Database	MySQL 8.0
Build Tool	Apache Maven
Server	Apache Tomcat 10.1
IDE	Eclipse IDE for Enterprise Java
Security	BCrypt Password Hashing
Database Tool	XAMPP / phpMyAdmin
Architecture	Model-View-Controller (MVC)
🏗️ Architecture (MVC)
The application strictly follows the Model-View-Controller design pattern to ensure clean separation of concerns.

┌──────────────────────────────────────────────────────────┐
│ CLIENT │
│ (Browser / HTTP Request) │
└────────────────────────┬─────────────────────────────────┘
│
▼
┌──────────────────────────────────────────────────────────┐
│ AUTH FILTER │
│ (Intercepts all requests, validates session) │
└────────────────────────┬─────────────────────────────────┘
│
▼
┌──────────────────────────────────────────────────────────┐
│ CONTROLLER LAYER │
│ com.attendance.controllers (Servlets) │
│ - doGet(): load pages, retrieve data │
│ - doPost(): handle form submissions & business logic │
└────────────────────────┬─────────────────────────────────┘
│
▼
┌──────────────────────────────────────────────────────────┐
│ SERVICE LAYER │
│ com.attendance.service (JDBC + PreparedStatements)│
│ - Business logic + Database interactions │
│ - SQL injection protection │
└────────────────────────┬─────────────────────────────────┘
│
▼
┌──────────────────────────────────────────────────────────┐
│ MODEL LAYER │
│ com.attendance.model (POJOs) │
│ - User, AttendanceRecord, LeaveRequest, Department, etc.│
└────────────────────────┬─────────────────────────────────┘
│
▼
┌──────────────────────────────────────────────────────────┐
│ VIEW LAYER (JSP) │
│ WEB-INF/pages (protected from direct access) │
└──────────────────────────────────────────────────────────┘

text


> 📷 **Screenshot Placeholder:**
> 
> ![MVC Architecture Diagram](./screenshots/mvc-architecture.png)

---

## 📁 Project Structure

AttendanceManagementSystem/
│
├── src/main/java/
│ └── com/attendance/
│ ├── config/
│ │ └── DBConfig.java # Database connection manager
│ │
│ ├── model/ # Data models (POJOs)
│ │ ├── User.java
│ │ ├── AttendanceRecord.java
│ │ ├── LeaveRequest.java
│ │ ├── LeaveBalance.java
│ │ ├── Department.java
│ │ ├── Shift.java
│ │ ├── Holiday.java
│ │ ├── Announcement.java
│ │ └── AuditLog.java
│ │
│ ├── service/ # Business logic + DB operations
│ │ ├── UserService.java
│ │ ├── AttendanceService.java
│ │ ├── LeaveService.java
│ │ ├── DepartmentService.java
│ │ ├── ShiftService.java
│ │ ├── HolidayService.java
│ │ ├── AnnouncementService.java
│ │ └── AuditService.java
│ │
│ ├── controllers/ # Servlets (request handlers)
│ │ ├── RegisterServlet.java
│ │ ├── UserServlet.java
│ │ ├── DepartmentServlet.java
│ │ ├── ShiftServlet.java
│ │ ├── HolidayServlet.java
│ │ ├── AnnouncementServlet.java
│ │ ├── ReportServlet.java
│ │ ├── ProfileServlet.java
│ │ ├── AuditServlet.java
│ │ ├── GetDepartmentsServlet.java
│ │ └── HashGen.java
│ │
│ └── filter/
│ └── AuthFilter.java # Global authentication filter
│
├── src/main/webapp/
│ └── WEB-INF/
│ ├── pages/ # JSP views
│ │ ├── login.jsp
│ │ ├── register.jsp
│ │ ├── dashboard.jsp
│ │ ├── attendance.jsp
│ │ ├── leaveRequest.jsp
│ │ ├── leaveApproval.jsp
│ │ ├── reports.jsp
│ │ ├── users.jsp
│ │ ├── departments.jsp
│ │ ├── shifts.jsp
│ │ ├── holidays.jsp
│ │ ├── announcements.jsp
│ │ └── auditLog.jsp
│ │
│ └── web.xml (optional - annotation-based config used)
│
├── pom.xml # Maven build configuration
└── README.md

text


---

## 🗄️ Database Schema

The database consists of **11 tables** managing all aspects of attendance, leave, and user management:

| # | Table Name | Description |
|---|-----------|-------------|
| 1 | `users` | User accounts & credentials |
| 2 | `attendance_record` | Daily check-in/check-out logs |
| 3 | `leave_request` | Leave applications & status |
| 4 | `leave_balance` | Yearly leave entitlements per user |
| 5 | `leave_types` | Configurable leave categories |
| 6 | `department` | Organizational departments |
| 7 | `shifts` | Work shift definitions |
| 8 | `organizations` | Multi-organization support |
| 9 | `announcement` | System-wide broadcasts |
| 10 | `audit_log` | Activity tracking |
| 11 | `holiday` | Public holidays |

> 📷 **Screenshot Placeholder:**
> 
> ![Entity Relationship Schema](./screenshots/er-schema.png)

---

## ⚙️ Installation & Setup

### Prerequisites
- ☕ **Java JDK 17** or higher
- 🐬 **MySQL 8.0** (via XAMPP or standalone)
- 🐱 **Apache Tomcat 10.1**
- 📦 **Apache Maven 3.8+**
- 💻 **Eclipse IDE for Enterprise Java** (recommended)

### Steps

1. **Clone the repository**
   ```bash
   git clone https://github.com/your-username/attendance-management-system.git
   cd attendance-management-system
Set up the database
Start XAMPP and launch Apache & MySQL
Open http://localhost/phpmyadmin
Create a new database (e.g., attendance_db)
Import the provided SQL schema file (database/schema.sql)
Configure database credentials
Open src/main/java/com/attendance/config/DBConfig.java
Update the following constants:
java

private static final String URL = "jdbc:mysql://localhost:3306/attendance_db";
private static final String USER = "root";
private static final String PASSWORD = "your_password";
Build with Maven
bash

mvn clean package
Deploy on Tomcat
Copy the generated .war file from target/ to $CATALINA_HOME/webapps/
OR add Tomcat server in Eclipse and run directly
Access the application
text

http://localhost:8080/AttendanceManagementSystem/
📸 Screenshots
Place your screenshots in a screenshots/ folder and link them below.

🔐 Login Page
Login Page

📝 Registration Page
Registration Page

📊 Dashboard (User View)
User Dashboard

📊 Dashboard (Admin View)
Admin Dashboard

⏰ Mark Attendance
Mark Attendance

📅 Attendance History
Attendance History

🏖️ Leave Request
Leave Request

✅ Leave Approval (Admin)
Leave Approval

📈 Reports
Reports

👥 Manage Users
Manage Users

🏢 Departments
Departments

⏱️ Shifts
Shifts

🎉 Holidays
Holidays

📢 Announcements
Announcements

🔍 Audit Logs
Audit Logs

🔄 CRUD Functionality
The system implements full Create, Read, Update, Delete operations across multiple modules:

Operation
Modules
Create (C)	Users, Departments, Shifts, Holidays, Announcements, Leave Requests, Attendance Records
Read (R)	Attendance History, Leave History, Reports, Audit Logs, User Lists
Update (U)	User Roles, User Status (Activate/Deactivate), Announcements (Activate/Deactivate), Leave Approvals
Delete (D)	Departments (with integrity checks), Shifts, Holidays, Announcements

🧪 Testing
The system underwent comprehensive testing across three categories:

1. ✅ Functional Testing (20 Test Cases)
Verified all features work as expected per requirements — including login, registration, attendance marking, leave workflow, and admin operations.

2. 📋 Validation Testing (15 Test Cases)
Tested form input validations, date range filters, email format checks, password matching, and field constraints.

3. ⚠️ Exception Testing (7 Test Cases)
Tested system behavior under error conditions — invalid credentials, database failures, unauthorized access, and concurrent operations.

📷 Screenshot Placeholder — Sample Test Case:

Test Cases

🔬 Critical Analysis
🚧 Development Challenges
Implementing strict MVC flow with all JSPs inside WEB-INF/pages
Database constraint management to prevent duplicate attendance entries
Role-based access control across multiple user types
Dynamic form interactions (Fetch API for department/shift loading)
BCrypt integration with legacy servlet workflows
📊 SWOT Analysis
Strengths 💪
Weaknesses 📉
Clean MVC architecture	No real-time notifications
BCrypt-secured authentication	Limited mobile app support
Industry-agnostic design	Manual report generation
Comprehensive audit logging	Single-language UI

Opportunities 🌟
Threats ⚠️
Mobile app extension	Competing SaaS platforms
Biometric integration	Data privacy regulations
AI-powered attendance predictions	Browser compatibility issues
Multi-language support	Server downtime risks

🚀 Future Recommendations
📱 Mobile Application — Native iOS/Android apps for on-the-go attendance
🔐 Biometric Authentication — Fingerprint/Face ID integration
📊 Advanced Analytics Dashboard — Charts and predictive insights
🔔 Real-time Notifications — WebSocket-based push notifications
🌐 Multi-language Support — Internationalization (i18n)
☁️ Cloud Deployment — AWS/Azure deployment with CI/CD pipeline
🤖 AI Anomaly Detection — Flag suspicious attendance patterns
📧 Email/SMS Integration — Automated leave status notifications
👩‍💻 Author
Neha K.C (Khatri)

🎓 London Met ID: 24046602
🎓 College ID: NP01AI4A240137
📚 Module: CS5003NI — Data Structure and Specialist Programming
🏫 Institution: London Metropolitan University (in affiliation with ISMT College)
📅 Academic Year: 2025/26 Autumn
💬 Feel free to connect for feedback, suggestions, or collaboration!

📄 License
This project is submitted as academic coursework for CS5003NI: Data Structure and Specialist Programming.

🚫 No commercial use permitted
📚 Educational reference only
© 2026 Neha K.C (Khatri). All rights reserved.
🙏 Acknowledgements
Module leader and faculty of CS5003NI
Apache Software Foundation — Tomcat, Maven
Oracle — Java & MySQL
Eclipse Foundation — IDE support
Open-source community for documentation and references
⭐ If you found this project helpful, please consider giving it a star! ⭐
