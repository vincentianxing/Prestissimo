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
-- Table structure for table `votes`
--

DROP TABLE IF EXISTS `votes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `votes` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `votable_id` int(11) DEFAULT NULL,
  `votable_type` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `voter_id` int(11) DEFAULT NULL,
  `voter_type` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `vote_flag` tinyint(1) DEFAULT NULL,
  `vote_scope` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  `vote_weight` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_votes_on_votable_id_and_votable_type` (`votable_id`,`votable_type`),
  KEY `index_votes_on_voter_id_and_voter_type` (`voter_id`,`voter_type`),
  KEY `index_votes_on_voter_id_and_voter_type_and_vote_scope` (`voter_id`,`voter_type`,`vote_scope`),
  KEY `index_votes_on_votable_id_and_votable_type_and_vote_scope` (`votable_id`,`votable_type`,`vote_scope`)
) ENGINE=InnoDB AUTO_INCREMENT=23 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `votes`
--

LOCK TABLES `votes` WRITE;
/*!40000 ALTER TABLE `votes` DISABLE KEYS */;
INSERT INTO `votes` VALUES (1,14,'Comment',11,'Handle',1,NULL,'2013-02-11 20:47:54','2013-02-11 20:47:54',NULL),(2,13,'Comment',11,'Handle',1,NULL,'2013-02-11 20:50:20','2013-02-11 20:50:20',NULL),(3,13,'Comment',1604,'Handle',1,NULL,'2013-11-20 14:38:52','2013-11-20 14:38:52',NULL),(4,13,'Comment',1772,'Handle',1,NULL,'2013-11-20 20:38:27','2013-11-20 20:38:27',NULL),(5,13,'Comment',1121,'Handle',1,NULL,'2014-01-20 21:46:39','2014-01-20 21:46:39',NULL),(6,28,'Comment',98,'Handle',0,NULL,'2014-01-21 21:43:13','2014-01-21 21:43:13',NULL),(7,14,'Comment',1461,'Handle',1,NULL,'2014-02-03 04:21:25','2014-02-03 04:21:25',NULL),(8,14,'Comment',1348,'Handle',1,NULL,'2014-06-29 21:26:00','2014-06-29 21:26:00',NULL),(9,13,'Comment',95,'Handle',1,NULL,'2014-08-12 19:13:47','2014-08-12 19:13:47',NULL),(10,13,'Comment',1760,'Handle',1,NULL,'2014-08-12 19:14:16','2014-08-12 19:14:16',NULL),(11,14,'Comment',2267,'Handle',1,NULL,'2014-08-28 15:40:48','2014-08-28 15:40:48',NULL),(13,14,'Comment',2491,'Handle',1,NULL,'2014-09-02 05:17:09','2014-09-02 05:17:09',NULL),(14,28,'Comment',11,'Handle',1,NULL,'2015-03-14 20:23:55','2015-03-14 20:23:55',NULL),(15,14,'Comment',95,'Handle',1,NULL,'2015-06-24 17:07:32','2015-06-24 17:07:32',NULL),(19,28,'Comment',3013,'Handle',0,NULL,'2015-10-07 03:27:29','2015-10-07 03:27:29',0),(20,37,'Comment',3013,'Handle',0,NULL,'2015-10-07 03:27:31','2015-10-07 03:27:31',0),(21,14,'Comment',2806,'Handle',1,NULL,'2015-11-03 19:33:46','2015-11-03 19:33:46',0),(22,13,'Comment',2969,'Handle',1,NULL,'2015-11-09 14:00:27','2015-11-09 14:00:27',0);
/*!40000 ALTER TABLE `votes` ENABLE KEYS */;
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
