<%@ page contentType="text/html;charset=UTF-8" isErrorPage="true" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Server Error</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body class="auth-page">
    <div class="error-page-box">
        <div class="error-code">500</div>
        <h2>Something went wrong</h2>
        <p>An unexpected error occurred. Please try again or contact support.</p>
        <a href="${pageContext.request.contextPath}/dashboard"
           class="btn btn-primary" style="margin-top:24px;">
            Back to Dashboard
        </a>
    </div>
</body>
</html>