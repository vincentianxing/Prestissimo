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
-- Table structure for table `settings`
--

DROP TABLE IF EXISTS `settings`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `settings` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `key` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `value` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `index_settings_on_key` (`key`)
) ENGINE=InnoDB AUTO_INCREMENT=17 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `settings`
--

LOCK TABLES `settings` WRITE;
/*!40000 ALTER TABLE `settings` DISABLE KEYS */;
INSERT INTO `settings` VALUES (1,'current_semester','Spring 2016','2012-08-03 18:58:50','2015-10-19 15:43:07'),(2,'semesters','Spring 2016|Fall 2015|Spring 2015|Fall 2014|Spring 2014|Fall 2013|Spring 2013|Fall 2012|Spring 2012|Fall 2011|Spring 2011|Fall 2010|Spring 2010|Fall 2009','2012-08-03 18:58:50','2015-10-19 15:43:07'),(3,'user_count','3425','2012-08-03 18:58:50','2015-11-11 07:00:03'),(4,'comment_count','38','2012-08-03 18:58:50','2015-11-04 07:00:03'),(5,'admins','Master Admin|Richard Townsend|Elizabeth Bennett|Abigail Marsh|Cole Peppis|Meghan McCreary','2012-08-03 18:58:50','2015-07-14 20:35:11'),(6,'high_comment_score','5','2012-08-03 18:58:50','2012-08-03 18:58:50'),(7,'low_comment_score','-5','2012-08-03 18:58:50','2012-08-03 18:58:50'),(8,'courses_revision_number','1.1226','2012-08-03 18:58:50','2015-11-11 16:44:55'),(9,'enrollment_revision_number','1.1888','2012-08-03 18:58:50','2015-11-11 16:44:56'),(10,'comment_report_threshold','5','2012-08-03 18:58:50','2012-08-03 18:58:50'),(11,'handle_report_threshold','5','2012-08-03 18:58:50','2012-08-03 18:58:50'),(12,'user_report_threshold','5','2012-08-03 18:58:50','2012-08-03 18:58:50'),(13,'handle_abuse_threshold','5','2012-08-03 18:58:50','2012-08-03 18:58:50'),(14,'motd','We\'re now showing information about spring 2016!','2012-08-03 18:58:50','2015-10-28 20:08:38'),(15,'courses_last_updated','2015-11-11T11:40:00-0500','2012-08-03 18:58:50','2015-11-11 16:44:58'),(16,'profs_last_notified','','2015-07-13 14:34:17','2015-07-13 14:34:17');
/*!40000 ALTER TABLE `settings` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2015-11-11 15:18:01
