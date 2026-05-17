<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Sign In — AttendanceMS</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700;800&family=Be+Vietnam+Pro:wght@300;400;500;600&display=swap"
          rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body class="auth-page">

<div class="auth-box">

    <!-- Logo -->
    <div class="auth-logo-wrap">
        <div class="auth-logo">
            <svg width="28" height="28" viewBox="0 0 24 24" fill="none"
                 stroke="#9d3d5a" stroke-width="2" stroke-linecap="round">
                <path d="M9 5H7a2 2 0 00-2 2v12a2 2 0 002 2h10a2 2 0 002-2V7a2 2 0 00-2-2h-2"/>
                <rect x="9" y="3" width="6" height="4" rx="2"/>
                <path d="M9 12l2 2 4-4"/>
            </svg>
        </div>
        <h1 class="auth-title">Welcome back</h1>
        <p class="auth-sub">Sign in to your attendance portal</p>
    </div>

    <%-- Registration success flash --%>
    <% if (session.getAttribute("flashMessage") != null) { %>
        <div class="alert alert-success">
            <%= session.getAttribute("flashMessage") %>
            <% session.removeAttribute("flashMessage"); %>
        </div>
    <% } %>

    <%-- Error message --%>
    <% if (request.getAttribute("errorMessage") != null) { %>
        <div class="alert alert-error">
            <%= request.getAttribute("errorMessage") %>
        </div>
    <% } %>

    <!-- Login form -->
    <form action="${pageContext.request.contextPath}/auth"
          method="POST" novalidate>

        <div class="form-group">
            <label class="form-label" for="email">
                Email address
            </label>
            <input type="email"
                   id="email"
                   name="email"
                   class="form-control"
                   placeholder="you@company.com"
                   value="${prevEmail}"
                   autocomplete="email"
                   required>
        </div>

        <div class="form-group">
            <label class="form-label" for="password">
                Password
            </label>
            <div class="input-wrapper">
                <input type="password"
                       id="password"
                       name="password"
                       class="form-control"
                       placeholder="Enter your password"
                       autocomplete="current-password"
                       required>
                <button type="button"
                        class="input-toggle-btn"
                        id="toggleBtn"
                        onclick="togglePassword('password','toggleBtn')">
                    <svg width="16" height="16" viewBox="0 0 24 24" fill="none"
                         stroke="currentColor" stroke-width="2" stroke-linecap="round">
                        <path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"/>
                        <circle cx="12" cy="12" r="3"/>
                    </svg>
                </button>
            </div>
        </div>

        <button type="submit"
                class="btn btn-primary btn-block"
                style="margin-top: 8px;">
            Sign In
        </button>

    </form>

    <p class="auth-footer-text">
        Don't have an account?
        <a href="${pageContext.request.contextPath}/register">
            Create one
        </a>
    </p>

</div>

<script src="${pageContext.request.contextPath}/js/main.js"></script>
</body>
</html>