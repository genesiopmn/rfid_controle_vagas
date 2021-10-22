-- --------------------------------------------------------
-- Servidor:                     localhost
-- Versão do servidor:           5.7.12-log - MySQL Community Server (GPL)
-- OS do Servidor:               Win64
-- HeidiSQL Versão:              10.3.0.5771
-- --------------------------------------------------------

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!50503 SET NAMES utf8mb4 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;


-- Copiando estrutura do banco de dados para rfid
CREATE DATABASE IF NOT EXISTS `rfid` /*!40100 DEFAULT CHARACTER SET utf8 */;
USE `rfid`;

-- Copiando estrutura para tabela rfid.apto
CREATE TABLE IF NOT EXISTS `apto` (
  `RowID` int(11) NOT NULL AUTO_INCREMENT,
  `num_apto` int(11) NOT NULL,
  `TotalVagas` int(11) NOT NULL,
  `VagasDisp` int(11) NOT NULL,
  `Status` tinyint(1) NOT NULL DEFAULT '1',
  PRIMARY KEY (`num_apto`),
  KEY `Rownum` (`RowID`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=latin1;

-- Copiando dados para a tabela rfid.apto: ~2 rows (aproximadamente)
/*!40000 ALTER TABLE `apto` DISABLE KEYS */;
INSERT INTO `apto` (`RowID`, `num_apto`, `TotalVagas`, `VagasDisp`, `Status`) VALUES
	(1, 101, 2, 0, 1),
	(2, 102, 2, 0, 1);
/*!40000 ALTER TABLE `apto` ENABLE KEYS */;

-- Copiando estrutura para tabela rfid.history
CREATE TABLE IF NOT EXISTS `history` (
  `RowID` int(11) NOT NULL AUTO_INCREMENT,
  `UID` varchar(50) NOT NULL,
  `Name` text NOT NULL,
  `num_apto` int(11) NOT NULL,
  `DTime` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `Act` tinytext NOT NULL,
  KEY `RowID` (`RowID`),
  KEY `UID` (`UID`),
  KEY `num_apto` (`num_apto`),
  CONSTRAINT `FK_history_apto` FOREIGN KEY (`num_apto`) REFERENCES `apto` (`num_apto`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `FK_log_users` FOREIGN KEY (`UID`) REFERENCES `users` (`UID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=38 DEFAULT CHARSET=latin1;

-- Copiando dados para a tabela rfid.history: ~17 rows (aproximadamente)
/*!40000 ALTER TABLE `history` DISABLE KEYS */;
INSERT INTO `history` (`RowID`, `UID`, `Name`, `num_apto`, `DTime`, `Act`) VALUES
	(5, '0074907C', 'GENESIO', 101, '2020-02-18 01:53:28', 'Entrada'),
	(6, '0074907C', 'GENESIO', 101, '2020-02-18 01:53:42', 'Entrada'),
	(7, 'A06AC180', 'LARA', 102, '2020-02-18 02:20:23', 'Entrada'),
	(8, 'A06AC180', 'LARA', 102, '2020-02-18 02:20:41', 'Entrada'),
	(9, 'A06AC180', 'LARA', 102, '2020-02-18 02:20:48', 'Entrada'),
	(10, '0074907C', 'GENESIO', 101, '2020-02-18 02:20:57', 'Entrada'),
	(11, '0074907C', 'GENESIO', 101, '2020-02-18 02:21:01', 'Entrada'),
	(12, '0074907C', 'GENESIO', 101, '2020-02-18 02:28:22', 'Entrada'),
	(13, '0074907C', 'GENESIO', 101, '2020-02-18 02:28:28', 'Entrada'),
	(14, '0074907C', 'GENESIO', 101, '2020-02-18 02:30:39', 'Entrada'),
	(15, 'A06AC180', 'LARA', 102, '2020-02-18 02:30:44', 'Entrada'),
	(16, '0074907C', 'GENESIO', 101, '2020-02-18 02:31:33', 'Entrada'),
	(17, '0074907C', 'GENESIO', 101, '2020-02-18 02:31:45', 'Entrada'),
	(18, '0074907C', 'GENESIO', 101, '2020-02-18 02:31:50', 'Negado'),
	(19, 'A06AC180', 'LARA', 102, '2020-02-18 02:32:16', 'Entrada'),
	(20, 'A06AC180', 'LARA', 102, '2020-02-18 02:32:22', 'Entrada'),
	(21, 'A06AC180', 'LARA', 102, '2020-02-18 02:32:28', 'Negado'),
	(22, '0074907C', 'GENESIO', 101, '2020-02-18 02:34:05', 'Entrada'),
	(23, '0074907C', 'GENESIO', 101, '2020-02-18 02:34:10', 'Entrada'),
	(24, '0074907C', 'GENESIO', 101, '2020-02-18 02:45:02', 'Entrada'),
	(25, '0074907C', 'GENESIO', 101, '2020-02-18 02:45:07', 'Entrada'),
	(26, '0074907C', 'GENESIO', 101, '2020-02-18 02:45:13', 'Saida'),
	(27, 'A06AC180', 'LARA', 102, '2020-02-18 02:45:46', 'Entrada'),
	(28, 'A06AC180', 'LARA', 102, '2020-02-18 02:45:56', 'Entrada'),
	(29, '0074907C', 'GENESIO', 101, '2020-02-18 02:46:02', 'Entrada'),
	(30, 'A06AC180', 'LARA', 102, '2020-02-18 02:46:07', 'Saida'),
	(31, 'A06AC180', 'LARA', 102, '2020-02-18 02:46:12', 'Entrada'),
	(32, '0074907C', 'GENESIO', 101, '2020-02-18 02:46:22', 'Saida'),
	(33, '0074907C', 'GENESIO', 101, '2020-02-18 02:46:27', 'Entrada'),
	(34, '0074907C', 'GENESIO', 101, '2020-02-18 02:47:51', 'Saida'),
	(35, '0074907C', 'GENESIO', 101, '2020-02-18 02:47:55', 'Entrada'),
	(36, 'A06AC180', 'LARA', 102, '2020-02-18 02:48:02', 'Saida'),
	(37, 'A06AC180', 'LARA', 102, '2020-02-18 02:48:06', 'Entrada');
/*!40000 ALTER TABLE `history` ENABLE KEYS */;

-- Copiando estrutura para procedure rfid.p2
DELIMITER //
CREATE PROCEDURE `p2`()
BEGIN
  DECLARE done INT DEFAULT FALSE;
  DECLARE x  INT(11);
  DECLARE cur1 CURSOR FOR SELECT apto.num_apto FROM rfid.apto;   
  DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;
  OPEN cur1; 
  read_loop:LOOP
    FETCH cur1 INTO x;  
	 IF done THEN
      LEAVE read_loop;
    END IF;  
    IF 1 = 1 THEN
    	UPDATE rfid.apto	
		SET apto.VagasDisp = VagasDisp -1
		WHERE  apto.num_apto = x
		AND apto.VagasDisp BETWEEN 1 
		AND apto.TotalVagas;
     END IF;
  END LOOP;
  CLOSE cur1;  
END//
DELIMITER ;

-- Copiando estrutura para tabela rfid.users
CREATE TABLE IF NOT EXISTS `users` (
  `RowID` int(11) NOT NULL AUTO_INCREMENT,
  `UID` varchar(50) NOT NULL,
  `Name` text NOT NULL,
  `num_apto` int(11) NOT NULL,
  `Gender` tinytext NOT NULL,
  `Status` tinyint(1) NOT NULL DEFAULT '1',
  KEY `rownum` (`RowID`),
  KEY `FK_users_apto` (`num_apto`),
  KEY `UID` (`UID`),
  CONSTRAINT `FK_users_apto` FOREIGN KEY (`num_apto`) REFERENCES `apto` (`num_apto`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=latin1;

-- Copiando dados para a tabela rfid.users: ~2 rows (aproximadamente)
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` (`RowID`, `UID`, `Name`, `num_apto`, `Gender`, `Status`) VALUES
	(1, '0074907C', 'GENESIO', 101, 'MASC', 1),
	(2, 'A06AC180', 'LARA', 102, 'FEM', 1);
/*!40000 ALTER TABLE `users` ENABLE KEYS */;

-- Copiando estrutura para trigger rfid.TG_UPD_ENTRADAS
