-- MySQL dump 10.16  Distrib 10.1.48-MariaDB, for debian-linux-gnu (x86_64)
--
-- Host: localhost    Database: db
-- ------------------------------------------------------
-- Server version	10.1.48-MariaDB-0+deb9u2

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `sqlite_sequence`
--

DROP TABLE IF EXISTS `sqlite_sequence`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sqlite_sequence` (
  `name` varchar(20) DEFAULT NULL,
  `seq` smallint(6) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sqlite_sequence`
--

LOCK TABLES `sqlite_sequence` WRITE;
/*!40000 ALTER TABLE `sqlite_sequence` DISABLE KEYS */;
INSERT INTO `sqlite_sequence` VALUES ('symfony_demo_user',3),('symfony_demo_tag',9),('symfony_demo_post',30),('symfony_demo_comment',150);
/*!40000 ALTER TABLE `sqlite_sequence` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `symfony_demo_post_tag`
--

DROP TABLE IF EXISTS `symfony_demo_post_tag`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `symfony_demo_post_tag` (
  `post_id` tinyint(4) DEFAULT NULL,
  `tag_id` tinyint(4) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `symfony_demo_post_tag`
--

LOCK TABLES `symfony_demo_post_tag` WRITE;
/*!40000 ALTER TABLE `symfony_demo_post_tag` DISABLE KEYS */;
INSERT INTO `symfony_demo_post_tag` VALUES (1,1),(1,8),(2,2),(2,4),(3,4),(3,9),(4,2),(4,3),(4,5),(5,1),(5,4),(5,8),(6,4),(6,5),(6,7),(7,1),(7,7),(7,8),(8,2),(8,4),(8,7),(8,8),(9,4),(9,8),(9,9),(10,4),(10,7),(11,5),(11,7),(12,1),(12,7),(13,1),(13,3),(13,4),(13,9),(14,4),(14,6),(14,7),(14,9),(15,3),(15,6),(16,2),(16,7),(16,8),(17,4),(17,7),(17,8),(18,1),(18,4),(18,7),(19,2),(19,3),(19,5),(19,6),(20,5),(20,7),(20,8),(21,1),(21,4),(21,5),(21,8),(22,1),(22,2),(22,5),(22,8),(23,5),(23,6),(23,7),(23,8),(24,8),(24,9),(25,2),(25,4),(25,6),(25,9),(26,3),(26,5),(27,6),(27,7),(28,1),(28,2),(29,7),(29,8),(30,5),(30,7),(30,8);
/*!40000 ALTER TABLE `symfony_demo_post_tag` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `symfony_demo_tag`
--

DROP TABLE IF EXISTS `symfony_demo_tag`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `symfony_demo_tag` (
  `id` tinyint(4) DEFAULT NULL,
  `name` varchar(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `symfony_demo_tag`
--

LOCK TABLES `symfony_demo_tag` WRITE;
/*!40000 ALTER TABLE `symfony_demo_tag` DISABLE KEYS */;
INSERT INTO `symfony_demo_tag` VALUES (4,'adipiscing'),(3,'consectetur'),(8,'dolore'),(5,'incididunt'),(2,'ipsum'),(6,'labore'),(1,'lorem'),(9,'pariatur'),(7,'voluptate');
/*!40000 ALTER TABLE `symfony_demo_tag` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2024-04-30 16:42:41
