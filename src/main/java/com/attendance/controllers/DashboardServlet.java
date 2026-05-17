package com.attendance.controllers;

import com.attendance.model.*;
import com.attendance.service.*;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

/**
 * DashboardServlet loads the main dashboard.
 * GET /dashboard → loads stats, today's record,
 *                  balances, announcements → forwards to dashboard.jsp
 */
@WebServlet("/dashboard")
public class DashboardServlet extends HttpServlet {

    private AttendanceService  attendanceService;
    private LeaveService       leaveService;
    private UserService        userService;
    private AnnouncementService announcementService;

    @Override
    public void init() {
        attendanceService   = new AttendanceService();
        leaveService        = new LeaveService();
        userService         = new UserService();
        announcementService = new AnnouncementService();
    }

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        User user = (User) session.getAttribute("loggedInUser");

        int orgId  = user.getOrgId();
        int userId = user.getId();

        // ── Today's attendance record ────────────────────────────────────
        AttendanceRecord todayRecord =
            attendanceService.getTodayRecord(userId);

        // ── Leave balances ───────────────────────────────────────────────
        List<LeaveBalance> balances =
            leaveService.getBalances(userId);

        // ── Active announcements ─────────────────────────────────────────
        List<Announcement> announcements =
            announcementService.getActiveAnnouncements(orgId);

        // ── Stats (admin / manager / hr only) ───────────────────────────
        if (user.canViewReports()) {
            int totalEmployees =
                userService.getTotalEmployees(orgId);
            int presentToday =
                attendanceService.getPresentTodayCount(orgId);
            int onLeaveToday =
                attendanceService.getOnLeaveTodayCount(orgId);
            int lateToday =
                attendanceService.getLateTodayCount(orgId);
            int pendingLeaves =
                leaveService.getPendingCount(orgId);

            // Absent = total - present - on leave
            int absentToday = Math.max(0,
                totalEmployees - presentToday - onLeaveToday);

            request.setAttribute("totalEmployees", totalEmployees);
            request.setAttribute("presentToday",   presentToday);
            request.setAttribute("onLeaveToday",   onLeaveToday);
            request.setAttribute("lateToday",      lateToday);
            request.setAttribute("absentToday",    absentToday);
            request.setAttribute("pendingLeaves",  pendingLeaves);
        }

        // ── Today's date formatted ───────────────────────────────────────
        String todayDate = new SimpleDateFormat("EEEE, dd MMMM yyyy")
                               .format(new Date());

        // ── Set all attributes ───────────────────────────────────────────
        request.setAttribute("todayRecord",    todayRecord);
        request.setAttribute("balances",       balances);
        request.setAttribute("announcements",  announcements);
        request.setAttribute("todayDate",      todayDate);
        request.setAttribute("pageTitle",      "Dashboard");
        request.setAttribute("pageSubtitle",   todayDate);

        request.getRequestDispatcher(
            "/WEB-INF/pages/dashboard/index.jsp")
            .forward(request, response);
    }
}