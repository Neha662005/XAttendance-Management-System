<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.attendance.model.*" %>
<%@ page import="java.util.List" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Leave Approvals — AttendanceMS</title>
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
                List<LeaveRequest> pending =
                    (List<LeaveRequest>)
                    request.getAttribute("pendingLeaves");
            %>

            <div class="page-header">
                <div class="page-header-left">
                    <h2>Leave Approvals</h2>
                    <p>Review and action pending leave requests</p>
                </div>
                <a href="${pageContext.request.contextPath}/leave"
                   class="btn btn-ghost">
                    My Leave
                </a>
            </div>

            <div class="card">
                <div class="card-header">
                    <h3>Pending Requests</h3>
                    <span class="badge badge-pending"
                          style="font-size:12px;">
                        <%= pending != null ? pending.size() : 0 %>
                        pending
                    </span>
                </div>

                <% if (pending == null || pending.isEmpty()) { %>
                    <div class="empty-state">
                        <div class="empty-state-icon">✅</div>
                        <h3>All clear!</h3>
                        <p>No pending leave requests at the moment.</p>
                    </div>
                <% } else { %>
                    <div class="table-wrapper">
                        <table class="data-table">
                            <thead>
                                <tr>
                                    <th>Employee</th>
                                    <th>Department</th>
                                    <th>Type</th>
                                    <th>From</th>
                                    <th>To</th>
                                    <th>Days</th>
                                    <th>Reason</th>
                                    <th>Applied</th>
                                    <th>Action</th>
                                </tr>
                            </thead>
                            <tbody>
                                <% for (LeaveRequest lr : pending) { %>
                                <tr>
                                    <td>
                                        <div style="font-weight:600;
                                                    color:var(--text-heading);">
                                            <%= lr.getUserName() %>
                                        </div>
                                    </td>
                                    <td>
                                        <span style="font-size:12px;
                                                     color:var(--text-muted);">
                                            <%= lr.getDepartmentName() != null
                                                ? lr.getDepartmentName() : "—" %>
                                        </span>
                                    </td>
                                    <td>
                                        <span style="font-weight:500;">
                                            <%= lr.getLeaveTypeName() %>
                                        </span>
                                    </td>
                                    <td><%= lr.getFromDate() %></td>
                                    <td><%= lr.getToDate() %></td>
                                    <td>
                                        <span style="font-weight:700;
                                                     color:var(--primary-dark);">
                                            <%= lr.getTotalDays() %>
                                        </span>
                                    </td>
                                    <td style="max-width:160px;
                                               font-size:12px;
                                               color:var(--text-muted);">
                                        <%= lr.getReason() != null
                                            && !lr.getReason().isEmpty()
                                            ? lr.getReason() : "—" %>
                                    </td>
                                    <td style="font-size:12px;
                                               color:var(--text-muted);">
                                        <%= lr.getAppliedDateFormatted() %>
                                    </td>
                                    <td>
                                        <button class="btn btn-primary btn-sm"
                                                onclick="openApproveModal(
                                                    <%= lr.getId() %>,
                                                    '<%= lr.getUserName() %>',
                                                    '<%= lr.getLeaveTypeName() %>',
                                                    '<%= lr.getTotalDays() %>'
                                                )">
                                            Approve
                                        </button>
                                        <button class="btn btn-outline-danger btn-sm"
                                                style="margin-left:6px;"
                                                onclick="openRejectModal(
                                                    <%= lr.getId() %>,
                                                    '<%= lr.getUserName() %>'
                                                )">
                                            Reject
                                        </button>
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

<%-- Approve Modal --%>
<div class="modal-overlay" id="approveModal">
    <div class="modal">
        <div class="modal-header">
            <span class="modal-title">Approve Leave Request</span>
            <button class="modal-close"
                    onclick="closeModal('approveModal')">
                &times;
            </button>
        </div>
        <div class="modal-body">
            <p id="approveText"
               style="margin-bottom:16px;
                      color:var(--text-body);
                      font-size:14px;">
            </p>
            <div class="form-group">
                <label class="form-label">
                    Approval Note (optional)
                </label>
                <textarea id="approveNote"
                          class="form-control"
                          rows="3"
                          placeholder="Add a note for the employee...">
                </textarea>
            </div>
        </div>
        <div class="modal-footer">
            <button class="btn btn-ghost"
                    onclick="closeModal('approveModal')">
                Cancel
            </button>
            <form id="approveForm" method="POST"
                  action="${pageContext.request.contextPath}/leave">
                <input type="hidden" name="action" value="approve">
                <input type="hidden" name="leaveId" id="approveLeaveId">
                <input type="hidden" name="approvalNote"
                       id="approveNoteHidden">
                <button type="submit"
                        class="btn btn-primary"
                        onclick="syncNote('approveNote',
                                          'approveNoteHidden')">
                    Confirm Approve
                </button>
            </form>
        </div>
    </div>
</div>

<%-- Reject Modal --%>
<div class="modal-overlay" id="rejectModal">
    <div class="modal">
        <div class="modal-header">
            <span class="modal-title">Reject Leave Request</span>
            <button class="modal-close"
                    onclick="closeModal('rejectModal')">
                &times;
            </button>
        </div>
        <div class="modal-body">
            <p id="rejectText"
               style="margin-bottom:16px;
                      color:var(--text-body);
                      font-size:14px;">
            </p>
            <div class="form-group">
                <label class="form-label">
                    Rejection Reason
                    <span class="form-required">*</span>
                </label>
                <textarea id="rejectNote"
                          class="form-control"
                          rows="3"
                          placeholder="Please provide a reason for rejection...">
                </textarea>
            </div>
        </div>
        <div class="modal-footer">
            <button class="btn btn-ghost"
                    onclick="closeModal('rejectModal')">
                Cancel
            </button>
            <form id="rejectForm" method="POST"
                  action="${pageContext.request.contextPath}/leave">
                <input type="hidden" name="action" value="reject">
                <input type="hidden" name="leaveId" id="rejectLeaveId">
                <input type="hidden" name="approvalNote"
                       id="rejectNoteHidden">
                <button type="submit"
                        class="btn btn-danger"
                        onclick="syncNote('rejectNote',
                                          'rejectNoteHidden')">
                    Confirm Reject
                </button>
            </form>
        </div>
    </div>
</div>

<script src="${pageContext.request.contextPath}/js/main.js"></script>
<script>
    function openApproveModal(id, name, type, days) {
        document.getElementById('approveLeaveId').value = id;
        document.getElementById('approveText').textContent =
            'You are about to approve ' + name + "'s " +
            type + ' request for ' + days + ' day(s).';
        document.getElementById('approveNote').value = '';
        openModal('approveModal');
    }

    function openRejectModal(id, name) {
        document.getElementById('rejectLeaveId').value = id;
        document.getElementById('rejectText').textContent =
            'You are about to reject ' + name +
            "'s leave request. Please provide a reason.";
        document.getElementById('rejectNote').value = '';
        openModal('rejectModal');
    }

    function syncNote(textareaId, hiddenId) {
        document.getElementById(hiddenId).value =
            document.getElementById(textareaId).value;
    }
</script>
</body>
</html>