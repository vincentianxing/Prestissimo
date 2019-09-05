-- MySQL dump 10.13  Distrib 5.1.73, for slackware-linux-gnu (x86_64)
--
-- Host: localhost    Database: prestissimo_production
-- ------------------------------------------------------
-- Server version	5.1.73

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
-- Table structure for table `departments`
--

DROP TABLE IF EXISTS `departments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `departments` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `dept` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  `dept_long` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=76 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `departments`
--

LOCK TABLES `departments` WRITE;
/*!40000 ALTER TABLE `departments` DISABLE KEYS */;
INSERT INTO `departments` VALUES (1,'AAST','2012-08-03 18:59:48','2012-08-03 18:59:48','Africana Studies'),(2,'ACHS','2012-08-03 18:59:48','2012-08-03 18:59:48','Archeological Studies'),(3,'ANTH','2012-08-03 18:59:48','2012-08-03 18:59:48','Anthropology'),(4,'APST','2012-08-03 18:59:48','2012-08-03 18:59:48','Applied Studies'),(5,'ARBC','2012-08-03 18:59:48','2012-08-03 18:59:48','Arabic'),(6,'ARTS','2012-08-03 18:59:48','2012-08-03 18:59:48','Art'),(7,'ASTR','2012-08-03 18:59:48','2012-08-03 18:59:48','Astronomy'),(8,'ATHL','2012-08-03 18:59:48','2012-08-03 18:59:48','Athletics & Physical Education'),(9,'BIOL','2012-08-03 18:59:49','2012-08-03 18:59:49','Biology'),(10,'CAST','2012-08-03 18:59:49','2012-08-03 18:59:49','Comparative American Studies'),(11,'CHEM','2012-08-03 18:59:49','2012-08-03 18:59:49','Chemistry'),(12,'CHIN','2012-08-03 18:59:49','2012-08-03 18:59:49','Chinese'),(13,'CINE','2012-08-03 18:59:49','2012-08-03 18:59:49','Cinema Studies'),(14,'CLAS','2012-08-03 18:59:49','2012-08-03 18:59:49','Classics'),(15,'CMPL','2012-08-03 18:59:49','2012-08-03 18:59:49','Comparative Literature'),(16,'CMUS','2012-08-03 18:59:49','2012-08-03 18:59:49','College Music'),(17,'CNST','2012-08-03 18:59:49','2012-08-03 18:59:49','Conservatory Studies'),(18,'COMP','2012-08-03 18:59:49','2012-08-03 18:59:49','Composition'),(19,'CRWR','2012-08-03 18:59:49','2012-08-03 18:59:49','Creative Writing'),(20,'CSCI','2012-08-03 18:59:49','2012-08-03 18:59:49','Computer Science'),(21,'DANC','2012-08-03 18:59:49','2012-08-03 18:59:49','Dance'),(22,'EAST','2012-08-03 18:59:49','2012-08-03 18:59:49','East Asian Studies'),(23,'ECON','2012-08-03 18:59:49','2012-08-03 18:59:49','Economics'),(24,'EDUA','2012-08-03 18:59:49','2012-08-03 18:59:49','Education-Arts and Sciences'),(25,'ENGL','2012-08-03 18:59:49','2012-08-03 18:59:49','English'),(26,'ENTR','2012-08-03 18:59:49','2012-08-03 18:59:49','Entrepreneurship Studies'),(27,'ENVS','2012-08-03 18:59:49','2012-08-03 18:59:49','Environmental Studies'),(28,'ETHN','2012-08-03 18:59:49','2012-08-03 18:59:49','Ethnomusicology'),(29,'FREN','2012-08-03 18:59:49','2012-08-03 18:59:49','French'),(30,'FYSP','2012-08-03 18:59:49','2012-08-03 18:59:49','First Year Seminar Program'),(31,'GEOL','2012-08-03 18:59:49','2012-08-03 18:59:49','Geology'),(32,'GERM','2012-08-03 18:59:50','2012-08-03 18:59:50','German'),(33,'GREK','2012-08-03 18:59:50','2012-08-03 18:59:50','Greek'),(34,'GSFS','2012-08-03 18:59:50','2012-08-03 18:59:50','Gender Sexuality Feminist St'),(35,'HISP','2012-08-03 18:59:50','2012-08-03 18:59:50','Hispanic Studies'),(36,'HIST','2012-08-03 18:59:50','2012-08-03 18:59:50','History'),(37,'HPRF','2012-08-03 18:59:50','2012-08-03 18:59:50','Historical Performance'),(38,'INDV','2012-08-03 18:59:50','2012-08-03 18:59:50','Individual Major'),(39,'ITAL','2012-08-03 18:59:50','2012-08-03 18:59:50','Italian'),(40,'JAPN','2012-08-03 18:59:50','2012-08-03 18:59:50','Japanese'),(41,'JAZZ','2012-08-03 18:59:50','2012-08-03 18:59:50','Jazz Studies'),(42,'JWST','2012-08-03 18:59:50','2012-08-03 18:59:50','Jewish Studies'),(43,'LANG','2012-08-03 18:59:50','2012-08-03 18:59:50','Language'),(44,'LATN','2012-08-03 18:59:50','2012-08-03 18:59:50','Latin'),(45,'LATS','2012-08-03 18:59:50','2012-08-03 18:59:50','Latin American Studies'),(46,'LOND','2012-08-03 18:59:50','2012-08-03 18:59:50','London Program'),(47,'LRNS','2012-08-03 18:59:50','2012-08-03 18:59:50','Learning Assistance Program'),(48,'MATH','2012-08-03 18:59:50','2012-08-03 18:59:50','Mathematics'),(49,'MHST','2012-08-03 18:59:50','2012-08-03 18:59:50','Music History'),(50,'MLIT','2012-08-03 18:59:50','2012-08-03 18:59:50','Music Literature'),(51,'MUED','2012-08-03 18:59:50','2012-08-03 18:59:50','Music Education'),(52,'MUTH','2012-08-03 18:59:50','2012-08-03 18:59:50','Music Theory'),(53,'NSCI','2012-08-03 18:59:50','2012-08-03 18:59:50','Neuroscience'),(54,'OPTH','2012-08-03 18:59:50','2012-08-03 18:59:50','Opera Theater'),(55,'PHIL','2012-08-03 18:59:50','2012-08-03 18:59:50','Philosophy'),(56,'PHYS','2012-08-03 18:59:50','2012-08-03 18:59:50','Physics'),(57,'POLT','2012-08-03 18:59:50','2012-08-03 18:59:50','Politics'),(58,'PSYC','2012-08-03 18:59:51','2012-08-03 18:59:51','Psychology'),(59,'PVST','2012-08-03 18:59:51','2012-08-03 18:59:51','Private Studies'),(60,'RELG','2012-08-03 18:59:51','2012-08-03 18:59:51','Religion'),(61,'RHET','2012-08-03 18:59:51','2012-08-03 18:59:51','Rhetoric & Composition Program'),(62,'RUSS','2012-08-03 18:59:51','2012-08-03 18:59:51','Russian'),(63,'SOCI','2012-08-03 18:59:51','2012-08-03 18:59:51','Sociology'),(64,'TECH','2012-08-03 18:59:51','2012-08-03 18:59:51','TIMARA'),(65,'THEA','2012-08-03 18:59:51','2012-08-03 18:59:51','Theater'),(66,'EDUC','2012-08-03 19:00:48','2012-08-03 19:00:48','Education'),(67,'TWST','2012-08-03 19:01:47','2012-08-03 19:01:47','Third World Studies'),(68,'REES','2012-08-03 19:06:51','2012-08-03 19:06:51','Russian & East European St'),(69,'STAT','2012-08-03 19:06:51','2012-08-03 19:06:51','Statistics'),(70,'XART','2012-08-03 19:06:51','2012-08-03 19:06:51','Interdivisional Arts'),(71,'EDPR','2013-04-12 21:05:56','2013-04-12 21:05:56','Education Practica'),(72,'ESOL','2013-04-12 21:05:56','2013-04-12 21:05:56','English as a Second Lang'),(73,'HLTH','2013-04-12 21:05:56','2013-04-12 21:05:56','Health Careers'),(74,'PORT','2013-04-12 21:05:57','2013-04-12 21:05:57','Portuguese'),(75,'RTCP','2013-04-12 21:05:57','2013-04-12 21:05:57','Rhet and Comp Practica Courses');
/*!40000 ALTER TABLE `departments` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2015-11-11 15:18:00
