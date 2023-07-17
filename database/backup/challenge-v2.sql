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
  `apply_to` enum('origin','freight','destination','') NOT NULL,
  `amount` float NOT NULL,
  `currency` varchar(256) NOT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Table structure for table `surcharges`
--

CREATE TABLE `surcharges` (
  `id` bigint UNSIGNED NOT NULL,
  `name` varchar(256) NOT NULL,
  `calculation_type_id` bigint UNSIGNED NOT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `surcharges`
--

INSERT INTO `surcharges` (`id`, `name`, `calculation_type_id`) VALUES
(1, 'Bill Of Lading', 2),
(2, 'Ocean Freight', 1),
(3, 'Basic Freight', 1),
(4, 'Terminal Handling', 1),
(5, 'Bunker Adjustment', 1),
(6, 'Documentation Fee', 2),
(7, 'Peak Season', 1),
(8, 'Booking Fee', 2),
(9, 'Port Charges', 2),
(10, 'Overweight', 1),
(11, 'T3', 1);

--
-- Table structure for table `surcharge_aliases`
--

CREATE TABLE `surcharge_aliases` (
  `id` bigint UNSIGNED NOT NULL,
  `surcharge_id` bigint UNSIGNED NOT NULL,
  `name` varchar(256) NOT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `surcharge_aliases`
--
INSERT INTO `surcharge_aliases` (`id`, `surcharge_id`, `name`) VALUES
(1, 1, 'BL Fee'),
(2, 1, 'BL'),
(3, 1, 'Bill of Lading (BL)'),
(4, 2, 'Ocean Freight'),
(5, 2, 'Ocean Freight Charge'),
(6, 3, 'Basic Freight'),
(7, 4, 'Terminal Handling Charge Origin'),
(8, 4, 'Terminal Handling Charge'),
(9, 4, 'Terminal Handling Charge Destination'),
(10, 5, 'Bunker Adjustment'),
(11, 5, 'Bunker Adjustment Fee'),
(12, 5, 'Bunker Adjustment Charge'),
(13, 6, 'Doc fee'),
(14, 6, 'Documentation fee'),
(15, 7, 'Peak Season'),
(16, 7, 'Peak Season Surcharge'),
(17, 7, 'Peak Season Adjustment Factor'),
(18, 8, 'Booking fee'),
(19, 9, 'Port Charges Import'),
(20, 9, 'Port Charges Export'),
(21, 10, 'Overweight'),
(22, 10, 'Overweight surcharge'),
(23, 11, 'T3 Origin'),
(24, 11, 'T3');

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
-- Indexes for table `surcharges`
--
ALTER TABLE `surcharge_aliases`
  ADD PRIMARY KEY (`id`),
  ADD KEY `surcharge_id` (`surcharge_id`);

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
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;

--
-- AUTO_INCREMENT for table `surcharge_aliases`
--
ALTER TABLE `surcharge_aliases`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=25;

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

--
-- Constraints for table `surcharge_aliases`
--
ALTER TABLE `surcharge_aliases`
  ADD CONSTRAINT `surcharge_aliases_ibfk_1` FOREIGN KEY (`surcharge_id`) REFERENCES `surcharges` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
