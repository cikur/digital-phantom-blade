-- --------------------------------------------------------
-- Host:                         127.0.0.1
-- Server version:               10.1.13-MariaDB - mariadb.org binary distribution
-- Server OS:                    Win32
-- HeidiSQL Version:             9.3.0.5111
-- --------------------------------------------------------

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!50503 SET NAMES utf8mb4 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;


-- Dumping database structure for smartlamp
DROP DATABASE IF EXISTS `smartlamp`;
CREATE DATABASE IF NOT EXISTS `smartlamp` /*!40100 DEFAULT CHARACTER SET latin1 */;
USE `smartlamp`;

-- Dumping structure for table smartlamp.conf_url
DROP TABLE IF EXISTS `conf_url`;
CREATE TABLE IF NOT EXISTS `conf_url` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `url` varchar(255) DEFAULT NULL,
  `type` enum('ON','OFF','STATUS') DEFAULT 'STATUS',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=latin1;

-- Dumping data for table smartlamp.conf_url: ~0 rows (approximately)
/*!40000 ALTER TABLE `conf_url` DISABLE KEYS */;
INSERT INTO `conf_url` (`id`, `url`, `type`) VALUES
	(1, 'http://agnosthings.com/b3034576-6c39-11e6-8001-005056805279/field/last/feed/690/Lamp', 'STATUS'),
	(2, 'http://agnosthings.com/b3034576-6c39-11e6-8001-005056805279/feed?push=Lamp=1_ON_0_0_lightBulb.png', 'ON'),
	(3, 'http://agnosthings.com/b3034576-6c39-11e6-8001-005056805279/feed?push=Lamp=1_OFF_0_0_darkBulb.png', 'OFF');
/*!40000 ALTER TABLE `conf_url` ENABLE KEYS */;

-- Dumping structure for table smartlamp.devices
DROP TABLE IF EXISTS `devices`;
CREATE TABLE IF NOT EXISTS `devices` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(50) DEFAULT NULL,
  `description` text,
  `status` enum('1','0') DEFAULT '1',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=latin1;

-- Dumping data for table smartlamp.devices: ~2 rows (approximately)
/*!40000 ALTER TABLE `devices` DISABLE KEYS */;
INSERT INTO `devices` (`id`, `name`, `description`, `status`) VALUES
	(1, 'Lamp', NULL, '1'),
	(2, 'Suhu', NULL, '0');
/*!40000 ALTER TABLE `devices` ENABLE KEYS */;

