<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.attendance.model.Holiday" %>
<%@ page import="java.util.List" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Holidays — AttendanceMS</title>
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
                List<Holiday> holidays =
                    (List<Holiday>) request.getAttribute("holidays");
            %>

            <div class="page-header">
                <div class="page-header-left">
                    <h2>Public Holidays</h2>
                    <p>Manage public holidays for your organization</p>
                </div>
                <button class="btn btn-primary"
                        onclick="openModal('addHolidayModal')">
                    + Add Holiday
                </button>
            </div>

            <div class="card">
                <div class="card-header">
                    <h3>Holiday Calendar</h3>
                </div>
                <% if (holidays == null || holidays.isEmpty()) { %>
                    <div class="empty-state">
                        <div class="empty-state-icon">🎉</div>
                        <h3>No holidays added</h3>
                        <p>Add public holidays to let your team know.</p>
                    </div>
                <% } else { %>
                <div class="table-wrapper">
                    <table class="data-table">
                        <thead>
                            <tr>
                                <th>Holiday</th>
                                <th>Date</th>
                                <th>Description</th>
                                <th>Action</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% for (Holiday h : holidays) { %>
                            <tr>
                                <td>
                                    <span style="font-weight:600;
                                                 color:var(--text-heading);">
                                        <%= h.getName() %>
                                    </span>
                                </td>
                                <td>
                                    <span class="badge badge-holiday"
                                          style="font-size:12px;">
                                        <%= h.getHolidayDate() %>
                                    </span>
                                </td>
                                <td style="color:var(--text-muted);
                                           font-size:13px;">
                                    <%= h.getDescription() != null
                                        && !h.getDescription().isEmpty()
                                        ? h.getDescription() : "—" %>
                                </td>
                                <td>
                                    <form method="POST"
                                          action="${pageContext.request.contextPath}/holiday">
                                        <input type="hidden"
                                               name="action"
                                               value="delete">
                                        <input type="hidden"
                                               name="holidayId"
                                               value="<%= h.getId() %>">
                                        <button type="submit"
                                                class="btn btn-outline-danger btn-sm"
                                                onclick="return confirmAction('Delete this holiday?')">
                                            Delete
                                        </button>
                                    </form>
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

<%-- Add Holiday Modal --%>
<div class="modal-overlay" id="addHolidayModal">
    <div class="modal">
        <div class="modal-header">
            <span class="modal-title">Add Holiday</span>
            <button class="modal-close"
                    onclick="closeModal('addHolidayModal')">
                &times;
            </button>
        </div>
        <form method="POST"
              action="${pageContext.request.contextPath}/holiday">
            <input type="hidden" name="action" value="add">
            <div class="modal-body">
                <div class="form-group">
                    <label class="form-label">
                        Holiday Name
                        <span class="form-required">*</span>
                    </label>
                    <input type="text" name="name"
                           class="form-control"
                           placeholder="e.g. New Year's Day"
                           required>
                </div>
                <div class="form-group">
                    <label class="form-label">
                        Date <span class="form-required">*</span>
                    </label>
                    <input type="date" name="holidayDate"
                           class="form-control" required>
                </div>
                <div class="form-group">
                    <label class="form-label">
                        Description
                    </label>
                    <input type="text" name="description"
                           class="form-control"
                           placeholder="Optional description...">
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-ghost"
                        onclick="closeModal('addHolidayModal')">
                    Cancel
                </button>
                <button type="submit" class="btn btn-primary">
                    Add Holiday
                </button>
            </div>
        </form>
    </div>
</div>

<script src="${pageContext.request.contextPath}/js/main.js"></script>
</body>
</html>