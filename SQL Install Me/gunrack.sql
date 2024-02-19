CREATE TABLE IF NOT EXISTS `gunracks` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `coords` longtext NOT NULL,
  `rifles` longtext NOT NULL,
  `pistols` longtext NOT NULL,
  `taser` enum('1','0') NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;