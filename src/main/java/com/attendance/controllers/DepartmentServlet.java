package com.attendance.controllers;

import com.attendance.model.Department;
import com.attendance.model.User;
import com.attendance.service.AuditService;
import com.attendance.service.DepartmentService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;

/**
 * DepartmentServlet manages departments.
 *
 * GET  /department               → list all departments
 * POST /department?action=add    → add new department
 * POST /department?action=edit   → edit department
 * POST /department?action=delete → delete department
 */
@WebServlet("/department")
public class DepartmentServlet extends HttpServlet {

    private DepartmentService deptService;

    @Override
    public void init() {
        deptService = new DepartmentService();
    }

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        User user = (User) session.getAttribute("loggedInUser");

        if (!user.canManageDepartments()) {
            response.sendRedirect(
                request.getContextPath() + "/dashboard");
            return;
        }

        List<Department> depts =
            deptService.getDepartmentsByOrg(user.getOrgId());

        request.setAttribute("departments", depts);
        request.setAttribute("pageTitle",   "Departments");
        request.setAttribute("pageSubtitle",
            depts.size() + " departments");

        request.getRequestDispatcher(
            "/WEB-INF/pages/department/index.jsp")
            .forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        User user   = (User) session.getAttribute("loggedInUser");
        String action = request.getParameter("action");

        if (!user.canManageDepartments()) {
            response.sendRedirect(
                request.getContextPath() + "/dashboard");
            return;
        }

        switch (action == null ? "" : action) {

            case "add": {
                String name = request.getParameter("name");
                String desc = request.getParameter("description");
                if (name == null || name.trim().isEmpty()) {
                    session.setAttribute("flashError",
                        "Department name is required.");
                    break;
                }
                Department d = new Department();
                d.setOrgId(user.getOrgId());
                d.setName(name.trim());
                d.setDescription(desc);
                boolean ok = deptService.addDepartment(d);
                if (ok) {
                    AuditService.log(user.getId(),
                        "DEPARTMENT_ADDED",
                        "departments", 0,
                        null, name,
                        request.getRemoteAddr());
                    session.setAttribute("flashMessage",
                        "Department \"" + name + "\" added.");
                } else {
                    session.setAttribute("flashError",
                        "Could not add department.");
                }
                break;
            }

            case "edit": {
                String idStr = request.getParameter("deptId");
                String name  = request.getParameter("name");
                String desc  = request.getParameter("description");
                if (idStr == null || name == null ||
                    name.trim().isEmpty()) {
                    session.setAttribute("flashError",
                        "Invalid request.");
                    break;
                }
                Department d = new Department();
                d.setId(Integer.parseInt(idStr));
                d.setName(name.trim());
                d.setDescription(desc);
                boolean ok = deptService.updateDepartment(d);
                if (ok) {
                    session.setAttribute("flashMessage",
                        "Department updated.");
                } else {
                    session.setAttribute("flashError",
                        "Could not update department.");
                }
                break;
            }

            case "delete": {
                String idStr = request.getParameter("deptId");
                if (idStr == null) {
                    session.setAttribute("flashError",
                        "Invalid request.");
                    break;
                }
                int id = Integer.parseInt(idStr);
                boolean ok = deptService.deleteDepartment(id);
                if (ok) {
                    AuditService.log(user.getId(),
                        "DEPARTMENT_DELETED",
                        "departments", id,
                        null, null,
                        request.getRemoteAddr());
                    session.setAttribute("flashMessage",
                        "Department deleted.");
                } else {
                    session.setAttribute("flashError",
                        "Cannot delete — department has " +
                        "active employees assigned to it.");
                }
                break;
            }

            default:
                session.setAttribute("flashError",
                    "Unknown action.");
        }

        response.sendRedirect(
            request.getContextPath() + "/department");
    }
}