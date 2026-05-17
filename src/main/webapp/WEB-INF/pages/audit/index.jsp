<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.attendance.model.AuditLog" %>
<%@ page import="java.util.List" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Audit Log — AttendanceMS</title>
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

            <%
                List<AuditLog> logs =
                    (List<AuditLog>) request.getAttribute("logs");
                int limit = (int) request.getAttribute("limit");
            %>

            <div class="page-header">
                <div class="page-header-left">
                    <h2>Audit Log</h2>
                    <p>
                        Last <%= logs != null ? logs.size() : 0 %>
                        system actions
                    </p>
                </div>
                <div style="display:flex; gap:10px;">
                    <a href="${pageContext.request.contextPath}/audit?limit=50"
                       class="btn btn-ghost btn-sm
                              <%= limit == 50 ? "btn-primary" : "" %>">
                        Last 50
                    </a>
                    <a href="${pageContext.request.contextPath}/audit?limit=100"
                       class="btn btn-ghost btn-sm
                              <%= limit == 100 ? "btn-primary" : "" %>">
                        Last 100
                    </a>
                    <a href="${pageContext.request.contextPath}/audit?limit=200"
                       class="btn btn-ghost btn-sm
                              <%= limit == 200 ? "btn-primary" : "" %>">
                        Last 200
                    </a>
                </div>
            </div>

            <div class="card">
                <div class="card-header">
                    <h3>System Actions</h3>
                    <span style="font-size:13px; color:var(--text-muted);">
                        Most recent first
                    </span>
                </div>

                <% if (logs == null || logs.isEmpty()) { %>
                    <div class="empty-state">
                        <div class="empty-state-icon">📋</div>
                        <h3>No audit entries</h3>
                        <p>System actions will appear here once recorded.</p>
                    </div>
                <% } else { %>
                    <div class="table-wrapper">
                        <table class="data-table">
                            <thead>
                                <tr>
                                    <th>Timestamp</th>
                                    <th>User</th>
                                    <th>Action</th>
                                    <th>Table</th>
                                    <th>Record ID</th>
                                    <th>Old Value</th>
                                    <th>New Value</th>
                                    <th>IP Address</th>
                                </tr>
                            </thead>
                            <tbody>
                                <% for (AuditLog log : logs) { %>
                                <tr>
                                    <td style="font-size:12px;
                                               color:var(--text-muted);
                                               white-space:nowrap;">
                                        <%= log.getCreatedDateFormatted() %>
                                    </td>
                                    <td>
                                        <span style="font-weight:600;
                                                     font-size:13px;
                                                     color:var(--text-heading);">
                                            <%= log.getUserName() != null
                                                ? log.getUserName()
                                                : "System" %>
                                        </span>
                                    </td>
                                    <td>
                                        <%
                                            String action = log.getAction();
                                            String actionClass = "badge-default";
                                            if (action != null) {
                                                if (action.contains("LOGIN"))
                                                    actionClass = "badge-present";
                                                else if (action.contains("LOGOUT"))
                                                    actionClass = "badge-leave";
                                                else if (action.contains("APPROVED"))
                                                    actionClass = "badge-approved";
                                                else if (action.contains("REJECTED"))
                                                    actionClass = "badge-rejected";
                                                else if (action.contains("DELETED"))
                                                    actionClass = "badge-absent";
                                                else if (action.contains("ADDED") ||
                                                         action.contains("REGISTERED"))
                                                    actionClass = "badge-present";
                                            }
                                        %>
                                        <span class="badge <%= actionClass %>"
                                              style="font-size:11px;">
                                            <%= action != null
                                                ? action : "—" %>
                                        </span>
                                    </td>
                                    <td style="font-size:12px;
                                               color:var(--text-muted);">
                                        <%= log.getTableName() != null
                                            ? log.getTableName() : "—" %>
                                    </td>
                                    <td style="font-size:12px;
                                               color:var(--text-muted);
                                               text-align:center;">
                                        <%= log.getRecordId() > 0
                                            ? log.getRecordId() : "—" %>
                                    </td>
                                    <td style="font-size:12px;
                                               color:var(--text-muted);
                                               max-width:120px;">
                                        <%= log.getOldValue() != null
                                            ? log.getOldValue() : "—" %>
                                    </td>
                                    <td style="font-size:12px;
                                               color:var(--text-muted);
                                               max-width:120px;">
                                        <%= log.getNewValue() != null
                                            ? log.getNewValue() : "—" %>
                                    </td>
                                    <td style="font-size:12px;
                                               color:var(--text-muted);">
                                        <%= log.getIpAddress() != null
                                            ? log.getIpAddress() : "—" %>
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