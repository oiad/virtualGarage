--
-- Import this into your `garage` database or modify it to suit your specific database.
-- This will remove vehicles older than 35 days (5 weeks)

-- ----------------------------
-- Event structure for RemoveOldVG
-- ----------------------------
DROP EVENT IF EXISTS `RemoveOldVG`;
DELIMITER ;;
CREATE EVENT `RemoveOldVG` ON SCHEDULE EVERY 1 DAY COMMENT 'Removes old Virtual Garage Vehicles.' DO DELETE FROM `garage` WHERE `DateStamp` < DATE_SUB(CURRENT_TIMESTAMP, INTERVAL 35 DAY)
;;
DELIMITER ;