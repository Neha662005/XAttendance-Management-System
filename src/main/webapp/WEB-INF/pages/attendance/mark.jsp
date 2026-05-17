<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.attendance.model.AttendanceRecord" %>
<%@ page import="com.attendance.model.User" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Mark Attendance — AttendanceMS</title>
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
                User markUser = (User) session.getAttribute("loggedInUser");
                AttendanceRecord rec =
                    (AttendanceRecord) request.getAttribute("todayRecord");
            %>

            <div class="page-header">
                <div class="page-header-left">
                    <h2>Mark Attendance</h2>
                    <p><%= request.getAttribute("pageSubtitle") %></p>
                </div>
                <a href="${pageContext.request.contextPath}/attendance?action=history"
                   class="btn btn-ghost">
                    View History
                </a>
            </div>

            <%-- Status card --%>
            <div style="max-width: 600px;">

                <% if (rec == null) { %>

                <%-- Not checked in --%>
                <div class="card">
                    <div class="card-body"
                         style="text-align:center; padding:48px 24px;">
                        <div style="width:72px; height:72px;
                                    border-radius:50%;
                                    background:#fde8ed;
                                    display:flex; align-items:center;
                                    justify-content:center;
                                    margin:0 auto 20px;">
                            <svg width="32" height="32" viewBox="0 0 24 24"
                                 fill="none" stroke="#dc2626"
                                 stroke-width="2" stroke-linecap="round">
                                <circle cx="12" cy="12" r="10"/>
                                <line x1="12" y1="8" x2="12" y2="12"/>
                                <line x1="12" y1="16" x2="12.01" y2="16"/>
                            </svg>
                        </div>
                        <h3 style="font-size:20px; margin-bottom:8px;">
                            Not checked in yet
                        </h3>
                        <p style="color:var(--text-muted);
                                  margin-bottom:28px; font-size:14px;">
                            Click the button below to record
                            your check-in for today
                        </p>
                        <form action="${pageContext.request.contextPath}/attendance"
                              method="POST">
                            <input type="hidden" name="action" value="checkin">
                            <button type="submit"
                                    class="btn btn-primary btn-lg">
                                <svg width="18" height="18"
                                     viewBox="0 0 24 24" fill="none"
                                     stroke="currentColor" stroke-width="2"
                                     stroke-linecap="round">
                                    <polyline points="20 6 9 17 4 12"/>
                                </svg>
                                Check In Now
                            </button>
                        </form>
                    </div>
                </div>

                <% } else { %>

                <%-- Checked in — show details --%>
                <div class="card">
                    <div class="card-header">
                        <h3>Today's Record</h3>
                        <span class="badge <%= rec.getStatusBadgeClass() %>">
                            <%= rec.getStatus() %>
                        </span>
                    </div>
                    <div class="card-body">

                        <%-- Time grid --%>
                        <div style="display:grid;
                                    grid-template-columns:repeat(3,1fr);
                                    gap:16px; margin-bottom:24px;">

                            <div style="background:var(--tertiary);
                                        border-radius:var(--radius-md);
                                        padding:16px; text-align:center;">
                                <div style="font-size:11px;
                                            color:var(--text-muted);
                                            margin-bottom:6px;
                                            text-transform:uppercase;
                                            letter-spacing:.5px;">
                                    Check In
                                </div>
                                <div style="font-family:'Plus Jakarta Sans',sans-serif;
                                            font-size:24px; font-weight:700;
                                            color:var(--text-heading);">
                                    <%= rec.getFormattedCheckIn() %>
                                </div>
                            </div>

                            <div style="background:var(--tertiary);
                                        border-radius:var(--radius-md);
                                        padding:16px; text-align:center;">
                                <div style="font-size:11px;
                                            color:var(--text-muted);
                                            margin-bottom:6px;
                                            text-transform:uppercase;
                                            letter-spacing:.5px;">
                                    Check Out
                                </div>
                                <div style="font-family:'Plus Jakarta Sans',sans-serif;
                                            font-size:24px; font-weight:700;
                                            color:var(--text-heading);">
                                    <%= rec.getFormattedCheckOut() %>
                                </div>
                            </div>

                            <div style="background:var(--tertiary);
                                        border-radius:var(--radius-md);
                                        padding:16px; text-align:center;">
                                <div style="font-size:11px;
                                            color:var(--text-muted);
                                            margin-bottom:6px;
                                            text-transform:uppercase;
                                            letter-spacing:.5px;">
                                    Overtime
                                </div>
                                <div style="font-family:'Plus Jakarta Sans',sans-serif;
                                            font-size:24px; font-weight:700;
                                            color:#7c3aed;">
                                    <%= rec.getOvertimeFormatted() %>
                                </div>
                            </div>

                        </div>

                        <%-- Break times if recorded --%>
                        <% if (rec.getBreakStart() != null) { %>
                        <div style="display:grid;
                                    grid-template-columns:1fr 1fr;
                                    gap:16px; margin-bottom:24px;">
                            <div style="background:#fffbeb;
                                        border-radius:var(--radius-md);
                                        padding:14px; text-align:center;
                                        border:1px solid #fcd34d;">
                                <div style="font-size:11px;
                                            color:#92400e;
                                            margin-bottom:4px;">
                                    Break Start
                                </div>
                                <div style="font-size:20px; font-weight:700;
                                            color:#92400e;">
                                    <%= rec.getFormattedBreakStart() %>
                                </div>
                            </div>
                            <div style="background:#fffbeb;
                                        border-radius:var(--radius-md);
                                        padding:14px; text-align:center;
                                        border:1px solid #fcd34d;">
                                <div style="font-size:11px;
                                            color:#92400e;
                                            margin-bottom:4px;">
                                    Break End
                                </div>
                                <div style="font-size:20px; font-weight:700;
                                            color:#92400e;">
                                    <%= rec.getFormattedBreakEnd() %>
                                </div>
                            </div>
                        </div>
                        <% } %>

                        <%-- Shift info --%>
                        <% if (rec.getShiftName() != null) { %>
                        <div style="font-size:13px; color:var(--text-muted);
                                    margin-bottom:20px;">
                            Shift: <strong><%= rec.getShiftName() %></strong>
                        </div>
                        <% } %>

                        <%-- Action buttons --%>
                        <div style="display:flex; gap:10px; flex-wrap:wrap;">

                            <% if (rec.getCheckOut() == null) { %>

                                <% if (rec.getBreakStart() == null) { %>
                                    <%-- Start break button --%>
                                    <form action="${pageContext.request.contextPath}/attendance"
                                          method="POST">
                                        <input type="hidden" name="action"
                                               value="startbreak">
                                        <button type="submit"
                                                class="btn btn-ghost">
                                            <svg width="16" height="16"
                                                 viewBox="0 0 24 24"
                                                 fill="none"
                                                 stroke="currentColor"
                                                 stroke-width="2"
                                                 stroke-linecap="round">
                                                <circle cx="12" cy="12"
                                                        r="10"/>
                                                <line x1="10" y1="15"
                                                      x2="10" y2="9"/>
                                                <line x1="14" y1="15"
                                                      x2="14" y2="9"/>
                                            </svg>
                                            Start Break
                                        </button>
                                    </form>
                                <% } else if (rec.getBreakEnd() == null) { %>
                                    <%-- End break button --%>
                                    <form action="${pageContext.request.contextPath}/attendance"
                                          method="POST">
                                        <input type="hidden" name="action"
                                               value="endbreak">
                                        <button type="submit"
                                                class="btn btn-warning">
                                            <svg width="16" height="16"
                                                 viewBox="0 0 24 24"
                                                 fill="none"
                                                 stroke="currentColor"
                                                 stroke-width="2"
                                                 stroke-linecap="round">
                                                <polygon points="5 3 19 12 5 21 5 3"/>
                                            </svg>
                                            End Break
                                        </button>
                                    </form>
                                <% } %>

                                <%-- Check out button --%>
                                <form action="${pageContext.request.contextPath}/attendance"
                                      method="POST">
                                    <input type="hidden" name="action"
                                           value="checkout">
                                    <button type="submit"
                                            class="btn btn-secondary">
                                        <svg width="16" height="16"
                                             viewBox="0 0 24 24" fill="none"
                                             stroke="currentColor"
                                             stroke-width="2"
                                             stroke-linecap="round">
                                            <path d="M9 21H5a2 2 0 01-2-2V5a2 2 0 012-2h4"/>
                                            <polyline points="16 17 21 12 16 7"/>
                                            <line x1="21" y1="12"
                                                  x2="9" y2="12"/>
                                        </svg>
                                        Check Out
                                    </button>
                                </form>

                            <% } else { %>
                                <%-- Day complete --%>
                                <div class="alert alert-success"
                                     style="margin:0; flex:1;">
                                    Your attendance for today is complete.
                                    See you tomorrow!
                                </div>
                            <% } %>

                        </div>

                    </div>
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