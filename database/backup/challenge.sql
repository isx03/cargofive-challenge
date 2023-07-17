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
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Table structure for table `surcharge_concepts`
--

CREATE TABLE `surcharge_concepts` (
  `id` bigint UNSIGNED NOT NULL,
  `name` varchar(256) NOT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `surcharge_concepts`
--

INSERT INTO `surcharge_concepts` (`id`, `name`) VALUES
(1, 'Winter Surcharge'),
(2, 'Winter Charge'),
(3, 'Bill of Lading Fee'),
(4, 'Documentation Fee'),
(5, 'Logistics Fee'),
(6, 'Arbitrary Charge'),
(7, 'Bunker Adjustment Fee'),
(8, 'Bunker Adjustment Factor'),
(9, 'Bunker Adjustment Charge'),
(10, 'BAF Fee'),
(11, 'Basic Fee'),
(12, 'Basic Ocean Fee'),
(13, 'Ocean Charge'),
(14, 'Ocean Fee'),
(15, 'Booking  Fee'),
(16, 'Booking  Charge'),
(17, 'Cesion transporte Fee'),
(18, 'VGM Fee'),
(19, 'Terminal Handling Fee'),
(20, 'Terminal Fee'),
(21, 'T3 Fee'),
(22, 'Peak Season Surcharge'),
(23, 'Peak Season Factor'),
(24, 'Port Charge Import'),
(25, 'Port Charge Export'),
(26, 'Port Charges'),
(27, 'Overweight Fee'),
(28, 'Overweight surcharge'),
(29, 'ISPS Fee');

-- --------------------------------------------------------

--
-- Table structure for table `surcharges`
--

CREATE TABLE `surcharges` (
  `id` bigint UNSIGNED NOT NULL,
  `surcharge_concept_id` bigint UNSIGNED NOT NULL,
  `apply_to` enum('origin','freight','destination','') NOT NULL,
  `calculation_type_id` bigint UNSIGNED NOT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `surcharges`
--

INSERT INTO `surcharges` (`id`, `name`, `apply_to`, `calculation_type_id`, `created_at`, `updated_at`) VALUES
(1, 'Winter Surcharge', 'freight', 1, '2023-06-05 16:30:00', '2023-06-05 16:30:00'),
(2, 'Winter charge', 'freight', 1, '2023-06-05 16:30:00', '2023-06-05 16:30:00'),
(3, 'BL', 'freight', 2, '2023-06-05 16:30:00', '2023-06-05 16:30:00'),
(4, 'BL Fee', 'freight', 2, '2023-06-05 16:30:00', '2023-06-05 16:30:00'),
(5, 'B/L fee', 'origin', 2, '2023-06-05 16:30:00', '2023-06-05 16:30:00'),
(6, 'Doc fee', 'origin', 2, '2023-06-05 16:30:00', '2023-06-05 16:30:00'),
(7, 'Doc fees', 'origin', 2, '2023-06-05 16:30:00', '2023-06-05 16:30:00'),
(8, 'Documentation Fee', 'origin', 2, '2023-06-05 16:30:00', '2023-06-05 16:30:00'),
(9, 'LOG FEE ', 'freight', 2, '2023-06-05 16:30:00', '2023-06-05 16:30:00'),
(10, 'LOGISTICS FEE ', 'freight', 2, '2023-06-05 16:30:00', '2023-06-05 16:30:00'),
(11, 'Arbitrary Charge Destination', 'destination', 1, '2023-06-05 16:30:00', '2023-06-05 16:30:00'),
(12, 'Arbitrary Charge Origin', 'origin', 1, '2023-06-05 16:30:00', '2023-06-05 16:30:00'),
(13, 'Arbitrary Charge O', 'origin', 1, '2023-06-05 16:30:00', '2023-06-05 16:30:00'),
(14, 'Arbitrary Charge D', 'destination', 1, '2023-06-05 16:30:00', '2023-06-05 16:30:00'),
(15, 'Bunker Adjustment Fee', 'freight', 1, '2023-06-05 16:30:00', '2023-06-05 16:30:00'),
(16, 'Bunker Adjustment Factor', 'freight', 1, '2023-06-05 16:30:00', '2023-06-05 16:30:00'),
(17, 'Bunker Adjustment Charge', 'freight', 1, '2023-06-05 16:30:00', '2023-06-05 16:30:00'),
(18, 'BAF', 'freight', 1, '2023-06-05 16:30:00', '2023-06-05 16:30:00'),
(19, 'Basic Freight', 'freight', 1, '2023-06-05 16:30:00', '2023-06-05 16:30:00'),
(20, 'Basic Ocean Freight', 'freight', 1, '2023-06-05 16:30:00', '2023-06-05 16:30:00'),
(21, 'Ocean Freight Charge', 'freight', 1, '2023-06-05 16:30:00', '2023-06-05 16:30:00'),
(22, 'Ocean Freight', 'freight', 1, '2023-06-05 16:30:00', '2023-06-05 16:30:00'),
(23, 'Bill of Lading (BL)', 'freight', 2, '2023-06-05 16:30:00', '2023-06-05 16:30:00'),
(24, 'Booking fee', 'freight', 2, '2023-06-05 16:30:00', '2023-06-05 16:30:00'),
(25, 'Booking Service Charge', 'freight', 2, '2023-06-05 16:30:00', '2023-06-05 16:30:00'),
(26, 'Booking Charge', 'freight', 2, '2023-06-05 16:30:00', '2023-06-05 16:30:00'),
(27, 'Cesion transporte', 'destination', 1, '2023-06-05 16:30:00', '2023-06-05 16:30:00'),
(28, 'Cesion Tte', 'destination', 1, '2023-06-05 16:30:00', '2023-06-05 16:30:00'),
(29, 'Cesion', 'destination', 1, '2023-06-05 16:30:00', '2023-06-05 16:30:00'),
(30, 'VGM', 'origin', 1, '2023-06-06 16:01:49', '2023-06-06 16:01:49'),
(31, 'VGM Fee', 'destination', 1, '2023-06-06 16:01:49', '2023-06-06 16:01:49'),
(32, 'Terminal Handling', 'origin', 1, '2023-06-05 16:30:00', '2023-06-05 16:30:00'),
(33, 'Terminal Handling charge', 'destination', 1, '2023-06-05 16:30:00', '2023-06-05 16:30:00'),
(34, 'Terminal Handling Charge O', 'origin', 1, '2023-06-05 16:30:00', '2023-06-05 16:30:00'),
(35, 'Terminal Handling Charge Origin', 'origin', 1, '2023-06-05 16:30:00', '2023-06-05 16:30:00'),
(36, 'Terminal Handling Charge Destination', 'destination', 1, '2023-06-05 16:30:00', '2023-06-05 16:30:00'),
(37, 'Terminal Handling Charge (D)', 'destination', 1, '2023-06-05 16:30:00', '2023-06-05 16:30:00'),
(38, 'Terminal fees', 'origin', 1, '2023-06-05 16:30:00', '2023-06-05 16:30:00'),
(39, 'Tasa T3', 'origin', 1, '2023-06-05 16:30:00', '2023-06-05 16:30:00'),
(40, 'T-3', 'origin', 1, '2023-06-05 16:30:00', '2023-06-05 16:30:00'),
(41, 'T3', 'destination', 1, '2023-06-05 16:30:00', '2023-06-05 16:30:00'),
(42, 'T3 fee', 'destination', 1, '2023-06-05 16:30:00', '2023-06-05 16:30:00'),
(43, 'Peak Season Surcharge', 'freight', 1, '2023-06-05 16:30:00', '2023-06-05 16:30:00'),
(44, 'PSS', 'freight', 1, '2023-06-05 16:30:00', '2023-06-05 16:30:00'),
(45, 'Peak Season Adjustment Factor ', 'freight', 1, '2023-06-05 16:30:00', '2023-06-05 16:30:00'),
(46, 'Port Charges Import', 'destination', 2, '2023-06-05 16:30:00', '2023-06-05 16:30:00'),
(47, 'Port Charges Export', 'origin', 2, '2023-06-05 16:30:00', '2023-06-05 16:30:00'),
(48, 'Port Charges Destination', 'destination', 2, '2023-06-05 16:30:00', '2023-06-05 16:30:00'),
(49, 'Overweight', 'freight', 1, '2023-06-05 16:30:00', '2023-06-05 16:30:00'),
(50, 'Overweight surcharge', 'freight', 1, '2023-06-05 16:30:00', '2023-06-05 16:30:00'),
(51, 'ISPS', 'freight', 1, '2023-06-06 16:01:49', '2023-06-06 16:01:49'),
(52, 'ISPS', 'freight', 1, '2023-06-06 16:01:49', '2023-06-06 16:01:49');

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
-- Indexes for table `surcharges`
--
ALTER TABLE `surcharges`
  ADD PRIMARY KEY (`id`),
  ADD KEY `calculation_type_id` (`calculation_type_id`);

--
-- Indexes for table `surcharge_concepts`
--
ALTER TABLE `surcharge_concepts`
  ADD PRIMARY KEY (`id`);

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
-- AUTO_INCREMENT for table `surcharges`
--
ALTER TABLE `surcharges`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=53;

--
-- AUTO_INCREMENT for table `surcharge_concepts`
--
ALTER TABLE `surcharge_concepts`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=30;

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
ALTER TABLE `surcharges`
  ADD CONSTRAINT `surcharges_ibfk_1` FOREIGN KEY (`calculation_type_id`) REFERENCES `calculation_types` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
