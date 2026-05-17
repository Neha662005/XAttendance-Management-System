<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.attendance.model.*" %>
<%@ page import="java.util.List" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard — AttendanceMS</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700;800&family=Be+Vietnam+Pro:wght@300;400;500;600&display=swap"
          rel="stylesheet">
    <link rel="stylesheet"
          href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
<div class="app-shell">

    <jsp:include page="/WEB-INF/pages/partials/sidebar.jsp"/>

    <div class="main-area">

        <jsp:include page="/WEB-INF/pages/partials/header.jsp"/>

        <main class="page-content">

            <%-- Flash messages --%>
            <% if (session.getAttribute("flashMessage") != null) { %>
                <div class="alert alert-success">
                    <%= session.getAttribute("flashMessage") %>
                    <% session.removeAttribute("flashMessage"); %>
                </div>
            <% } %>
            <% if (session.getAttribute("flashError") != null) { %>
                <div class="alert alert-error">
                    <%= session.getAttribute("flashError") %>
                    <% session.removeAttribute("flashError"); %>
                </div>
            <% } %>

            <%
                User dashUser = (User) session.getAttribute("loggedInUser");
                AttendanceRecord todayRecord =
                    (AttendanceRecord) request.getAttribute("todayRecord");
                List<LeaveBalance> balances =
                    (List<LeaveBalance>) request.getAttribute("balances");
                List<Announcement> announcements =
                    (List<Announcement>) request.getAttribute("announcements");
            %>

            <%-- Welcome header --%>
            <div class="page-header">
                <div class="page-header-left">
                    <h2>Welcome back, <%= dashUser.getFullName().split(" ")[0] %> 👋</h2>
                    <p><%= request.getAttribute("todayDate") %></p>
                </div>
            </div>

            <%-- ── STAT CARDS (admin / hr / manager only) ── --%>
            <% if (dashUser.canViewReports() &&
                   request.getAttribute("totalEmployees") != null) { %>
            <div class="stats-grid">

                <div class="stat-card">
                    <div class="stat-icon stat-icon-pink">
                        <svg width="22" height="22" viewBox="0 0 24 24"
                             fill="none" stroke="#c0607a" stroke-width="2"
                             stroke-linecap="round">
                            <path d="M17 21v-2a4 4 0 00-4-4H5a4 4 0 00-4 4v2"/>
                            <circle cx="9" cy="7" r="4"/>
                            <path d="M23 21v-2a4 4 0 00-3-3.87"/>
                            <path d="M16 3.13a4 4 0 010 7.75"/>
                        </svg>
                    </div>
                    <div class="stat-info">
                        <div class="stat-value">
                            <%= request.getAttribute("totalEmployees") %>
                        </div>
                        <div class="stat-label">Total Employees</div>
                    </div>
                </div>

                <div class="stat-card">
                    <div class="stat-icon stat-icon-green">
                        <svg width="22" height="22" viewBox="0 0 24 24"
                             fill="none" stroke="#16a34a" stroke-width="2"
                             stroke-linecap="round">
                            <polyline points="20 6 9 17 4 12"/>
                        </svg>
                    </div>
                    <div class="stat-info">
                        <div class="stat-value">
                            <%= request.getAttribute("presentToday") %>
                        </div>
                        <div class="stat-label">Present Today</div>
                    </div>
                </div>

                <div class="stat-card">
                    <div class="stat-icon stat-icon-red">
                        <svg width="22" height="22" viewBox="0 0 24 24"
                             fill="none" stroke="#dc2626" stroke-width="2"
                             stroke-linecap="round">
                            <circle cx="12" cy="12" r="10"/>
                            <line x1="15" y1="9" x2="9" y2="15"/>
                            <line x1="9" y1="9" x2="15" y2="15"/>
                        </svg>
                    </div>
                    <div class="stat-info">
                        <div class="stat-value">
                            <%= request.getAttribute("absentToday") %>
                        </div>
                        <div class="stat-label">Absent Today</div>
                    </div>
                </div>

                <div class="stat-card">
                    <div class="stat-icon stat-icon-amber">
                        <svg width="22" height="22" viewBox="0 0 24 24"
                             fill="none" stroke="#d97706" stroke-width="2"
                             stroke-linecap="round">
                            <circle cx="12" cy="12" r="10"/>
                            <polyline points="12 6 12 12 16 14"/>
                        </svg>
                    </div>
                    <div class="stat-info">
                        <div class="stat-value">
                            <%= request.getAttribute("onLeaveToday") %>
                        </div>
                        <div class="stat-label">On Leave</div>
                    </div>
                </div>

                <div class="stat-card">
                    <div class="stat-icon stat-icon-blue">
                        <svg width="22" height="22" viewBox="0 0 24 24"
                             fill="none" stroke="#2563eb" stroke-width="2"
                             stroke-linecap="round">
                            <path d="M18 8A6 6 0 006 8c0 7-3 9-3 9h18s-3-2-3-9"/>
                            <path d="M13.73 21a2 2 0 01-3.46 0"/>
                        </svg>
                    </div>
                    <div class="stat-info">
                        <div class="stat-value">
                            <%= request.getAttribute("pendingLeaves") %>
                        </div>
                        <div class="stat-label">Pending Approvals</div>
                    </div>
                </div>

                <div class="stat-card">
                    <div class="stat-icon stat-icon-purple">
                        <svg width="22" height="22" viewBox="0 0 24 24"
                             fill="none" stroke="#7c3aed" stroke-width="2"
                             stroke-linecap="round">
                            <circle cx="12" cy="12" r="10"/>
                            <polyline points="12 6 12 12 16 14"/>
                        </svg>
                    </div>
                    <div class="stat-info">
                        <div class="stat-value">
                            <%= request.getAttribute("lateToday") %>
                        </div>
                        <div class="stat-label">Late Today</div>
                    </div>
                </div>

            </div>
            <% } %>

            <%-- ── TODAY'S ATTENDANCE CARD ── --%>
            <% if (todayRecord == null) { %>

                <%-- Not checked in yet --%>
                <div class="today-card">
                    <div class="today-card-left">
                        <div class="today-status-icon"
                             style="background:#fde8ed;">
                            <svg width="22" height="22" viewBox="0 0 24 24"
                                 fill="none" stroke="#dc2626" stroke-width="2"
                                 stroke-linecap="round">
                                <circle cx="12" cy="12" r="10"/>
                                <line x1="12" y1="8" x2="12" y2="12"/>
                                <line x1="12" y1="16" x2="12.01" y2="16"/>
                            </svg>
                        </div>
                        <div>
                            <div class="today-label">Not checked in yet</div>
                            <div class="today-sub">
                                Check in to start your work day
                            </div>
                        </div>
                    </div>
                    <form action="${pageContext.request.contextPath}/attendance"
                          method="POST">
                        <input type="hidden" name="action" value="checkin">
                        <button type="submit" class="btn btn-primary btn-lg">
                            <svg width="16" height="16" viewBox="0 0 24 24"
                                 fill="none" stroke="currentColor"
                                 stroke-width="2" stroke-linecap="round">
                                <polyline points="20 6 9 17 4 12"/>
                            </svg>
                            Check In Now
                        </button>
                    </form>
                </div>

            <% } else { %>

                <%-- Checked in --%>
                <div class="today-card">
                    <div class="today-card-left">
                        <div class="today-status-icon">
                            <svg width="22" height="22" viewBox="0 0 24 24"
                                 fill="none" stroke="#c0607a" stroke-width="2"
                                 stroke-linecap="round">
                                <polyline points="20 6 9 17 4 12"/>
                            </svg>
                        </div>
                        <div>
                            <div class="today-label">
                                <%= todayRecord.getStatus() %>
                                <span class="badge <%= todayRecord.getStatusBadgeClass() %>"
                                      style="margin-left:8px;">
                                    <%= todayRecord.getStatus() %>
                                </span>
                            </div>
                            <div class="today-sub">
                                <% if (todayRecord.getShiftName() != null) { %>
                                    <%= todayRecord.getShiftName() %>
                                <% } %>
                            </div>
                        </div>
                    </div>

                    <div class="today-times">
                        <div class="today-time-item">
                            <div class="today-time-value">
                                <%= todayRecord.getFormattedCheckIn() %>
                            </div>
                            <div class="today-time-label">Check In</div>
                        </div>

                        <div class="today-time-item">
                            <div class="today-time-value">
                                <%= todayRecord.getFormattedCheckOut() %>
                            </div>
                            <div class="today-time-label">Check Out</div>
                        </div>

                        <% if (todayRecord.getOvertimeMinutes() > 0) { %>
                        <div class="today-time-item">
                            <div class="today-time-value"
                                 style="color:#7c3aed;">
                                <%= todayRecord.getOvertimeFormatted() %>
                            </div>
                            <div class="today-time-label">Overtime</div>
                        </div>
                        <% } %>
                    </div>

                    <%-- Action buttons --%>
                    <div style="display:flex; gap:10px; flex-wrap:wrap;">

                        <% if (todayRecord.getCheckOut() == null) { %>

                            <% if (todayRecord.getBreakStart() == null) { %>
                                <%-- Start break --%>
                                <form action="${pageContext.request.contextPath}/attendance"
                                      method="POST">
                                    <input type="hidden" name="action"
                                           value="startbreak">
                                    <button type="submit"
                                            class="btn btn-ghost">
                                        Start Break
                                    </button>
                                </form>
                            <% } else if (todayRecord.getBreakEnd() == null) { %>
                                <%-- End break --%>
                                <form action="${pageContext.request.contextPath}/attendance"
                                      method="POST">
                                    <input type="hidden" name="action"
                                           value="endbreak">
                                    <button type="submit"
                                            class="btn btn-ghost">
                                        End Break
                                    </button>
                                </form>
                            <% } %>

                            <%-- Check out --%>
                            <form action="${pageContext.request.contextPath}/attendance"
                                  method="POST">
                                <input type="hidden" name="action"
                                       value="checkout">
                                <button type="submit"
                                        class="btn btn-secondary">
                                    Check Out
                                </button>
                            </form>

                        <% } else { %>
                            <span class="badge badge-present"
                                  style="padding:10px 16px; font-size:13px;">
                                Day complete
                            </span>
                        <% } %>

                    </div>
                </div>

            <% } %>

            <%-- ── TWO COLUMN LAYOUT ── --%>
            <div style="display:grid;
                        grid-template-columns: 1fr 1fr;
                        gap: 22px;
                        align-items: start;">

                <%-- Left column — Leave Balances + Quick Links --%>
                <div>

                    <%-- Leave Balances --%>
                    <% if (balances != null && !balances.isEmpty()) { %>
                    <div class="card">
                        <div class="card-header">
                            <h3>Leave Balances</h3>
                            <a href="${pageContext.request.contextPath}/leave"
                               class="btn btn-ghost btn-sm">
                                Apply Leave
                            </a>
                        </div>
                        <div class="card-body">
                            <div class="balance-grid">
                                <% for (LeaveBalance lb : balances) { %>
                                <div class="balance-card">
                                    <div class="balance-name">
                                        <%= lb.getLeaveTypeName() %>
                                    </div>
                                    <div class="balance-numbers">
                                        <span class="balance-remaining">
                                            <%= lb.getRemainingDays() %>
                                        </span>
                                        <span class="balance-total">
                                            / <%= lb.getTotalDays() %> days
                                        </span>
                                    </div>
                                    <div class="progress-wrap">
                                        <div class="progress-fill <%= lb.getProgressColor() %>"
                                             style="width:<%= lb.getUsedPercent() %>%;">
                                        </div>
                                    </div>
                                    <div class="balance-used">
                                        <%= lb.getUsedDays() %> used
                                    </div>
                                </div>
                                <% } %>
                            </div>
                        </div>
                    </div>
                    <% } %>

                    <%-- Quick Links --%>
                    <div class="card">
                        <div class="card-header">
                            <h3>Quick Actions</h3>
                        </div>
                        <div class="card-body">
                            <div class="quick-links">
                                <a href="${pageContext.request.contextPath}/attendance?action=history"
                                   class="quick-link">
                                    <div class="quick-link-icon">
                                        <svg width="20" height="20"
                                             viewBox="0 0 24 24" fill="none"
                                             stroke="#c0607a" stroke-width="2"
                                             stroke-linecap="round">
                                            <circle cx="12" cy="12" r="10"/>
                                            <polyline points="12 6 12 12 16 14"/>
                                        </svg>
                                    </div>
                                    My Attendance
                                </a>

                                <a href="${pageContext.request.contextPath}/leave"
                                   class="quick-link">
                                    <div class="quick-link-icon">
                                        <svg width="20" height="20"
                                             viewBox="0 0 24 24" fill="none"
                                             stroke="#c0607a" stroke-width="2"
                                             stroke-linecap="round">
                                            <rect x="3" y="4" width="18"
                                                  height="18" rx="2"/>
                                            <line x1="16" y1="2"
                                                  x2="16" y2="6"/>
                                            <line x1="8" y1="2"
                                                  x2="8" y2="6"/>
                                            <line x1="3" y1="10"
                                                  x2="21" y2="10"/>
                                        </svg>
                                    </div>
                                    Apply Leave
                                </a>

                                <% if (dashUser.canApproveLeave()) { %>
                                <a href="${pageContext.request.contextPath}/leave?action=approve"
                                   class="quick-link">
                                    <div class="quick-link-icon">
                                        <svg width="20" height="20"
                                             viewBox="0 0 24 24" fill="none"
                                             stroke="#c0607a" stroke-width="2"
                                             stroke-linecap="round">
                                            <polyline points="20 6 9 17 4 12"/>
                                        </svg>
                                    </div>
                                    Approvals
                                </a>
                                <% } %>

                                <% if (dashUser.canViewReports()) { %>
                                <a href="${pageContext.request.contextPath}/reports"
                                   class="quick-link">
                                    <div class="quick-link-icon">
                                        <svg width="20" height="20"
                                             viewBox="0 0 24 24" fill="none"
                                             stroke="#c0607a" stroke-width="2"
                                             stroke-linecap="round">
                                            <line x1="18" y1="20"
                                                  x2="18" y2="10"/>
                                            <line x1="12" y1="20"
                                                  x2="12" y2="4"/>
                                            <line x1="6" y1="20"
                                                  x2="6" y2="14"/>
                                        </svg>
                                    </div>
                                    Reports
                                </a>
                                <% } %>

                                <% if (dashUser.canManageUsers()) { %>
                                <a href="${pageContext.request.contextPath}/users"
                                   class="quick-link">
                                    <div class="quick-link-icon">
                                        <svg width="20" height="20"
                                             viewBox="0 0 24 24" fill="none"
                                             stroke="#c0607a" stroke-width="2"
                                             stroke-linecap="round">
                                            <path d="M17 21v-2a4 4 0 00-4-4H5a4 4 0 00-4 4v2"/>
                                            <circle cx="9" cy="7" r="4"/>
                                        </svg>
                                    </div>
                                    Users
                                </a>
                                <% } %>

                            </div>
                        </div>
                    </div>

                </div>

                <%-- Right column — Announcements --%>
                <div>
                    <div class="card">
                        <div class="card-header">
                            <h3>Announcements</h3>
                            <% if (dashUser.canManageAnnouncements()) { %>
                            <a href="${pageContext.request.contextPath}/announcements"
                               class="btn btn-ghost btn-sm">
                                Manage
                            </a>
                            <% } %>
                        </div>
                        <% if (announcements == null || announcements.isEmpty()) { %>
                            <div class="empty-state" style="padding:40px 24px;">
                                <div class="empty-state-icon">📢</div>
                                <h3>No announcements</h3>
                                <p>Nothing to show right now.</p>
                            </div>
                        <% } else { %>
                            <% for (Announcement ann : announcements) { %>
                            <div class="announcement-item">
                                <div class="announcement-dot"></div>
                                <div>
                                    <div class="announcement-title">
                                        <%= ann.getTitle() %>
                                    </div>
                                    <div class="announcement-body">
                                        <%= ann.getMessage() %>
                                    </div>
                                    <div class="announcement-date">
                                        <%= ann.getCreatedDateFormatted() %>
                                        &mdash; <%= ann.getCreatedByName() %>
                                    </div>
                                </div>
                            </div>
                            <% } %>
                        <% } %>
                    </div>
                </div>

            </div>

        </main>

        <jsp:include page="/WEB-INF/pages/partials/footer.jsp"/>

    </div>
</div>

<script src="${pageContext.request.contextPath}/js/main.js"></script>
</body>
</html>