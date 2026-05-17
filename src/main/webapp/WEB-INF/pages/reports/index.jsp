<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.attendance.model.*" %>
<%@ page import="com.attendance.model.Department" %>
<%@ page import="java.util.List" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Reports — AttendanceMS</title>
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

            <%-- Flash --%>
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
                List<AttendanceRecord> records =
                    (List<AttendanceRecord>) request.getAttribute("records");
                String fromDate =
                    (String) request.getAttribute("fromDate");
                String toDate =
                    (String) request.getAttribute("toDate");
                long presentCount =
                    request.getAttribute("presentCount") != null
                    ? (long) request.getAttribute("presentCount") : 0;
                long absentCount =
                    request.getAttribute("absentCount") != null
                    ? (long) request.getAttribute("absentCount") : 0;
                long lateCount =
                    request.getAttribute("lateCount") != null
                    ? (long) request.getAttribute("lateCount") : 0;
                long leaveCount =
                    request.getAttribute("leaveCount") != null
                    ? (long) request.getAttribute("leaveCount") : 0;
                long totalOT =
                    request.getAttribute("totalOT") != null
                    ? (long) request.getAttribute("totalOT") : 0;
                String otHours = (totalOT / 60) + "h " + (totalOT % 60) + "m";
            %>

            <div class="page-header">
                <div class="page-header-left">
                    <h2>Attendance Reports</h2>
                    <p>
                        <%= fromDate %> &mdash; <%= toDate %>
                    </p>
                </div>
                <%-- CSV Export button --%>
                <a href="${pageContext.request.contextPath}/reports?action=export&fromDate=<%= fromDate %>&toDate=<%= toDate %>"
                   class="btn btn-secondary">
                    <svg width="16" height="16" viewBox="0 0 24 24"
                         fill="none" stroke="currentColor"
                         stroke-width="2" stroke-linecap="round">
                        <path d="M21 15v4a2 2 0 01-2 2H5a2 2 0 01-2-2v-4"/>
                        <polyline points="7 10 12 15 17 10"/>
                        <line x1="12" y1="15" x2="12" y2="3"/>
                    </svg>
                    Export CSV
                </a>
            </div>

            <%-- Filter bar --%>
            <div class="card" style="margin-bottom:22px;">
                <div class="card-body" style="padding:18px 22px;">
                    <form action="${pageContext.request.contextPath}/reports"
                          method="GET"
                          style="display:flex; gap:14px;
                                 align-items:flex-end; flex-wrap:wrap;">
                        <input type="hidden" name="action" value="filter">

                        <div class="filter-group">
                            <span class="filter-label">From</span>
                            <input type="date" name="fromDate"
                                   class="form-control"
                                   style="min-width:160px;"
                                   value="<%= fromDate %>">
                        </div>

                        <div class="filter-group">
                            <span class="filter-label">To</span>
                            <input type="date" name="toDate"
                                   class="form-control"
                                   style="min-width:160px;"
                                   value="<%= toDate %>">
                        </div>

                        <button type="submit" class="btn btn-primary">
                            <svg width="16" height="16" viewBox="0 0 24 24"
                                 fill="none" stroke="currentColor"
                                 stroke-width="2" stroke-linecap="round">
                                <circle cx="11" cy="11" r="8"/>
                                <line x1="21" y1="21"
                                      x2="16.65" y2="16.65"/>
                            </svg>
                            Generate Report
                        </button>
                    </form>
                </div>
            </div>

            <%-- Summary stat cards --%>
            <div class="stats-grid" style="margin-bottom:22px;">

                <div class="stat-card">
                    <div class="stat-icon stat-icon-pink">
                        <svg width="22" height="22" viewBox="0 0 24 24"
                             fill="none" stroke="#c0607a" stroke-width="2"
                             stroke-linecap="round">
                            <path d="M14 2H6a2 2 0 00-2 2v16a2 2 0 002 2h12a2 2 0 002-2V8z"/>
                            <polyline points="14 2 14 8 20 8"/>
                            <line x1="16" y1="13" x2="8" y2="13"/>
                            <line x1="16" y1="17" x2="8" y2="17"/>
                        </svg>
                    </div>
                    <div class="stat-info">
                        <div class="stat-value">
                            <%= records != null ? records.size() : 0 %>
                        </div>
                        <div class="stat-label">Total Records</div>
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
                        <div class="stat-value"><%= presentCount %></div>
                        <div class="stat-label">Present Days</div>
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
                        <div class="stat-value"><%= absentCount %></div>
                        <div class="stat-label">Absent Days</div>
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
                        <div class="stat-value"><%= lateCount %></div>
                        <div class="stat-label">Late Arrivals</div>
                    </div>
                </div>

                <div class="stat-card">
                    <div class="stat-icon stat-icon-blue">
                        <svg width="22" height="22" viewBox="0 0 24 24"
                             fill="none" stroke="#2563eb" stroke-width="2"
                             stroke-linecap="round">
                            <rect x="3" y="4" width="18"
                                  height="18" rx="2"/>
                            <line x1="16" y1="2" x2="16" y2="6"/>
                            <line x1="8"  y1="2" x2="8"  y2="6"/>
                            <line x1="3"  y1="10" x2="21" y2="10"/>
                        </svg>
                    </div>
                    <div class="stat-info">
                        <div class="stat-value"><%= leaveCount %></div>
                        <div class="stat-label">Leave Days</div>
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
                        <div class="stat-value"><%= otHours %></div>
                        <div class="stat-label">Total Overtime</div>
                    </div>
                </div>

            </div>

            <%-- Data table --%>
            <div class="card">
                <div class="card-header">
                    <h3>Attendance Records</h3>
                    <span style="font-size:13px; color:var(--text-muted);">
                        <%= records != null ? records.size() : 0 %> records
                    </span>
                </div>

                <% if (records == null || records.isEmpty()) { %>
                    <div class="empty-state">
                        <div class="empty-state-icon">📊</div>
                        <h3>No records found</h3>
                        <p>
                            No attendance data for the selected period.
                            Try a different date range.
                        </p>
                    </div>
                <% } else { %>
                    <div class="table-wrapper">
                        <table class="data-table">
                            <thead>
                                <tr>
                                    <th>Employee</th>
                                    <th>Department</th>
                                    <th>Date</th>
                                    <th>Check In</th>
                                    <th>Check Out</th>
                                    <th>Overtime</th>
                                    <th>Shift</th>
                                    <th>Status</th>
                                </tr>
                            </thead>
                            <tbody>
                                <% for (AttendanceRecord r : records) { %>
                                <tr>
                                    <td>
                                        <span style="font-weight:600;
                                                     color:var(--text-heading);">
                                            <%= r.getUserFullName() %>
                                        </span>
                                    </td>
                                    <td style="font-size:13px;
                                               color:var(--text-muted);">
                                        <%= r.getDepartmentName() != null
                                            ? r.getDepartmentName() : "—" %>
                                    </td>
                                    <td style="font-weight:500;">
                                        <%= r.getAttendanceDate() %>
                                    </td>
                                    <td>
                                        <span style="font-family:'Plus Jakarta Sans',sans-serif;
                                                     font-weight:600;
                                                     color:var(--text-heading);">
                                            <%= r.getFormattedCheckIn() %>
                                        </span>
                                    </td>
                                    <td>
                                        <span style="font-family:'Plus Jakarta Sans',sans-serif;
                                                     font-weight:600;
                                                     color:var(--text-heading);">
                                            <%= r.getFormattedCheckOut() %>
                                        </span>
                                    </td>
                                    <td>
                                        <% if (r.getOvertimeMinutes() > 0) { %>
                                            <span style="color:#7c3aed;
                                                         font-weight:600;">
                                                <%= r.getOvertimeFormatted() %>
                                            </span>
                                        <% } else { %>
                                            <span style="color:var(--text-muted);">
                                                —
                                            </span>
                                        <% } %>
                                    </td>
                                    <td style="font-size:13px;
                                               color:var(--text-muted);">
                                        <%= r.getShiftName() != null
                                            ? r.getShiftName() : "—" %>
                                    </td>
                                    <td>
                                        <span class="badge
                                              <%= r.getStatusBadgeClass() %>">
                                            <%= r.getStatus() %>
                                        </span>
                                    </td>
                                </tr>
                                <% } %>
                            </tbody>
                        </table>
                    </div>
                <% } %>
            </div>

        </main>

        <jsp:include page="/WEB-INF/pages/partials/footer.jsp"/>

    </div>
</div>

<script src="${pageContext.request.contextPath}/js/main.js"></script>
</body>
</html>