-- Dumping structure for table smartlamp.log
DROP TABLE IF EXISTS `log`;
CREATE TABLE IF NOT EXISTS `log` (
  `id_log` int(15) unsigned NOT NULL AUTO_INCREMENT,
  `timestamp` char(19) NOT NULL DEFAULT '0000-00-00 00:00:00',
  `status` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `notes` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id_log`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Dumping data for table smartlamp.log: ~0 rows (approximately)
/*!40000 ALTER TABLE `log` DISABLE KEYS */;
/*!40000 ALTER TABLE `log` ENABLE KEYS */;

-- Dumping structure for table smartlamp.scanning
DROP TABLE IF EXISTS `scanning`;
CREATE TABLE IF NOT EXISTS `scanning` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `url` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=latin1;

-- Dumping data for table smartlamp.scanning: ~4 rows (approximately)
/*!40000 ALTER TABLE `scanning` DISABLE KEYS */;
INSERT INTO `scanning` (`id`, `url`) VALUES
	(5, 'http://agnosthings.com/b3034576-6c39-11e6-8001-005056805279/field/last/feed/690/Lamp'),
	(6, 'http://agnosthings.com/75568d0e-6c3f-11e6-8001-005056805279/field/last/feed/691/Suhu'),
	(7, 'http://agnosthings.com/b3034576-6c39-11e6-8001-005056805279/feed?push=Lamp=1_OFF_0_0_darkBulb.png'),
	(8, 'http://agnosthings.com/b3034576-6c39-11e6-8001-005056805279/feed?push=Lamp=1_ON_0_0_lightBulb.png');
/*!40000 ALTER TABLE `scanning` ENABLE KEYS */;

-- Dumping structure for table smartlamp.status
DROP TABLE IF EXISTS `status`;
CREATE TABLE IF NOT EXISTS `status` (
  `id_status` int(15) unsigned NOT NULL AUTO_INCREMENT,
  `lamp` enum('ON','OFF') NOT NULL DEFAULT 'OFF',
  `auto_refresh` tinyint(1) NOT NULL DEFAULT '0',
  `auto_refresh_time` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `status` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `notes` varchar(255) NOT NULL,
  PRIMARY KEY (`id_status`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Dumping data for table smartlamp.status: ~0 rows (approximately)
/*!40000 ALTER TABLE `status` DISABLE KEYS */;
/*!40000 ALTER TABLE `status` ENABLE KEYS */;

-- Dumping structure for table smartlamp.url
DROP TABLE IF EXISTS `url`;
CREATE TABLE IF NOT EXISTS `url` (
  `id_url` int(15) unsigned NOT NULL AUTO_INCREMENT,
  `device_id` int(11) DEFAULT NULL,
  `url` varchar(255) NOT NULL,
  `type` enum('-','ON','OFF','STATUS') NOT NULL DEFAULT '-',
  `status` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `notes` varchar(255) DEFAULT NULL,
  `icon` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id_url`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=latin1;

-- Dumping data for table smartlamp.url: ~8 rows (approximately)
/*!40000 ALTER TABLE `url` DISABLE KEYS */;
INSERT INTO `url` (`id_url`, `device_id`, `url`, `type`, `status`, `notes`, `icon`) VALUES
	(1, 1, 'http://agnosthings.com/b3034576-6c39-11e6-8001-005056805279/field/last/feed/690/Lamp', 'STATUS', 1, 'Status lampu saat ini', '/assets/img/darkBulb.png'),
	(2, 1, 'http://agnosthings.com/b3034576-6c39-11e6-8001-005056805279/feed?push=Lamp=1_ON_0_0_lightBulb.png', 'ON', 1, 'Lampu menyala', '/assets/img/lightbulb.png'),
	(3, 1, 'http://agnosthings.com/b3034576-6c39-11e6-8001-005056805279/feed?push=Lamp=1_OFF_0_0_darkBulb.png', 'OFF', 1, 'Lampu padam', '/assets/img/darkBulb.png'),
	(4, 2, 'http://agnosthings.com/75568d0e-6c3f-11e6-8001-005056805279/feed?push=Suhu=2_ON_0_0', 'ON', 1, '', NULL),
	(5, 2, 'http://agnosthings.com/75568d0e-6c3f-11e6-8001-005056805279/feed?push=Suhu=2_OFF_0_0', 'OFF', 1, NULL, NULL),
	(6, 2, 'http://agnosthings.com/75568d0e-6c3f-11e6-8001-005056805279/field/last/feed/691/Suhu', 'STATUS', 0, NULL, NULL),
	(7, 2, 'http://agnosthings.com/75568d0e-6c3f-11e6-8001-005056805279/feed?push=Suhu=', '-', 0, NULL, NULL),
	(8, 1, 'http://agnosthings.com/b3034576-6c39-11e6-8001-005056805279/feed?push=Lamp=', '-', 0, NULL, NULL);
/*!40000 ALTER TABLE `url` ENABLE KEYS */;

-- Dumping structure for table smartlamp.user
DROP TABLE IF EXISTS `user`;
CREATE TABLE IF NOT EXISTS `user` (
  `id_user` int(15) unsigned NOT NULL AUTO_INCREMENT,
  `username` varchar(15) NOT NULL,
  `password` varchar(255) NOT NULL,
  `ip_address` varchar(255) DEFAULT NULL,
  `user_agent` text,
  `status` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `notes` varchar(255) DEFAULT NULL,
  `token` text,
  PRIMARY KEY (`id_user`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=latin1;

-- Dumping data for table smartlamp.user: ~1 rows (approximately)
/*!40000 ALTER TABLE `user` DISABLE KEYS */;
INSERT INTO `user` (`id_user`, `username`, `password`, `ip_address`, `user_agent`, `status`, `notes`, `token`) VALUES
	(1, 'cikur@mail.com', '8cb44471e8b6f8b53d2276999c4d601f', NULL, NULL, 0, NULL, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpYXQiOjEsImV4cCI6MTQ3NDg3ODc5MCwiZGF0YSI6IjJkOXRSUnJ4OHJvZzFPbHNlUE04QlMiLCJzY29wZSI6IiJ9.0wNk9d2Fc0q7qIyXdNf6EUOQ8jLj7bZM8LhO0lkeU7k'),
	(2, 'dpb@mail.com', '8cb44471e8b6f8b53d2276999c4d601f', NULL, NULL, 1, NULL, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpYXQiOjEsImV4cCI6MTQ3NDg3ODc5MCwiZGF0YSI6IjJkOXRSUnJ4OHJvZzFPbHNlUE04QlMiLCJzY29wZSI6IiJ9.0wNk9d2Fc0q7qIyXdNf6EUOQ8jLj7bZM8LhO0lkeU7k');
/*!40000 ALTER TABLE `user` ENABLE KEYS */;

/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
