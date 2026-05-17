<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.attendance.model.Shift" %>
<%@ page import="java.util.List" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Shifts — AttendanceMS</title>
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
                List<Shift> shifts =
                    (List<Shift>) request.getAttribute("shifts");
            %>

            <div class="page-header">
                <div class="page-header-left">
                    <h2>Shifts</h2>
                    <p>Configure work shifts for your organization</p>
                </div>
                <button class="btn btn-primary"
                        onclick="openModal('addShiftModal')">
                    + Add Shift
                </button>
            </div>

            <div class="card">
                <div class="card-header">
                    <h3>All Shifts</h3>
                </div>
                <% if (shifts == null || shifts.isEmpty()) { %>
                    <div class="empty-state">
                        <div class="empty-state-icon">🕐</div>
                        <h3>No shifts configured</h3>
                        <p>Add your first shift to get started.</p>
                    </div>
                <% } else { %>
                <div class="table-wrapper">
                    <table class="data-table">
                        <thead>
                            <tr>
                                <th>Shift Name</th>
                                <th>Start Time</th>
                                <th>End Time</th>
                                <th>Grace Period</th>
                                <th>Employees</th>
                                <th>Status</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% for (Shift s : shifts) { %>
                            <tr>
                                <td>
                                    <span style="font-weight:600;
                                                 color:var(--text-heading);">
                                        <%= s.getName() %>
                                    </span>
                                </td>
                                <td>
                                    <span style="font-family:'Plus Jakarta Sans',sans-serif;
                                                 font-weight:600;">
                                        <%= s.getStartTime() %>
                                    </span>
                                </td>
                                <td>
                                    <span style="font-family:'Plus Jakarta Sans',sans-serif;
                                                 font-weight:600;">
                                        <%= s.getEndTime() %>
                                    </span>
                                </td>
                                <td>
                                    <span style="font-size:13px;
                                                 color:var(--text-muted);">
                                        <%= s.getGraceMinutes() %> mins
                                    </span>
                                </td>
                                <td>
                                    <span class="badge badge-active">
                                        <%= s.getEmployeeCount() %>
                                    </span>
                                </td>
                                <td>
                                    <span class="badge
                                          <%= s.isActive()
                                              ? "badge-active"
                                              : "badge-inactive" %>">
                                        <%= s.isActive()
                                            ? "Active" : "Inactive" %>
                                    </span>
                                </td>
                                <td>
                                    <div class="td-actions">
                                        <button class="btn btn-ghost btn-sm"
                                                onclick="openEditShift(
                                                    <%= s.getId() %>,
                                                    '<%= s.getName().replace("'","\'") %>',
                                                    '<%= s.getStartTime() %>',
                                                    '<%= s.getEndTime() %>',
                                                    '<%= s.getGraceMinutes() %>'
                                                )">
                                            Edit
                                        </button>
                                        <form method="POST"
                                              action="${pageContext.request.contextPath}/shift"
                                              style="display:inline;">
                                            <input type="hidden"
                                                   name="action"
                                                   value="toggle">
                                            <input type="hidden"
                                                   name="shiftId"
                                                   value="<%= s.getId() %>">
                                            <input type="hidden"
                                                   name="active"
                                                   value="<%= !s.isActive() %>">
                                            <button type="submit"
                                                    class="btn btn-ghost btn-sm">
                                                <%= s.isActive()
                                                    ? "Deactivate"
                                                    : "Activate" %>
                                            </button>
                                        </form>
                                    </div>
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

<%-- Add Shift Modal --%>
<div class="modal-overlay" id="addShiftModal">
    <div class="modal">
        <div class="modal-header">
            <span class="modal-title">Add Shift</span>
            <button class="modal-close"
                    onclick="closeModal('addShiftModal')">
                &times;
            </button>
        </div>
        <form method="POST"
              action="${pageContext.request.contextPath}/shift">
            <input type="hidden" name="action" value="add">
            <div class="modal-body">
                <div class="form-group">
                    <label class="form-label">
                        Shift Name <span class="form-required">*</span>
                    </label>
                    <input type="text" name="name"
                           class="form-control"
                           placeholder="e.g. Morning Shift" required>
                </div>
                <div class="form-row">
                    <div class="form-group">
                        <label class="form-label">
                            Start Time <span class="form-required">*</span>
                        </label>
                        <input type="time" name="startTime"
                               class="form-control"
                               value="09:00" required>
                    </div>
                    <div class="form-group">
                        <label class="form-label">
                            End Time <span class="form-required">*</span>
                        </label>
                        <input type="time" name="endTime"
                               class="form-control"
                               value="17:00" required>
                    </div>
                </div>
                <div class="form-group">
                    <label class="form-label">
                        Grace Period (minutes)
                    </label>
                    <input type="number" name="graceMinutes"
                           class="form-control"
                           value="15" min="0" max="60">
                    <div class="form-hint">
                        Employees arriving within this many minutes
                        after shift start will be marked PRESENT,
                        not LATE.
                    </div>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-ghost"
                        onclick="closeModal('addShiftModal')">
                    Cancel
                </button>
                <button type="submit" class="btn btn-primary">
                    Add Shift
                </button>
            </div>
        </form>
    </div>
</div>

<%-- Edit Shift Modal --%>
<div class="modal-overlay" id="editShiftModal">
    <div class="modal">
        <div class="modal-header">
            <span class="modal-title">Edit Shift</span>
            <button class="modal-close"
                    onclick="closeModal('editShiftModal')">
                &times;
            </button>
        </div>
        <form method="POST"
              action="${pageContext.request.contextPath}/shift">
            <input type="hidden" name="action" value="edit">
            <input type="hidden" name="shiftId" id="editShiftId">
            <div class="modal-body">
                <div class="form-group">
                    <label class="form-label">
                        Shift Name <span class="form-required">*</span>
                    </label>
                    <input type="text" name="name"
                           id="editShiftName"
                           class="form-control" required>
                </div>
                <div class="form-row">
                    <div class="form-group">
                        <label class="form-label">Start Time</label>
                        <input type="time" name="startTime"
                               id="editShiftStart"
                               class="form-control">
                    </div>
                    <div class="form-group">
                        <label class="form-label">End Time</label>
                        <input type="time" name="endTime"
                               id="editShiftEnd"
                               class="form-control">
                    </div>
                </div>
                <div class="form-group">
                    <label class="form-label">
                        Grace Period (minutes)
                    </label>
                    <input type="number" name="graceMinutes"
                           id="editShiftGrace"
                           class="form-control"
                           min="0" max="60">
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-ghost"
                        onclick="closeModal('editShiftModal')">
                    Cancel
                </button>
                <button type="submit" class="btn btn-primary">
                    Save Changes
                </button>
            </div>
        </form>
    </div>
</div>

<script src="${pageContext.request.contextPath}/js/main.js"></script>
<script>
    function openEditShift(id, name, start, end, grace) {
        document.getElementById('editShiftId').value    = id;
        document.getElementById('editShiftName').value  = name;
        document.getElementById('editShiftStart').value = start;
        document.getElementById('editShiftEnd').value   = end;
        document.getElementById('editShiftGrace').value = grace;
        openModal('editShiftModal');
    }
</script>
</body>
</html>