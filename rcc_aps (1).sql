-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Nov 06, 2026 at 04:37 AM
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
-- Database: `rcc_aps`
--

-- --------------------------------------------------------

--
-- Table structure for table `app_config`
--

CREATE TABLE `app_config` (
  `cfg_key` varchar(60) NOT NULL,
  `cfg_value` varchar(1024) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `app_config`
--

INSERT INTO `app_config` (`cfg_key`, `cfg_value`) VALUES
('bonusExemptionLimit', '90000'),
('dedMeta', '{}'),
('hoursPerWorkload', '3'),
('nextBonusId', '6'),
('nextDedCatId', '2'),
('nextLeaveRecordId', '11'),
('nextLeaveTypeId', '6'),
('nextRankId', '55'),
('nextTeachingLoadClassId', '19'),
('nextTeachingLoadId', '12'),
('nextUserId', '10'),
('savedAt', '2026-11-06T03:24:00.984Z'),
('schemaVersion', '2'),
('stateRevision', '14'),
('workDays', '22');

-- --------------------------------------------------------

--
-- Table structure for table `attendance`
--

CREATE TABLE `attendance` (
  `id` int(11) NOT NULL,
  `empId` int(11) DEFAULT NULL,
  `employeeId` varchar(40) NOT NULL DEFAULT '',
  `employeeEmail` varchar(200) NOT NULL DEFAULT '',
  `date` date DEFAULT NULL,
  `clockInAt` varchar(40) NOT NULL DEFAULT '',
  `clockOutAt` varchar(40) NOT NULL DEFAULT '',
  `hours` decimal(6,2) NOT NULL DEFAULT 0.00
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `attendance`
--

INSERT INTO `attendance` (`id`, `empId`, `employeeId`, `employeeEmail`, `date`, `clockInAt`, `clockOutAt`, `hours`) VALUES
(4649, 1, 'EMP-001', 'admin@rcc.edu.ph', '2026-09-01', '2026-08-31T23:45:00.000Z', '2026-09-01T08:00:00.000Z', 8.25),
(4650, 1, 'EMP-001', 'admin@rcc.edu.ph', '2026-09-02', '2026-09-01T23:51:00.000Z', '2026-09-02T08:11:00.000Z', 8.33),
(4651, 1, 'EMP-001', 'admin@rcc.edu.ph', '2026-09-03', '2026-09-02T23:57:00.000Z', '2026-09-03T08:22:00.000Z', 8.42),
(4652, 1, 'EMP-001', 'admin@rcc.edu.ph', '2026-09-04', '2026-09-04T00:03:00.000Z', '2026-09-04T08:33:00.000Z', 8.50),
(4653, 1, 'EMP-001', 'admin@rcc.edu.ph', '2026-09-09', '2026-09-09T00:09:00.000Z', '2026-09-09T08:44:00.000Z', 8.58),
(4654, 1, 'EMP-001', 'admin@rcc.edu.ph', '2026-09-10', '2026-09-10T00:15:00.000Z', '2026-09-10T04:00:00.000Z', 3.75),
(4655, 1, 'EMP-001', 'admin@rcc.edu.ph', '2026-09-11', '2026-09-10T23:46:00.000Z', '2026-09-11T08:11:00.000Z', 8.42),
(4656, 1, 'EMP-001', 'admin@rcc.edu.ph', '2026-09-14', '2026-09-13T23:52:00.000Z', '2026-09-14T08:22:00.000Z', 8.50),
(4657, 1, 'EMP-001', 'admin@rcc.edu.ph', '2026-09-15', '2026-09-14T23:58:00.000Z', '2026-09-15T08:33:00.000Z', 8.58),
(4658, 1, 'EMP-001', 'admin@rcc.edu.ph', '2026-09-16', '2026-09-16T00:04:00.000Z', '2026-09-16T08:44:00.000Z', 8.67),
(4659, 1, 'EMP-001', 'admin@rcc.edu.ph', '2026-09-17', '2026-09-17T00:10:00.000Z', '2026-09-17T08:00:00.000Z', 7.83),
(4660, 1, 'EMP-001', 'admin@rcc.edu.ph', '2026-09-18', '2026-09-18T00:16:00.000Z', '2026-09-18T08:11:00.000Z', 7.92),
(4661, 1, 'EMP-001', 'admin@rcc.edu.ph', '2026-09-21', '2026-09-20T23:47:00.000Z', '2026-09-21T08:22:00.000Z', 8.58),
(4662, 1, 'EMP-001', 'admin@rcc.edu.ph', '2026-09-23', '2026-09-22T23:53:00.000Z', '2026-09-23T08:33:00.000Z', 8.67),
(4663, 1, 'EMP-001', 'admin@rcc.edu.ph', '2026-09-24', '2026-09-23T23:59:00.000Z', '2026-09-24T08:44:00.000Z', 8.75),
(4664, 1, 'EMP-001', 'admin@rcc.edu.ph', '2026-09-25', '2026-09-25T00:05:00.000Z', '2026-09-25T08:00:00.000Z', 7.92),
(4665, 1, 'EMP-001', 'admin@rcc.edu.ph', '2026-09-28', '2026-09-28T00:11:00.000Z', '2026-09-28T08:11:00.000Z', 8.00),
(4666, 1, 'EMP-001', 'admin@rcc.edu.ph', '2026-09-30', '2026-09-30T00:17:00.000Z', '2026-09-30T08:22:00.000Z', 8.08),
(4667, 2, 'EMP-002', 'finance@rcc.edu.ph', '2026-09-01', '2026-08-31T23:50:00.000Z', '2026-09-01T08:15:00.000Z', 8.42),
(4668, 2, 'EMP-002', 'finance@rcc.edu.ph', '2026-09-02', '2026-09-01T23:59:00.000Z', '2026-09-02T08:28:00.000Z', 8.48),
(4669, 2, 'EMP-002', 'finance@rcc.edu.ph', '2026-09-03', '2026-09-03T00:08:00.000Z', '2026-09-03T08:41:00.000Z', 8.55),
(4670, 2, 'EMP-002', 'finance@rcc.edu.ph', '2026-09-07', '2026-09-07T00:15:00.000Z', '2026-09-07T08:54:00.000Z', 8.65),
(4671, 2, 'EMP-002', 'finance@rcc.edu.ph', '2026-09-08', '2026-09-07T23:56:00.000Z', '2026-09-08T08:22:00.000Z', 8.43),
(4672, 2, 'EMP-002', 'finance@rcc.edu.ph', '2026-09-09', '2026-09-09T00:05:00.000Z', '2026-09-09T08:35:00.000Z', 8.50),
(4673, 2, 'EMP-002', 'finance@rcc.edu.ph', '2026-09-11', '2026-09-11T00:14:00.000Z', '2026-09-11T08:48:00.000Z', 8.57),
(4674, 2, 'EMP-002', 'finance@rcc.edu.ph', '2026-09-14', '2026-09-13T23:53:00.000Z', '2026-09-14T08:16:00.000Z', 8.38),
(4675, 2, 'EMP-002', 'finance@rcc.edu.ph', '2026-09-15', '2026-09-15T00:02:00.000Z', '2026-09-15T08:29:00.000Z', 8.45),
(4676, 2, 'EMP-002', 'finance@rcc.edu.ph', '2026-09-16', '2026-09-16T00:11:00.000Z', '2026-09-16T07:00:00.000Z', 6.82),
(4677, 2, 'EMP-002', 'finance@rcc.edu.ph', '2026-09-17', '2026-09-16T23:50:00.000Z', '2026-09-17T08:55:00.000Z', 9.08),
(4678, 2, 'EMP-002', 'finance@rcc.edu.ph', '2026-09-18', '2026-09-17T23:59:00.000Z', '2026-09-18T08:23:00.000Z', 8.40),
(4679, 2, 'EMP-002', 'finance@rcc.edu.ph', '2026-09-21', '2026-09-21T00:08:00.000Z', '2026-09-21T08:36:00.000Z', 8.47),
(4680, 2, 'EMP-002', 'finance@rcc.edu.ph', '2026-09-22', '2026-09-22T00:17:00.000Z', '2026-09-22T08:49:00.000Z', 8.53),
(4681, 2, 'EMP-002', 'finance@rcc.edu.ph', '2026-09-23', '2026-09-23T00:15:00.000Z', '2026-09-23T08:17:00.000Z', 8.03),
(4682, 2, 'EMP-002', 'finance@rcc.edu.ph', '2026-09-24', '2026-09-24T00:05:00.000Z', '2026-09-24T08:30:00.000Z', 8.42),
(4683, 2, 'EMP-002', 'finance@rcc.edu.ph', '2026-09-28', '2026-09-28T00:14:00.000Z', '2026-09-28T08:43:00.000Z', 8.48),
(4684, 2, 'EMP-002', 'finance@rcc.edu.ph', '2026-09-29', '2026-09-28T23:53:00.000Z', '2026-09-29T08:56:00.000Z', 9.05),
(4685, 2, 'EMP-002', 'finance@rcc.edu.ph', '2026-09-30', '2026-09-30T00:02:00.000Z', '2026-09-30T08:24:00.000Z', 8.37),
(4686, 3, 'EMP-003', 'employee@rcc.edu.ph', '2026-09-01', '2026-08-31T23:35:00.000Z', '2026-09-01T09:00:00.000Z', 9.42),
(4687, 3, 'EMP-003', 'employee@rcc.edu.ph', '2026-09-02', '2026-09-01T23:50:00.000Z', '2026-09-02T07:00:00.000Z', 7.17),
(4688, 3, 'EMP-003', 'employee@rcc.edu.ph', '2026-09-03', '2026-09-02T23:20:00.000Z', '2026-09-03T08:00:00.000Z', 8.67),
(4689, 3, 'EMP-003', 'employee@rcc.edu.ph', '2026-09-04', '2026-09-03T23:45:00.000Z', '2026-09-04T09:00:00.000Z', 9.25),
(4690, 3, 'EMP-003', 'employee@rcc.edu.ph', '2026-09-08', '2026-09-08T00:00:00.000Z', '2026-09-08T07:00:00.000Z', 7.00),
(4691, 3, 'EMP-003', 'employee@rcc.edu.ph', '2026-09-09', '2026-09-08T23:30:00.000Z', '2026-09-09T10:00:00.000Z', 10.50),
(4692, 3, 'EMP-003', 'employee@rcc.edu.ph', '2026-09-10', '2026-09-09T23:40:00.000Z', '2026-09-10T07:20:00.000Z', 7.67),
(4693, 3, 'EMP-003', 'employee@rcc.edu.ph', '2026-09-11', '2026-09-10T23:55:00.000Z', '2026-09-11T08:40:00.000Z', 8.75),
(4694, 3, 'EMP-003', 'employee@rcc.edu.ph', '2026-09-14', '2026-09-13T23:25:00.000Z', '2026-09-14T07:00:00.000Z', 7.58),
(4695, 3, 'EMP-003', 'employee@rcc.edu.ph', '2026-09-15', '2026-09-14T23:50:00.000Z', '2026-09-15T09:30:00.000Z', 9.67),
(4696, 3, 'EMP-003', 'employee@rcc.edu.ph', '2026-09-17', '2026-09-16T23:35:00.000Z', '2026-09-17T07:40:00.000Z', 8.08),
(4697, 3, 'EMP-003', 'employee@rcc.edu.ph', '2026-09-18', '2026-09-17T23:30:00.000Z', '2026-09-18T08:20:00.000Z', 8.83),
(4698, 3, 'EMP-003', 'employee@rcc.edu.ph', '2026-09-22', '2026-09-21T23:45:00.000Z', '2026-09-22T04:00:00.000Z', 4.25),
(4699, 3, 'EMP-003', 'employee@rcc.edu.ph', '2026-09-23', '2026-09-22T23:20:00.000Z', '2026-09-23T09:20:00.000Z', 10.00),
(4700, 3, 'EMP-003', 'employee@rcc.edu.ph', '2026-09-24', '2026-09-23T23:40:00.000Z', '2026-09-24T07:00:00.000Z', 7.33),
(4701, 3, 'EMP-003', 'employee@rcc.edu.ph', '2026-09-25', '2026-09-24T23:55:00.000Z', '2026-09-25T08:50:00.000Z', 8.92),
(4702, 3, 'EMP-003', 'employee@rcc.edu.ph', '2026-09-28', '2026-09-27T23:30:00.000Z', '2026-09-28T05:10:00.000Z', 5.67),
(4703, 3, 'EMP-003', 'employee@rcc.edu.ph', '2026-09-29', '2026-09-28T23:45:00.000Z', '2026-09-29T08:00:00.000Z', 8.25),
(4704, 3, 'EMP-003', 'employee@rcc.edu.ph', '2026-09-30', '2026-09-30T00:00:00.000Z', '2026-09-30T10:00:00.000Z', 10.00);

-- --------------------------------------------------------

--
-- Table structure for table `auth`
--

CREATE TABLE `auth` (
  `id` int(11) NOT NULL,
  `email` varchar(200) NOT NULL DEFAULT '',
  `pass` varchar(200) NOT NULL DEFAULT '',
  `label` varchar(50) NOT NULL DEFAULT '',
  `icon` varchar(20) NOT NULL DEFAULT '',
  `page` varchar(50) NOT NULL DEFAULT '',
  `role` varchar(20) NOT NULL DEFAULT 'employee',
  `status` varchar(20) NOT NULL DEFAULT 'Active',
  `googleSub` varchar(255) CHARACTER SET ascii COLLATE ascii_bin DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `auth`
--

INSERT INTO `auth` (`id`, `email`, `pass`, `label`, `icon`, `page`, `role`, `status`, `googleSub`) VALUES
(1, 'admin@rcc.edu.ph', '$2b$10$vbtDHWCRDF/2MtoMnqbPl.RJFZ6tO9XFyVCT/N6zn9QRhglruqC4y', 'System Admin', '🔧', 'adminPage', 'admin', 'Active', NULL),
(2, 'finance@rcc.edu.ph', '$2b$10$o7UDi2Qsh6jAonaxf2zxluCJdr9iNHA7UkP.KXHZZRAi7IUvilHcm', 'Finance Officer', '💼', 'financePage', 'finance', 'Active', NULL),
(3, 'employee@rcc.edu.ph', '$2b$10$1lu9YSG60G7U6/ckDNXm7ugsa5Z7x0ezlZdXsieAW0Efglr2MymxC', 'Employee', '👤', 'empPage', 'employee', 'Active', NULL),
(4, 'jums@rcc.edu.ph', '$2b$10$a/5f9wcWV/hyxavcnpMPze8cGoWUgybgy.8U52xX1BKguY0O0OfNK', 'Employee', '👤', 'empPage', 'employee', 'Active', NULL),
(5, 'elem.teacher@rcc.edu.ph', '$2b$10$BsTiLruSHrZs0YC18Pm8gugASypGhpoiQ2qOIe9wAg9WjZenVulcO', 'Employee', '👤', 'empPage', 'employee', 'Active', NULL),
(6, 'hs.teacher@rcc.edu.ph', '$2b$10$kIETWZfkk0HzPwn9IY//L.MbrQs4mi2WIloyUG6L4jGAKFNyFP6xu', 'Employee', '👤', 'empPage', 'employee', 'Active', NULL),
(7, 'grad.teacher@rcc.edu.ph', '$2b$10$u0ozhtyBhmIZConRY3wGfuxc5aQlON8TdbPlX4biFrVbH5x2zSQEa', 'Employee', '👤', 'empPage', 'employee', 'Active', NULL),
(8, 'college.teacher@rcc.edu.ph', '$2b$10$R.QmXCsxbsBPKbZJ/vLd0Otke0yOD43GahfRX8uZ04T/Oh8NQafP.', 'Employee', '👤', 'empPage', 'employee', 'Active', NULL),
(9, 'dual.teacher@rcc.edu.ph', '$2b$10$nmSQiiNkyTEexsCOYOrkzOkINj9dK7Owh5.g1aTUqBlAAVWZsbf.u', 'Employee', '👤', 'empPage', 'employee', 'Active', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `bir_table`
--

CREATE TABLE `bir_table` (
  `id` int(11) NOT NULL,
  `range` varchar(80) NOT NULL DEFAULT '',
  `base` decimal(12,2) NOT NULL DEFAULT 0.00,
  `rate` decimal(6,2) NOT NULL DEFAULT 0.00,
  `min` decimal(12,2) DEFAULT NULL,
  `max` decimal(12,2) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `bir_table`
--

INSERT INTO `bir_table` (`id`, `range`, `base`, `rate`, `min`, `max`) VALUES
(499, '0 - 250,000', 0.00, 0.00, 0.00, 250000.00),
(500, '250,000 - 400,000', 0.00, 15.00, 250000.00, 400000.00),
(501, '400,000 - 800,000', 22500.00, 20.00, 400000.00, 800000.00),
(502, '800,000 - 2,000,000', 102500.00, 25.00, 800000.00, 2000000.00),
(503, '2,000,000 - 8,000,000', 402500.00, 30.00, 2000000.00, 8000000.00),
(504, '8,000,000+', 2202500.00, 35.00, 8000000.00, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `bonus_payouts`
--

CREATE TABLE `bonus_payouts` (
  `empId` int(11) NOT NULL,
  `year` int(11) NOT NULL DEFAULT 0,
  `date` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `bonus_types`
--

CREATE TABLE `bonus_types` (
  `id` int(11) NOT NULL,
  `name` varchar(120) NOT NULL DEFAULT '',
  `kind` varchar(30) NOT NULL DEFAULT '',
  `value` decimal(10,2) NOT NULL DEFAULT 0.00,
  `desc` varchar(255) NOT NULL DEFAULT '',
  `status` varchar(20) NOT NULL DEFAULT 'Active',
  `releaseDate` date DEFAULT NULL,
  `endDate` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `bonus_types`
--

INSERT INTO `bonus_types` (`id`, `name`, `kind`, `value`, `desc`, `status`, `releaseDate`, `endDate`) VALUES
(4, '13th Month Pay', 'months', 1.00, '', 'Active', NULL, NULL),
(5, 'sample bonus', 'fixed', 15006.00, '', 'Inactive', NULL, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `cash_advances`
--

CREATE TABLE `cash_advances` (
  `id` int(11) NOT NULL,
  `amount` decimal(12,2) NOT NULL DEFAULT 0.00
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `deduction_categories`
--

CREATE TABLE `deduction_categories` (
  `id` int(11) NOT NULL,
  `name` varchar(120) NOT NULL DEFAULT '',
  `type` varchar(30) NOT NULL DEFAULT '',
  `amount` decimal(12,2) NOT NULL DEFAULT 0.00,
  `desc` varchar(255) NOT NULL DEFAULT '',
  `status` varchar(20) NOT NULL DEFAULT 'Active'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `deduction_categories`
--

INSERT INTO `deduction_categories` (`id`, `name`, `type`, `amount`, `desc`, `status`) VALUES
(1, 'PERAA', 'percent', 3.50, 'Private Education Retirement Annuity Association — employee retirement contribution', 'Active');

-- --------------------------------------------------------

--
-- Table structure for table `leave_records`
--

CREATE TABLE `leave_records` (
  `id` int(11) NOT NULL,
  `empId` int(11) NOT NULL,
  `typeId` int(11) NOT NULL,
  `startDate` date DEFAULT NULL,
  `endDate` date DEFAULT NULL,
  `days` decimal(6,2) NOT NULL DEFAULT 0.00
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `leave_records`
--

INSERT INTO `leave_records` (`id`, `empId`, `typeId`, `startDate`, `endDate`, `days`) VALUES
(6, 1, 3, '2026-09-07', '2026-09-08', 2.00),
(7, 1, 1, '2026-09-22', '2026-09-22', 1.00),
(8, 2, 1, '2026-09-10', '2026-09-10', 1.00),
(9, 2, 2, '2026-09-25', '2026-09-25', 1.00),
(10, 3, 1, '2026-09-16', '2026-09-16', 1.00);

-- --------------------------------------------------------

--
-- Table structure for table `leave_types`
--

CREATE TABLE `leave_types` (
  `id` int(11) NOT NULL,
  `name` varchar(80) NOT NULL DEFAULT '',
  `isPaid` tinyint(1) NOT NULL DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `leave_types`
--

INSERT INTO `leave_types` (`id`, `name`, `isPaid`) VALUES
(1, 'Sick Leave', 1),
(2, 'Personal Leave', 0),
(3, 'Vacation Leave', 0),
(4, 'Maternity Leave', 1),
(5, 'Paternity Leave', 1);

-- --------------------------------------------------------

--
-- Table structure for table `pag_data`
--

CREATE TABLE `pag_data` (
  `id` int(11) NOT NULL DEFAULT 1,
  `rate1` decimal(6,2) NOT NULL DEFAULT 1.00,
  `rate2` decimal(6,2) NOT NULL DEFAULT 2.00,
  `empMax` decimal(12,2) NOT NULL DEFAULT 100.00,
  `erMax` decimal(12,2) NOT NULL DEFAULT 100.00
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `pag_data`
--

INSERT INTO `pag_data` (`id`, `rate1`, `rate2`, `empMax`, `erMax`) VALUES
(1, 1.00, 2.00, 100.00, 100.00);

-- --------------------------------------------------------

--
-- Table structure for table `payroll_records`
--

CREATE TABLE `payroll_records` (
  `id` int(11) NOT NULL,
  `empId` int(11) NOT NULL,
  `name` varchar(150) NOT NULL DEFAULT '',
  `month` int(11) NOT NULL DEFAULT 0,
  `monthName` varchar(20) NOT NULL DEFAULT '',
  `year` int(11) NOT NULL DEFAULT 0,
  `period` varchar(50) NOT NULL DEFAULT '',
  `gross` decimal(12,2) NOT NULL DEFAULT 0.00,
  `deMinimisSum` decimal(12,2) NOT NULL DEFAULT 0.00,
  `thirteenth` decimal(12,2) NOT NULL DEFAULT 0.00,
  `thirteenTaxable` decimal(12,2) NOT NULL DEFAULT 0.00,
  `thirteenExempt` decimal(12,2) NOT NULL DEFAULT 0.00,
  `thirteenTax` decimal(12,2) NOT NULL DEFAULT 0.00,
  `net` decimal(12,2) NOT NULL DEFAULT 0.00,
  `sss` decimal(12,2) NOT NULL DEFAULT 0.00,
  `phil` decimal(12,2) NOT NULL DEFAULT 0.00,
  `pag` decimal(12,2) NOT NULL DEFAULT 0.00,
  `bir` decimal(12,2) NOT NULL DEFAULT 0.00,
  `cash` decimal(12,2) NOT NULL DEFAULT 0.00,
  `bonuses` mediumtext NOT NULL,
  `date` date DEFAULT NULL,
  `subjectBreakdown` text DEFAULT NULL,
  `payNote` varchar(500) DEFAULT '',
  `customDeds` text DEFAULT NULL,
  `salaryBase` decimal(12,2) DEFAULT NULL,
  `absenceWorkDays` decimal(6,2) DEFAULT NULL,
  `absenceDays` decimal(6,2) DEFAULT NULL,
  `teachingSemester` varchar(20) DEFAULT NULL,
  `teachingSchoolYear` varchar(30) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `payroll_records`
--

INSERT INTO `payroll_records` (`id`, `empId`, `name`, `month`, `monthName`, `year`, `period`, `gross`, `deMinimisSum`, `thirteenth`, `thirteenTaxable`, `thirteenExempt`, `thirteenTax`, `net`, `sss`, `phil`, `pag`, `bir`, `cash`, `bonuses`, `date`, `subjectBreakdown`, `payNote`, `customDeds`, `salaryBase`, `absenceWorkDays`, `absenceDays`, `teachingSemester`, `teachingSchoolYear`) VALUES
(188, 2, 'John Cabigting', 9, 'September', 2026, 'September 2026', 34545.45, 0.00, 0.00, 0.00, 0.00, 0.00, 30203.29, 1725.00, 863.64, 100.00, 1653.52, 0.00, '[]', '2026-09-10', '[]', '', '[]', NULL, NULL, NULL, NULL, NULL),
(189, 3, 'Jhon Gerald Batuaan', 9, 'September', 2026, 'September 2026', 26791.90, 0.00, 0.00, 0.00, 0.00, 0.00, 24096.29, 1350.00, 669.80, 100.00, 575.81, 0.00, '[]', '2026-09-10', '[]', '', '[]', NULL, NULL, NULL, NULL, NULL),
(190, 8, 'Paolo Mendoza', 9, 'September', 2026, 'September 2026', 13860.00, 0.00, 0.00, 0.00, 0.00, 0.00, 12713.50, 700.00, 346.50, 100.00, 0.00, 0.00, '[]', '2026-10-21', '[{\"type\":\"subject\",\"subject\":\"Data Structures\",\"days\":\"M, W, F\",\"level\":\"College\",\"deptCode\":\"CS\",\"qty\":39,\"rate\":210,\"amount\":8190},{\"type\":\"subject\",\"subject\":\"Web Systems\",\"days\":\"T, Th\",\"level\":\"College\",\"deptCode\":\"CS\",\"qty\":27,\"rate\":210,\"amount\":5670}]', '', '[]', NULL, NULL, NULL, NULL, NULL),
(191, 6, 'Mark Anthony Reyes', 9, 'September', 2026, 'September 2026', 6056.67, 0.00, 0.00, 0.00, 0.00, 0.00, 5194.69, 300.00, 250.00, 100.00, 0.00, 0.00, '[]', '2026-11-06', '[{\"type\":\"subject\",\"subject\":\"Science 8\",\"days\":\"M, W, F\",\"level\":\"High School\",\"deptCode\":\"G8\",\"qty\":17.3333333333333,\"rate\":230,\"amount\":3986.67},{\"type\":\"subject\",\"subject\":\"MAPEH 8\",\"days\":\"T, Th\",\"level\":\"High School\",\"deptCode\":\"G8\",\"qty\":9,\"rate\":230,\"amount\":2070}]', '', '[{\"id\":1,\"name\":\"PERAA\",\"amount\":211.98}]', 230.00, NULL, NULL, '1st', '2026-2027'),
(192, 5, 'Rosario Dela Cruz', 9, 'September', 2026, 'September 2026', 10125.00, 0.00, 0.00, 0.00, 0.00, 0.00, 8917.49, 500.00, 253.13, 100.00, 0.00, 0.00, '[]', '2026-11-06', '[]', '', '[{\"id\":1,\"name\":\"PERAA\",\"amount\":354.38}]', 10125.00, 22.00, 0.00, NULL, NULL),
(193, 5, 'Rosario Dela Cruz', 10, 'October', 2026, 'October 2026', 10125.00, 0.00, 0.00, 0.00, 0.00, 0.00, 8917.49, 500.00, 253.13, 100.00, 0.00, 0.00, '[]', '2026-11-06', '[]', '', '[{\"id\":1,\"name\":\"PERAA\",\"amount\":354.38}]', 10125.00, 22.00, 0.00, NULL, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `phil_data`
--

CREATE TABLE `phil_data` (
  `id` int(11) NOT NULL DEFAULT 1,
  `rate` decimal(6,2) NOT NULL DEFAULT 5.00,
  `min` decimal(12,2) NOT NULL DEFAULT 500.00,
  `max` decimal(12,2) NOT NULL DEFAULT 5000.00,
  `floor` decimal(12,2) NOT NULL DEFAULT 10000.00,
  `ceiling` decimal(12,2) NOT NULL DEFAULT 100000.00
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `phil_data`
--

INSERT INTO `phil_data` (`id`, `rate`, `min`, `max`, `floor`, `ceiling`) VALUES
(1, 5.00, 500.00, 5000.00, 10000.00, 100000.00);

-- --------------------------------------------------------

--
-- Table structure for table `profiles`
--

CREATE TABLE `profiles` (
  `id` int(11) NOT NULL,
  `empPhone` varchar(40) NOT NULL DEFAULT '',
  `empAddr` varchar(255) NOT NULL DEFAULT '',
  `photo` mediumtext DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `profiles`
--

INSERT INTO `profiles` (`id`, `empPhone`, `empAddr`, `photo`) VALUES
(1, '', '', 'data:image/jpeg;base64,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'),
(2, '', '', 'data:image/jpeg;base64,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'),
(8, '', '', 'data:image/jpeg;base64,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');

-- --------------------------------------------------------

--
-- Table structure for table `sss_table`
--

CREATE TABLE `sss_table` (
  `id` int(11) NOT NULL,
  `range` varchar(80) NOT NULL DEFAULT '',
  `emp` decimal(10,2) NOT NULL DEFAULT 0.00,
  `er` decimal(10,2) NOT NULL DEFAULT 0.00,
  `min` decimal(12,2) DEFAULT NULL,
  `max` decimal(12,2) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `sss_table`
--

INSERT INTO `sss_table` (`id`, `range`, `emp`, `er`, `min`, `max`) VALUES
(5064, '1.00 - 5,249.99', 250.00, 500.00, 1.00, 5250.00),
(5065, '5,250.00 - 5,749.99', 275.00, 550.00, 5250.00, 5750.00),
(5066, '5,750.00 - 6,249.99', 300.00, 600.00, 5750.00, 6250.00),
(5067, '6,250.00 - 6,749.99', 325.00, 650.00, 6250.00, 6750.00),
(5068, '6,750.00 - 7,249.99', 350.00, 700.00, 6750.00, 7250.00),
(5069, '7,250.00 - 7,749.99', 375.00, 750.00, 7250.00, 7750.00),
(5070, '7,750.00 - 8,249.99', 400.00, 800.00, 7750.00, 8250.00),
(5071, '8,250.00 - 8,749.99', 425.00, 850.00, 8250.00, 8750.00),
(5072, '8,750.00 - 9,249.99', 450.00, 900.00, 8750.00, 9250.00),
(5073, '9,250.00 - 9,749.99', 475.00, 950.00, 9250.00, 9750.00),
(5074, '9,750.00 - 10,249.99', 500.00, 1000.00, 9750.00, 10250.00),
(5075, '10,250.00 - 10,749.99', 525.00, 1050.00, 10250.00, 10750.00),
(5076, '10,750.00 - 11,249.99', 550.00, 1100.00, 10750.00, 11250.00),
(5077, '11,250.00 - 11,749.99', 575.00, 1150.00, 11250.00, 11750.00),
(5078, '11,750.00 - 12,249.99', 600.00, 1200.00, 11750.00, 12250.00),
(5079, '12,250.00 - 12,749.99', 625.00, 1250.00, 12250.00, 12750.00),
(5080, '12,750.00 - 13,249.99', 650.00, 1300.00, 12750.00, 13250.00),
(5081, '13,250.00 - 13,749.99', 675.00, 1350.00, 13250.00, 13750.00),
(5082, '13,750.00 - 14,249.99', 700.00, 1400.00, 13750.00, 14250.00),
(5083, '14,250.00 - 14,749.99', 725.00, 1450.00, 14250.00, 14750.00),
(5084, '14,750.00 - 15,249.99', 750.00, 1500.00, 14750.00, 15250.00),
(5085, '15,250.00 - 15,749.99', 775.00, 1550.00, 15250.00, 15750.00),
(5086, '15,750.00 - 16,249.99', 800.00, 1600.00, 15750.00, 16250.00),
(5087, '16,250.00 - 16,749.99', 825.00, 1650.00, 16250.00, 16750.00),
(5088, '16,750.00 - 17,249.99', 850.00, 1700.00, 16750.00, 17250.00),
(5089, '17,250.00 - 17,749.99', 875.00, 1750.00, 17250.00, 17750.00),
(5090, '17,750.00 - 18,249.99', 900.00, 1800.00, 17750.00, 18250.00),
(5091, '18,250.00 - 18,749.99', 925.00, 1850.00, 18250.00, 18750.00),
(5092, '18,750.00 - 19,249.99', 950.00, 1900.00, 18750.00, 19250.00),
(5093, '19,250.00 - 19,749.99', 975.00, 1950.00, 19250.00, 19750.00),
(5094, '19,750.00 - 20,249.99', 1000.00, 2000.00, 19750.00, 20250.00),
(5095, '20,250.00 - 20,749.99', 1025.00, 2050.00, 20250.00, 20750.00),
(5096, '20,750.00 - 21,249.99', 1050.00, 2100.00, 20750.00, 21250.00),
(5097, '21,250.00 - 21,749.99', 1075.00, 2150.00, 21250.00, 21750.00),
(5098, '21,750.00 - 22,249.99', 1100.00, 2200.00, 21750.00, 22250.00),
(5099, '22,250.00 - 22,749.99', 1125.00, 2250.00, 22250.00, 22750.00),
(5100, '22,750.00 - 23,249.99', 1150.00, 2300.00, 22750.00, 23250.00),
(5101, '23,250.00 - 23,749.99', 1175.00, 2350.00, 23250.00, 23750.00),
(5102, '23,750.00 - 24,249.99', 1200.00, 2400.00, 23750.00, 24250.00),
(5103, '24,250.00 - 24,749.99', 1225.00, 2450.00, 24250.00, 24750.00),
(5104, '24,750.00 - 25,249.99', 1250.00, 2500.00, 24750.00, 25250.00),
(5105, '25,250.00 - 25,749.99', 1275.00, 2550.00, 25250.00, 25750.00),
(5106, '25,750.00 - 26,249.99', 1300.00, 2600.00, 25750.00, 26250.00),
(5107, '26,250.00 - 26,749.99', 1325.00, 2650.00, 26250.00, 26750.00),
(5108, '26,750.00 - 27,249.99', 1350.00, 2700.00, 26750.00, 27250.00),
(5109, '27,250.00 - 27,749.99', 1375.00, 2750.00, 27250.00, 27750.00),
(5110, '27,750.00 - 28,249.99', 1400.00, 2800.00, 27750.00, 28250.00),
(5111, '28,250.00 - 28,749.99', 1425.00, 2850.00, 28250.00, 28750.00),
(5112, '28,750.00 - 29,249.99', 1450.00, 2900.00, 28750.00, 29250.00),
(5113, '29,250.00 - 29,749.99', 1475.00, 2950.00, 29250.00, 29750.00),
(5114, '29,750.00 - 30,249.99', 1500.00, 3000.00, 29750.00, 30250.00),
(5115, '30,250.00 - 30,749.99', 1525.00, 3050.00, 30250.00, 30750.00),
(5116, '30,750.00 - 31,249.99', 1550.00, 3100.00, 30750.00, 31250.00),
(5117, '31,250.00 - 31,749.99', 1575.00, 3150.00, 31250.00, 31750.00),
(5118, '31,750.00 - 32,249.99', 1600.00, 3200.00, 31750.00, 32250.00),
(5119, '32,250.00 - 32,749.99', 1625.00, 3250.00, 32250.00, 32750.00),
(5120, '32,750.00 - 33,249.99', 1650.00, 3300.00, 32750.00, 33250.00),
(5121, '33,250.00 - 33,749.99', 1675.00, 3350.00, 33250.00, 33750.00),
(5122, '33,750.00 - 34,249.99', 1700.00, 3400.00, 33750.00, 34250.00),
(5123, '34,250.00 - 34,749.99', 1725.00, 3450.00, 34250.00, 34750.00),
(5124, '34,750.00+', 1750.00, 3500.00, 34750.00, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `teacher_ranks`
--

CREATE TABLE `teacher_ranks` (
  `id` int(11) NOT NULL,
  `department` varchar(20) NOT NULL DEFAULT 'College',
  `rank` varchar(120) NOT NULL DEFAULT '',
  `rate` decimal(10,2) NOT NULL DEFAULT 0.00
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `teacher_ranks`
--

INSERT INTO `teacher_ranks` (`id`, `department`, `rank`, `rate`) VALUES
(1, 'College', 'Assistant Instructor 1', 150.00),
(2, 'College', 'Assistant Instructor 2', 170.00),
(3, 'College', 'Instructor 1', 190.00),
(4, 'College', 'Instructor 2', 210.00),
(5, 'College', 'Instructor 3', 230.00),
(6, 'College', 'Instructor 4', 250.00),
(7, 'College', 'Assistant Professor 1', 270.00),
(8, 'College', 'Assistant Professor 2', 290.00),
(9, 'College', 'Assistant Professor 3', 310.00),
(10, 'College', 'Associate Professor 1', 330.00),
(11, 'College', 'Associate Professor 2', 350.00),
(12, 'College', 'Associate Professor 3', 370.00),
(13, 'College', 'Professor 1', 390.00),
(14, 'College', 'Professor 2', 420.00),
(15, 'College', 'Professor 3', 450.00),
(16, 'Elementary', 'Provisional Teacher 1A (PT-1A)', 130.00),
(17, 'Elementary', 'Provisional Teacher 1B (PT-1B)', 150.00),
(18, 'Elementary', 'Teacher 1A (T-1A)', 170.00),
(19, 'Elementary', 'Teacher 1B (T-1B)', 190.00),
(20, 'Elementary', 'Teacher 2A (T-2A)', 210.00),
(21, 'Elementary', 'Teacher 2B (T-2B)', 230.00),
(22, 'Elementary', 'Teacher 3A (T-3A)', 250.00),
(23, 'Elementary', 'Teacher 3B (T-3B)', 270.00),
(24, 'Elementary', 'Master Teacher 1A (MT-1A)', 300.00),
(25, 'Elementary', 'Master Teacher 1B (MT-1B)', 325.00),
(26, 'Elementary', 'Master Teacher 2A (MT-2A)', 350.00),
(27, 'Elementary', 'Master Teacher 2B (MT-2B)', 380.00),
(28, 'High School', 'Provisional Teacher 1A (PT-1A)', 130.00),
(29, 'High School', 'Provisional Teacher 1B (PT-1B)', 150.00),
(30, 'High School', 'Teacher 1A (T-1A)', 170.00),
(31, 'High School', 'Teacher 1B (T-1B)', 190.00),
(32, 'High School', 'Teacher 2A (T-2A)', 210.00),
(33, 'High School', 'Teacher 2B (T-2B)', 230.00),
(34, 'High School', 'Teacher 3A (T-3A)', 250.00),
(35, 'High School', 'Teacher 3B (T-3B)', 270.00),
(36, 'High School', 'Master Teacher 1A (MT-1A)', 300.00),
(37, 'High School', 'Master Teacher 1B (MT-1B)', 325.00),
(38, 'High School', 'Master Teacher 2A (MT-2A)', 350.00),
(39, 'High School', 'Master Teacher 2B (MT-2B)', 380.00),
(40, 'Graduate School', 'Assistant Instructor 1', 150.00),
(41, 'Graduate School', 'Assistant Instructor 2', 170.00),
(42, 'Graduate School', 'Instructor 1', 190.00),
(43, 'Graduate School', 'Instructor 2', 210.00),
(44, 'Graduate School', 'Instructor 3', 230.00),
(45, 'Graduate School', 'Instructor 4', 250.00),
(46, 'Graduate School', 'Assistant Professor 1', 270.00),
(47, 'Graduate School', 'Assistant Professor 2', 290.00),
(48, 'Graduate School', 'Assistant Professor 3', 310.00),
(49, 'Graduate School', 'Associate Professor 1', 330.00),
(50, 'Graduate School', 'Associate Professor 2', 350.00),
(51, 'Graduate School', 'Associate Professor 3', 370.00),
(52, 'Graduate School', 'Professor 1', 390.00),
(53, 'Graduate School', 'Professor 2', 410.00),
(54, 'Graduate School', 'Professor 3', 430.00);

-- --------------------------------------------------------

--
-- Table structure for table `teaching_load_classes`
--

CREATE TABLE `teaching_load_classes` (
  `id` int(11) NOT NULL,
  `recordId` int(11) NOT NULL,
  `subject` varchar(150) NOT NULL DEFAULT '',
  `deptCode` varchar(30) NOT NULL DEFAULT '',
  `timeStart` varchar(20) NOT NULL DEFAULT '',
  `timeEnd` varchar(20) NOT NULL DEFAULT '',
  `days` varchar(30) NOT NULL DEFAULT '',
  `studentsMale` int(11) NOT NULL DEFAULT 0,
  `studentsFemale` int(11) NOT NULL DEFAULT 0,
  `roomNo` varchar(20) NOT NULL DEFAULT '',
  `googleCode` varchar(60) NOT NULL DEFAULT '',
  `hoursPerWeek` decimal(6,2) NOT NULL DEFAULT 0.00,
  `sortOrder` int(11) NOT NULL DEFAULT 0,
  `level` varchar(30) NOT NULL DEFAULT ''
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `teaching_load_classes`
--

INSERT INTO `teaching_load_classes` (`id`, `recordId`, `subject`, `deptCode`, `timeStart`, `timeEnd`, `days`, `studentsMale`, `studentsFemale`, `roomNo`, `googleCode`, `hoursPerWeek`, `sortOrder`, `level`) VALUES
(6, 7, 'Mathematics 4', 'G4', '7:30 AM', '12:00 PM', 'M, T, W, Th, F', 14, 16, 'Rm 101', '', 22.50, 0, 'Elementary'),
(7, 7, 'Araling Panlipunan 4', 'G4', '1:00 PM', '4:00 PM', 'M, T, W, Th, F', 14, 16, 'Rm 101', '', 15.00, 1, 'Elementary'),
(8, 8, 'Science 8', 'G8', '8:00 AM', '12:00 PM', 'M, W, F', 22, 25, 'Rm 201', '', 12.00, 0, 'High School'),
(9, 8, 'MAPEH 8', 'G8', '1:00 PM', '4:00 PM', 'T, Th', 22, 25, 'Rm 201', '', 6.00, 1, 'High School'),
(10, 9, 'MBA Seminar', 'MBA', '5:00 PM', '8:00 PM', 'M, W', 8, 6, 'Grad Rm A', '', 6.00, 0, 'Graduate School'),
(11, 9, 'Research Methods', 'MBA', '6:00 PM', '9:00 PM', 'T, Th', 8, 6, 'Grad Rm A', '', 6.00, 1, 'Graduate School'),
(12, 10, 'Data Structures', 'CS', '7:00 AM', '10:00 AM', 'M, W, F', 20, 18, 'Lab 2', '', 9.00, 0, 'College'),
(13, 10, 'Web Systems', 'CS', '1:00 PM', '4:00 PM', 'T, Th', 20, 18, 'Lab 2', '', 6.00, 1, 'College'),
(14, 11, 'Artificial Intelligence', 'CS', '7:00 AM', '10:00 AM', 'M, W, F', 18, 15, 'Lab 3', 'ndv', 9.00, 0, 'College'),
(15, 11, 'Information Assurance', 'CS', '1:00 PM', '4:00 PM', 'Th', 18, 15, 'Lab 3', 'fgr', 3.00, 1, 'College'),
(16, 11, 'Graduate Seminar', 'GS', '5:00 PM', '8:00 PM', 'T', 7, 5, 'Grad Rm B', 'dfv', 3.00, 2, 'Graduate School'),
(17, 11, 'Research Methods', 'GS', '6:00 PM', '9:00 PM', 'S', 7, 5, 'Grad Rm B', 'dgfe', 3.00, 3, 'Graduate School'),
(18, 11, 'AP', 'CBA', '6:00 PM', '8:00 PM', 'T, W', 12, 13, '', '', 4.00, 4, 'College');

-- --------------------------------------------------------

--
-- Table structure for table `teaching_load_records`
--

CREATE TABLE `teaching_load_records` (
  `id` int(11) NOT NULL,
  `empId` int(11) NOT NULL,
  `semester` varchar(20) NOT NULL DEFAULT '',
  `schoolYear` varchar(30) NOT NULL DEFAULT '',
  `classification` varchar(30) NOT NULL DEFAULT 'Teaching',
  `level` varchar(30) NOT NULL DEFAULT '',
  `rankId` int(11) NOT NULL DEFAULT 0,
  `rankName` varchar(120) NOT NULL DEFAULT '',
  `rate` decimal(10,2) NOT NULL DEFAULT 0.00,
  `rateUnit` varchar(30) NOT NULL DEFAULT '',
  `salary` decimal(12,2) NOT NULL DEFAULT 0.00,
  `workloadType` varchar(20) NOT NULL DEFAULT 'hours',
  `workloadValue` decimal(6,2) NOT NULL DEFAULT 0.00,
  `absences` decimal(6,2) NOT NULL DEFAULT 0.00,
  `computedPay` decimal(12,2) NOT NULL DEFAULT 0.00,
  `savedAt` varchar(40) NOT NULL DEFAULT ''
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `teaching_load_records`
--

INSERT INTO `teaching_load_records` (`id`, `empId`, `semester`, `schoolYear`, `classification`, `level`, `rankId`, `rankName`, `rate`, `rateUnit`, `salary`, `workloadType`, `workloadValue`, `absences`, `computedPay`, `savedAt`) VALUES
(7, 5, '1st', '2026-2027', 'Teaching', 'Elementary', 23, 'Teacher 3B (T-3B)', 270.00, 'per Month', 10125.00, 'absences', 0.00, 1.00, 9664.77, '2026-10-20T13:57:45.156Z'),
(8, 6, '1st', '2026-2027', 'Teaching', 'High School', 33, 'Teacher 2B (T-2B)', 230.00, 'per Workload', 20000.00, 'hours', 18.00, 0.00, 6072.00, '2026-10-22T05:46:35.375Z'),
(9, 7, '1st', '2026-2027', 'Teaching', 'Graduate School', 49, 'Associate Professor 1', 330.00, 'per Hour', 35000.00, 'hours', 12.00, 0.00, 17424.00, '2026-10-20T07:38:48.282Z'),
(10, 8, '1st', '2026-2027', 'Teaching', 'College', 6, 'Instructor 4', 250.00, 'per Hour', 22000.00, 'hours', 15.00, 0.00, 16500.00, '2026-11-03T04:02:55.686Z'),
(11, 9, '1st', '2026-2027', 'Teaching', 'College', 13, 'Professor 1', 390.00, 'per Hour', 37000.00, 'hours', 22.00, 0.00, 37752.00, '2026-10-20T14:04:22.741Z');

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` int(11) NOT NULL,
  `first` varchar(100) NOT NULL DEFAULT '',
  `last` varchar(100) NOT NULL DEFAULT '',
  `email` varchar(200) NOT NULL DEFAULT '',
  `role` varchar(50) NOT NULL DEFAULT 'Employee',
  `status` varchar(20) NOT NULL DEFAULT 'Active',
  `date` date DEFAULT NULL,
  `salary` decimal(12,2) NOT NULL DEFAULT 0.00,
  `classification` varchar(50) NOT NULL DEFAULT 'Non-Teaching',
  `department` varchar(120) NOT NULL DEFAULT '',
  `hireDate` date DEFAULT NULL,
  `hourlyRate` decimal(10,2) NOT NULL DEFAULT 0.00,
  `absenceDays` decimal(6,2) NOT NULL DEFAULT 0.00,
  `hoursWorked` decimal(8,2) NOT NULL DEFAULT 0.00,
  `endDate` date DEFAULT NULL,
  `rankId` int(11) DEFAULT NULL,
  `rankName` varchar(120) NOT NULL DEFAULT '',
  `rateCustom` tinyint(1) NOT NULL DEFAULT 0,
  `schoolLevel` varchar(20) NOT NULL DEFAULT ''
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `first`, `last`, `email`, `role`, `status`, `date`, `salary`, `classification`, `department`, `hireDate`, `hourlyRate`, `absenceDays`, `hoursWorked`, `endDate`, `rankId`, `rankName`, `rateCustom`, `schoolLevel`) VALUES
(1, 'Nash', 'Valencia', 'admin@rcc.edu.ph', 'System Admin', 'Active', '2026-01-10', 45000.00, 'Non-Teaching', 'College of Computer Studies', '2022-01-10', 0.00, 0.00, 0.00, NULL, NULL, '', 1, ''),
(2, 'John', 'Cabigting', 'finance@rcc.edu.ph', 'Finance Officer', 'Active', '2026-01-10', 38000.00, 'Non-Teaching', 'Finance Office', '2023-01-15', 0.00, 0.00, 0.00, NULL, NULL, '', 0, ''),
(3, 'Jhon Gerald', 'Batuaan', 'employee@rcc.edu.ph', 'Employee', 'Active', '2026-01-12', 37800.00, 'Teaching', 'College of Computer Studies', '2024-08-01', 420.00, 0.00, 90.00, NULL, 14, 'Professor 2', 0, 'College'),
(4, 'Jumar', 'Basco', 'jums@rcc.edu.ph', 'Employee', 'Active', '2026-10-18', 31500.00, 'Teaching', 'CESO director / CASED Dean', '2026-10-02', 370.00, 0.00, 90.00, NULL, 12, 'Associate Professor 3', 0, 'College'),
(5, 'Rosario', 'Dela Cruz', 'elem.teacher@rcc.edu.ph', 'Employee', 'Active', '2026-10-20', 10125.00, 'Teaching', 'Elementary Department', '2024-06-03', 270.00, 0.00, 0.00, NULL, 23, 'Teacher 3B (T-3B)', 0, 'Elementary'),
(6, 'Mark Anthony', 'Reyes', 'hs.teacher@rcc.edu.ph', 'Employee', 'Active', '2026-10-20', 20000.00, 'Teaching', 'High School Department', '2025-06-02', 230.00, 0.00, 0.00, NULL, 33, 'Teacher 2B (T-2B)', 0, 'High School'),
(7, 'Sheila', 'Ramos', 'grad.teacher@rcc.edu.ph', 'Employee', 'Active', '2026-10-20', 35000.00, 'Teaching', 'Graduate School Department', '2023-08-14', 330.00, 0.00, 0.00, NULL, 49, 'Associate Professor 1', 0, 'Graduate School'),
(8, 'Paolo', 'Mendoza', 'college.teacher@rcc.edu.ph', 'Employee', 'Active', '2026-10-20', 22000.00, 'Teaching', 'College of Computer Studies', '2025-08-04', 250.00, 0.00, 0.00, NULL, 6, 'Instructor 4', 0, 'College'),
(9, 'Ana Luisa', 'Santos', 'dual.teacher@rcc.edu.ph', 'Employee', 'Active', '2026-10-20', 37000.00, 'Teaching', 'College of Computer Studies', '2022-08-08', 390.00, 0.00, 0.00, NULL, 13, 'Professor 1', 0, 'College');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `app_config`
--
ALTER TABLE `app_config`
  ADD PRIMARY KEY (`cfg_key`);

--
-- Indexes for table `attendance`
--
ALTER TABLE `attendance`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uk_att_emp_date` (`empId`,`date`);

--
-- Indexes for table `auth`
--
ALTER TABLE `auth`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uk_auth_email` (`email`),
  ADD UNIQUE KEY `uk_auth_google_sub` (`googleSub`);

--
-- Indexes for table `bir_table`
--
ALTER TABLE `bir_table`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `bonus_payouts`
--
ALTER TABLE `bonus_payouts`
  ADD PRIMARY KEY (`empId`,`year`);

--
-- Indexes for table `bonus_types`
--
ALTER TABLE `bonus_types`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `cash_advances`
--
ALTER TABLE `cash_advances`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `deduction_categories`
--
ALTER TABLE `deduction_categories`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `leave_records`
--
ALTER TABLE `leave_records`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_leave_records_empId` (`empId`),
  ADD KEY `fk_leave_records_typeId` (`typeId`);

--
-- Indexes for table `leave_types`
--
ALTER TABLE `leave_types`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `pag_data`
--
ALTER TABLE `pag_data`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `payroll_records`
--
ALTER TABLE `payroll_records`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uk_payroll_employee_period` (`empId`,`year`,`month`),
  ADD KEY `idx_payroll_emp` (`empId`),
  ADD KEY `idx_payroll_period` (`year`,`month`);

--
-- Indexes for table `phil_data`
--
ALTER TABLE `phil_data`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `profiles`
--
ALTER TABLE `profiles`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `sss_table`
--
ALTER TABLE `sss_table`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `teacher_ranks`
--
ALTER TABLE `teacher_ranks`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `teaching_load_classes`
--
ALTER TABLE `teaching_load_classes`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_teaching_load_classes_recordId` (`recordId`);

--
-- Indexes for table `teaching_load_records`
--
ALTER TABLE `teaching_load_records`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uk_tload_emp_sem` (`empId`,`semester`,`schoolYear`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uk_users_email` (`email`),
  ADD KEY `fk_users_rankId` (`rankId`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `attendance`
--
ALTER TABLE `attendance`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4705;

--
-- AUTO_INCREMENT for table `bir_table`
--
ALTER TABLE `bir_table`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=505;

--
-- AUTO_INCREMENT for table `leave_records`
--
ALTER TABLE `leave_records`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT for table `payroll_records`
--
ALTER TABLE `payroll_records`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=194;

--
-- AUTO_INCREMENT for table `sss_table`
--
ALTER TABLE `sss_table`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5125;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `attendance`
--
ALTER TABLE `attendance`
  ADD CONSTRAINT `fk_attendance_empId` FOREIGN KEY (`empId`) REFERENCES `users` (`id`);

--
-- Constraints for table `auth`
--
ALTER TABLE `auth`
  ADD CONSTRAINT `fk_auth_id` FOREIGN KEY (`id`) REFERENCES `users` (`id`);

--
-- Constraints for table `bonus_payouts`
--
ALTER TABLE `bonus_payouts`
  ADD CONSTRAINT `fk_bonus_payouts_empId` FOREIGN KEY (`empId`) REFERENCES `users` (`id`);

--
-- Constraints for table `cash_advances`
--
ALTER TABLE `cash_advances`
  ADD CONSTRAINT `fk_cash_advances_id` FOREIGN KEY (`id`) REFERENCES `users` (`id`);

--
-- Constraints for table `leave_records`
--
ALTER TABLE `leave_records`
  ADD CONSTRAINT `fk_leave_records_empId` FOREIGN KEY (`empId`) REFERENCES `users` (`id`),
  ADD CONSTRAINT `fk_leave_records_typeId` FOREIGN KEY (`typeId`) REFERENCES `leave_types` (`id`);

--
-- Constraints for table `payroll_records`
--
ALTER TABLE `payroll_records`
  ADD CONSTRAINT `fk_payroll_records_empId` FOREIGN KEY (`empId`) REFERENCES `users` (`id`);

--
-- Constraints for table `profiles`
--
ALTER TABLE `profiles`
  ADD CONSTRAINT `fk_profiles_id` FOREIGN KEY (`id`) REFERENCES `users` (`id`);

--
-- Constraints for table `teaching_load_classes`
--
ALTER TABLE `teaching_load_classes`
  ADD CONSTRAINT `fk_teaching_load_classes_recordId` FOREIGN KEY (`recordId`) REFERENCES `teaching_load_records` (`id`);

--
-- Constraints for table `teaching_load_records`
--
ALTER TABLE `teaching_load_records`
  ADD CONSTRAINT `fk_teaching_load_records_empId` FOREIGN KEY (`empId`) REFERENCES `users` (`id`);

--
-- Constraints for table `users`
--
ALTER TABLE `users`
  ADD CONSTRAINT `fk_users_rankId` FOREIGN KEY (`rankId`) REFERENCES `teacher_ranks` (`id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
