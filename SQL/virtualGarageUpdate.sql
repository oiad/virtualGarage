/*
	Only use this sql file if you are updating from a previous version.
	Use virtualGarage.sql if you are starting fresh.
*/

ALTER TABLE `garage` ADD `Name` VARCHAR(50) NOT NULL DEFAULT '' AFTER `PlayerUID`;
ALTER TABLE `garage` ADD `displayName` VARCHAR(50) NOT NULL DEFAULT '' AFTER `Name`;