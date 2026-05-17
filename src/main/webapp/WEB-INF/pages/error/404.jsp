<%@ page contentType="text/html;charset=UTF-8" isErrorPage="true" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Page Not Found</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body class="auth-page">
    <div class="error-page-box">
        <div class="error-code">404</div>
        <h2>Page not found</h2>
        <p>The page you are looking for does not exist or has been moved.</p>
        <a href="${pageContext.request.contextPath}/dashboard"
           class="btn btn-primary" style="margin-top:24px;">
            Back to Dashboard
        </a>
    </div>
</body>
</html>