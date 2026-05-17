<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.attendance.model.User" %>
<%
    User sidebarUser = (User) session.getAttribute("loggedInUser");
    String currentURI = request.getRequestURI();
    String ctx = request.getContextPath();

    // Helper to mark nav item active
    // We pass the servlet path and check if currentURI contains it
%>
<%!
    private String activeClass(String currentURI, String path) {
        return currentURI.contains(path) ? "nav-item active" : "nav-item";
    }
%>

<aside class="sidebar" id="sidebar">

    <!-- Brand -->
    <div class="sidebar-brand">
        <div class="sidebar-brand-icon">
            <svg viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg">
                <path d="M9 5H7a2 2 0 00-2 2v12a2 2 0 002 2h10a2 2 0 002-2V7a2 2 0 00-2-2h-2M9 5a2 2 0 002 2h2a2 2 0 002-2M9 5a2 2 0 012-2h2a2 2 0 012 2m-6 9l2 2 4-4"/>
            </svg>
        </div>
        <div class="sidebar-brand-text">
            <span class="sidebar-brand-name">AttendanceMS</span>
            <span class="sidebar-brand-org">
                <%= sidebarUser != null ? sidebarUser.getRoleDisplay() : "" %>
            </span>
        </div>
    </div>

    <!-- Navigation -->
    <nav class="sidebar-nav">

        <!-- Main -->
        <div class="nav-section">
            <span class="nav-section-label">Main</span>

            <a href="<%= ctx %>/dashboard"
               class="<%= activeClass(currentURI, "/dashboard") %>">
                <span class="nav-icon">
                    <svg width="18" height="18" viewBox="0 0 24 24" fill="none"
                         stroke="currentColor" stroke-width="2" stroke-linecap="round">
                        <rect x="3" y="3" width="7" height="7"/>
                        <rect x="14" y="3" width="7" height="7"/>
                        <rect x="14" y="14" width="7" height="7"/>
                        <rect x="3" y="14" width="7" height="7"/>
                    </svg>
                </span>
                Dashboard
            </a>

            <a href="<%= ctx %>/attendance"
               class="<%= activeClass(currentURI, "/attendance") %>">
                <span class="nav-icon">
                    <svg width="18" height="18" viewBox="0 0 24 24" fill="none"
                         stroke="currentColor" stroke-width="2" stroke-linecap="round">
                        <circle cx="12" cy="12" r="10"/>
                        <polyline points="12 6 12 12 16 14"/>
                    </svg>
                </span>
                Attendance
            </a>

            <a href="<%= ctx %>/leave"
               class="<%= activeClass(currentURI, "/leave") %>">
                <span class="nav-icon">
                    <svg width="18" height="18" viewBox="0 0 24 24" fill="none"
                         stroke="currentColor" stroke-width="2" stroke-linecap="round">
                        <rect x="3" y="4" width="18" height="18" rx="2" ry="2"/>
                        <line x1="16" y1="2" x2="16" y2="6"/>
                        <line x1="8" y1="2" x2="8" y2="6"/>
                        <line x1="3" y1="10" x2="21" y2="10"/>
                    </svg>
                </span>
                My Leave
            </a>
        </div>

        <!-- Management — only admin, hr, manager -->
        <% if (sidebarUser != null && sidebarUser.canApproveLeave()) { %>
        <div class="nav-section">
            <span class="nav-section-label">Management</span>

            <a href="<%= ctx %>/leave?action=approve"
				class="<%= (currentURI.contains("/leave") && currentURI.contains("approve")) ? "nav-item active" : "nav-item" %>">	                <span class="nav-icon">
                    <svg width="18" height="18" viewBox="0 0 24 24" fill="none"
                         stroke="currentColor" stroke-width="2" stroke-linecap="round">
                        <polyline points="20 6 9 17 4 12"/>
                    </svg>
                </span>
                Leave Approvals
            </a>

            <% if (sidebarUser.canViewReports()) { %>
            <a href="<%= ctx %>/reports"
               class="<%= activeClass(currentURI, "/reports") %>">
                <span class="nav-icon">
                    <svg width="18" height="18" viewBox="0 0 24 24" fill="none"
                         stroke="currentColor" stroke-width="2" stroke-linecap="round">
                        <line x1="18" y1="20" x2="18" y2="10"/>
                        <line x1="12" y1="20" x2="12" y2="4"/>
                        <line x1="6" y1="20" x2="6" y2="14"/>
                    </svg>
                </span>
                Reports
            </a>
            <% } %>

            <% if (sidebarUser.canManageUsers()) { %>
            <a href="<%= ctx %>/users"
               class="<%= activeClass(currentURI, "/users") %>">
                <span class="nav-icon">
                    <svg width="18" height="18" viewBox="0 0 24 24" fill="none"
                         stroke="currentColor" stroke-width="2" stroke-linecap="round">
                        <path d="M17 21v-2a4 4 0 00-4-4H5a4 4 0 00-4 4v2"/>
                        <circle cx="9" cy="7" r="4"/>
                        <path d="M23 21v-2a4 4 0 00-3-3.87"/>
                        <path d="M16 3.13a4 4 0 010 7.75"/>
                    </svg>
                </span>
                Users
            </a>
            <% } %>
        </div>
        <% } %>

        <!-- Admin Only -->
        <% if (sidebarUser != null && sidebarUser.isAdmin()) { %>
        <div class="nav-section">
            <span class="nav-section-label">Admin</span>

            <a href="<%= ctx %>/department"
               class="<%= activeClass(currentURI, "/department") %>">
                <span class="nav-icon">
                    <svg width="18" height="18" viewBox="0 0 24 24" fill="none"
                         stroke="currentColor" stroke-width="2" stroke-linecap="round">
                        <path d="M3 9l9-7 9 7v11a2 2 0 01-2 2H5a2 2 0 01-2-2z"/>
                        <polyline points="9 22 9 12 15 12 15 22"/>
                    </svg>
                </span>
                Departments
            </a>

            <a href="<%= ctx %>/shift"
               class="<%= activeClass(currentURI, "/shift") %>">
                <span class="nav-icon">
                    <svg width="18" height="18" viewBox="0 0 24 24" fill="none"
                         stroke="currentColor" stroke-width="2" stroke-linecap="round">
                        <circle cx="12" cy="12" r="10"/>
                        <polyline points="12 6 12 12 16 14"/>
                    </svg>
                </span>
                Shifts
            </a>

            <a href="<%= ctx %>/holiday"
               class="<%= activeClass(currentURI, "/holiday") %>">
                <span class="nav-icon">
                    <svg width="18" height="18" viewBox="0 0 24 24" fill="none"
                         stroke="currentColor" stroke-width="2" stroke-linecap="round">
                        <path d="M12 2a10 10 0 100 20A10 10 0 0012 2z"/>
                        <path d="M12 6v6l4 2"/>
                    </svg>
                </span>
                Holidays
            </a>

            <a href="<%= ctx %>/announcements"
               class="<%= activeClass(currentURI, "/announcements") %>">
                <span class="nav-icon">
                    <svg width="18" height="18" viewBox="0 0 24 24" fill="none"
                         stroke="currentColor" stroke-width="2" stroke-linecap="round">
                        <path d="M22 17H2a3 3 0 000-6h1V9a9 9 0 0118 0v2h1a3 3 0 010 6z"/>
                        <path d="M13.73 21a2 2 0 01-3.46 0"/>
                    </svg>
                </span>
                Announcements
            </a>

            <a href="<%= ctx %>/audit"
               class="<%= activeClass(currentURI, "/audit") %>">
                <span class="nav-icon">
                    <svg width="18" height="18" viewBox="0 0 24 24" fill="none"
                         stroke="currentColor" stroke-width="2" stroke-linecap="round">
                        <path d="M14 2H6a2 2 0 00-2 2v16a2 2 0 002 2h12a2 2 0 002-2V8z"/>
                        <polyline points="14 2 14 8 20 8"/>
                        <line x1="16" y1="13" x2="8" y2="13"/>
                        <line x1="16" y1="17" x2="8" y2="17"/>
                        <polyline points="10 9 9 9 8 9"/>
                    </svg>
                </span>
                Audit Log
            </a>
        </div>
        <% } %>

    </nav>

    <!-- Footer — user info + logout -->
    <div class="sidebar-footer">
        <% if (sidebarUser != null) { %>
        <div class="sidebar-user">
            <div class="user-avatar">
                <%= sidebarUser.getInitials() %>
            </div>
            <div class="user-info">
                <div class="user-name"><%= sidebarUser.getFullName() %></div>
                <div class="user-role"><%= sidebarUser.getRoleDisplay() %></div>
            </div>
        </div>
        <% } %>
        <a href="<%= ctx %>/auth?action=logout" class="sidebar-logout">
            <svg width="16" height="16" viewBox="0 0 24 24" fill="none"
                 stroke="currentColor" stroke-width="2" stroke-linecap="round">
                <path d="M9 21H5a2 2 0 01-2-2V5a2 2 0 012-2h4"/>
                <polyline points="16 17 21 12 16 7"/>
                <line x1="21" y1="12" x2="9" y2="12"/>
            </svg>
            Sign out
        </a>
    </div>

</aside>