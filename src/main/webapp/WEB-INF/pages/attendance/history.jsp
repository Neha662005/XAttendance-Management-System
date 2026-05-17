<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.attendance.model.AttendanceRecord" %>
<%@ page import="java.util.List" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Attendance History — AttendanceMS</title>
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

            <div class="page-header">
                <div class="page-header-left">
                    <h2>Attendance History</h2>
                    <p>View your past attendance records</p>
                </div>
                <a href="${pageContext.request.contextPath}/attendance"
                   class="btn btn-primary">
                    Mark Today
                </a>
            </div>

            <%-- Date filter --%>
            <div class="card" style="margin-bottom:22px;">
                <div class="card-body" style="padding:18px 22px;">
                    <form action="${pageContext.request.contextPath}/attendance"
                          method="GET"
                          style="display:flex; gap:14px;
                                 align-items:flex-end; flex-wrap:wrap;">
                        <input type="hidden" name="action" value="history">

                        <div class="filter-group">
                            <span class="filter-label">From</span>
                            <input type="date"
                                   name="fromDate"
                                   class="form-control"
                                   style="min-width:160px;"
                                   value="${fromDate}">
                        </div>

                        <div class="filter-group">
                            <span class="filter-label">To</span>
                            <input type="date"
                                   name="toDate"
                                   class="form-control"
                                   style="min-width:160px;"
                                   value="${toDate}">
                        </div>

                        <button type="submit" class="btn btn-primary">
                            <svg width="16" height="16" viewBox="0 0 24 24"
                                 fill="none" stroke="currentColor"
                                 stroke-width="2" stroke-linecap="round">
                                <circle cx="11" cy="11" r="8"/>
                                <line x1="21" y1="21" x2="16.65" y2="16.65"/>
                            </svg>
                            Filter
                        </button>
                    </form>
                </div>
            </div>

            <%-- Results --%>
            <div class="card">
                <div class="card-header">
                    <h3>
                        Records from ${fromDate} to ${toDate}
                    </h3>
                    <%
                        List<AttendanceRecord> history =
                            (List<AttendanceRecord>)
                            request.getAttribute("history");
                    %>
                    <span style="font-size:13px; color:var(--text-muted);">
                        <%= history != null ? history.size() : 0 %> records
                    </span>
                </div>

                <% if (history == null || history.isEmpty()) { %>
                    <div class="empty-state">
                        <div class="empty-state-icon">📋</div>
                        <h3>No records found</h3>
                        <p>No attendance records for this date range.</p>
                    </div>
                <% } else { %>
                    <div class="table-wrapper">
                        <table class="data-table">
                            <thead>
                                <tr>
                                    <th>Date</th>
                                    <th>Check In</th>
                                    <th>Check Out</th>
                                    <th>Break</th>
                                    <th>Overtime</th>
                                    <th>Shift</th>
                                    <th>Status</th>
                                </tr>
                            </thead>
                            <tbody>
                                <% for (AttendanceRecord r : history) { %>
                                <tr>
                                    <td>
                                        <span style="font-weight:500;">
                                            <%= r.getAttendanceDate() %>
                                        </span>
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
                                        <% if (r.getBreakStart() != null) { %>
                                            <span style="font-size:12px;
                                                         color:var(--text-muted);">
                                                <%= r.getFormattedBreakStart() %>
                                                —
                                                <%= r.getFormattedBreakEnd() %>
                                            </span>
                                        <% } else { %>
                                            <span style="color:var(--text-muted);">—</span>
                                        <% } %>
                                    </td>
                                    <td>
                                        <% if (r.getOvertimeMinutes() > 0) { %>
                                            <span style="color:#7c3aed;
                                                         font-weight:600;">
                                                <%= r.getOvertimeFormatted() %>
                                            </span>
                                        <% } else { %>
                                            <span style="color:var(--text-muted);">—</span>
                                        <% } %>
                                    </td>
                                    <td>
                                        <span style="font-size:13px;
                                                     color:var(--text-muted);">
                                            <%= r.getShiftName() != null
                                                ? r.getShiftName() : "—" %>
                                        </span>
                                    </td>
                                    <td>
                                        <span class="badge <%= r.getStatusBadgeClass() %>">
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