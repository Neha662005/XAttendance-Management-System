<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.attendance.model.User" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.Date" %>
<%
    User headerUser = (User) session.getAttribute("loggedInUser");
    String today = new SimpleDateFormat("EEEE, dd MMMM yyyy").format(new Date());

    // Page title — servlets set "pageTitle" as a request attribute
    String pageTitle = (String) request.getAttribute("pageTitle");
    if (pageTitle == null) pageTitle = "Dashboard";

    String pageSubtitle = (String) request.getAttribute("pageSubtitle");
    if (pageSubtitle == null) pageSubtitle = "";

    // Role badge CSS class
    String roleBadgeClass = "role-employee";
    if (headerUser != null) {
        switch (headerUser.getRole()) {
            case "SUPER_ADMIN": roleBadgeClass = "role-super-admin"; break;
            case "ADMIN":       roleBadgeClass = "role-admin";       break;
            case "HR":          roleBadgeClass = "role-hr";          break;
            case "MANAGER":     roleBadgeClass = "role-manager";     break;
            default:            roleBadgeClass = "role-employee";    break;
        }
    }
%>

<header class="topbar">

    <div class="topbar-left">

        <!-- Mobile hamburger -->
        <button class="btn btn-icon btn-ghost sidebar-toggle"
                id="sidebarToggle"
                onclick="toggleSidebar()"
                style="display:none; margin-right:4px;">
            <svg width="18" height="18" viewBox="0 0 24 24" fill="none"
                 stroke="currentColor" stroke-width="2" stroke-linecap="round">
                <line x1="3" y1="6" x2="21" y2="6"/>
                <line x1="3" y1="12" x2="21" y2="12"/>
                <line x1="3" y1="18" x2="21" y2="18"/>
            </svg>
        </button>

        <div>
            <div class="topbar-title"><%= pageTitle %></div>
            <% if (!pageSubtitle.isEmpty()) { %>
                <div class="topbar-subtitle"><%= pageSubtitle %></div>
            <% } %>
        </div>
    </div>

    <div class="topbar-right">

        <span class="topbar-date"><%= today %></span>

        <% if (headerUser != null) { %>
            <span class="role-badge <%= roleBadgeClass %>">
                <%= headerUser.getRoleDisplay() %>
            </span>

            <a href="${pageContext.request.contextPath}/profile"
			   title="My Profile"
			   style="text-decoration:none;">
			    <div class="user-avatar"
			         style="cursor:pointer;
			                transition: box-shadow 0.18s ease;"
			         onmouseover="this.style.boxShadow='0 0 0 3px var(--primary)'"
			         onmouseout="this.style.boxShadow='none'">
			        <%= headerUser.getInitials() %>
    			</div>
</a>
        <% } %>

    </div>

</header>