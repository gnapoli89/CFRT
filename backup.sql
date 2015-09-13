-- MySQL dump 10.13  Distrib 5.6.24, for Win64 (x86_64)
--
-- Host: localhost    Database: sla
-- ------------------------------------------------------
-- Server version	5.6.26-log

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
-- Table structure for table `definition`
--

DROP TABLE IF EXISTS `definition`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `definition` (
  `id_SLA` int(11) NOT NULL,
  `name` varchar(50) NOT NULL,
  `form` varchar(500) NOT NULL,
  `period` varchar(100) NOT NULL,
  `valuetime` varchar(40) NOT NULL,
  `unit` varchar(5) NOT NULL,
  `service` varchar(50) NOT NULL,
  PRIMARY KEY (`id_SLA`,`name`),
  KEY `name` (`name`),
  KEY `name_2` (`name`),
  CONSTRAINT `definition_ibfk_1` FOREIGN KEY (`id_SLA`) REFERENCES `sla` (`ID`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `definition`
--

LOCK TABLES `definition` WRITE;
/*!40000 ALTER TABLE `definition` DISABLE KEYS */;
INSERT INTO `definition` VALUES (15,'averageResponseTime_definition','avg(\'[of all requests response times ]\')','5.0','5','ms','S3'),(15,'error_rate_definition','[error “ InternalError ” or “ ServiceUnavailable ”]/[ total number of requests]','5.0','43200','%','S3'),(15,'numberOfConnections_definition','count(\'[separate cloud service customer users ]\')','1.0','1','num','S3'),(15,'uptime_definition','100.0 - avg(\'[error “ InternalError ” or “ ServiceUnavailable ”]/[ total number of requests]\')','5.0','43200','%','S3');
/*!40000 ALTER TABLE `definition` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sla`
--

DROP TABLE IF EXISTS `sla`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sla` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `provider` varchar(30) NOT NULL,
  `service` varchar(60) NOT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sla`
--

LOCK TABLES `sla` WRITE;
/*!40000 ALTER TABLE `sla` DISABLE KEYS */;
INSERT INTO `sla` VALUES (15,'Amazon','S3');
/*!40000 ALTER TABLE `sla` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `slo`
--

DROP TABLE IF EXISTS `slo`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `slo` (
  `name` varchar(40) NOT NULL,
  `id_sla` int(11) NOT NULL,
  PRIMARY KEY (`name`,`id_sla`),
  KEY `id_sla` (`id_sla`),
  KEY `id_sla_2` (`id_sla`),
  KEY `name` (`name`),
  KEY `id_sla_3` (`id_sla`),
  CONSTRAINT `slo_ibfk_1` FOREIGN KEY (`id_sla`) REFERENCES `sla` (`ID`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `slo`
--

LOCK TABLES `slo` WRITE;
/*!40000 ALTER TABLE `slo` DISABLE KEYS */;
INSERT INTO `slo` VALUES ('averageResponseTime',15),('numberOfConnections',15),('uptime',15);
/*!40000 ALTER TABLE `slo` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `slo_value`
--

DROP TABLE IF EXISTS `slo_value`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `slo_value` (
  `id_SLA` int(11) NOT NULL,
  `name` varchar(40) NOT NULL,
  `value` float NOT NULL,
  `valuetime` varchar(20) NOT NULL,
  `operator` varchar(2) NOT NULL,
  `unit` varchar(5) NOT NULL,
  `value_service` varchar(60) NOT NULL,
  `def_name` varchar(50) NOT NULL,
  PRIMARY KEY (`id_SLA`,`name`,`value`),
  KEY `slo_value_ibfk_2` (`name`),
  KEY `def_name` (`def_name`),
  CONSTRAINT `slo_value_ibfk_1` FOREIGN KEY (`id_SLA`) REFERENCES `slo` (`id_sla`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `slo_value_ibfk_2` FOREIGN KEY (`name`) REFERENCES `slo` (`name`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `slo_value_ibfk_3` FOREIGN KEY (`def_name`) REFERENCES `definition` (`name`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `slo_value`
--

LOCK TABLES `slo_value` WRITE;
/*!40000 ALTER TABLE `slo_value` DISABLE KEYS */;
INSERT INTO `slo_value` VALUES (15,'averageResponseTime',500,'5 minutes ','<','ms','S3','averageResponseTime_definition'),(15,'numberOfConnections',500,'1 minute ','<','num','S3','numberOfConnections_definition'),(15,'uptime',99.9,'month','>=','%','S3','uptime_definition');
/*!40000 ALTER TABLE `slo_value` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2015-09-13 18:45:52
