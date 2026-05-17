package com.attendance.controllers;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.*;
import java.io.IOException;

/**
 * AuthFilter intercepts every request.
 * Public paths bypass the session check.
 * Everything else requires a valid logged-in session.
 */
@WebFilter("/*")
public class AuthFilter implements Filter {

    private static final String[] PUBLIC = {
        "/auth", "/register", "/getDepartments",
        "/css/", "/js/", "/images/", "/error/"
    };

    @Override
    public void doFilter(ServletRequest req, ServletResponse res, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest  request  = (HttpServletRequest) req;
        HttpServletResponse response = (HttpServletResponse) res;

        String path = request.getRequestURI()
                             .substring(request.getContextPath().length());

        // Allow public paths through
        for (String pub : PUBLIC) {
            if (path.startsWith(pub)) {
                chain.doFilter(request, response);
                return;
            }
        }

        // Check session
        HttpSession session  = request.getSession(false);
        boolean     loggedIn = session != null
                            && session.getAttribute("loggedInUser") != null;

        if (loggedIn) {
            chain.doFilter(request, response);
        } else {
            response.sendRedirect(request.getContextPath() + "/auth");
        }
    }

    @Override public void init(FilterConfig fc) {}
    @Override public void destroy() {}
}