
CREATE TABLE IF NOT EXISTS `gunracks` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `coords` longtext NOT NULL,
  `rifles` longtext NOT NULL DEFAULT '[]',
  `pistols` longtext NOT NULL DEFAULT '[]',
  `taser` enum('1','0') NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


ALTER TABLE gunracks ADD COLUMN code varchar(50) NULL DEFAULT NULL;