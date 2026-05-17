<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.attendance.model.User" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Profile — AttendanceMS</title>
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
                User profileUser =
                    (User) session.getAttribute("loggedInUser");
                String roleCss = "role-employee";
                if (profileUser != null) {
                    switch (profileUser.getRole()) {
                        case "SUPER_ADMIN": roleCss = "role-super-admin"; break;
                        case "ADMIN":       roleCss = "role-admin";       break;
                        case "HR":          roleCss = "role-hr";          break;
                        case "MANAGER":     roleCss = "role-manager";     break;
                        default:            roleCss = "role-employee";    break;
                    }
                }
            %>

            <div class="page-header">
                <div class="page-header-left">
                    <h2>My Profile</h2>
                    <p>Manage your account information and password</p>
                </div>
                <%-- Logout button in topbar area --%>
                <a href="${pageContext.request.contextPath}/auth?action=logout"
                   class="btn btn-outline-danger">
                    <svg width="16" height="16" viewBox="0 0 24 24"
                         fill="none" stroke="currentColor"
                         stroke-width="2" stroke-linecap="round">
                        <path d="M9 21H5a2 2 0 01-2-2V5a2 2 0 012-2h4"/>
                        <polyline points="16 17 21 12 16 7"/>
                        <line x1="21" y1="12" x2="9" y2="12"/>
                    </svg>
                    Sign Out
                </a>
            </div>

            <div style="display:grid;
                        grid-template-columns: 300px 1fr;
                        gap: 22px;
                        align-items: start;">

                <%-- Left — Avatar + Info card --%>
                <div>
                    <div class="card">
                        <div class="card-body"
                             style="text-align:center; padding:32px 24px;">

                            <%-- Large avatar --%>
                            <div class="user-avatar-lg"
                                 style="margin:0 auto 16px; width:80px;
                                        height:80px; font-size:26px;">
                                <%= profileUser != null
                                    ? profileUser.getInitials() : "?" %>
                            </div>

                            <h3 style="font-size:18px; margin-bottom:6px;">
                                <%= profileUser != null
                                    ? profileUser.getFullName() : "" %>
                            </h3>

                            <% if (profileUser != null &&
                                   profileUser.getDesignation() != null &&
                                   !profileUser.getDesignation().isEmpty()) { %>
                                <p style="font-size:14px;
                                          color:var(--text-muted);
                                          margin-bottom:12px;">
                                    <%= profileUser.getDesignation() %>
                                </p>
                            <% } %>

                            <span class="role-badge <%= roleCss %>"
                                  style="margin-bottom:20px;
                                         display:inline-block;">
                                <%= profileUser != null
                                    ? profileUser.getRoleDisplay() : "" %>
                            </span>

                            <div class="divider"></div>

                            <%-- Info rows --%>
                            <div style="text-align:left; margin-top:16px;">

                                <div style="display:flex;
                                            align-items:center;
                                            gap:10px;
                                            padding:10px 0;
                                            border-bottom:1px solid var(--border-light);">
                                    <svg width="16" height="16"
                                         viewBox="0 0 24 24" fill="none"
                                         stroke="var(--text-muted)"
                                         stroke-width="2"
                                         stroke-linecap="round">
                                        <path d="M4 4h16c1.1 0 2 .9 2 2v12c0 1.1-.9 2-2 2H4c-1.1 0-2-.9-2-2V6c0-1.1.9-2 2-2z"/>
                                        <polyline points="22,6 12,13 2,6"/>
                                    </svg>
                                    <div>
                                        <div style="font-size:11px;
                                                    color:var(--text-muted);
                                                    margin-bottom:2px;">
                                            Email
                                        </div>
                                        <div style="font-size:13px;
                                                    font-weight:500;
                                                    color:var(--text-body);
                                                    word-break:break-all;">
                                            <%= profileUser != null
                                                ? profileUser.getEmail() : "" %>
                                        </div>
                                    </div>
                                </div>

                                <div style="display:flex;
                                            align-items:center;
                                            gap:10px;
                                            padding:10px 0;
                                            border-bottom:1px solid var(--border-light);">
                                    <svg width="16" height="16"
                                         viewBox="0 0 24 24" fill="none"
                                         stroke="var(--text-muted)"
                                         stroke-width="2"
                                         stroke-linecap="round">
                                        <rect x="2" y="7" width="20"
                                              height="14" rx="2" ry="2"/>
                                        <path d="M16 21V5a2 2 0 00-2-2h-4a2 2 0 00-2 2v16"/>
                                    </svg>
                                    <div>
                                        <div style="font-size:11px;
                                                    color:var(--text-muted);
                                                    margin-bottom:2px;">
                                            Employee ID
                                        </div>
                                        <div style="font-size:13px;
                                                    font-weight:500;
                                                    color:var(--text-body);">
                                            <%= profileUser != null &&
                                                profileUser.getEmployeeId() != null
                                                ? profileUser.getEmployeeId() : "—" %>
                                        </div>
                                    </div>
                                </div>

                                <div style="display:flex;
                                            align-items:center;
                                            gap:10px;
                                            padding:10px 0;
                                            border-bottom:1px solid var(--border-light);">
                                    <svg width="16" height="16"
                                         viewBox="0 0 24 24" fill="none"
                                         stroke="var(--text-muted)"
                                         stroke-width="2"
                                         stroke-linecap="round">
                                        <path d="M3 9l9-7 9 7v11a2 2 0 01-2 2H5a2 2 0 01-2-2z"/>
                                        <polyline points="9 22 9 12 15 12 15 22"/>
                                    </svg>
                                    <div>
                                        <div style="font-size:11px;
                                                    color:var(--text-muted);
                                                    margin-bottom:2px;">
                                            Department
                                        </div>
                                        <div style="font-size:13px;
                                                    font-weight:500;
                                                    color:var(--text-body);">
                                            <%= profileUser != null &&
                                                profileUser.getDepartmentName() != null
                                                ? profileUser.getDepartmentName() : "—" %>
                                        </div>
                                    </div>
                                </div>

                                <div style="display:flex;
                                            align-items:center;
                                            gap:10px;
                                            padding:10px 0;
                                            border-bottom:1px solid var(--border-light);">
                                    <svg width="16" height="16"
                                         viewBox="0 0 24 24" fill="none"
                                         stroke="var(--text-muted)"
                                         stroke-width="2"
                                         stroke-linecap="round">
                                        <circle cx="12" cy="12" r="10"/>
                                        <polyline points="12 6 12 12 16 14"/>
                                    </svg>
                                    <div>
                                        <div style="font-size:11px;
                                                    color:var(--text-muted);
                                                    margin-bottom:2px;">
                                            Shift
                                        </div>
                                        <div style="font-size:13px;
                                                    font-weight:500;
                                                    color:var(--text-body);">
                                            <%= profileUser != null &&
                                                profileUser.getShiftName() != null
                                                ? profileUser.getShiftName() : "—" %>
                                        </div>
                                    </div>
                                </div>

                                <div style="display:flex;
                                            align-items:center;
                                            gap:10px;
                                            padding:10px 0;">
                                    <svg width="16" height="16"
                                         viewBox="0 0 24 24" fill="none"
                                         stroke="var(--text-muted)"
                                         stroke-width="2"
                                         stroke-linecap="round">
                                        <path d="M22 16.92v3a2 2 0 01-2.18 2 19.79 19.79 0 01-8.63-3.07A19.5 19.5 0 013.07 9.8a19.79 19.79 0 01-3.07-8.64A2 2 0 012 .98h3a2 2 0 012 1.72 12.84 12.84 0 00.7 2.81 2 2 0 01-.45 2.11L6.09 8.1a16 16 0 006.29 6.29l1.42-1.42a2 2 0 012.11-.45 12.84 12.84 0 002.81.7A2 2 0 0122 15.18v1.74z"/>
                                    </svg>
                                    <div>
                                        <div style="font-size:11px;
                                                    color:var(--text-muted);
                                                    margin-bottom:2px;">
                                            Phone
                                        </div>
                                        <div style="font-size:13px;
                                                    font-weight:500;
                                                    color:var(--text-body);">
                                            <%= profileUser != null &&
                                                profileUser.getPhone() != null &&
                                                !profileUser.getPhone().isEmpty()
                                                ? profileUser.getPhone() : "—" %>
                                        </div>
                                    </div>
                                </div>

                            </div>

                            <div class="divider" style="margin-top:16px;"></div>

                            <%-- Sign out button --%>
                            <a href="${pageContext.request.contextPath}/auth?action=logout"
                               class="btn btn-outline-danger btn-block"
                               style="margin-top:16px;">
                                <svg width="16" height="16" viewBox="0 0 24 24"
                                     fill="none" stroke="currentColor"
                                     stroke-width="2" stroke-linecap="round">
                                    <path d="M9 21H5a2 2 0 01-2-2V5a2 2 0 012-2h4"/>
                                    <polyline points="16 17 21 12 16 7"/>
                                    <line x1="21" y1="12" x2="9" y2="12"/>
                                </svg>
                                Sign Out
                            </a>

                        </div>
                    </div>
                </div>

                <%-- Right — Edit forms --%>
                <div>

                    <%-- Edit profile info --%>
                    <div class="card" style="margin-bottom:22px;">
                        <div class="card-header">
                            <h3>Personal Information</h3>
                        </div>
                        <div class="card-body">
                            <form action="${pageContext.request.contextPath}/profile"
                                  method="POST">
                                <input type="hidden"
                                       name="action" value="update">

                                <div class="form-row">
                                    <div class="form-group">
                                        <label class="form-label">
                                            Full Name
                                            <span class="form-required">*</span>
                                        </label>
                                        <input type="text"
                                               name="fullName"
                                               class="form-control"
                                               value="<%= profileUser != null
                                                   ? profileUser.getFullName() : "" %>"
                                               required>
                                    </div>
                                    <div class="form-group">
                                        <label class="form-label">
                                            Phone Number
                                        </label>
                                        <input type="tel"
                                               name="phone"
                                               class="form-control"
                                               placeholder="e.g. 9800000000"
                                               value="<%= profileUser != null &&
                                                   profileUser.getPhone() != null
                                                   ? profileUser.getPhone() : "" %>">
                                    </div>
                                </div>

                                <div class="form-group">
                                    <label class="form-label">
                                        Designation
                                    </label>
                                    <input type="text"
                                           name="designation"
                                           class="form-control"
                                           placeholder="e.g. Software Developer"
                                           value="<%= profileUser != null &&
                                               profileUser.getDesignation() != null
                                               ? profileUser.getDesignation() : "" %>">
                                </div>

                                <%-- Read-only fields --%>
                                <div class="form-row">
                                    <div class="form-group">
                                        <label class="form-label">
                                            Email Address
                                        </label>
                                        <input type="email"
                                               class="form-control"
                                               value="<%= profileUser != null
                                                   ? profileUser.getEmail() : "" %>"
                                               disabled>
                                        <div class="form-hint">
                                            Email cannot be changed.
                                            Contact your admin.
                                        </div>
                                    </div>
                                    <div class="form-group">
                                        <label class="form-label">
                                            Role
                                        </label>
                                        <input type="text"
                                               class="form-control"
                                               value="<%= profileUser != null
                                                   ? profileUser.getRoleDisplay() : "" %>"
                                               disabled>
                                        <div class="form-hint">
                                            Role is assigned by your admin.
                                        </div>
                                    </div>
                                </div>

                                <button type="submit"
                                        class="btn btn-primary">
                                    Save Changes
                                </button>

                            </form>
                        </div>
                    </div>

                    <%-- Change password --%>
                    <div class="card">
                        <div class="card-header">
                            <h3>Change Password</h3>
                        </div>
                        <div class="card-body">
                            <form action="${pageContext.request.contextPath}/profile"
                                  method="POST">
                                <input type="hidden"
                                       name="action" value="password">

                                <div class="form-group">
                                    <label class="form-label">
                                        Current Password
                                        <span class="form-required">*</span>
                                    </label>
                                    <div class="input-wrapper">
                                        <input type="password"
                                               id="currentPassword"
                                               name="currentPassword"
                                               class="form-control"
                                               placeholder="Enter current password"
                                               required>
                                        <button type="button"
                                                class="input-toggle-btn"
                                                id="toggleCurrent"
                                                onclick="togglePassword('currentPassword','toggleCurrent')">
                                            <svg width="16" height="16"
                                                 viewBox="0 0 24 24" fill="none"
                                                 stroke="currentColor"
                                                 stroke-width="2"
                                                 stroke-linecap="round">
                                                <path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"/>
                                                <circle cx="12" cy="12" r="3"/>
                                            </svg>
                                        </button>
                                    </div>
                                </div>

                                <div class="form-row">
                                    <div class="form-group">
                                        <label class="form-label">
                                            New Password
                                            <span class="form-required">*</span>
                                        </label>
                                        <input type="password"
                                               id="newPassword"
                                               name="newPassword"
                                               class="form-control"
                                               placeholder="Min. 8 characters"
                                               required
                                               oninput="checkPasswordMatch(
                                                   'newPassword',
                                                   'confirmPassword',
                                                   'passHint')">
                                    </div>
                                    <div class="form-group">
                                        <label class="form-label">
                                            Confirm New Password
                                            <span class="form-required">*</span>
                                        </label>
                                        <input type="password"
                                               id="confirmPassword"
                                               name="confirmPassword"
                                               class="form-control"
                                               placeholder="Repeat new password"
                                               required
                                               oninput="checkPasswordMatch(
                                                   'newPassword',
                                                   'confirmPassword',
                                                   'passHint')">
                                    </div>
                                </div>

                                <div id="passHint"
                                     style="font-size:12.5px;
                                            margin-top:-10px;
                                            margin-bottom:16px;
                                            display:none;">
                                </div>

                                <button type="submit"
                                        class="btn btn-primary">
                                    Update Password
                                </button>

                            </form>
                        </div>
                    </div>

                </div>

            </div>

        </main>

        <jsp:include page="/WEB-INF/pages/partials/footer.jsp"/>

    </div>
</div>

<script src="${pageContext.request.contextPath}/js/main.js"></script>
</body>
</html>