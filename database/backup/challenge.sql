-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: localhost
-- Generation Time: Jun 06, 2023 at 09:34 PM
-- Server version: 8.0.32
-- PHP Version: 8.0.28

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";
SET FOREIGN_KEY_CHECKS = 0;

DROP TABLE IF EXISTS
  `calculation_types`,
  `carriers`,
  `rates`,
  `surcharge_concept_aliases`,
  `surcharge_concepts`,
  `surcharges`,
  `users`;


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `challenge`
--

-- --------------------------------------------------------

--
-- Table structure for table `calculation_types`
--

CREATE TABLE `calculation_types` (
  `id` bigint UNSIGNED NOT NULL,
  `name` varchar(256) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `calculation_types`
--

INSERT INTO `calculation_types` (`id`, `name`) VALUES
(1, 'Per Container'),
(2, 'Per BL');

-- --------------------------------------------------------

--
-- Table structure for table `carriers`
--

CREATE TABLE `carriers` (
  `id` bigint UNSIGNED NOT NULL,
  `name` varchar(256) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `carriers`
--

INSERT INTO `carriers` (`id`, `name`) VALUES
(1, 'CMA CGM'),
(2, 'MSC'),
(3, 'COSCO'),
(4, 'MAERSK'),
(5, 'EVERGREEN'),
(6, 'HAPAG LLOYD'),
(7, 'ZIM'),
(8, 'YML'),
(9, 'SEALAND');

-- --------------------------------------------------------

--
-- Table structure for table `rates`
--

CREATE TABLE `rates` (
  `id` bigint UNSIGNED NOT NULL,
  `surcharge_id` bigint UNSIGNED NOT NULL,
  `carrier_id` bigint UNSIGNED NOT NULL,
  `amount` float NOT NULL,
  `currency` varchar(256) NOT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Table structure for table `surcharge_concepts`
--

CREATE TABLE `surcharge_concepts` (
  `id` bigint unsigned NOT NULL,
  `name` varchar(256) NOT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `surcharge_concepts`
--
INSERT INTO `surcharge_concepts` (`id`, `name`, `created_at`, `updated_at`) VALUES
(1, 'Winter', '2023-07-17 16:34:36', NULL),
(2, 'Bill of Lading', '2023-07-17 16:34:54', NULL),
(3, 'Documentation', '2023-07-17 16:35:11', NULL),
(4, 'Logistics', '2023-07-17 16:43:13', NULL),
(5, 'Arbitrary', '2023-07-17 16:47:06', NULL),
(6, 'Bunker Adjustment', '2023-07-17 16:50:51', NULL),
(7, 'Basic', '2023-07-17 16:56:13', NULL),
(8, 'Ocean', '2023-07-17 16:57:59', NULL),
(9, 'Booking', '2023-07-17 16:59:59', NULL),
(10, 'Cesion', '2023-07-17 17:01:55', NULL),
(11, 'VGM', '2023-07-17 17:03:21', NULL),
(12, 'Terminal Handling', '2023-07-17 17:13:02', NULL),
(13, 'T3', '2023-07-17 17:17:44', NULL),
(14, 'Peak Season', '2023-07-17 17:22:40', NULL),
(15, 'Port', '2023-07-17 17:26:43', NULL),
(16, 'Overweight', '2023-07-17 17:31:21', NULL),
(17, 'ISPS', '2023-07-17 17:33:46', NULL);


--
-- Table structure for table `surcharge_concept_aliases`
--

CREATE TABLE `surcharge_concept_aliases` (
  `id` bigint unsigned NOT NULL,
  `name` varchar(256) NOT NULL,
  `surcharge_concept_id` bigint UNSIGNED NOT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `surcharge_concepts`
--

INSERT INTO `surcharge_concept_aliases` (`id`, `name`, `surcharge_concept_id`, `created_at`, `updated_at`) VALUES
(1, 'WINTER SURCHARGE', 1, '2023-07-17 16:35:32', '2023-07-17 17:40:13'),
(2, 'WINTER CHARGE', 1, '2023-07-17 16:35:43', '2023-07-17 17:40:13'),
(3, 'BL', 2, '2023-07-17 16:37:27', '2023-07-17 12:40:21'),
(4, 'BL FEE', 2, '2023-07-17 16:37:41', '2023-07-17 17:40:13'),
(5, 'B/L FEE', 2, '2023-07-17 16:37:52', '2023-07-17 17:40:13'),
(6, 'BILL OF LADING (BL)', 2, '2023-07-17 11:44:49', '2023-07-17 17:40:13'),
(7, 'DOC FEE', 3, '2023-07-17 11:44:58', '2023-07-17 17:40:13'),
(8, 'DOC FEES', 3, '2023-07-17 11:45:01', '2023-07-17 17:40:13'),
(9, 'DOCUMENTATION FEE', 3, '2023-07-17 11:45:04', '2023-07-17 17:40:13'),
(10, 'LOG FEE', 4, '2023-07-17 16:44:40', '2023-07-17 12:40:24'),
(11, 'LOGISTICS FEE', 4, '2023-07-17 16:51:29', '2023-07-17 12:40:28'),
(12, 'ARBITRARY CHARGE DESTINATION', 5, '2023-07-17 16:51:29', '2023-07-17 17:40:13'),
(13, 'ARBITRARY CHARGE ORIGIN', 5, '2023-07-17 16:51:29', '2023-07-17 17:40:13'),
(14, 'ARBITRARY CHARGE O', 5, '2023-07-17 16:51:29', '2023-07-17 17:40:13'),
(15, 'ARBITRARY CHARGE D', 5, '2023-07-17 16:51:29', '2023-07-17 17:40:13'),
(16, 'BUNKER ADJUSTMENT FEE', 6, '2023-07-17 16:51:29', '2023-07-17 17:40:13'),
(17, 'BUNKER ADJUSTMENT FACTOR', 6, '2023-07-17 16:51:29', '2023-07-17 17:40:13'),
(18, 'BUNKER ADJUSTMENT CHARGE', 6, '2023-07-17 16:51:29', '2023-07-17 17:40:13'),
(19, 'BUNKER ADJUSTMENT', 6, '2023-07-17 16:53:23', '2023-07-17 17:40:13'),
(20, 'BASIC FREIGHT', 7, '2023-07-17 17:00:40', '2023-07-17 17:40:13'),
(21, 'BASIC OCEAN FREIGHT', 8, '2023-07-17 17:00:40', '2023-07-17 17:40:13'),
(22, 'OCEAN FREIGHT CHARGE', 8, '2023-07-17 17:00:40', '2023-07-17 17:40:13'),
(23, 'OCEAN FREIGHT', 8, '2023-07-17 17:00:40', '2023-07-17 17:40:13'),
(24, 'BOOKING FEE', 9, '2023-07-17 17:00:40', '2023-07-17 17:40:13'),
(25, 'BOOKING SERVICE CHARGE', 9, '2023-07-17 17:00:40', '2023-07-17 17:40:13'),
(26, 'BOOKING CHARGE', 9, '2023-07-17 17:03:32', '2023-07-17 17:40:13'),
(27, 'CESION TRANSPORTE', 10, '2023-07-17 17:03:32', '2023-07-17 17:40:13'),
(28, 'CESION TTE', 10, '2023-07-17 17:03:32', '2023-07-17 17:40:13'),
(29, 'CESION', 10, '2023-07-17 17:03:32', '2023-07-17 17:40:13'),
(30, 'VGM', 11, '2023-07-17 17:03:32', '2023-07-17 12:40:37'),
(31, 'VGM FEE', 11, '2023-07-17 17:14:30', '2023-07-17 17:40:13'),
(32, 'TERMINAL HANDLING', 12, '2023-07-17 17:14:30', '2023-07-17 17:40:13'),
(33, 'TERMINAL HANDLING CHARGE O', 12, '2023-07-17 17:14:30', '2023-07-17 17:40:13'),
(34, 'TERMINAL HANDLING CHARGE', 12, '2023-07-17 17:14:30', '2023-07-17 17:40:13'),
(35, 'TERMINAL HANDLING CHARGE ORIGIN', 12, '2023-07-17 17:14:30', '2023-07-17 17:40:13'),
(36, 'TERMINAL HANDLING CHARGE DESTINATION', 12, '2023-07-17 17:14:30', '2023-07-17 17:40:13'),
(37, 'TERMINAL HANDLING CHARGE (D)', 12, '2023-07-17 17:21:27', '2023-07-17 17:40:13'),
(38, 'T3', 13, '2023-07-17 17:21:27', '2023-07-17 12:40:37'),
(39, 'T-3', 13, '2023-07-17 17:21:27', '2023-07-17 12:40:37'),
(40, 'T3 FEE', 13, '2023-07-17 17:21:27', '2023-07-17 17:40:13'),
(41, 'T3 ORIGIN', 13, '2023-07-17 17:21:27', '2023-07-17 17:40:13'),
(42, 'PEAK SEASON SURCHARGE', 14, '2023-07-17 17:26:24', '2023-07-17 17:40:13'),
(43, 'PSS', 14, '2023-07-17 17:26:24', '2023-07-17 12:40:37'),
(44, 'PEAK SEASON ADJUSTMENT FACTOR', 14, '2023-07-17 17:26:24', '2023-07-17 17:40:13'),
(45, 'PORT CHARGES IMPORT', 15, '2023-07-17 17:33:20', '2023-07-17 17:40:13'),
(46, 'PORT CHARGES EXPORT', 15, '2023-07-17 17:33:20', '2023-07-17 17:40:13'),
(47, 'PORT CHARGES DESTINATION', 15, '2023-07-17 17:33:20', '2023-07-17 17:40:13'),
(48, 'OVERWEIGHT', 16, '2023-07-17 17:33:20', '2023-07-17 17:40:13'),
(49, 'OVERWEIGHT SURCHARGE', 16, '2023-07-17 17:33:20', '2023-07-17 17:40:13'),
(50, 'ISPS', 17, '2023-07-17 17:34:02', '2023-07-17 12:40:37'),
(51, 'PEAK SEASON', 14, '2023-07-17 17:39:08', '2023-07-17 17:40:13');


-- --------------------------------------------------------

--
-- Table structure for table `surcharges`
--

CREATE TABLE `surcharges` (
  `id` bigint UNSIGNED NOT NULL,
  `surcharge_concept_id` bigint UNSIGNED NOT NULL,
  `apply_to` enum('origin','freight','destination','') NOT NULL,
  `calculation_type_id` bigint UNSIGNED NOT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `surcharges`
--

INSERT INTO `surcharges` (`id`, `surcharge_concept_id`, `apply_to`, `calculation_type_id`, `created_at`, `updated_at`) VALUES
(1, 1, 'freight', 1, '2023-06-05 16:30:00', '2023-06-05 16:30:00'),
(2, 2, 'freight', 2, '2023-06-05 16:30:00', '2023-06-05 16:30:00'),
(3, 2, 'origin', 2, '2023-06-05 16:30:00', '2023-06-05 16:30:00'),
(4, 3, 'origin', 2, '2023-06-05 16:30:00', '2023-06-05 16:30:00'),
(5, 4, 'freight', 2, '2023-06-05 16:30:00', '2023-06-05 16:30:00'),
(6, 5, 'destination', 1, '2023-06-05 16:30:00', '2023-06-05 16:30:00'),
(7, 5, 'origin', 1, '2023-06-05 16:30:00', '2023-06-05 16:30:00'),
(8, 6, 'freight', 1, '2023-06-05 16:30:00', '2023-06-05 16:30:00'),
(9, 7, 'freight', 1, '2023-06-05 16:30:00', '2023-06-05 16:30:00'),
(10, 8, 'freight', 1, '2023-06-05 16:30:00', '2023-06-05 16:30:00'),
(11, 9, 'freight', 2, '2023-06-05 16:30:00', '2023-06-05 16:30:00'),
(12, 10, 'destination', 1, '2023-06-05 16:30:00', '2023-06-05 16:30:00'),
(13, 11, 'origin', 1, '2023-06-06 16:01:49', '2023-06-06 16:01:49'),
(14, 11, 'destination', 1, '2023-06-06 16:01:49', '2023-06-06 16:01:49'),
(15, 12, 'origin', 1, '2023-06-05 16:30:00', '2023-06-05 16:30:00'),
(16, 12, 'destination', 1, '2023-06-05 16:30:00', '2023-06-05 16:30:00'),
(17, 13, 'origin', 1, '2023-06-05 16:30:00', '2023-06-05 16:30:00'),
(18, 13, 'destination', 1, '2023-06-05 16:30:00', '2023-06-05 16:30:00'),
(19, 14, 'freight', 1, '2023-06-05 16:30:00', '2023-06-05 16:30:00'),
(20, 15, 'destination', 2, '2023-06-05 16:30:00', '2023-06-05 16:30:00'),
(21, 15, 'origin', 2, '2023-06-05 16:30:00', '2023-06-05 16:30:00'),
(22, 16, 'freight', 1, '2023-06-05 16:30:00', '2023-06-05 16:30:00'),
(23, 17, 'freight', 1, '2023-06-06 16:01:49', '2023-06-06 16:01:49'),
(24, 3, 'destination', 2, '2023-06-06 16:01:49', '2023-06-06 16:01:49');

CREATE TABLE `users` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `email` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `password` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `users_email_unique` (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO `users` (`id`, `name`, `email`, `password`, `created_at`, `updated_at`) VALUES
(1,	'Israel',	'israel.flores@cargofive.com',	'$2y$10$qwYQhqOl0RxzZpMAJ6oDMe.Z.Rq8eT4YZM9actwO.OEBqxSeAPvLa',	'2023-07-17 22:06:05',	'2023-07-17 22:06:05');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `calculation_types`
--
ALTER TABLE `calculation_types`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `carriers`
--
ALTER TABLE `carriers`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `rates`
--
ALTER TABLE `rates`
  ADD PRIMARY KEY (`id`),
  ADD KEY `surcharge_id_index` (`surcharge_id`),
  ADD KEY `carrier_id_index` (`carrier_id`);

--
-- Indexes for table `surcharge_concepts`
--
ALTER TABLE `surcharge_concepts`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `surcharge_concept_aliases`
--
ALTER TABLE `surcharge_concept_aliases`
  ADD PRIMARY KEY (`id`),
  ADD KEY `surcharge_concepts` (`surcharge_concept_id`);

--
-- Indexes for table `surcharges`
--
ALTER TABLE `surcharges`
  ADD PRIMARY KEY (`id`),
  ADD KEY `surcharge_concepts` (`surcharge_concept_id`),
  ADD KEY `calculation_type_id` (`calculation_type_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `calculation_types`
--
ALTER TABLE `calculation_types`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `carriers`
--
ALTER TABLE `carriers`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT for table `rates`
--
ALTER TABLE `rates`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `surcharge_concepts`
--
ALTER TABLE `surcharge_concepts`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=18;

--
-- AUTO_INCREMENT for table `surcharge_concept_aliases`
--
ALTER TABLE `surcharge_concept_aliases`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=52;

--
-- AUTO_INCREMENT for table `surcharges`
--
ALTER TABLE `surcharges`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=24;

--
-- AUTO_INCREMENT for table `surcharges`
--
ALTER TABLE `surcharges`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=53;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `rates`
--
ALTER TABLE `rates`
  ADD CONSTRAINT `rates_ibfk_1` FOREIGN KEY (`carrier_id`) REFERENCES `carriers` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `rates_ibfk_2` FOREIGN KEY (`surcharge_id`) REFERENCES `surcharges` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;

--
-- Constraints for table `surcharges`
--
ALTER TABLE `surcharge_concept_aliases`
  ADD CONSTRAINT `surcharge_concept_aliases_ibfk_1` FOREIGN KEY (`surcharge_concept_id`) REFERENCES `surcharge_concepts` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;
COMMIT;

--
-- Constraints for table `surcharges`
--
ALTER TABLE `surcharges`
  ADD CONSTRAINT `surcharges_ibfk_1` FOREIGN KEY (`surcharge_concept_id`) REFERENCES `surcharge_concepts` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `surcharges_ibfk_2` FOREIGN KEY (`calculation_type_id`) REFERENCES `calculation_types` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;
COMMIT;

SET FOREIGN_KEY_CHECKS = 1;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
