-- Use this sql ONLY if you are creating a NEW database.
-- Use 'SQL\virtualGarageUpdate.sql' if you are updating from the previous version.

-- Uncomment the next 2 lines if you want to use an external database away from your epoch databas,	i.e you have multiple servers sharing the same virtual garage database.
-- If your hosting provider only allows you access to 1 database (i.e your main epoch one) then leave these commented out as they are.

-- CREATE DATABASE IF NOT EXISTS `extdb` /*!40100 DEFAULT CHARACTER SET utf8 */;
-- USE `extdb`;

CREATE TABLE IF NOT EXISTS `garage` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `PlayerUID` varchar(20) NOT NULL DEFAULT '0',
  `Name` varchar(50) NOT NULL DEFAULT '',
  `DisplayName` varchar(50) NOT NULL DEFAULT '',
  `Classname` varchar(50) DEFAULT NULL,
  `Datestamp` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `DateStored` varchar(10) NOT NULL DEFAULT 'old',
  `DateMaintained` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `CharacterID` bigint(20) unsigned NOT NULL DEFAULT '0',
  `StorageCounts` varchar(30) NOT NULL DEFAULT '[0,0,0]',
  `Inventory` mediumtext,
  `Hitpoints` mediumtext,
  `Fuel` double(13,5) NOT NULL DEFAULT '1.00000',
  `Damage` double(13,5) NOT NULL DEFAULT '0.00000',
  `Colour` varchar(50) NOT NULL,
  `Colour2` varchar(50) NOT NULL,
  `serverKey` varchar(10) NOT NULL DEFAULT 'old',
  `ObjUID` varchar(20) NOT NULL DEFAULT 'old',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;
