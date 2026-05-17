-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: May 17, 2026 at 09:49 AM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.0.30

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `attendance_db`
--

-- --------------------------------------------------------

--
-- Table structure for table `announcements`
--

CREATE TABLE `announcements` (
  `id` int(11) NOT NULL,
  `org_id` int(11) NOT NULL,
  `created_by` int(11) NOT NULL,
  `title` varchar(200) NOT NULL,
  `message` text NOT NULL,
  `is_active` tinyint(1) DEFAULT 1,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `announcements`
--

INSERT INTO `announcements` (`id`, `org_id`, `created_by`, `title`, `message`, `is_active`, `created_at`) VALUES
(1, 1, 1, 'Welcome to AttendanceMS', 'This is your new attendance management system. Please check in daily.', 1, '2026-05-04 04:45:32'),
(3, 1, 2, 'Office Closed on Tuesday', 'Due to some renovation work office will close on coming tuesday \r\n\r\n\r\nWork from Home', 1, '2026-05-17 03:29:46');

-- --------------------------------------------------------

--
-- Table structure for table `attendance_records`
--

CREATE TABLE `attendance_records` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `shift_id` int(11) DEFAULT NULL,
  `check_in` datetime DEFAULT NULL,
  `check_out` datetime DEFAULT NULL,
  `break_start` datetime DEFAULT NULL,
  `break_end` datetime DEFAULT NULL,
  `attendance_date` date NOT NULL,
  `status` enum('PRESENT','ABSENT','LATE','HALF_DAY','ON_LEAVE','HOLIDAY') DEFAULT 'PRESENT',
  `overtime_minutes` int(11) DEFAULT 0,
  `remarks` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `attendance_records`
--

INSERT INTO `attendance_records` (`id`, `user_id`, `shift_id`, `check_in`, `check_out`, `break_start`, `break_end`, `attendance_date`, `status`, `overtime_minutes`, `remarks`) VALUES
(1, 2, 1, '2026-05-04 13:32:30', '2026-05-04 17:09:47', NULL, NULL, '2026-05-04', 'LATE', 9, NULL),
(2, 3, 1, '2026-05-04 13:39:20', NULL, NULL, NULL, '2026-05-04', 'LATE', 0, NULL),
(3, 3, 1, '2026-05-16 20:08:53', '2026-05-16 20:09:06', '2026-05-16 20:08:59', '2026-05-16 20:09:03', '2026-05-16', 'LATE', 189, NULL),
(4, 2, 1, '2026-05-16 20:13:31', NULL, NULL, NULL, '2026-05-16', 'LATE', 0, NULL),
(5, 4, 1, '2026-05-17 08:30:12', NULL, '2026-05-17 08:30:36', '2026-05-17 08:40:24', '2026-05-17', 'PRESENT', 0, NULL),
(6, 2, 1, '2026-05-17 12:14:36', NULL, NULL, NULL, '2026-05-17', 'LATE', 0, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `audit_log`
--

CREATE TABLE `audit_log` (
  `id` int(11) NOT NULL,
  `user_id` int(11) DEFAULT NULL,
  `action` varchar(100) NOT NULL,
  `table_name` varchar(50) DEFAULT NULL,
  `record_id` int(11) DEFAULT NULL,
  `old_value` text DEFAULT NULL,
  `new_value` text DEFAULT NULL,
  `ip_address` varchar(45) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `audit_log`
--

INSERT INTO `audit_log` (`id`, `user_id`, `action`, `table_name`, `record_id`, `old_value`, `new_value`, `ip_address`, `created_at`) VALUES
(1, 2, 'USER_LOGIN', NULL, 0, NULL, NULL, '0:0:0:0:0:0:0:1', '2026-05-04 06:39:50'),
(2, 2, 'USER_DEACTIVATED', 'users', 1, 'active', 'inactive', '0:0:0:0:0:0:0:1', '2026-05-04 06:40:02'),
(3, 2, 'USER_ACTIVATED', 'users', 1, 'inactive', 'active', '0:0:0:0:0:0:0:1', '2026-05-04 06:40:04'),
(4, 2, 'USER_LOGIN', NULL, 0, NULL, NULL, '0:0:0:0:0:0:0:1', '2026-05-04 07:46:46'),
(5, 2, 'ATTENDANCE_CHECKIN', NULL, 0, NULL, NULL, '0:0:0:0:0:0:0:1', '2026-05-04 07:47:30'),
(6, 2, 'USER_LOGOUT', NULL, 0, NULL, NULL, '0:0:0:0:0:0:0:1', '2026-05-04 07:53:28'),
(7, 3, 'USER_LOGIN', NULL, 0, NULL, NULL, '0:0:0:0:0:0:0:1', '2026-05-04 07:54:16'),
(8, 3, 'ATTENDANCE_CHECKIN', NULL, 0, NULL, NULL, '0:0:0:0:0:0:0:1', '2026-05-04 07:54:20'),
(9, 3, 'USER_LOGOUT', NULL, 0, NULL, NULL, '0:0:0:0:0:0:0:1', '2026-05-04 07:54:44'),
(10, 2, 'USER_LOGIN', NULL, 0, NULL, NULL, '0:0:0:0:0:0:0:1', '2026-05-04 07:54:54'),
(11, 2, 'USER_LOGOUT', NULL, 0, NULL, NULL, '0:0:0:0:0:0:0:1', '2026-05-04 07:59:29'),
(12, 3, 'USER_LOGIN', NULL, 0, NULL, NULL, '0:0:0:0:0:0:0:1', '2026-05-04 07:59:53'),
(13, 3, 'LEAVE_APPLIED', 'leave_requests', 0, NULL, '5 days', '0:0:0:0:0:0:0:1', '2026-05-04 08:00:15'),
(14, 3, 'USER_LOGOUT', NULL, 0, NULL, NULL, '0:0:0:0:0:0:0:1', '2026-05-04 08:00:20'),
(15, 2, 'USER_LOGIN', NULL, 0, NULL, NULL, '0:0:0:0:0:0:0:1', '2026-05-04 08:00:32'),
(16, 2, 'USER_LOGIN', NULL, 0, NULL, NULL, '0:0:0:0:0:0:0:1', '2026-05-04 11:11:09'),
(17, 2, 'ATTENDANCE_CHECKOUT', NULL, 0, NULL, NULL, '0:0:0:0:0:0:0:1', '2026-05-04 11:24:47'),
(18, 2, 'USER_LOGOUT', NULL, 0, NULL, NULL, '0:0:0:0:0:0:0:1', '2026-05-04 11:40:04'),
(19, 2, 'USER_LOGIN', NULL, 0, NULL, NULL, '0:0:0:0:0:0:0:1', '2026-05-07 05:02:41'),
(20, 2, 'DEPARTMENT_DELETED', 'departments', 4, NULL, NULL, '0:0:0:0:0:0:0:1', '2026-05-07 05:07:19'),
(21, 2, 'USER_LOGIN', NULL, 0, NULL, NULL, '0:0:0:0:0:0:0:1', '2026-05-16 14:14:10'),
(22, 3, 'USER_LOGIN', NULL, 0, NULL, NULL, '0:0:0:0:0:0:0:1', '2026-05-16 14:17:54'),
(23, 3, 'USER_LOGOUT', NULL, 0, NULL, NULL, '0:0:0:0:0:0:0:1', '2026-05-16 14:19:06'),
(24, 2, 'USER_LOGIN', NULL, 0, NULL, NULL, '0:0:0:0:0:0:0:1', '2026-05-16 14:19:18'),
(25, 2, 'LEAVE_APPROVED', 'leave_requests', 1, 'PENDING', 'APPROVED', '0:0:0:0:0:0:0:1', '2026-05-16 14:19:41'),
(26, 2, 'ANNOUNCEMENT_ADDED', 'announcements', 0, NULL, 'Friday bidaaa', '0:0:0:0:0:0:0:1', '2026-05-16 14:21:28'),
(27, 3, 'USER_LOGIN', NULL, 0, NULL, NULL, '0:0:0:0:0:0:0:1', '2026-05-16 14:22:24'),
(28, 3, 'ATTENDANCE_CHECKIN', NULL, 0, NULL, NULL, '0:0:0:0:0:0:0:1', '2026-05-16 14:23:53'),
(29, 3, 'ATTENDANCE_CHECKOUT', NULL, 0, NULL, NULL, '0:0:0:0:0:0:0:1', '2026-05-16 14:24:06'),
(30, 2, 'USER_DEACTIVATED', 'users', 3, 'active', 'inactive', '0:0:0:0:0:0:0:1', '2026-05-16 14:26:13'),
(31, 3, 'USER_LOGOUT', NULL, 0, NULL, NULL, '0:0:0:0:0:0:0:1', '2026-05-16 14:26:28'),
(32, 2, 'USER_ACTIVATED', 'users', 3, 'inactive', 'active', '0:0:0:0:0:0:0:1', '2026-05-16 14:26:35'),
(33, 3, 'USER_LOGIN', NULL, 0, NULL, NULL, '0:0:0:0:0:0:0:1', '2026-05-16 14:26:37'),
(34, 2, 'ATTENDANCE_CHECKIN', NULL, 0, NULL, NULL, '0:0:0:0:0:0:0:1', '2026-05-16 14:28:31'),
(35, 2, 'HOLIDAY_ADDED', 'holidays', 0, NULL, 'friday on 2026-05-22', '0:0:0:0:0:0:0:1', '2026-05-16 14:58:52'),
(36, 3, 'USER_LOGOUT', NULL, 0, NULL, NULL, '0:0:0:0:0:0:0:1', '2026-05-16 15:56:44'),
(37, 3, 'USER_LOGIN', NULL, 0, NULL, NULL, '0:0:0:0:0:0:0:1', '2026-05-16 15:56:47'),
(38, 3, 'USER_LOGOUT', NULL, 0, NULL, NULL, '0:0:0:0:0:0:0:1', '2026-05-16 15:56:58'),
(39, 3, 'USER_LOGIN', NULL, 0, NULL, NULL, '0:0:0:0:0:0:0:1', '2026-05-16 15:57:00'),
(40, 3, 'LEAVE_APPLIED', 'leave_requests', 0, NULL, '1 days', '0:0:0:0:0:0:0:1', '2026-05-16 16:01:18'),
(41, 3, 'USER_LOGIN', NULL, 0, NULL, NULL, '0:0:0:0:0:0:0:1', '2026-05-17 02:26:49'),
(42, 3, 'USER_LOGOUT', NULL, 0, NULL, NULL, '0:0:0:0:0:0:0:1', '2026-05-17 02:27:02'),
(44, 4, 'USER_LOGIN', NULL, 0, NULL, NULL, '0:0:0:0:0:0:0:1', '2026-05-17 02:40:05'),
(45, 4, 'ATTENDANCE_CHECKIN', NULL, 0, NULL, NULL, '0:0:0:0:0:0:0:1', '2026-05-17 02:45:12'),
(46, 4, 'USER_LOGOUT', NULL, 0, NULL, NULL, '0:0:0:0:0:0:0:1', '2026-05-17 03:01:24'),
(47, 3, 'USER_LOGIN', NULL, 0, NULL, NULL, '0:0:0:0:0:0:0:1', '2026-05-17 03:01:30'),
(48, 2, 'USER_LOGIN', NULL, 0, NULL, NULL, '0:0:0:0:0:0:0:1', '2026-05-17 03:05:07'),
(49, 2, 'LEAVE_APPROVED', 'leave_requests', 2, 'PENDING', 'APPROVED', '0:0:0:0:0:0:0:1', '2026-05-17 03:05:49'),
(50, 3, 'LEAVE_APPLIED', 'leave_requests', 0, NULL, '1 days', '0:0:0:0:0:0:0:1', '2026-05-17 03:10:52'),
(51, 2, 'LEAVE_REJECTED', 'leave_requests', 3, 'PENDING', 'REJECTED', '0:0:0:0:0:0:0:1', '2026-05-17 03:12:20'),
(52, 2, 'HOLIDAY_ADDED', 'holidays', 0, NULL, 'friday on 2026-05-22', '0:0:0:0:0:0:0:1', '2026-05-17 03:24:53'),
(53, 2, 'ANNOUNCEMENT_ADDED', 'announcements', 0, NULL, 'Office Closed on Tuesday', '0:0:0:0:0:0:0:1', '2026-05-17 03:29:46'),
(54, 3, 'PROFILE_UPDATED', NULL, 0, NULL, NULL, '0:0:0:0:0:0:0:1', '2026-05-17 03:36:52'),
(55, 2, 'DEPARTMENT_ADDED', 'departments', 0, NULL, 'Account', '0:0:0:0:0:0:0:1', '2026-05-17 03:43:03'),
(56, 3, 'USER_LOGOUT', NULL, 0, NULL, NULL, '0:0:0:0:0:0:0:1', '2026-05-17 03:53:17'),
(57, 3, 'USER_LOGIN', NULL, 0, NULL, NULL, '0:0:0:0:0:0:0:1', '2026-05-17 04:14:25'),
(58, 3, 'USER_LOGOUT', NULL, 0, NULL, NULL, '0:0:0:0:0:0:0:1', '2026-05-17 04:41:44'),
(59, 4, 'USER_LOGIN', NULL, 0, NULL, NULL, '0:0:0:0:0:0:0:1', '2026-05-17 04:41:48'),
(60, 2, 'USER_LOGIN', NULL, 0, NULL, NULL, '0:0:0:0:0:0:0:1', '2026-05-17 05:56:47'),
(61, 2, 'USER_LOGOUT', NULL, 0, NULL, NULL, '0:0:0:0:0:0:0:1', '2026-05-17 06:00:46'),
(62, 2, 'USER_LOGIN', NULL, 0, NULL, NULL, '0:0:0:0:0:0:0:1', '2026-05-17 06:02:28'),
(63, 2, 'USER_LOGOUT', NULL, 0, NULL, NULL, '0:0:0:0:0:0:0:1', '2026-05-17 06:03:18'),
(64, 2, 'USER_LOGIN', NULL, 0, NULL, NULL, '0:0:0:0:0:0:0:1', '2026-05-17 06:03:27'),
(65, 2, 'USER_LOGOUT', NULL, 0, NULL, NULL, '0:0:0:0:0:0:0:1', '2026-05-17 06:03:50'),
(66, 2, 'USER_LOGIN', NULL, 0, NULL, NULL, '0:0:0:0:0:0:0:1', '2026-05-17 06:03:59'),
(67, 2, 'USER_LOGOUT', NULL, 0, NULL, NULL, '0:0:0:0:0:0:0:1', '2026-05-17 06:28:19'),
(68, 2, 'USER_LOGIN', NULL, 0, NULL, NULL, '0:0:0:0:0:0:0:1', '2026-05-17 06:29:32'),
(69, 2, 'ATTENDANCE_CHECKIN', NULL, 0, NULL, NULL, '0:0:0:0:0:0:0:1', '2026-05-17 06:29:36'),
(70, 4, 'USER_LOGIN', NULL, 0, NULL, NULL, '0:0:0:0:0:0:0:1', '2026-05-17 07:06:59');

-- --------------------------------------------------------

--
-- Table structure for table `departments`
--

CREATE TABLE `departments` (
  `id` int(11) NOT NULL,
  `org_id` int(11) NOT NULL,
  `name` varchar(100) NOT NULL,
  `description` varchar(255) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `departments`
--

INSERT INTO `departments` (`id`, `org_id`, `name`, `description`, `created_at`) VALUES
(1, 1, 'Administration', NULL, '2026-05-04 04:45:31'),
(2, 1, 'Engineering', NULL, '2026-05-04 04:45:31'),
(3, 1, 'Human Resources', NULL, '2026-05-04 04:45:31'),
(5, 1, 'Account', '                    ', '2026-05-17 03:43:03');

-- --------------------------------------------------------

--
-- Table structure for table `holidays`
--

CREATE TABLE `holidays` (
  `id` int(11) NOT NULL,
  `org_id` int(11) NOT NULL,
  `name` varchar(100) NOT NULL,
  `holiday_date` date NOT NULL,
  `description` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `holidays`
--

INSERT INTO `holidays` (`id`, `org_id`, `name`, `holiday_date`, `description`) VALUES
(2, 1, 'friday', '2026-05-22', 'Last Friday');

-- --------------------------------------------------------

--
-- Table structure for table `leave_balances`
--

CREATE TABLE `leave_balances` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `leave_type_id` int(11) NOT NULL,
  `year` int(11) NOT NULL,
  `total_days` int(11) NOT NULL DEFAULT 0,
  `used_days` int(11) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `leave_balances`
--

INSERT INTO `leave_balances` (`id`, `user_id`, `leave_type_id`, `year`, `total_days`, `used_days`) VALUES
(1, 1, 1, 2026, 12, 0),
(2, 1, 2, 2026, 12, 0),
(3, 1, 3, 2026, 18, 0),
(4, 1, 4, 2026, 30, 0),
(5, 2, 1, 2026, 12, 0),
(6, 2, 2, 2026, 12, 0),
(7, 2, 3, 2026, 18, 0),
(8, 2, 4, 2026, 30, 0),
(9, 3, 1, 2026, 12, 0),
(10, 3, 2, 2026, 12, 1),
(11, 3, 3, 2026, 18, 5),
(12, 3, 4, 2026, 30, 0);

-- --------------------------------------------------------

--
-- Table structure for table `leave_requests`
--

CREATE TABLE `leave_requests` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `leave_type_id` int(11) NOT NULL,
  `from_date` date NOT NULL,
  `to_date` date NOT NULL,
  `total_days` int(11) NOT NULL DEFAULT 1,
  `reason` text DEFAULT NULL,
  `status` enum('PENDING','APPROVED','REJECTED','CANCELLED') DEFAULT 'PENDING',
  `approved_by` int(11) DEFAULT NULL,
  `approval_note` varchar(255) DEFAULT NULL,
  `applied_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `actioned_at` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `leave_requests`
--

INSERT INTO `leave_requests` (`id`, `user_id`, `leave_type_id`, `from_date`, `to_date`, `total_days`, `reason`, `status`, `approved_by`, `approval_note`, `applied_at`, `actioned_at`) VALUES
(1, 3, 3, '2026-05-05', '2026-05-09', 5, '                                Summer Break', 'APPROVED', 2, 'okay!!!', '2026-05-04 08:00:15', '2026-05-16 20:04:41'),
(2, 3, 2, '2026-05-17', '2026-05-17', 1, '                                leave me alone\r\n', 'APPROVED', 2, 'enjoyy!!', '2026-05-16 16:01:18', '2026-05-17 08:50:49'),
(3, 3, 3, '2026-05-18', '2026-05-18', 1, '                                Annual Leave', 'REJECTED', 2, 'no more leave', '2026-05-17 03:10:52', '2026-05-17 08:57:20');

-- --------------------------------------------------------

--
-- Table structure for table `leave_types`
--

CREATE TABLE `leave_types` (
  `id` int(11) NOT NULL,
  `org_id` int(11) NOT NULL,
  `name` varchar(100) NOT NULL,
  `days_allowed` int(11) NOT NULL DEFAULT 10,
  `is_paid` tinyint(1) DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `leave_types`
--

INSERT INTO `leave_types` (`id`, `org_id`, `name`, `days_allowed`, `is_paid`) VALUES
(1, 1, 'Sick Leave', 12, 1),
(2, 1, 'Casual Leave', 12, 1),
(3, 1, 'Annual Leave', 18, 1),
(4, 1, 'Unpaid Leave', 30, 0),
(5, 1, 'Maternity Leave', 90, 1),
(6, 1, 'Paternity Leave', 15, 1);

-- --------------------------------------------------------

--
-- Table structure for table `organizations`
--

CREATE TABLE `organizations` (
  `id` int(11) NOT NULL,
  `name` varchar(150) NOT NULL,
  `industry` varchar(100) DEFAULT NULL,
  `address` varchar(255) DEFAULT NULL,
  `email` varchar(100) DEFAULT NULL,
  `phone` varchar(20) DEFAULT NULL,
  `is_active` tinyint(1) DEFAULT 1,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `organizations`
--

INSERT INTO `organizations` (`id`, `name`, `industry`, `address`, `email`, `phone`, `is_active`, `created_at`) VALUES
(1, 'Demo Company', 'Technology', 'Kathmandu, Nepal', 'admin@demo.com', NULL, 1, '2026-05-04 04:45:31');

-- --------------------------------------------------------

--
-- Table structure for table `shifts`
--

CREATE TABLE `shifts` (
  `id` int(11) NOT NULL,
  `org_id` int(11) NOT NULL,
  `name` varchar(100) NOT NULL,
  `start_time` time NOT NULL,
  `end_time` time NOT NULL,
  `grace_minutes` int(11) DEFAULT 15,
  `is_active` tinyint(1) DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `shifts`
--

INSERT INTO `shifts` (`id`, `org_id`, `name`, `start_time`, `end_time`, `grace_minutes`, `is_active`) VALUES
(1, 1, 'Morning Shift', '09:00:00', '17:00:00', 15, 1),
(2, 1, 'Evening Shift', '14:00:00', '22:00:00', 15, 1),
(3, 1, 'Night Shift', '22:00:00', '06:00:00', 15, 1),
(4, 1, 'Part-time Shifts', '09:00:00', '12:00:00', 15, 1),
(5, 1, 'Overtime Shift', '09:00:00', '09:00:00', 15, 0),
(6, 1, 'shifts', '09:00:00', '08:00:00', 15, 1);

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` int(11) NOT NULL,
  `org_id` int(11) NOT NULL,
  `dept_id` int(11) DEFAULT NULL,
  `shift_id` int(11) DEFAULT NULL,
  `full_name` varchar(100) NOT NULL,
  `email` varchar(100) NOT NULL,
  `password_hash` varchar(255) NOT NULL,
  `role` enum('SUPER_ADMIN','ADMIN','HR','MANAGER','EMPLOYEE') DEFAULT 'EMPLOYEE',
  `employee_id` varchar(50) DEFAULT NULL,
  `phone` varchar(20) DEFAULT NULL,
  `designation` varchar(100) DEFAULT NULL,
  `manager_id` int(11) DEFAULT NULL,
  `is_active` tinyint(1) DEFAULT 1,
  `failed_attempts` int(11) DEFAULT 0,
  `locked_until` datetime DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `org_id`, `dept_id`, `shift_id`, `full_name`, `email`, `password_hash`, `role`, `employee_id`, `phone`, `designation`, `manager_id`, `is_active`, `failed_attempts`, `locked_until`, `created_at`) VALUES
(1, 1, 1, 1, 'Super Admin', 'superadmin@demo.com', '$2a$12$53EU6JrmAjeZbCQD5AuCwuNzkClIgjjZSkzzoQLLZ/IgODjZqlE.q', 'SUPER_ADMIN', 'EMP000', NULL, 'System Administrator', NULL, 1, 0, NULL, '2026-05-04 04:45:31'),
(2, 1, 1, 1, 'Admin User', 'admin@demo.com', '$2a$12$53EU6JrmAjeZbCQD5AuCwuNzkClIgjjZSkzzoQLLZ/IgODjZqlE.q', 'ADMIN', 'EMP001', NULL, 'Administrator', NULL, 1, 0, NULL, '2026-05-04 04:45:31'),
(3, 1, 2, 1, 'Test Employee', 'employee@demo.com', '$2a$12$53EU6JrmAjeZbCQD5AuCwuNzkClIgjjZSkzzoQLLZ/IgODjZqlE.q', 'EMPLOYEE', 'EMP002', '9879879870', 'Software Developer', NULL, 1, 0, NULL, '2026-05-04 04:45:31'),
(4, 1, 3, 1, 'Neha KC', 'neha@demo.com', '$2a$12$/LtcUv4/rZuH3VzoHxJSauYHMeE1Vgv4Qrg1atEvuLf12Db8Ktmzi', 'EMPLOYEE', 'EMP001', '9876543210', 'Developer', NULL, 1, 0, NULL, '2026-05-17 02:39:43');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `announcements`
--
ALTER TABLE `announcements`
  ADD PRIMARY KEY (`id`),
  ADD KEY `org_id` (`org_id`),
  ADD KEY `created_by` (`created_by`);

--
-- Indexes for table `attendance_records`
--
ALTER TABLE `attendance_records`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `unique_daily` (`user_id`,`attendance_date`),
  ADD KEY `shift_id` (`shift_id`);

--
-- Indexes for table `audit_log`
--
ALTER TABLE `audit_log`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_id` (`user_id`);

--
-- Indexes for table `departments`
--
ALTER TABLE `departments`
  ADD PRIMARY KEY (`id`),
  ADD KEY `org_id` (`org_id`);

--
-- Indexes for table `holidays`
--
ALTER TABLE `holidays`
  ADD PRIMARY KEY (`id`),
  ADD KEY `org_id` (`org_id`);

--
-- Indexes for table `leave_balances`
--
ALTER TABLE `leave_balances`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `unique_balance` (`user_id`,`leave_type_id`,`year`),
  ADD KEY `leave_type_id` (`leave_type_id`);

--
-- Indexes for table `leave_requests`
--
ALTER TABLE `leave_requests`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_id` (`user_id`),
  ADD KEY `leave_type_id` (`leave_type_id`),
  ADD KEY `approved_by` (`approved_by`);

--
-- Indexes for table `leave_types`
--
ALTER TABLE `leave_types`
  ADD PRIMARY KEY (`id`),
  ADD KEY `org_id` (`org_id`);

--
-- Indexes for table `organizations`
--
ALTER TABLE `organizations`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `shifts`
--
ALTER TABLE `shifts`
  ADD PRIMARY KEY (`id`),
  ADD KEY `org_id` (`org_id`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `email` (`email`),
  ADD KEY `org_id` (`org_id`),
  ADD KEY `dept_id` (`dept_id`),
  ADD KEY `shift_id` (`shift_id`),
  ADD KEY `manager_id` (`manager_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `announcements`
--
ALTER TABLE `announcements`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `attendance_records`
--
ALTER TABLE `attendance_records`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `audit_log`
--
ALTER TABLE `audit_log`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=71;

--
-- AUTO_INCREMENT for table `departments`
--
ALTER TABLE `departments`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `holidays`
--
ALTER TABLE `holidays`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `leave_balances`
--
ALTER TABLE `leave_balances`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- AUTO_INCREMENT for table `leave_requests`
--
ALTER TABLE `leave_requests`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `leave_types`
--
ALTER TABLE `leave_types`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `organizations`
--
ALTER TABLE `organizations`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `shifts`
--
ALTER TABLE `shifts`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `announcements`
--
ALTER TABLE `announcements`
  ADD CONSTRAINT `announcements_ibfk_1` FOREIGN KEY (`org_id`) REFERENCES `organizations` (`id`),
  ADD CONSTRAINT `announcements_ibfk_2` FOREIGN KEY (`created_by`) REFERENCES `users` (`id`);

--
-- Constraints for table `attendance_records`
--
ALTER TABLE `attendance_records`
  ADD CONSTRAINT `attendance_records_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`),
  ADD CONSTRAINT `attendance_records_ibfk_2` FOREIGN KEY (`shift_id`) REFERENCES `shifts` (`id`);

--
-- Constraints for table `audit_log`
--
ALTER TABLE `audit_log`
  ADD CONSTRAINT `audit_log_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE SET NULL;

--
-- Constraints for table `departments`
--
ALTER TABLE `departments`
  ADD CONSTRAINT `departments_ibfk_1` FOREIGN KEY (`org_id`) REFERENCES `organizations` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `holidays`
--
ALTER TABLE `holidays`
  ADD CONSTRAINT `holidays_ibfk_1` FOREIGN KEY (`org_id`) REFERENCES `organizations` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `leave_balances`
--
ALTER TABLE `leave_balances`
  ADD CONSTRAINT `leave_balances_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `leave_balances_ibfk_2` FOREIGN KEY (`leave_type_id`) REFERENCES `leave_types` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `leave_requests`
--
ALTER TABLE `leave_requests`
  ADD CONSTRAINT `leave_requests_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`),
  ADD CONSTRAINT `leave_requests_ibfk_2` FOREIGN KEY (`leave_type_id`) REFERENCES `leave_types` (`id`),
  ADD CONSTRAINT `leave_requests_ibfk_3` FOREIGN KEY (`approved_by`) REFERENCES `users` (`id`);

--
-- Constraints for table `leave_types`
--
ALTER TABLE `leave_types`
  ADD CONSTRAINT `leave_types_ibfk_1` FOREIGN KEY (`org_id`) REFERENCES `organizations` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `shifts`
--
ALTER TABLE `shifts`
  ADD CONSTRAINT `shifts_ibfk_1` FOREIGN KEY (`org_id`) REFERENCES `organizations` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `users`
--
ALTER TABLE `users`
  ADD CONSTRAINT `users_ibfk_1` FOREIGN KEY (`org_id`) REFERENCES `organizations` (`id`),
  ADD CONSTRAINT `users_ibfk_2` FOREIGN KEY (`dept_id`) REFERENCES `departments` (`id`),
  ADD CONSTRAINT `users_ibfk_3` FOREIGN KEY (`shift_id`) REFERENCES `shifts` (`id`),
  ADD CONSTRAINT `users_ibfk_4` FOREIGN KEY (`manager_id`) REFERENCES `users` (`id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
