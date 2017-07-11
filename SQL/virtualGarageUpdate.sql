/*
	Only use this sql file if you are updating from a previous version.
	Use SQL\virtualGarage.sql if you are starting fresh.
*/

ALTER TABLE `garage` CHARACTER SET utf8 COLLATE utf8_general_ci;
ALTER TABLE `garage` CONVERT TO CHARACTER SET utf8 COLLATE utf8_unicode_ci;
ALTER TABLE `garage` ADD `Name` VARCHAR(50) NOT NULL DEFAULT '' AFTER `PlayerUID`;
ALTER TABLE `garage` ADD `displayName` VARCHAR(50) NOT NULL DEFAULT '' AFTER `Name`;

UPDATE `garage` SET Inventory = '[[[],[]],[[],[]],[[],[]]]' WHERE Inventory = '[]';