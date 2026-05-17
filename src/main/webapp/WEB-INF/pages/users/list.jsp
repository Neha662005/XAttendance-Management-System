<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.attendance.model.User" %>
<%@ page import="java.util.List" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Users — AttendanceMS</title>
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
                User adminUser =
                    (User) session.getAttribute("loggedInUser");
                List<User> users =
                    (List<User>) request.getAttribute("users");
            %>

            <div class="page-header">
                <div class="page-header-left">
                    <h2>Manage Users</h2>
                    <p>
                        <%= users != null ? users.size() : 0 %>
                        users in your organization
                    </p>
                </div>
            </div>

            <div class="card">
                <div class="card-header">
                    <h3>All Users</h3>
                </div>

                <% if (users == null || users.isEmpty()) { %>
                    <div class="empty-state">
                        <div class="empty-state-icon">👥</div>
                        <h3>No users found</h3>
                        <p>No users in your organization yet.</p>
                    </div>
                <% } else { %>
                <div class="table-wrapper">
                    <table class="data-table">
                        <thead>
                            <tr>
                                <th>Employee</th>
                                <th>Email</th>
                                <th>Employee ID</th>
                                <th>Department</th>
                                <th>Shift</th>
                                <th>Role</th>
                                <th>Status</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% for (User u : users) { %>
                            <tr>
                                <td>
                                    <div style="display:flex;
                                                align-items:center;
                                                gap:10px;">
                                        <div class="user-avatar"
                                             style="width:34px;
                                                    height:34px;
                                                    font-size:12px;">
                                            <%= u.getInitials() %>
                                        </div>
                                        <div>
                                            <div style="font-weight:600;
                                                        color:var(--text-heading);">
                                                <%= u.getFullName() %>
                                            </div>
                                            <% if (u.getDesignation() != null
                                                   && !u.getDesignation().isEmpty()) { %>
                                            <div style="font-size:12px;
                                                        color:var(--text-muted);">
                                                <%= u.getDesignation() %>
                                            </div>
                                            <% } %>
                                        </div>
                                    </div>
                                </td>
                                <td style="font-size:13px;
                                           color:var(--text-muted);">
                                    <%= u.getEmail() %>
                                </td>
                                <td style="font-size:13px;">
                                    <%= u.getEmployeeId() != null
                                        && !u.getEmployeeId().isEmpty()
                                        ? u.getEmployeeId() : "—" %>
                                </td>
                                <td style="font-size:13px;">
                                    <%= u.getDepartmentName() != null
                                        ? u.getDepartmentName() : "—" %>
                                </td>
                                <td style="font-size:13px;">
                                    <%= u.getShiftName() != null
                                        ? u.getShiftName() : "—" %>
                                </td>
                                <td>
                                    <%
                                        String roleCss = "role-employee";
                                        String role = u.getRole();
                                        if ("SUPER_ADMIN".equals(role))
                                            roleCss = "role-super-admin";
                                        else if ("ADMIN".equals(role))
                                            roleCss = "role-admin";
                                        else if ("HR".equals(role))
                                            roleCss = "role-hr";
                                        else if ("MANAGER".equals(role))
                                            roleCss = "role-manager";
                                    %>
                                    <span class="role-badge <%= roleCss %>">
                                        <%= u.getRoleDisplay() %>
                                    </span>
                                </td>
                                <td>
                                    <span class="badge
                                          <%= u.isActive()
                                              ? "badge-active"
                                              : "badge-inactive" %>">
                                        <%= u.isActive()
                                            ? "Active" : "Inactive" %>
                                    </span>
                                </td>
                                <td>
                                    <% if (u.getId() != adminUser.getId()) { %>
                                    <div class="td-actions">

                                        <%-- Toggle active --%>
                                        <form method="POST"
                                              action="${pageContext.request.contextPath}/users">
                                            <input type="hidden"
                                                   name="userId"
                                                   value="<%= u.getId() %>">
                                            <% if (u.isActive()) { %>
                                                <input type="hidden"
                                                       name="action"
                                                       value="deactivate">
                                                <button type="submit"
                                                        class="btn btn-outline-danger btn-sm"
                                                        onclick="return confirmAction('Deactivate this user?')">
                                                    Deactivate
                                                </button>
                                            <% } else { %>
                                                <input type="hidden"
                                                       name="action"
                                                       value="activate">
                                                <button type="submit"
                                                        class="btn btn-ghost btn-sm">
                                                    Activate
                                                </button>
                                            <% } %>
                                        </form>

                                        <%-- Change role (admin only) --%>
                                        <% if (adminUser.isAdmin()) { %>
                                        <button class="btn btn-ghost btn-sm"
                                                onclick="openRoleModal(
                                                    <%= u.getId() %>,
                                                    '<%= u.getFullName() %>',
                                                    '<%= u.getRole() %>'
                                                )">
                                            Role
                                        </button>
                                        <% } %>

                                    </div>
                                    <% } else { %>
                                        <span style="font-size:12px;
                                                     color:var(--text-muted);">
                                            You
                                        </span>
                                    <% } %>
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

<%-- Role change modal --%>
<div class="modal-overlay" id="roleModal">
    <div class="modal">
        <div class="modal-header">
            <span class="modal-title">Change User Role</span>
            <button class="modal-close"
                    onclick="closeModal('roleModal')">
                &times;
            </button>
        </div>
        <div class="modal-body">
            <p id="roleModalText"
               style="margin-bottom:16px;
                      font-size:14px;
                      color:var(--text-body);">
            </p>
            <div class="form-group">
                <label class="form-label">New Role</label>
                <select id="roleSelect" class="form-control">
                    <option value="EMPLOYEE">Employee</option>
                    <option value="MANAGER">Manager</option>
                    <option value="HR">HR</option>
                    <option value="ADMIN">Admin</option>
                </select>
            </div>
        </div>
        <div class="modal-footer">
            <button class="btn btn-ghost"
                    onclick="closeModal('roleModal')">
                Cancel
            </button>
            <form id="roleForm" method="POST"
                  action="${pageContext.request.contextPath}/users">
                <input type="hidden" name="action" value="role">
                <input type="hidden" name="userId" id="roleUserId">
                <input type="hidden" name="role" id="roleHidden">
                <button type="submit"
                        class="btn btn-primary"
                        onclick="syncRole()">
                    Update Role
                </button>
            </form>
        </div>
    </div>
</div>

<script src="${pageContext.request.contextPath}/js/main.js"></script>
<script>
    function openRoleModal(id, name, currentRole) {
        document.getElementById('roleUserId').value = id;
        document.getElementById('roleModalText').textContent =
            'Change role for ' + name;
        document.getElementById('roleSelect').value = currentRole;
        openModal('roleModal');
    }
    function syncRole() {
        document.getElementById('roleHidden').value =
            document.getElementById('roleSelect').value;
    }
</script>
</body>
</html>