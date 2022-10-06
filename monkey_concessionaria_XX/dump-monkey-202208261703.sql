-- MySQL dump 10.13  Distrib 5.5.62, for Win64 (AMD64)
--
-- Host: localhost    Database: monkey
-- ------------------------------------------------------
-- Server version	5.5.5-10.4.24-MariaDB

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `monkey_concessionaria`
--

DROP TABLE IF EXISTS `monkey_concessionaria`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `monkey_concessionaria` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `carro` varchar(100) NOT NULL,
  `valor` bigint(20) NOT NULL,
  `tipo` varchar(100) NOT NULL,
  `estoque` int(11) NOT NULL,
  `nomeVitrine` varchar(100) NOT NULL,
  `peso` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `monkey_concessionaria`
--

LOCK TABLES `monkey_concessionaria` WRITE;
/*!40000 ALTER TABLE `monkey_concessionaria` DISABLE KEYS */;
INSERT INTO `monkey_concessionaria` VALUES (1,'akuma',100000,'carro',1000,'akuma',50),(2,'dominator2',50000,'carro',1000,'Dominator 2',70),(3,'nightshade',50000,'carro',1000,'Night Shade',80),(4,'bullet',50000,'carro',1000,'Bullet',70),(5,'italigtb',50000,'carro',1000,'Itali GB',10),(6,'furia',50000,'carro',1000,'Furia',0),(7,'fordtaurus',100000,'carro',1000,'Ford Taurus',0),(8,'nemesis',100000,'carro',1000,'Nemesis',0),(9,'panto',100000,'carro',1000,'Panto',0),(10,'cb500policia2',100000,'carro',1000,'CB500 Policia 2',0),(11,'audirs6',100000,'carro',1000,'Audi RS6',0),(12,'fordexplorer',100000,'carro',1000,'Ford Explorer',0);
/*!40000 ALTER TABLE `monkey_concessionaria` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2022-08-26 17:03:40
