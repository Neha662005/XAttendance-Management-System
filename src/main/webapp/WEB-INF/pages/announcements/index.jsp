<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.attendance.model.Announcement" %>
<%@ page import="java.util.List" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Announcements — AttendanceMS</title>
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
                List<Announcement> announcements =
                    (List<Announcement>)
                    request.getAttribute("announcements");
            %>

            <div class="page-header">
                <div class="page-header-left">
                    <h2>Announcements</h2>
                    <p>Manage system-wide announcements for your organisation</p>
                </div>
                <button class="btn btn-primary"
                        onclick="openModal('addModal')">
                    <svg width="16" height="16" viewBox="0 0 24 24"
                         fill="none" stroke="currentColor"
                         stroke-width="2" stroke-linecap="round">
                        <line x1="12" y1="5" x2="12" y2="19"/>
                        <line x1="5" y1="12" x2="19" y2="12"/>
                    </svg>
                    New Announcement
                </button>
            </div>

            <div class="card">
                <div class="card-header">
                    <h3>All Announcements</h3>
                    <span style="font-size:13px; color:var(--text-muted);">
                        <%= announcements != null
                            ? announcements.size() : 0 %> total
                    </span>
                </div>

                <% if (announcements == null || announcements.isEmpty()) { %>
                    <div class="empty-state">
                        <div class="empty-state-icon">📢</div>
                        <h3>No announcements yet</h3>
                        <p>Create your first announcement for your team.</p>
                    </div>
                <% } else { %>
                    <div class="table-wrapper">
                        <table class="data-table">
                            <thead>
                                <tr>
                                    <th>Title</th>
                                    <th>Message</th>
                                    <th>Created By</th>
                                    <th>Date</th>
                                    <th>Status</th>
                                    <th>Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <% for (Announcement a : announcements) { %>
                                <tr>
                                    <td>
                                        <span style="font-weight:600;
                                                     color:var(--text-heading);">
                                            <%= a.getTitle() %>
                                        </span>
                                    </td>
                                    <td style="max-width:280px;
                                               font-size:13px;
                                               color:var(--text-muted);">
                                        <%= a.getMessage().length() > 80
                                            ? a.getMessage().substring(0, 80) + "..."
                                            : a.getMessage() %>
                                    </td>
                                    <td style="font-size:13px;">
                                        <%= a.getCreatedByName() %>
                                    </td>
                                    <td style="font-size:12px;
                                               color:var(--text-muted);">
                                        <%= a.getCreatedDateFormatted() %>
                                    </td>
                                    <td>
                                        <span class="badge
                                              <%= a.isActive()
                                                  ? "badge-active"
                                                  : "badge-inactive" %>">
                                            <%= a.isActive()
                                                ? "Active" : "Inactive" %>
                                        </span>
                                    </td>
                                    <td>
                                        <div class="td-actions">

                                            <%-- Toggle --%>
                                            <form method="POST"
                                                  action="${pageContext.request.contextPath}/announcements">
                                                <input type="hidden"
                                                       name="action"
                                                       value="toggle">
                                                <input type="hidden"
                                                       name="announcementId"
                                                       value="<%= a.getId() %>">
                                                <input type="hidden"
                                                       name="active"
                                                       value="<%= !a.isActive() %>">
                                                <button type="submit"
                                                        class="btn btn-ghost btn-sm">
                                                    <%= a.isActive()
                                                        ? "Deactivate"
                                                        : "Activate" %>
                                                </button>
                                            </form>

                                            <%-- Delete --%>
                                            <form method="POST"
                                                  action="${pageContext.request.contextPath}/announcements"
                                                  style="margin-left:6px;">
                                                <input type="hidden"
                                                       name="action"
                                                       value="delete">
                                                <input type="hidden"
                                                       name="announcementId"
                                                       value="<%= a.getId() %>">
                                                <button type="submit"
                                                        class="btn btn-outline-danger btn-sm"
                                                        onclick="return confirmAction('Delete this announcement?')">
                                                    Delete
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

<%-- Add Announcement Modal --%>
<div class="modal-overlay" id="addModal">
    <div class="modal">
        <div class="modal-header">
            <span class="modal-title">New Announcement</span>
            <button class="modal-close"
                    onclick="closeModal('addModal')">
                &times;
            </button>
        </div>
        <form method="POST"
              action="${pageContext.request.contextPath}/announcements">
            <input type="hidden" name="action" value="add">
            <div class="modal-body">
                <div class="form-group">
                    <label class="form-label">
                        Title <span class="form-required">*</span>
                    </label>
                    <input type="text"
                           name="title"
                           class="form-control"
                           placeholder="e.g. Office closed on Friday"
                           required>
                </div>
                <div class="form-group">
                    <label class="form-label">
                        Message <span class="form-required">*</span>
                    </label>
                    <textarea name="message"
                              class="form-control"
                              rows="4"
                              placeholder="Write your announcement message here..."
                              required>
                    </textarea>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button"
                        class="btn btn-ghost"
                        onclick="closeModal('addModal')">
                    Cancel
                </button>
                <button type="submit" class="btn btn-primary">
                    Publish Announcement
                </button>
            </div>
        </form>
    </div>
</div>

<script src="${pageContext.request.contextPath}/js/main.js"></script>
</body>
</html>