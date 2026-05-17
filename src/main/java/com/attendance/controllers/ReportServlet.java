package com.attendance.controllers;

import com.attendance.model.AttendanceRecord;
import com.attendance.model.User;
import com.attendance.service.AttendanceService;
import com.attendance.service.DepartmentService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.io.PrintWriter;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

/**
 * ReportServlet handles attendance reports and CSV export.
 *
 * GET  /reports                → show report page with current month data
 * GET  /reports?action=filter  → filter by date range and department
 * GET  /reports?action=export  → download CSV
 */
@WebServlet("/reports")
public class ReportServlet extends HttpServlet {

    private AttendanceService  attendanceService;
    private DepartmentService  deptService;

    @Override
    public void init() {
        attendanceService = new AttendanceService();
        deptService       = new DepartmentService();
    }

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        User user = (User) session.getAttribute("loggedInUser");

        if (!user.canViewReports()) {
            response.sendRedirect(
                request.getContextPath() + "/dashboard");
            return;
        }

        String action = request.getParameter("action");

        // Default date range — current month
        String fromDate = request.getParameter("fromDate");
        String toDate   = request.getParameter("toDate");

        if (fromDate == null || fromDate.isEmpty()) {
            fromDate = new SimpleDateFormat("yyyy-MM-01").format(new Date());
        }
        if (toDate == null || toDate.isEmpty()) {
            toDate = new SimpleDateFormat("yyyy-MM-dd").format(new Date());
        }

        // Load report data
        List<AttendanceRecord> records =
            attendanceService.getMonthlyReport(
                user.getOrgId(), fromDate, toDate);

        // ── CSV Export ───────────────────────────────────────────────────────
        if ("export".equals(action)) {
            response.setContentType("text/csv");
            response.setHeader("Content-Disposition",
                "attachment; filename=\"attendance_report_" +
                fromDate + "_to_" + toDate + ".csv\"");

            PrintWriter pw = response.getWriter();

            // CSV Header
            pw.println("Employee Name,Department,Shift," +
                       "Date,Check In,Check Out," +
                       "Break Start,Break End," +
                       "Overtime (mins),Status");

            // CSV Rows
            for (AttendanceRecord r : records) {
                pw.println(
                    csvVal(r.getUserFullName())   + "," +
                    csvVal(r.getDepartmentName()) + "," +
                    csvVal(r.getShiftName())      + "," +
                    csvVal(r.getAttendanceDate() != null
                        ? r.getAttendanceDate().toString() : "") + "," +
                    csvVal(r.getFormattedCheckIn())  + "," +
                    csvVal(r.getFormattedCheckOut()) + "," +
                    csvVal(r.getFormattedBreakStart()) + "," +
                    csvVal(r.getFormattedBreakEnd())   + "," +
                    r.getOvertimeMinutes() + "," +
                    csvVal(r.getStatus())
                );
            }
            pw.flush();
            return;
        }

        // ── Stats for the period ─────────────────────────────────────────────
        long presentCount = records.stream()
            .filter(r -> "PRESENT".equals(r.getStatus())
                      || "LATE".equals(r.getStatus())).count();
        long absentCount  = records.stream()
            .filter(r -> "ABSENT".equals(r.getStatus())).count();
        long lateCount    = records.stream()
            .filter(r -> "LATE".equals(r.getStatus())).count();
        long leaveCount   = records.stream()
            .filter(r -> "ON_LEAVE".equals(r.getStatus())).count();
        long totalOT      = records.stream()
            .mapToLong(AttendanceRecord::getOvertimeMinutes).sum();

        request.setAttribute("records",      records);
        request.setAttribute("fromDate",     fromDate);
        request.setAttribute("toDate",       toDate);
        request.setAttribute("presentCount", presentCount);
        request.setAttribute("absentCount",  absentCount);
        request.setAttribute("lateCount",    lateCount);
        request.setAttribute("leaveCount",   leaveCount);
        request.setAttribute("totalOT",      totalOT);
        request.setAttribute("departments",
            deptService.getDepartmentsByOrg(user.getOrgId()));
        request.setAttribute("pageTitle",    "Reports");
        request.setAttribute("pageSubtitle",
            fromDate + " to " + toDate);

        request.getRequestDispatcher(
            "/WEB-INF/pages/reports/index.jsp")
            .forward(request, response);
    }

    /** Wraps a value in quotes and escapes internal quotes for CSV. */
    private String csvVal(String val) {
        if (val == null) return "";
        return "\"" + val.replace("\"", "\"\"") + "\"";
    }
}