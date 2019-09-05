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
-- Table structure for table `comments`
--

DROP TABLE IF EXISTS `comments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `comments` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `commentable_id` int(11) DEFAULT '0',
  `commentable_type` varchar(255) COLLATE utf8_unicode_ci DEFAULT '',
  `title` varchar(255) COLLATE utf8_unicode_ci DEFAULT '',
  `body` text COLLATE utf8_unicode_ci,
  `subject` varchar(255) COLLATE utf8_unicode_ci DEFAULT '',
  `user_id` int(11) NOT NULL DEFAULT '0',
  `parent_id` int(11) DEFAULT NULL,
  `lft` int(11) DEFAULT NULL,
  `rgt` int(11) DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  `status` varchar(255) COLLATE utf8_unicode_ci DEFAULT 'active',
  `prev` int(11) DEFAULT NULL,
  `cached_votes_total` int(11) DEFAULT '0',
  `cached_votes_up` int(11) DEFAULT '0',
  `cached_votes_down` int(11) DEFAULT '0',
  `old` tinyint(1) DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `index_comments_on_cached_votes_down` (`cached_votes_down`),
  KEY `index_comments_on_cached_votes_total` (`cached_votes_total`),
  KEY `index_comments_on_cached_votes_up` (`cached_votes_up`),
  KEY `index_comments_on_commentable_id` (`commentable_id`),
  KEY `index_comments_on_user_id` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=40 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `comments`
--

LOCK TABLES `comments` WRITE;
/*!40000 ALTER TABLE `comments` DISABLE KEYS */;
INSERT INTO `comments` VALUES (1,27,'Hubcourse','','Anybody taken this class? \r\n(First comment)','',14,NULL,1,2,'2012-08-10 02:15:53','2012-08-10 02:15:53','active',NULL,0,0,0,0),(2,228,'Professor','','Great professor!','',3,NULL,1,2,'2012-08-10 18:16:46','2012-08-10 18:16:53','removed',NULL,0,0,0,0),(3,214,'Professor','','Bernard is amazing! Take anything you can with him. ','',59,NULL,1,2,'2012-08-27 20:19:02','2012-08-27 20:19:02','active',NULL,0,0,0,0),(4,149,'Professor','','Awesome professor. Intro bio is difficult but a great class','',107,NULL,1,2,'2012-09-04 14:35:52','2012-09-13 17:23:15','active',NULL,0,0,0,0),(5,198,'Hubcourse','','Difficult class but definitely rewarding. Maybe the most class I\'ve taken at Oberlin.','',107,NULL,1,2,'2012-09-04 14:37:17','2012-09-04 14:37:17','active',NULL,0,0,0,0),(6,442,'Professor','','Baldoz is the worst professor I\'ve had at Oberlin. He conflates personal experience with sociological evidence in his Intro Soc class, even when discussing subjects that have a substantial body of work around them. His class was incredibly boring and too basic even for a freshman.','',483,NULL,1,2,'2012-10-11 21:22:39','2012-10-11 21:22:39','active',NULL,0,0,0,0),(7,2005,'Hubcourse','','Fun and easy computer-based class! ','',714,NULL,1,2,'2012-11-05 01:47:58','2012-11-05 01:47:58','active',NULL,0,0,0,0),(8,1006,'Hubcourse','','Huge lecture, make lots of friends. Don\'t assume you\'ll ace it just because you liked AP Biology.','',714,NULL,1,2,'2012-11-05 01:49:01','2012-11-10 17:03:27','active',NULL,1,1,0,0),(9,575,'Professor','','Laid back dude!','',714,NULL,1,2,'2012-11-05 01:50:08','2012-11-05 01:50:08','active',NULL,0,0,0,0),(10,159,'Professor','','Take his classes while he is still on campus, Mark Braford is great.','',714,NULL,1,2,'2012-11-05 01:51:01','2013-01-28 20:05:03','active',NULL,1,1,0,0),(11,649,'Hubcourse','','Mostly looking at slides and preserved specimens, drawing things, move at your own pace. Kill and dissect your first rat.','',714,NULL,1,2,'2012-11-05 01:52:20','2012-11-05 01:52:20','active',NULL,0,0,0,0),(12,388,'Professor','','Loose is a very smart and has high expectations of his students, very approachable if you have intelligent questions.','',714,NULL,1,2,'2012-11-05 01:53:56','2012-11-05 01:53:56','active',NULL,0,0,0,0),(13,285,'Hubcourse','','Beware, labs for this class can take up >8 hours of your week. Plan accordingly.','',714,NULL,1,2,'2012-11-05 01:56:26','2015-11-09 14:00:27','active',NULL,7,7,0,0),(14,284,'Hubcourse','','Super fun and easy intro to programming if you have a naturally logical mind! If you\'re not very mathematically inclined it might be more challenging.','',714,NULL,1,2,'2012-11-05 01:57:13','2015-11-03 19:33:46','active',NULL,7,7,0,0),(15,438,'Professor','','Friendly prof and teaches about interesting things, loves to chat casually in office hours.','',714,NULL,1,2,'2012-11-05 01:58:23','2012-11-05 01:58:23','active',NULL,0,0,0,0),(16,933,'Hubcourse','','Interesting subject material, with labs on fossil identification, videos to watch, and latin species names to memorize. Very science-lite if you already study biology though.','',714,NULL,1,2,'2012-11-05 02:00:24','2012-11-05 02:00:24','active',NULL,0,0,0,0),(17,224,'Hubcourse','','It\'s organic chemistry. Do the problem sets, look for the patterns.','',714,NULL,1,2,'2012-11-05 02:01:29','2012-11-05 02:01:29','active',NULL,0,0,0,0),(18,209,'Professor','','Deb Vogel is a wonderful woman, cares deeply about student\'s mind and body health, and does a lot of interesting things! Take her classes.','',714,NULL,1,2,'2012-11-05 02:03:16','2012-11-05 02:03:16','active',NULL,0,0,0,0),(19,1006,'Hubcourse','','This is a weed-out course. Beware, the exams are very hard. ','',586,NULL,3,4,'2012-11-10 17:03:48','2012-11-10 17:03:48','active',NULL,0,0,0,0),(20,1794,'Hubcourse','','Very intense class. Perfect if you dig Mahler. Darcy goes into such great detail you will never listen to Mahler the same. \r\nGreat class. ','',586,NULL,1,2,'2012-11-10 17:05:39','2012-11-10 17:05:39','active',NULL,0,0,0,0),(21,1283,'Hubcourse','','This is a terrible class. Macdonald has difficulty answering questions accurately. There are typos in all the slides. It is an easy A but I learned nothing. ','',586,NULL,1,2,'2012-11-10 17:07:37','2012-11-10 17:07:37','active',NULL,0,0,0,0),(22,196,'Hubcourse','','This is a test.','',692,NULL,1,2,'2013-02-05 21:38:39','2013-02-11 20:46:54','removed',NULL,0,0,0,0),(23,196,'Hubcourse','','This is a test.','',692,NULL,3,4,'2013-02-05 21:38:44','2013-02-11 20:46:52','removed',NULL,0,0,0,0),(24,196,'Hubcourse','','This is a test.','',692,NULL,5,6,'2013-02-05 21:38:45','2013-02-11 20:46:51','removed',NULL,0,0,0,0),(25,196,'Hubcourse','','This is a test.','',692,NULL,7,8,'2013-02-05 21:38:45','2013-02-11 20:46:50','removed',NULL,0,0,0,0),(26,196,'Hubcourse','','This is a test.','',692,NULL,9,10,'2013-02-05 21:38:45','2013-02-11 20:46:48','removed',NULL,0,0,0,0),(27,196,'Hubcourse','','This is a test.','',692,NULL,11,12,'2013-02-05 21:38:45','2013-02-11 20:46:46','removed',NULL,0,0,0,0),(28,234,'Professor','','Hello I\'m testing please ignore this','',692,NULL,1,4,'2013-02-05 21:44:44','2015-10-07 03:27:29','active',NULL,3,1,2,0),(29,2128,'Hubcourse','','Great fun!','',2,NULL,1,2,'2013-02-09 17:55:04','2013-02-09 17:55:04','active',NULL,0,0,0,0),(30,2128,'Hubcourse','','Great fun!','',2,NULL,3,4,'2013-02-09 17:55:18','2013-02-09 17:55:18','active',NULL,0,0,0,0),(31,2128,'Hubcourse','','Great fun!','',2,NULL,5,6,'2013-02-09 17:55:38','2013-02-09 17:55:38','active',NULL,0,0,0,0),(32,2128,'Hubcourse','','Great fun!','',2,NULL,7,8,'2013-02-09 17:55:38','2013-02-09 17:55:38','active',NULL,0,0,0,0),(33,2128,'Hubcourse','','Great fun!','',2,NULL,9,10,'2013-02-09 17:55:41','2013-02-09 17:55:41','active',NULL,0,0,0,0),(34,2128,'Hubcourse','','Great fun!','',2,NULL,11,12,'2013-02-09 17:55:41','2013-02-09 17:55:41','active',NULL,0,0,0,0),(35,726,'Professor','','How is he?','',1267,NULL,1,2,'2013-04-22 00:59:32','2013-04-22 00:59:32','active',NULL,0,0,0,0),(36,897,'Hubcourse','','THEA 199 is currently listed as a 4-credit class, but it is actually for 0 credits.','',350,NULL,1,2,'2014-11-11 07:47:21','2014-11-11 07:47:21','active',NULL,0,0,0,0),(37,234,'Professor','','Hi Megan','',11,28,2,3,'2015-03-14 20:23:46','2015-10-07 03:27:31','active',NULL,1,0,1,0),(39,1336,'Hubcourse','','First choice class for POLT','',3254,NULL,1,2,'2015-11-03 18:46:05','2015-11-03 18:46:05','active',NULL,0,0,0,0);
/*!40000 ALTER TABLE `comments` ENABLE KEYS */;
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
