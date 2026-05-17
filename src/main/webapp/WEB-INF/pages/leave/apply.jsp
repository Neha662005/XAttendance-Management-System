<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.attendance.model.*" %>
<%@ page import="java.util.List" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Leave Request — AttendanceMS</title>
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
                User leaveUser =
                    (User) session.getAttribute("loggedInUser");
                List<LeaveType> leaveTypes =
                    (List<LeaveType>) request.getAttribute("leaveTypes");
                List<LeaveBalance> balances =
                    (List<LeaveBalance>) request.getAttribute("balances");
                List<LeaveRequest> myLeaves =
                    (List<LeaveRequest>) request.getAttribute("myLeaves");
            %>

            <div class="page-header">
                <div class="page-header-left">
                    <h2>Leave Request</h2>
                    <p>Apply for leave and view your history</p>
                </div>
                <% if (leaveUser.canApproveLeave()) { %>
                <a href="${pageContext.request.contextPath}/leave?action=approve"
                   class="btn btn-primary">
                    View Approvals
                </a>
                <% } %>
            </div>

            <%-- Leave Balances --%>
            <% if (balances != null && !balances.isEmpty()) { %>
            <div class="card" style="margin-bottom:22px;">
                <div class="card-header">
                    <h3>Your Leave Balances</h3>
                    <span style="font-size:13px;
                                 color:var(--text-muted);">
                        <%= java.time.Year.now().getValue() %>
                    </span>
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
                                <div class="progress-fill
                                     <%= lb.getProgressColor() %>"
                                     style="width:<%= lb.getUsedPercent() %>%;">
                                </div>
                            </div>
                            <div class="balance-used">
                                <%= lb.getUsedDays() %> days used
                            </div>
                        </div>
                        <% } %>
                    </div>
                </div>
            </div>
            <% } %>

            <%-- Two column layout --%>
            <div style="display:grid;
                        grid-template-columns:400px 1fr;
                        gap:22px;
                        align-items:start;">

                <%-- Apply form --%>
                <div class="card">
                    <div class="card-header">
                        <h3>Apply for Leave</h3>
                    </div>
                    <div class="card-body">
                        <form
                          action="${pageContext.request.contextPath}/leave"
                          method="POST">
                            <input type="hidden"
                                   name="action" value="apply">

                            <div class="form-group">
                                <label class="form-label">
                                    Leave Type
                                    <span class="form-required">*</span>
                                </label>
                                <select name="leaveTypeId"
                                        class="form-control"
                                        required
                                        onchange="updateBalance(this)">
                                    <option value="">
                                        — Select leave type —
                                    </option>
                                    <% if (leaveTypes != null) {
                                        for (LeaveType lt : leaveTypes) { %>
                                    <option value="<%= lt.getId() %>"
                                            data-id="<%= lt.getId() %>">
                                        <%= lt.getName() %>
                                        (<%= lt.isPaid()
                                             ? "Paid" : "Unpaid" %>)
                                    </option>
                                    <%  }
                                    } %>
                                </select>
                                <div id="balanceHint"
                                     style="font-size:12px;
                                            color:var(--primary-dark);
                                            margin-top:5px;
                                            display:none;">
                                </div>
                            </div>

                            <div class="form-row">
                                <div class="form-group">
                                    <label class="form-label">
                                        From Date
                                        <span class="form-required">*</span>
                                    </label>
                                    <input type="date"
                                           name="fromDate"
                                           class="form-control"
                                           required
                                           onchange="calcDays()">
                                </div>
                                <div class="form-group">
                                    <label class="form-label">
                                        To Date
                                        <span class="form-required">*</span>
                                    </label>
                                    <input type="date"
                                           name="toDate"
                                           class="form-control"
                                           required
                                           onchange="calcDays()">
                                </div>
                            </div>

                            <div id="daysCount"
                                 style="font-size:13px;
                                        color:var(--primary-dark);
                                        font-weight:600;
                                        margin-top:-10px;
                                        margin-bottom:16px;
                                        display:none;">
                            </div>

                            <div class="form-group">
                                <label class="form-label">
                                    Reason
                                </label>
                                <textarea name="reason"
                                          class="form-control"
                                          rows="3"
                                          placeholder="Briefly describe the reason for your leave...">
                                </textarea>
                            </div>

                            <button type="submit"
                                    class="btn btn-primary btn-block">
                                Submit Leave Request
                            </button>

                        </form>
                    </div>
                </div>

                <%-- My leave history --%>
                <div class="card">
                    <div class="card-header">
                        <h3>My Leave History</h3>
                        <span style="font-size:13px;
                                     color:var(--text-muted);">
                            <%= myLeaves != null
                                ? myLeaves.size() : 0 %> requests
                        </span>
                    </div>

                    <% if (myLeaves == null || myLeaves.isEmpty()) { %>
                        <div class="empty-state">
                            <div class="empty-state-icon">📅</div>
                            <h3>No leave requests yet</h3>
                            <p>Your submitted leave requests will appear here.</p>
                        </div>
                    <% } else { %>
                        <div class="table-wrapper">
                            <table class="data-table">
                                <thead>
                                    <tr>
                                        <th>Type</th>
                                        <th>From</th>
                                        <th>To</th>
                                        <th>Days</th>
                                        <th>Status</th>
                                        <th>Applied</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <% for (LeaveRequest lr : myLeaves) { %>
                                    <tr>
                                        <td>
                                            <span style="font-weight:500;">
                                                <%= lr.getLeaveTypeName() %>
                                            </span>
                                        </td>
                                        <td><%= lr.getFromDate() %></td>
                                        <td><%= lr.getToDate() %></td>
                                        <td>
                                            <span style="font-weight:600;
                                                     color:var(--primary-dark);">
                                                <%= lr.getTotalDays() %>
                                            </span>
                                        </td>
                                        <td>
                                            <span class="badge
                                                  <%= lr.getStatusBadgeClass() %>">
                                                <%= lr.getStatus() %>
                                            </span>
                                        </td>
                                        <td style="font-size:12px;
                                                   color:var(--text-muted);">
                                            <%= lr.getAppliedDateFormatted() %>
                                        </td>
                                    </tr>
                                    <% } %>
                                </tbody>
                            </table>
                        </div>
                    <% } %>
                </div>

            </div>

        </main>

        <jsp:include page="/WEB-INF/pages/partials/footer.jsp"/>

    </div>
