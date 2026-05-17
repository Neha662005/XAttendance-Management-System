<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.attendance.model.Department" %>
<%@ page import="java.util.List" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Departments — AttendanceMS</title>
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
                List<Department> depts =
                    (List<Department>) request.getAttribute("departments");
            %>

            <div class="page-header">
                <div class="page-header-left">
                    <h2>Departments</h2>
                    <p>Manage your organization's departments</p>
                </div>
                <button class="btn btn-primary"
                        onclick="openModal('addDeptModal')">
                    + Add Department
                </button>
            </div>

            <div class="card">
                <div class="card-header">
                    <h3>All Departments</h3>
                </div>
                <% if (depts == null || depts.isEmpty()) { %>
                    <div class="empty-state">
                        <div class="empty-state-icon">🏢</div>
                        <h3>No departments yet</h3>
                        <p>Add your first department to get started.</p>
                    </div>
                <% } else { %>
                <div class="table-wrapper">
                    <table class="data-table">
                        <thead>
                            <tr>
                                <th>Department</th>
                                <th>Description</th>
                                <th>Employees</th>
                                <th>Created</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% for (Department d : depts) { %>
                            <tr>
                                <td>
                                    <span style="font-weight:600;
                                                 color:var(--text-heading);">
                                        <%= d.getName() %>
                                    </span>
                                </td>
                                <td style="color:var(--text-muted);
                                           font-size:13px;">
                                    <%= d.getDescription() != null
                                        && !d.getDescription().isEmpty()
                                        ? d.getDescription() : "—" %>
                                </td>
                                <td>
                                    <span class="badge badge-active">
                                        <%= d.getEmployeeCount() %>
                                    </span>
                                </td>
                                <td style="font-size:12px;
                                           color:var(--text-muted);">
                                    <%= d.getCreatedAt() != null
                                        ? d.getCreatedAt()
                                           .toString().substring(0,10)
                                        : "—" %>
                                </td>
                                <td>
                                    <div class="td-actions">
                                        <button class="btn btn-ghost btn-sm"
                                                onclick="openEditModal(
                                                    <%= d.getId() %>,
                                                    '<%= d.getName().replace("'","\'") %>',
                                                    '<%= d.getDescription() != null ? d.getDescription().replace("'","\'") : "" %>'
                                                )">
                                            Edit
                                        </button>
                                        <% if (d.getEmployeeCount() == 0) { %>
                                        <form method="POST"
                                              action="${pageContext.request.contextPath}/department"
                                              style="display:inline;">
                                            <input type="hidden"
                                                   name="action"
                                                   value="delete">
                                            <input type="hidden"
                                                   name="deptId"
                                                   value="<%= d.getId() %>">
                                            <button type="submit"
                                                    class="btn btn-outline-danger btn-sm"
                                                    onclick="return confirmAction('Delete this department?')">
                                                Delete
                                            </button>
                                        </form>
                                        <% } %>
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

<%-- Add Department Modal --%>
<div class="modal-overlay" id="addDeptModal">
    <div class="modal">
        <div class="modal-header">
            <span class="modal-title">Add Department</span>
            <button class="modal-close"
                    onclick="closeModal('addDeptModal')">
                &times;
            </button>
        </div>
        <form method="POST"
              action="${pageContext.request.contextPath}/department">
            <input type="hidden" name="action" value="add">
            <div class="modal-body">
                <div class="form-group">
                    <label class="form-label">
                        Name <span class="form-required">*</span>
                    </label>
                    <input type="text" name="name"
                           class="form-control"
                           placeholder="e.g. Engineering"
                           required>
                </div>
                <div class="form-group">
                    <label class="form-label">Description</label>
                    <textarea name="description"
                              class="form-control" rows="2"
                              placeholder="Optional description...">
                    </textarea>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-ghost"
                        onclick="closeModal('addDeptModal')">
                    Cancel
                </button>
                <button type="submit" class="btn btn-primary">
                    Add Department
                </button>
            </div>
        </form>
    </div>
</div>

<%-- Edit Department Modal --%>
<div class="modal-overlay" id="editDeptModal">
    <div class="modal">
        <div class="modal-header">
            <span class="modal-title">Edit Department</span>
            <button class="modal-close"
                    onclick="closeModal('editDeptModal')">
                &times;
            </button>
        </div>
        <form method="POST"
              action="${pageContext.request.contextPath}/department">
            <input type="hidden" name="action" value="edit">
            <input type="hidden" name="deptId" id="editDeptId">
            <div class="modal-body">
                <div class="form-group">
                    <label class="form-label">
                        Name <span class="form-required">*</span>
                    </label>
                    <input type="text" name="name"
                           id="editDeptName"
                           class="form-control" required>
                </div>
                <div class="form-group">
                    <label class="form-label">Description</label>
                    <textarea name="description"
                              id="editDeptDesc"
                              class="form-control" rows="2">
                    </textarea>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-ghost"
                        onclick="closeModal('editDeptModal')">
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
    function openEditModal(id, name, desc) {
        document.getElementById('editDeptId').value   = id;
        document.getElementById('editDeptName').value = name;
        document.getElementById('editDeptDesc').value = desc;
        openModal('editDeptModal');
    }
</script>
</body>
</html>