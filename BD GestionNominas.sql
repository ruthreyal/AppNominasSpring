-- --------------------------------------------------------
-- Host:                         127.0.0.1
-- Versión del servidor:         11.2.2-MariaDB - mariadb.org binary distribution
-- SO del servidor:              Win64
-- HeidiSQL Versión:             12.3.0.6589
-- --------------------------------------------------------

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;


-- Volcando estructura de base de datos para gestionnomina
CREATE DATABASE IF NOT EXISTS `gestionnomina` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci */;
USE `gestionnomina`;

-- Volcando estructura para tabla gestionnomina.empleados
CREATE TABLE IF NOT EXISTS `empleados` (
  `nombre` varchar(50) DEFAULT NULL,
  `dni` varchar(50) NOT NULL,
  `sexo` char(1) DEFAULT NULL,
  `categoria` int(11) DEFAULT 1,
  `anyos` int(11) DEFAULT 0,
  PRIMARY KEY (`dni`),
  CONSTRAINT `empleados_chk_1` CHECK (`sexo` in ('m','f')),
  CONSTRAINT `empleados_chk_2` CHECK (`categoria` between 1 and 10),
  CONSTRAINT `empleados_chk_3` CHECK (`anyos` >= 0)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Volcando datos para la tabla gestionnomina.empleados: ~8 rows (aproximadamente)
INSERT INTO `empleados` (`nombre`, `dni`, `sexo`, `categoria`, `anyos`) VALUES
	('Carlos García', '11223344C', 'M', 3, 10),
	('Juan Pérez', '12345678A', 'M', 1, 5),
	('Ana Sánchez', '22334455D', 'F', 1, 8),
	('Pepe Rios', '28635398F', 'M', 1, 1),
	('Ada Lovelace', '32000031R', 'F', 1, 0),
	('James Gosling', '32000032G', 'M', 4, 7),
	('Luis Fernández', '55667788E', 'M', 2, 6),
	('María López', '87654321B', 'F', 2, 3);

-- Volcando estructura para tabla gestionnomina.nominas
CREATE TABLE IF NOT EXISTS `nominas` (
  `dni` varchar(50) DEFAULT NULL,
  `sueldo` int(11) DEFAULT NULL,
  KEY `fk_nominas_empleados` (`dni`),
  CONSTRAINT `fk_nominas_empleados` FOREIGN KEY (`dni`) REFERENCES `empleados` (`dni`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Volcando datos para la tabla gestionnomina.nominas: ~8 rows (aproximadamente)
INSERT INTO `nominas` (`dni`, `sueldo`) VALUES
	('32000032G', 145000),
	('32000031R', 50000),
	('28635398F', 55000),
	('12345678A', 75000),
	('87654321B', 85000),
	('11223344C', 140000),
	('22334455D', 90000),
	('55667788E', 100000);

-- Volcando estructura para disparador gestionnomina.empleados_after_update
SET @OLDTMP_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO';
DELIMITER //
CREATE TRIGGER `empleados_after_update` AFTER UPDATE ON `empleados`
    FOR EACH ROW
BEGIN
    DECLARE sueldo_calculado INT;

    SET sueldo_calculado = 30000 + NEW.categoria * 20000 + NEW.anyos * 5000;

    UPDATE `nominas`
    SET sueldo = sueldo_calculado
    WHERE dni = NEW.dni;
END//
DELIMITER ;
SET SQL_MODE=@OLDTMP_SQL_MODE;

-- Volcando estructura para disparador gestionnomina.nominas_after_insert
SET @OLDTMP_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO';
DELIMITER //
CREATE TRIGGER `nominas_after_insert` AFTER INSERT ON `empleados`
    FOR EACH ROW
BEGIN
    DECLARE sueldo_calculado INT;

    SET sueldo_calculado = 30000 + NEW.categoria * 20000 + NEW.anyos * 5000;

    INSERT INTO `nominas` (`dni`, `sueldo`)
    VALUES (NEW.dni, sueldo_calculado);
END//
DELIMITER ;
SET SQL_MODE=@OLDTMP_SQL_MODE;

/*!40103 SET TIME_ZONE=IFNULL(@OLD_TIME_ZONE, 'system') */;
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IFNULL(@OLD_FOREIGN_KEY_CHECKS, 1) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40111 SET SQL_NOTES=IFNULL(@OLD_SQL_NOTES, 1) */;
