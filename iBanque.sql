CREATE TABLE `iBanque` (
  `id` int(11) NOT NULL,
  `identifier` varchar(55) DEFAULT NULL,
  `type` varchar(25) NOT NULL,
  `amount` int(255) DEFAULT NULL,
  `hours` varchar(55) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

ALTER TABLE `iBanque`
  ADD PRIMARY KEY (`id`);

ALTER TABLE `iBanque`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=57;