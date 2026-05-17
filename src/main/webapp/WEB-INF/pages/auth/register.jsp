<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Create Account — AttendanceMS</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700;800&family=Be+Vietnam+Pro:wght@300;400;500;600&display=swap"
          rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body class="auth-page">

<div class="auth-box auth-box-wide">

    <!-- Logo -->
    <div class="auth-logo-wrap">
        <div class="auth-logo">
            <svg width="28" height="28" viewBox="0 0 24 24" fill="none"
                 stroke="#9d3d5a" stroke-width="2" stroke-linecap="round">
                <path d="M16 21v-2a4 4 0 00-4-4H6a4 4 0 00-4 4v2"/>
                <circle cx="9" cy="7" r="4"/>
                <line x1="19" y1="8" x2="19" y2="14"/>
                <line x1="22" y1="11" x2="16" y2="11"/>
            </svg>
        </div>
        <h1 class="auth-title">Create account</h1>
        <p class="auth-sub">Join your organization's attendance portal</p>
    </div>

    <%-- Error message --%>
    <% if (request.getAttribute("errorMessage") != null) { %>
        <div class="alert alert-error">
            <%= request.getAttribute("errorMessage") %>
        </div>
    <% } %>

    <form action="${pageContext.request.contextPath}/register"
          method="POST" novalidate>

        <!-- Full name -->
        <div class="form-group">
            <label class="form-label" for="fullName">
                Full Name <span class="form-required">*</span>
            </label>
            <input type="text"
                   id="fullName" name="fullName"
                   class="form-control"
                   placeholder="e.g. Bikram Shrestha"
                   value="${prevFullName}"
                   required>
        </div>

        <!-- Email -->
        <div class="form-group">
            <label class="form-label" for="email">
                Email Address <span class="form-required">*</span>
            </label>
            <input type="email"
                   id="email" name="email"
                   class="form-control"
                   placeholder="you@company.com"
                   value="${prevEmail}"
                   required>
        </div>

        <!-- Employee ID + Designation -->
        <div class="form-row">
            <div class="form-group">
                <label class="form-label" for="employeeId">
                    Employee ID
                </label>
                <input type="text"
                       id="employeeId" name="employeeId"
                       class="form-control"
                       placeholder="e.g. EMP001"
                       value="${prevEmployeeId}">
            </div>
            <div class="form-group">
                <label class="form-label" for="designation">
                    Designation
                </label>
                <input type="text"
                       id="designation" name="designation"
                       class="form-control"
                       placeholder="e.g. Developer"
                       value="${prevDesignation}">
            </div>
        </div>

        <!-- Phone -->
        <div class="form-group">
            <label class="form-label" for="phone">
                Phone Number
            </label>
            <input type="tel"
                   id="phone" name="phone"
                   class="form-control"
                   placeholder="e.g. 9800000000"
                   value="${prevPhone}">
        </div>

        <!-- Organization -->
        <div class="form-group">
            <label class="form-label" for="orgId">
                Organization <span class="form-required">*</span>
            </label>
            <select id="orgId" name="orgId"
                    class="form-control"
                    required
                    onchange="loadDeptAndShift(this.value, '${pageContext.request.contextPath}')">
                <option value="">— Select your organization —</option>
                <%
                    List<String[]> orgs =
                        (List<String[]>) request.getAttribute("organizations");
                    String prevOrgId =
                        (String) request.getAttribute("prevOrgId");
                    if (orgs != null) {
                        for (String[] org : orgs) {
                            String sel = org[0].equals(prevOrgId)
                                         ? "selected" : "";
                %>
                    <option value="<%= org[0] %>" <%= sel %>>
                        <%= org[1] %>
                    </option>
                <%      }
                    }
                %>
            </select>
        </div>

        <!-- Department + Shift -->
        <div class="form-row">
            <div class="form-group">
                <label class="form-label" for="deptId">
                    Department
                </label>
                <select id="deptId" name="deptId" class="form-control">
                    <option value="">— Select org first —</option>
                </select>
            </div>
            <div class="form-group">
                <label class="form-label" for="shiftId">
                    Shift
                </label>
                <select id="shiftId" name="shiftId" class="form-control">
                    <option value="">— Select org first —</option>
                </select>
            </div>
        </div>

        <!-- Passwords -->
        <div class="form-row">
            <div class="form-group">
                <label class="form-label" for="password">
                    Password <span class="form-required">*</span>
                </label>
                <input type="password"
                       id="password" name="password"
                       class="form-control"
                       placeholder="Min. 8 characters"
                       required
                       oninput="checkPasswordMatch('password','confirmPassword','passHint')">
            </div>
            <div class="form-group">
                <label class="form-label" for="confirmPassword">
                    Confirm Password <span class="form-required">*</span>
                </label>
                <input type="password"
                       id="confirmPassword" name="confirmPassword"
                       class="form-control"
                       placeholder="Repeat password"
                       required
                       oninput="checkPasswordMatch('password','confirmPassword','passHint')">
            </div>
        </div>

        <!-- Password match hint -->
        <div id="passHint"
             style="font-size:12.5px; margin-top:-10px;
                    margin-bottom:16px; display:none;">
        </div>

        <button type="submit"
                class="btn btn-primary btn-block"
                style="margin-top:8px;">
            Create Account
        </button>

    </form>

    <p class="auth-footer-text">
        Already have an account?
        <a href="${pageContext.request.contextPath}/auth">Sign in</a>
    </p>

</div>

<script src="${pageContext.request.contextPath}/js/main.js"></script>
<script>
    // Pre-load dept+shift if org was already selected (after validation error)
    var preOrg = document.getElementById('orgId').value;
    if (preOrg) {
        loadDeptAndShift(preOrg, '${pageContext.request.contextPath}');
    }
</script>
</body>
</html>