</div>

<script src="${pageContext.request.contextPath}/js/main.js"></script>
<script>
    // Balance data from server
    var balances = {
        <%
            if (balances != null) {
                for (LeaveBalance lb : balances) {
        %>
        '<%= lb.getLeaveTypeId() %>': {
            remaining: <%= lb.getRemainingDays() %>,
            total: <%= lb.getTotalDays() %>,
            name: '<%= lb.getLeaveTypeName() %>'
        },
        <%
                }
            }
        %>
    };

    function updateBalance(sel) {
        var hint = document.getElementById('balanceHint');
        var id   = sel.value;
        if (!id || !balances[id]) {
            hint.style.display = 'none';
            return;
        }
        var b = balances[id];
        hint.style.display = 'block';
        if (b.remaining <= 0) {
            hint.style.color = '#dc2626';
            hint.textContent =
                'No remaining balance for ' + b.name;
        } else {
            hint.style.color = '#166534';
            hint.textContent =
                b.remaining + ' of ' + b.total +
                ' days remaining';
        }
    }

    function calcDays() {
        var from  = document.querySelector('[name="fromDate"]').value;
        var to    = document.querySelector('[name="toDate"]').value;
        var div   = document.getElementById('daysCount');
        if (!from || !to) {
            div.style.display = 'none';
            return;
        }
        var d1   = new Date(from);
        var d2   = new Date(to);
        var diff = Math.round((d2 - d1) / (1000*60*60*24)) + 1;
        if (diff < 1) {
            div.style.color   = '#dc2626';
            div.textContent   = 'To date must be after from date';
            div.style.display = 'block';
        } else {
            div.style.color   = 'var(--primary-dark)';
            div.textContent   = diff + ' day' +
                                (diff > 1 ? 's' : '') + ' selected';
            div.style.display = 'block';
        }
    }
</script>
</body>
</html>