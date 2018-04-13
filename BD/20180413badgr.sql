-- MySQL dump 10.13  Distrib 5.7.21, for Linux (x86_64)
--
-- Host: localhost    Database: badgr
-- ------------------------------------------------------
-- Server version	5.7.21-0ubuntu0.16.04.1

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
-- Table structure for table `account_emailaddress`
--

DROP TABLE IF EXISTS `account_emailaddress`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `account_emailaddress` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `email` varchar(254),
  `verified` tinyint(1) NOT NULL,
  `primary` tinyint(1) NOT NULL,
  `user_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `email` (`email`),
  KEY `account_emailaddress_e8701ad4` (`user_id`),
  CONSTRAINT `account_emailaddress_user_id_5c85949e40d9a61d_fk_users_id` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `account_emailaddress`
--

LOCK TABLES `account_emailaddress` WRITE;
/*!40000 ALTER TABLE `account_emailaddress` DISABLE KEYS */;
INSERT INTO `account_emailaddress` VALUES (1,'lyera@ceibal.edu.uy',1,1,1);
/*!40000 ALTER TABLE `account_emailaddress` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `account_emailconfirmation`
--

DROP TABLE IF EXISTS `account_emailconfirmation`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `account_emailconfirmation` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `created` datetime NOT NULL,
  `sent` datetime DEFAULT NULL,
  `key` varchar(64) NOT NULL,
  `email_address_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `key` (`key`),
  KEY `account_emailconfirmation_6f1edeac` (`email_address_id`),
  CONSTRAINT `acc_email_address_id_5bcf9f503c32d4d8_fk_account_emailaddress_id` FOREIGN KEY (`email_address_id`) REFERENCES `account_emailaddress` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `account_emailconfirmation`
--

LOCK TABLES `account_emailconfirmation` WRITE;
/*!40000 ALTER TABLE `account_emailconfirmation` DISABLE KEYS */;
INSERT INTO `account_emailconfirmation` VALUES (1,'2018-03-23 19:56:26','2018-03-23 19:56:30','edb6hyegegmncyp4isomcdwinnvcjfheaizetzkfm46mm99jybiltyughm4ujied',1);
/*!40000 ALTER TABLE `account_emailconfirmation` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `auth_group`
--

DROP TABLE IF EXISTS `auth_group`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `auth_group` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(80) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auth_group`
--

LOCK TABLES `auth_group` WRITE;
/*!40000 ALTER TABLE `auth_group` DISABLE KEYS */;
/*!40000 ALTER TABLE `auth_group` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `auth_group_permissions`
--

DROP TABLE IF EXISTS `auth_group_permissions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `auth_group_permissions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `group_id` int(11) NOT NULL,
  `permission_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `group_id` (`group_id`,`permission_id`),
  KEY `auth_group_permissions_0e939a4f` (`group_id`),
  KEY `auth_group_permissions_8373b171` (`permission_id`),
  CONSTRAINT `auth_group__permission_id_1f49ccbbdc69d2fc_fk_auth_permission_id` FOREIGN KEY (`permission_id`) REFERENCES `auth_permission` (`id`),
  CONSTRAINT `auth_group_permission_group_id_689710a9a73b7457_fk_auth_group_id` FOREIGN KEY (`group_id`) REFERENCES `auth_group` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auth_group_permissions`
--

LOCK TABLES `auth_group_permissions` WRITE;
/*!40000 ALTER TABLE `auth_group_permissions` DISABLE KEYS */;
/*!40000 ALTER TABLE `auth_group_permissions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `auth_permission`
--

DROP TABLE IF EXISTS `auth_permission`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `auth_permission` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(50) NOT NULL,
  `content_type_id` int(11) NOT NULL,
  `codename` varchar(100) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `content_type_id` (`content_type_id`,`codename`),
  KEY `auth_permission_417f1b1c` (`content_type_id`),
  CONSTRAINT `auth__content_type_id_508cf46651277a81_fk_django_content_type_id` FOREIGN KEY (`content_type_id`) REFERENCES `django_content_type` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=103 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auth_permission`
--

LOCK TABLES `auth_permission` WRITE;
/*!40000 ALTER TABLE `auth_permission` DISABLE KEYS */;
INSERT INTO `auth_permission` VALUES (1,'Can add permission',1,'add_permission'),(2,'Can change permission',1,'change_permission'),(3,'Can delete permission',1,'delete_permission'),(4,'Can add group',2,'add_group'),(5,'Can change group',2,'change_group'),(6,'Can delete group',2,'delete_group'),(7,'Can add content type',3,'add_contenttype'),(8,'Can change content type',3,'change_contenttype'),(9,'Can delete content type',3,'delete_contenttype'),(10,'Can add session',4,'add_session'),(11,'Can change session',4,'change_session'),(12,'Can delete session',4,'delete_session'),(13,'Can add site',5,'add_site'),(14,'Can change site',5,'change_site'),(15,'Can delete site',5,'delete_site'),(16,'Can add log entry',6,'add_logentry'),(17,'Can change log entry',6,'change_logentry'),(18,'Can delete log entry',6,'delete_logentry'),(19,'Can add cached email address',7,'add_cachedemailaddress'),(20,'Can change cached email address',7,'change_cachedemailaddress'),(21,'Can delete cached email address',7,'delete_cachedemailaddress'),(22,'Can add badge user',8,'add_badgeuser'),(23,'Can change badge user',8,'change_badgeuser'),(24,'Can delete badge user',8,'delete_badgeuser'),(25,'Can add email address',7,'add_emailaddress'),(26,'Can change email address',7,'change_emailaddress'),(27,'Can delete email address',7,'delete_emailaddress'),(28,'Can add email confirmation',10,'add_emailconfirmation'),(29,'Can change email confirmation',10,'change_emailconfirmation'),(30,'Can delete email confirmation',10,'delete_emailconfirmation'),(31,'Can add revision',11,'add_revision'),(32,'Can change revision',11,'change_revision'),(33,'Can delete revision',11,'delete_revision'),(34,'Can add version',12,'add_version'),(35,'Can change version',12,'change_version'),(36,'Can delete version',12,'delete_version'),(37,'Can add token',13,'add_token'),(38,'Can change token',13,'change_token'),(39,'Can delete token',13,'delete_token'),(40,'Can add email blacklist',14,'add_emailblacklist'),(41,'Can change email blacklist',14,'change_emailblacklist'),(42,'Can delete email blacklist',14,'delete_emailblacklist'),(43,'Can add issuer',15,'add_issuer'),(44,'Can change issuer',15,'change_issuer'),(45,'Can delete issuer',15,'delete_issuer'),(46,'Can add issuer staff',16,'add_issuerstaff'),(47,'Can change issuer staff',16,'change_issuerstaff'),(48,'Can delete issuer staff',16,'delete_issuerstaff'),(49,'Can add badge class',17,'add_badgeclass'),(50,'Can change badge class',17,'change_badgeclass'),(51,'Can delete badge class',17,'delete_badgeclass'),(52,'Can add badge instance',18,'add_badgeinstance'),(53,'Can change badge instance',18,'change_badgeinstance'),(54,'Can delete badge instance',18,'delete_badgeinstance'),(55,'Can add local issuer',19,'add_localissuer'),(56,'Can change local issuer',19,'change_localissuer'),(57,'Can delete local issuer',19,'delete_localissuer'),(58,'Can add local badge class',20,'add_localbadgeclass'),(59,'Can change local badge class',20,'change_localbadgeclass'),(60,'Can delete local badge class',20,'delete_localbadgeclass'),(61,'Can add local badge instance',21,'add_localbadgeinstance'),(62,'Can change local badge instance',21,'change_localbadgeinstance'),(63,'Can delete local badge instance',21,'delete_localbadgeinstance'),(64,'Can add collection',22,'add_collection'),(65,'Can change collection',22,'change_collection'),(66,'Can delete collection',22,'delete_collection'),(67,'Can add BadgeInstance in a Collection',23,'add_localbadgeinstancecollection'),(68,'Can change BadgeInstance in a Collection',23,'change_localbadgeinstancecollection'),(69,'Can delete BadgeInstance in a Collection',23,'delete_localbadgeinstancecollection'),(70,'Can add collection permission',24,'add_collectionpermission'),(71,'Can change collection permission',24,'change_collectionpermission'),(72,'Can delete collection permission',24,'delete_collectionpermission'),(73,'Can add collection',25,'add_collection'),(74,'Can change collection',25,'change_collection'),(75,'Can delete collection',25,'delete_collection'),(76,'Can add stored badge instance collection',26,'add_storedbadgeinstancecollection'),(77,'Can change stored badge instance collection',26,'change_storedbadgeinstancecollection'),(78,'Can delete stored badge instance collection',26,'delete_storedbadgeinstancecollection'),(79,'Can add collection permission',27,'add_collectionpermission'),(80,'Can change collection permission',27,'change_collectionpermission'),(81,'Can delete collection permission',27,'delete_collectionpermission'),(82,'Can add stored issuer',28,'add_storedissuer'),(83,'Can change stored issuer',28,'change_storedissuer'),(84,'Can delete stored issuer',28,'delete_storedissuer'),(85,'Can add stored badge class',29,'add_storedbadgeclass'),(86,'Can change stored badge class',29,'change_storedbadgeclass'),(87,'Can delete stored badge class',29,'delete_storedbadgeclass'),(88,'Can add stored badge instance',30,'add_storedbadgeinstance'),(89,'Can change stored badge instance',30,'change_storedbadgeinstance'),(90,'Can delete stored badge instance',30,'delete_storedbadgeinstance'),(91,'Can add family class',31,'add_familyclass'),(92,'Can change family class',31,'change_familyclass'),(93,'Can delete family class',31,'delete_familyclass'),(94,'Can add category class',32,'add_categoryclass'),(95,'Can change category class',32,'change_categoryclass'),(96,'Can delete category class',32,'delete_categoryclass'),(97,'Can add local family class',33,'add_localfamilyclass'),(98,'Can change local family class',33,'change_localfamilyclass'),(99,'Can delete local family class',33,'delete_localfamilyclass'),(100,'Can add local category class',34,'add_localcategoryclass'),(101,'Can change local category class',34,'change_localcategoryclass'),(102,'Can delete local category class',34,'delete_localcategoryclass');
/*!40000 ALTER TABLE `auth_permission` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `authtoken_token`
--

DROP TABLE IF EXISTS `authtoken_token`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `authtoken_token` (
  `key` varchar(40) NOT NULL,
  `created` datetime NOT NULL,
  `user_id` int(11) NOT NULL,
  PRIMARY KEY (`key`),
  UNIQUE KEY `user_id` (`user_id`),
  CONSTRAINT `authtoken_token_user_id_1d10c57f535fb363_fk_users_id` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `authtoken_token`
--

LOCK TABLES `authtoken_token` WRITE;
/*!40000 ALTER TABLE `authtoken_token` DISABLE KEYS */;
INSERT INTO `authtoken_token` VALUES ('c261acd9e251e1993bfff08eacdd4df2c40e2c4f','2018-03-23 19:56:05',1);
/*!40000 ALTER TABLE `authtoken_token` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `composer_collection`
--

DROP TABLE IF EXISTS `composer_collection`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `composer_collection` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(128) NOT NULL,
  `slug` varchar(128) NOT NULL,
  `description` varchar(255) NOT NULL,
  `owner_id` int(11),
  `share_hash` varchar(255) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `composer_collection_recipient_id_7eb8f2558b2983e2_uniq` (`owner_id`,`slug`),
  KEY `composer_collection_2dbcba41` (`slug`),
  KEY `composer_collection_8b938c66` (`owner_id`),
  CONSTRAINT `composer_collection_owner_id_6aada90143506d2c_fk_users_id` FOREIGN KEY (`owner_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `composer_collection`
--

LOCK TABLES `composer_collection` WRITE;
/*!40000 ALTER TABLE `composer_collection` DISABLE KEYS */;
/*!40000 ALTER TABLE `composer_collection` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `composer_collectionpermission`
--

DROP TABLE IF EXISTS `composer_collectionpermission`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `composer_collectionpermission` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `can_write` tinyint(1),
  `collection_id` int(11) NOT NULL,
  `user_id` int(11),
  PRIMARY KEY (`id`),
  UNIQUE KEY `composer_collectionpermission_viewer_id_ff452a9f642fa71_uniq` (`user_id`,`collection_id`),
  KEY `composer_collectionpermission_0a1a4dd8` (`collection_id`),
  KEY `composer_collectionpermission_558d297a` (`user_id`),
  CONSTRAINT `compose_collection_id_4e36785e27f93f39_fk_composer_collection_id` FOREIGN KEY (`collection_id`) REFERENCES `composer_collection` (`id`),
  CONSTRAINT `composer_collectionpermissi_user_id_6c3c6f8fd3fbb9a6_fk_users_id` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `composer_collectionpermission`
--

LOCK TABLES `composer_collectionpermission` WRITE;
/*!40000 ALTER TABLE `composer_collectionpermission` DISABLE KEYS */;
/*!40000 ALTER TABLE `composer_collectionpermission` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `composer_storedbadgeinstancecollection`
--

DROP TABLE IF EXISTS `composer_storedbadgeinstancecollection`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `composer_storedbadgeinstancecollection` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `description` longtext NOT NULL,
  `collection_id` int(11) NOT NULL,
  `instance_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `composer_storedbadgeinstanceco_instance_id_7abff86b72f36ef1_uniq` (`instance_id`,`collection_id`),
  KEY `composer_storedbadgeinstancecollection_0a1a4dd8` (`collection_id`),
  KEY `composer_storedbadgeinstancecollection_51afcc4f` (`instance_id`),
  CONSTRAINT `D6cafefb2250212c0fbf0300586c62c5` FOREIGN KEY (`instance_id`) REFERENCES `credential_store_storedbadgeinstance` (`id`),
  CONSTRAINT `compose_collection_id_7c105304823a9832_fk_composer_collection_id` FOREIGN KEY (`collection_id`) REFERENCES `composer_collection` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `composer_storedbadgeinstancecollection`
--

LOCK TABLES `composer_storedbadgeinstancecollection` WRITE;
/*!40000 ALTER TABLE `composer_storedbadgeinstancecollection` DISABLE KEYS */;
/*!40000 ALTER TABLE `composer_storedbadgeinstancecollection` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `composition_collection`
--

DROP TABLE IF EXISTS `composition_collection`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `composition_collection` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(128) NOT NULL,
  `slug` varchar(128) NOT NULL,
  `description` varchar(255) NOT NULL,
  `share_hash` varchar(255) NOT NULL,
  `owner_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `composition_collection_owner_id_6d6b6b9fd6edbbcd_uniq` (`owner_id`,`slug`),
  KEY `composition_collection_2dbcba41` (`slug`),
  KEY `composition_collection_5e7b1936` (`owner_id`),
  CONSTRAINT `composition_collection_owner_id_3435fb01efd8b879_fk_users_id` FOREIGN KEY (`owner_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `composition_collection`
--

LOCK TABLES `composition_collection` WRITE;
/*!40000 ALTER TABLE `composition_collection` DISABLE KEYS */;
/*!40000 ALTER TABLE `composition_collection` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `composition_collectionpermission`
--

DROP TABLE IF EXISTS `composition_collectionpermission`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `composition_collectionpermission` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `can_write` tinyint(1) NOT NULL,
  `collection_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `composition_collectionpermission_user_id_5feef460e2152193_uniq` (`user_id`,`collection_id`),
  KEY `composition_collectionpermission_0a1a4dd8` (`collection_id`),
  KEY `composition_collectionpermission_e8701ad4` (`user_id`),
  CONSTRAINT `comp_collection_id_5357ced01cf7dd40_fk_composition_collection_id` FOREIGN KEY (`collection_id`) REFERENCES `composition_collection` (`id`),
  CONSTRAINT `composition_collectionpermi_user_id_3243447a52b39e21_fk_users_id` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `composition_collectionpermission`
--

LOCK TABLES `composition_collectionpermission` WRITE;
/*!40000 ALTER TABLE `composition_collectionpermission` DISABLE KEYS */;
/*!40000 ALTER TABLE `composition_collectionpermission` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `composition_localbadgeclass`
--

DROP TABLE IF EXISTS `composition_localbadgeclass`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `composition_localbadgeclass` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `created_at` datetime NOT NULL,
  `json` longtext NOT NULL,
  `criteria_text` longtext,
  `image` varchar(100) NOT NULL,
  `name` varchar(255) NOT NULL,
  `slug` varchar(255) NOT NULL,
  `created_by_id` int(11) DEFAULT NULL,
  `issuer_id` int(11) NOT NULL,
  `identifier` varchar(1024) NOT NULL,
  `category` varchar(255) NOT NULL,
  `family` varchar(255) NOT NULL,
  `order` varchar(255) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `slug` (`slug`),
  KEY `composition_localbadgeclass_e93cb7eb` (`created_by_id`),
  KEY `composition_localbadgeclass_dff64d5b` (`issuer_id`),
  CONSTRAINT `composi_issuer_id_3e6788ecbe081223_fk_composition_localissuer_id` FOREIGN KEY (`issuer_id`) REFERENCES `composition_localissuer` (`id`),
  CONSTRAINT `composition_localbadg_created_by_id_52483812e7a7780e_fk_users_id` FOREIGN KEY (`created_by_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `composition_localbadgeclass`
--

LOCK TABLES `composition_localbadgeclass` WRITE;
/*!40000 ALTER TABLE `composition_localbadgeclass` DISABLE KEYS */;
/*!40000 ALTER TABLE `composition_localbadgeclass` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `composition_localbadgeinstance`
--

DROP TABLE IF EXISTS `composition_localbadgeinstance`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `composition_localbadgeinstance` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `created_at` datetime NOT NULL,
  `json` longtext NOT NULL,
  `image` varchar(100) NOT NULL,
  `slug` varchar(255) NOT NULL,
  `revoked` tinyint(1) NOT NULL,
  `revocation_reason` varchar(255) DEFAULT NULL,
  `badgeclass_id` int(11) DEFAULT NULL,
  `created_by_id` int(11) DEFAULT NULL,
  `issuer_id` int(11),
  `recipient_user_id` int(11) NOT NULL,
  `identifier` varchar(1024) NOT NULL,
  `recipient_identifier` varchar(1024) NOT NULL,
  `expires` datetime,
  PRIMARY KEY (`id`),
  UNIQUE KEY `slug` (`slug`),
  KEY `composition_localbadgeinstance_6384308d` (`badgeclass_id`),
  KEY `composition_localbadgeinstance_e93cb7eb` (`created_by_id`),
  KEY `composition_localbadgeinstance_dff64d5b` (`issuer_id`),
  KEY `composition_localbadgeinstance_e920584d` (`recipient_user_id`),
  CONSTRAINT `D66ac1af40edd2256449b8a07fac026c` FOREIGN KEY (`badgeclass_id`) REFERENCES `composition_localbadgeclass` (`id`),
  CONSTRAINT `composi_issuer_id_3afcb8f3eee4c5dd_fk_composition_localissuer_id` FOREIGN KEY (`issuer_id`) REFERENCES `composition_localissuer` (`id`),
  CONSTRAINT `composition_local_recipient_user_id_10bd36a977915c9d_fk_users_id` FOREIGN KEY (`recipient_user_id`) REFERENCES `users` (`id`),
  CONSTRAINT `composition_localbadg_created_by_id_4a6e612e967a8c38_fk_users_id` FOREIGN KEY (`created_by_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `composition_localbadgeinstance`
--

LOCK TABLES `composition_localbadgeinstance` WRITE;
/*!40000 ALTER TABLE `composition_localbadgeinstance` DISABLE KEYS */;
/*!40000 ALTER TABLE `composition_localbadgeinstance` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `composition_localbadgeinstancecollection`
--

DROP TABLE IF EXISTS `composition_localbadgeinstancecollection`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `composition_localbadgeinstancecollection` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `description` longtext NOT NULL,
  `collection_id` int(11) NOT NULL,
  `instance_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `composition_localbadgeinstancec_instance_id_2529964ec91edaf_uniq` (`instance_id`,`collection_id`),
  KEY `composition_localbadgeinstancecollection_0a1a4dd8` (`collection_id`),
  KEY `composition_localbadgeinstancecollection_51afcc4f` (`instance_id`),
  CONSTRAINT `D8fc00ddee9ff48aa9d9f2a2033def92` FOREIGN KEY (`instance_id`) REFERENCES `composition_localbadgeinstance` (`id`),
  CONSTRAINT `comp_collection_id_68aa446087b7a652_fk_composition_collection_id` FOREIGN KEY (`collection_id`) REFERENCES `composition_collection` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `composition_localbadgeinstancecollection`
--

LOCK TABLES `composition_localbadgeinstancecollection` WRITE;
/*!40000 ALTER TABLE `composition_localbadgeinstancecollection` DISABLE KEYS */;
/*!40000 ALTER TABLE `composition_localbadgeinstancecollection` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `composition_localcategoryclass`
--

DROP TABLE IF EXISTS `composition_localcategoryclass`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `composition_localcategoryclass` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `created_at` datetime NOT NULL,
  `identifier` varchar(1024) NOT NULL,
  `json` longtext NOT NULL,
  `name` varchar(255) NOT NULL,
  `slug` varchar(255) NOT NULL,
  `created_by_id` int(11) DEFAULT NULL,
  `family_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `slug` (`slug`),
  KEY `composition_localcategoryclass_e93cb7eb` (`created_by_id`),
  KEY `composition_localcategoryclass_0caa70f7` (`family_id`),
  CONSTRAINT `com_family_id_7cfa8b50839325c_fk_composition_localfamilyclass_id` FOREIGN KEY (`family_id`) REFERENCES `composition_localfamilyclass` (`id`),
  CONSTRAINT `composition_localcate_created_by_id_4ad9b08b1a2b113c_fk_users_id` FOREIGN KEY (`created_by_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `composition_localcategoryclass`
--

LOCK TABLES `composition_localcategoryclass` WRITE;
/*!40000 ALTER TABLE `composition_localcategoryclass` DISABLE KEYS */;
/*!40000 ALTER TABLE `composition_localcategoryclass` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `composition_localfamilyclass`
--

DROP TABLE IF EXISTS `composition_localfamilyclass`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `composition_localfamilyclass` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `created_at` datetime NOT NULL,
  `identifier` varchar(1024) NOT NULL,
  `json` longtext NOT NULL,
  `name` varchar(255) NOT NULL,
  `slug` varchar(255) NOT NULL,
  `created_by_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `slug` (`slug`),
  KEY `composition_localfamilyclass_e93cb7eb` (`created_by_id`),
  CONSTRAINT `composition_localfami_created_by_id_3caf8f40f1a50a1e_fk_users_id` FOREIGN KEY (`created_by_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `composition_localfamilyclass`
--

LOCK TABLES `composition_localfamilyclass` WRITE;
/*!40000 ALTER TABLE `composition_localfamilyclass` DISABLE KEYS */;
/*!40000 ALTER TABLE `composition_localfamilyclass` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `composition_localissuer`
--

DROP TABLE IF EXISTS `composition_localissuer`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `composition_localissuer` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `created_at` datetime NOT NULL,
  `json` longtext NOT NULL,
  `image` varchar(100),
  `name` varchar(1024) NOT NULL,
  `slug` varchar(255) NOT NULL,
  `created_by_id` int(11) DEFAULT NULL,
  `identifier` varchar(1024) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `slug` (`slug`),
  KEY `composition_localissuer_e93cb7eb` (`created_by_id`),
  CONSTRAINT `composition_localissu_created_by_id_34f151aed2bb1330_fk_users_id` FOREIGN KEY (`created_by_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `composition_localissuer`
--

LOCK TABLES `composition_localissuer` WRITE;
/*!40000 ALTER TABLE `composition_localissuer` DISABLE KEYS */;
/*!40000 ALTER TABLE `composition_localissuer` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `credential_store_storedbadgeclass`
--

DROP TABLE IF EXISTS `credential_store_storedbadgeclass`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `credential_store_storedbadgeclass` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `json` longtext NOT NULL,
  `errors` longtext NOT NULL,
  `url` varchar(1024) NOT NULL,
  `issuer_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `credential_store_storedbadgeclass_dff64d5b` (`issuer_id`),
  CONSTRAINT `c_issuer_id_21c25b3889ccba76_fk_credential_store_storedissuer_id` FOREIGN KEY (`issuer_id`) REFERENCES `credential_store_storedissuer` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `credential_store_storedbadgeclass`
--

LOCK TABLES `credential_store_storedbadgeclass` WRITE;
/*!40000 ALTER TABLE `credential_store_storedbadgeclass` DISABLE KEYS */;
/*!40000 ALTER TABLE `credential_store_storedbadgeclass` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `credential_store_storedbadgeinstance`
--

DROP TABLE IF EXISTS `credential_store_storedbadgeinstance`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `credential_store_storedbadgeinstance` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `json` longtext NOT NULL,
  `errors` longtext NOT NULL,
  `url` varchar(1024) NOT NULL,
  `recipient_id` varchar(1024) NOT NULL,
  `badgeclass_id` int(11) DEFAULT NULL,
  `issuer_id` int(11),
  `recipient_user_id` int(11),
  `image` varchar(100),
  PRIMARY KEY (`id`),
  KEY `credential_store_storedbadgeinstance_6384308d` (`badgeclass_id`),
  KEY `credential_store_storedbadgeinstance_dff64d5b` (`issuer_id`),
  KEY `credential_store_storedbadgeinstance_e920584d` (`recipient_user_id`),
  CONSTRAINT `c_issuer_id_7147b1e0368f9de2_fk_credential_store_storedissuer_id` FOREIGN KEY (`issuer_id`) REFERENCES `credential_store_storedissuer` (`id`),
  CONSTRAINT `credential_store__recipient_user_id_2e13e6bb779dc0a2_fk_users_id` FOREIGN KEY (`recipient_user_id`) REFERENCES `users` (`id`),
  CONSTRAINT `f11b67aac9eecca76a30d9d5b033e94c` FOREIGN KEY (`badgeclass_id`) REFERENCES `credential_store_storedbadgeclass` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `credential_store_storedbadgeinstance`
--

LOCK TABLES `credential_store_storedbadgeinstance` WRITE;
/*!40000 ALTER TABLE `credential_store_storedbadgeinstance` DISABLE KEYS */;
/*!40000 ALTER TABLE `credential_store_storedbadgeinstance` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `credential_store_storedissuer`
--

DROP TABLE IF EXISTS `credential_store_storedissuer`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `credential_store_storedissuer` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `json` longtext NOT NULL,
  `errors` longtext NOT NULL,
  `url` varchar(1024) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `credential_store_storedissuer`
--

LOCK TABLES `credential_store_storedissuer` WRITE;
/*!40000 ALTER TABLE `credential_store_storedissuer` DISABLE KEYS */;
/*!40000 ALTER TABLE `credential_store_storedissuer` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `django_admin_log`
--

DROP TABLE IF EXISTS `django_admin_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `django_admin_log` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `action_time` datetime NOT NULL,
  `object_id` longtext,
  `object_repr` varchar(200) NOT NULL,
  `action_flag` smallint(5) unsigned NOT NULL,
  `change_message` longtext NOT NULL,
  `content_type_id` int(11) DEFAULT NULL,
  `user_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `django_admin_log_417f1b1c` (`content_type_id`),
  KEY `django_admin_log_e8701ad4` (`user_id`),
  CONSTRAINT `djang_content_type_id_697914295151027a_fk_django_content_type_id` FOREIGN KEY (`content_type_id`) REFERENCES `django_content_type` (`id`),
  CONSTRAINT `django_admin_log_user_id_52fdd58701c5f563_fk_users_id` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `django_admin_log`
--

LOCK TABLES `django_admin_log` WRITE;
/*!40000 ALTER TABLE `django_admin_log` DISABLE KEYS */;
INSERT INTO `django_admin_log` VALUES (1,'2018-03-26 12:03:35','1','PAM',1,'',31,1),(2,'2018-03-26 12:03:50','2','CREA',1,'',31,1),(3,'2018-03-26 12:04:34','1','Category 1',1,'',32,1),(4,'2018-03-26 12:05:24','2','Category 2',1,'',32,1);
/*!40000 ALTER TABLE `django_admin_log` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `django_content_type`
--

DROP TABLE IF EXISTS `django_content_type`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `django_content_type` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `app_label` varchar(100) NOT NULL,
  `model` varchar(100) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `django_content_type_app_label_45f3b1d93ec8c61c_uniq` (`app_label`,`model`)
) ENGINE=InnoDB AUTO_INCREMENT=35 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `django_content_type`
--

LOCK TABLES `django_content_type` WRITE;
/*!40000 ALTER TABLE `django_content_type` DISABLE KEYS */;
INSERT INTO `django_content_type` VALUES (1,'permission','auth','permission'),(2,'group','auth','group'),(3,'content type','contenttypes','contenttype'),(4,'session','sessions','session'),(5,'site','sites','site'),(6,'log entry','admin','logentry'),(7,'email address','account','emailaddress'),(8,'badge user','badgeuser','badgeuser'),(9,'cached email address','badgeuser','cachedemailaddress'),(10,'email confirmation','account','emailconfirmation'),(11,'revision','reversion','revision'),(12,'version','reversion','version'),(13,'token','authtoken','token'),(14,'email blacklist','mainsite','emailblacklist'),(15,'issuer','issuer','issuer'),(16,'issuer staff','issuer','issuerstaff'),(17,'badge class','issuer','badgeclass'),(18,'badge instance','issuer','badgeinstance'),(19,'local issuer','composition','localissuer'),(20,'local badge class','composition','localbadgeclass'),(21,'local badge instance','composition','localbadgeinstance'),(22,'collection','composition','collection'),(23,'BadgeInstance in a Collection','composition','localbadgeinstancecollection'),(24,'collection permission','composition','collectionpermission'),(25,'collection','composer','collection'),(26,'stored badge instance collection','composer','storedbadgeinstancecollection'),(27,'collection permission','composer','collectionpermission'),(28,'stored issuer','credential_store','storedissuer'),(29,'stored badge class','credential_store','storedbadgeclass'),(30,'stored badge instance','credential_store','storedbadgeinstance'),(31,'family class','issuer','familyclass'),(32,'category class','issuer','categoryclass'),(33,'local family class','composition','localfamilyclass'),(34,'local category class','composition','localcategoryclass');
/*!40000 ALTER TABLE `django_content_type` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `django_migrations`
--

DROP TABLE IF EXISTS `django_migrations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `django_migrations` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `app` varchar(255) NOT NULL,
  `name` varchar(255) NOT NULL,
  `applied` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=42 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `django_migrations`
--

LOCK TABLES `django_migrations` WRITE;
/*!40000 ALTER TABLE `django_migrations` DISABLE KEYS */;
INSERT INTO `django_migrations` VALUES (1,'contenttypes','0001_initial','2018-03-23 19:50:53'),(2,'auth','0001_initial','2018-03-23 19:50:58'),(3,'badgeuser','0001_initial','2018-03-23 19:51:05'),(4,'account','0001_initial','2018-03-23 19:51:09'),(5,'account','0002_email_max_length','2018-03-23 19:51:10'),(6,'admin','0001_initial','2018-03-23 19:51:13'),(7,'authtoken','0001_initial','2018-03-23 19:51:15'),(8,'badgeuser','0002_cachedemailaddress','2018-03-23 19:51:15'),(9,'badgeuser','0003_auto_20160309_0820','2018-03-23 19:51:15'),(10,'credential_store','0001_initial','2018-03-23 19:51:27'),(11,'credential_store','0002_auto_20150514_1544','2018-03-23 19:51:29'),(12,'credential_store','0003_storedbadgeinstance_image','2018-03-23 19:51:30'),(13,'composition','0001_initial','2018-03-23 19:51:58'),(14,'composition','0002_auto_20150914_1421','2018-03-23 19:52:02'),(15,'composition','0003_auto_20150914_1447','2018-03-23 19:52:06'),(16,'composition','0004_auto_20150915_1057','2018-03-23 19:52:07'),(17,'credential_store','0004_auto_20150914_2125','2018-03-23 19:52:07'),(18,'composer','0001_initial','2018-03-23 19:52:19'),(19,'composer','0002_auto_20150515_0958','2018-03-23 19:52:19'),(20,'composer','0003_auto_20150605_1320','2018-03-23 19:52:22'),(21,'composer','0004_auto_20150605_1349','2018-03-23 19:52:26'),(22,'composer','0005_collection_share_hash','2018-03-23 19:52:27'),(23,'composer','0006_auto_20150915_1103','2018-03-23 19:52:30'),(24,'composer','0007_auto_20150914_1711','2018-03-23 19:52:31'),(25,'composition','0005_auto_20151117_1555','2018-03-23 19:52:31'),(26,'issuer','0001_initial','2018-03-23 19:52:50'),(27,'issuer','0002_auto_20150409_1200','2018-03-23 19:52:53'),(28,'issuer','0003_auto_20150512_0657','2018-03-23 19:52:53'),(29,'issuer','0004_auto_20150915_1722','2018-03-23 19:53:04'),(30,'issuer','0005_auto_20150915_1723','2018-03-23 19:53:05'),(31,'issuer','0006_remove_badgeinstance_email','2018-03-23 19:53:06'),(32,'issuer','0007_auto_20151117_1555','2018-03-23 19:53:07'),(33,'issuer','0008_auto_20160322_1404','2018-03-23 19:53:10'),(34,'mainsite','0001_initial','2018-03-23 19:53:11'),(35,'reversion','0001_initial','2018-03-23 19:53:18'),(36,'sessions','0001_initial','2018-03-23 19:53:19'),(37,'sites','0001_initial','2018-03-23 19:53:20'),(38,'composition','0006_auto_20180323_1300','2018-03-23 20:06:56'),(39,'issuer','0009_auto_20180323_1300','2018-03-23 20:07:00'),(40,'composition','0007_auto_20180326_0500','2018-03-26 12:01:11'),(41,'issuer','0010_auto_20180326_0500','2018-03-26 12:01:16');
/*!40000 ALTER TABLE `django_migrations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `django_session`
--

DROP TABLE IF EXISTS `django_session`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `django_session` (
  `session_key` varchar(40) NOT NULL,
  `session_data` longtext NOT NULL,
  `expire_date` datetime NOT NULL,
  PRIMARY KEY (`session_key`),
  KEY `django_session_de54fa62` (`expire_date`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `django_session`
--

LOCK TABLES `django_session` WRITE;
/*!40000 ALTER TABLE `django_session` DISABLE KEYS */;
INSERT INTO `django_session` VALUES ('8k37as4e89y3bwnpu45m7d3ht2fn8txa','ODY2ODYyNzgyZjNiZWZjYjc0ODQ1ODIzNGNmYzhkYTU4NDE4Y2ZiMjp7Il9zZXNzaW9uX2V4cGlyeSI6MCwiX2F1dGhfdXNlcl9oYXNoIjoiY2YxODE0MDZmMzc3NDA5ZWE5M2UzYzMxYzY2YzQzZjcxMjg5YWNlNyIsIl9hdXRoX3VzZXJfYmFja2VuZCI6ImFsbGF1dGguYWNjb3VudC5hdXRoX2JhY2tlbmRzLkF1dGhlbnRpY2F0aW9uQmFja2VuZCIsIl9hdXRoX3VzZXJfaWQiOjF9','2018-04-26 12:00:31'),('8l0gudrrc1efxunrcw41vf06q1jnw933','ODY2ODYyNzgyZjNiZWZjYjc0ODQ1ODIzNGNmYzhkYTU4NDE4Y2ZiMjp7Il9zZXNzaW9uX2V4cGlyeSI6MCwiX2F1dGhfdXNlcl9oYXNoIjoiY2YxODE0MDZmMzc3NDA5ZWE5M2UzYzMxYzY2YzQzZjcxMjg5YWNlNyIsIl9hdXRoX3VzZXJfYmFja2VuZCI6ImFsbGF1dGguYWNjb3VudC5hdXRoX2JhY2tlbmRzLkF1dGhlbnRpY2F0aW9uQmFja2VuZCIsIl9hdXRoX3VzZXJfaWQiOjF9','2018-04-24 14:47:51'),('atm4ajj5h5kqmft23vu04n2w17jxaxrw','ODY2ODYyNzgyZjNiZWZjYjc0ODQ1ODIzNGNmYzhkYTU4NDE4Y2ZiMjp7Il9zZXNzaW9uX2V4cGlyeSI6MCwiX2F1dGhfdXNlcl9oYXNoIjoiY2YxODE0MDZmMzc3NDA5ZWE5M2UzYzMxYzY2YzQzZjcxMjg5YWNlNyIsIl9hdXRoX3VzZXJfYmFja2VuZCI6ImFsbGF1dGguYWNjb3VudC5hdXRoX2JhY2tlbmRzLkF1dGhlbnRpY2F0aW9uQmFja2VuZCIsIl9hdXRoX3VzZXJfaWQiOjF9','2018-04-20 13:53:31'),('f2akive9o7f3u2jr1wvzljo16xa4cr96','ODY2ODYyNzgyZjNiZWZjYjc0ODQ1ODIzNGNmYzhkYTU4NDE4Y2ZiMjp7Il9zZXNzaW9uX2V4cGlyeSI6MCwiX2F1dGhfdXNlcl9oYXNoIjoiY2YxODE0MDZmMzc3NDA5ZWE5M2UzYzMxYzY2YzQzZjcxMjg5YWNlNyIsIl9hdXRoX3VzZXJfYmFja2VuZCI6ImFsbGF1dGguYWNjb3VudC5hdXRoX2JhY2tlbmRzLkF1dGhlbnRpY2F0aW9uQmFja2VuZCIsIl9hdXRoX3VzZXJfaWQiOjF9','2018-04-24 12:51:45'),('fek1nq4ru9dolitdb32v9kymt7m7wget','ZDZkMjkzZDRkOTgxY2Y0MzZlMzBhNjg1NTQ5NmQxZjgwYzBkNjVlNTp7Il9hdXRoX3VzZXJfYmFja2VuZCI6ImFsbGF1dGguYWNjb3VudC5hdXRoX2JhY2tlbmRzLkF1dGhlbnRpY2F0aW9uQmFja2VuZCIsIl9hdXRoX3VzZXJfaGFzaCI6ImNmMTgxNDA2ZjM3NzQwOWVhOTNlM2MzMWM2NmM0M2Y3MTI4OWFjZTciLCJfYXV0aF91c2VyX2lkIjoxLCJfc2Vzc2lvbl9leHBpcnkiOjB9','2018-04-06 19:56:44'),('gbxkujl5t90upblw8lg03vhaui9sqmwt','ODY2ODYyNzgyZjNiZWZjYjc0ODQ1ODIzNGNmYzhkYTU4NDE4Y2ZiMjp7Il9zZXNzaW9uX2V4cGlyeSI6MCwiX2F1dGhfdXNlcl9oYXNoIjoiY2YxODE0MDZmMzc3NDA5ZWE5M2UzYzMxYzY2YzQzZjcxMjg5YWNlNyIsIl9hdXRoX3VzZXJfYmFja2VuZCI6ImFsbGF1dGguYWNjb3VudC5hdXRoX2JhY2tlbmRzLkF1dGhlbnRpY2F0aW9uQmFja2VuZCIsIl9hdXRoX3VzZXJfaWQiOjF9','2018-04-19 14:58:07'),('hdd6d2nnyqf0dimwrfyg277zhs5ux2ij','ODY2ODYyNzgyZjNiZWZjYjc0ODQ1ODIzNGNmYzhkYTU4NDE4Y2ZiMjp7Il9zZXNzaW9uX2V4cGlyeSI6MCwiX2F1dGhfdXNlcl9oYXNoIjoiY2YxODE0MDZmMzc3NDA5ZWE5M2UzYzMxYzY2YzQzZjcxMjg5YWNlNyIsIl9hdXRoX3VzZXJfYmFja2VuZCI6ImFsbGF1dGguYWNjb3VudC5hdXRoX2JhY2tlbmRzLkF1dGhlbnRpY2F0aW9uQmFja2VuZCIsIl9hdXRoX3VzZXJfaWQiOjF9','2018-04-23 15:32:18'),('i1tynmuqd66ahyxgntn5hqywiwkmvjt7','ODY2ODYyNzgyZjNiZWZjYjc0ODQ1ODIzNGNmYzhkYTU4NDE4Y2ZiMjp7Il9zZXNzaW9uX2V4cGlyeSI6MCwiX2F1dGhfdXNlcl9oYXNoIjoiY2YxODE0MDZmMzc3NDA5ZWE5M2UzYzMxYzY2YzQzZjcxMjg5YWNlNyIsIl9hdXRoX3VzZXJfYmFja2VuZCI6ImFsbGF1dGguYWNjb3VudC5hdXRoX2JhY2tlbmRzLkF1dGhlbnRpY2F0aW9uQmFja2VuZCIsIl9hdXRoX3VzZXJfaWQiOjF9','2018-04-09 11:49:21'),('jhh7hz67rabqdr4c7repjeyd77bfe4ib','ODY2ODYyNzgyZjNiZWZjYjc0ODQ1ODIzNGNmYzhkYTU4NDE4Y2ZiMjp7Il9zZXNzaW9uX2V4cGlyeSI6MCwiX2F1dGhfdXNlcl9oYXNoIjoiY2YxODE0MDZmMzc3NDA5ZWE5M2UzYzMxYzY2YzQzZjcxMjg5YWNlNyIsIl9hdXRoX3VzZXJfYmFja2VuZCI6ImFsbGF1dGguYWNjb3VudC5hdXRoX2JhY2tlbmRzLkF1dGhlbnRpY2F0aW9uQmFja2VuZCIsIl9hdXRoX3VzZXJfaWQiOjF9','2018-04-23 12:00:57'),('p6c5oxsy5wb4jwv4r9l33m53av7ehmpr','ODY2ODYyNzgyZjNiZWZjYjc0ODQ1ODIzNGNmYzhkYTU4NDE4Y2ZiMjp7Il9zZXNzaW9uX2V4cGlyeSI6MCwiX2F1dGhfdXNlcl9oYXNoIjoiY2YxODE0MDZmMzc3NDA5ZWE5M2UzYzMxYzY2YzQzZjcxMjg5YWNlNyIsIl9hdXRoX3VzZXJfYmFja2VuZCI6ImFsbGF1dGguYWNjb3VudC5hdXRoX2JhY2tlbmRzLkF1dGhlbnRpY2F0aW9uQmFja2VuZCIsIl9hdXRoX3VzZXJfaWQiOjF9','2018-04-24 15:51:17'),('qdjqywn858yc405aelvfysmjvdsj5hi4','ODY2ODYyNzgyZjNiZWZjYjc0ODQ1ODIzNGNmYzhkYTU4NDE4Y2ZiMjp7Il9zZXNzaW9uX2V4cGlyeSI6MCwiX2F1dGhfdXNlcl9oYXNoIjoiY2YxODE0MDZmMzc3NDA5ZWE5M2UzYzMxYzY2YzQzZjcxMjg5YWNlNyIsIl9hdXRoX3VzZXJfYmFja2VuZCI6ImFsbGF1dGguYWNjb3VudC5hdXRoX2JhY2tlbmRzLkF1dGhlbnRpY2F0aW9uQmFja2VuZCIsIl9hdXRoX3VzZXJfaWQiOjF9','2018-04-19 17:58:09'),('uuukctcirojm3jmm6uo8iqria6webltg','ODY2ODYyNzgyZjNiZWZjYjc0ODQ1ODIzNGNmYzhkYTU4NDE4Y2ZiMjp7Il9zZXNzaW9uX2V4cGlyeSI6MCwiX2F1dGhfdXNlcl9oYXNoIjoiY2YxODE0MDZmMzc3NDA5ZWE5M2UzYzMxYzY2YzQzZjcxMjg5YWNlNyIsIl9hdXRoX3VzZXJfYmFja2VuZCI6ImFsbGF1dGguYWNjb3VudC5hdXRoX2JhY2tlbmRzLkF1dGhlbnRpY2F0aW9uQmFja2VuZCIsIl9hdXRoX3VzZXJfaWQiOjF9','2018-04-18 18:12:53'),('vtr7zk955dq0ycitjk8ok92o8g3htdwm','ODY2ODYyNzgyZjNiZWZjYjc0ODQ1ODIzNGNmYzhkYTU4NDE4Y2ZiMjp7Il9zZXNzaW9uX2V4cGlyeSI6MCwiX2F1dGhfdXNlcl9oYXNoIjoiY2YxODE0MDZmMzc3NDA5ZWE5M2UzYzMxYzY2YzQzZjcxMjg5YWNlNyIsIl9hdXRoX3VzZXJfYmFja2VuZCI6ImFsbGF1dGguYWNjb3VudC5hdXRoX2JhY2tlbmRzLkF1dGhlbnRpY2F0aW9uQmFja2VuZCIsIl9hdXRoX3VzZXJfaWQiOjF9','2018-04-27 12:34:46');
/*!40000 ALTER TABLE `django_session` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `django_site`
--

DROP TABLE IF EXISTS `django_site`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `django_site` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `domain` varchar(100) NOT NULL,
  `name` varchar(50) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `django_site`
--

LOCK TABLES `django_site` WRITE;
/*!40000 ALTER TABLE `django_site` DISABLE KEYS */;
INSERT INTO `django_site` VALUES (1,'example.com','example.com');
/*!40000 ALTER TABLE `django_site` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `issuer_badgeclass`
--

DROP TABLE IF EXISTS `issuer_badgeclass`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `issuer_badgeclass` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `created_at` datetime NOT NULL,
  `json` longtext NOT NULL,
  `name` varchar(255) NOT NULL,
  `slug` varchar(255) NOT NULL,
  `criteria_text` longtext,
  `image` varchar(100) NOT NULL,
  `created_by_id` int(11) DEFAULT NULL,
  `issuer_id` int(11) NOT NULL,
  `identifier` varchar(1024) NOT NULL,
  `category` varchar(255) NOT NULL,
  `family` varchar(255) NOT NULL,
  `order` varchar(255) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `slug` (`slug`),
  KEY `issuer_badgeclass_e93cb7eb` (`created_by_id`),
  KEY `issuer_badgeclass_dff64d5b` (`issuer_id`),
  CONSTRAINT `issuer_badgeclass_created_by_id_740749c76ec272ba_fk_users_id` FOREIGN KEY (`created_by_id`) REFERENCES `users` (`id`),
  CONSTRAINT `issuer_badgeclass_issuer_id_4d6c66e4c1eb4fb7_fk_issuer_issuer_id` FOREIGN KEY (`issuer_id`) REFERENCES `issuer_issuer` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `issuer_badgeclass`
--

LOCK TABLES `issuer_badgeclass` WRITE;
/*!40000 ALTER TABLE `issuer_badgeclass` DISABLE KEYS */;
INSERT INTO `issuer_badgeclass` VALUES (1,'2018-03-26 12:06:17','{\"description\":\"category2\",\"family\":\"PAM\",\"image\":\"http://localhost:8000/public/badges/leyany-badge/image\",\"id\":\"http://localhost:8000/public/badges/leyany-badge\",\"issuer\":\"http://localhost:8000/public/issuers/ceibal\",\"category\":\"Category 1\",\"name\":\"leyany-badge\",\"criteria\":\"http://localhost:8000/public/badges/leyany-badge/criteria\",\"@context\":\"https://w3id.org/openbadges/v1\",\"type\":\"BadgeClass\",\"order\":\"1\"}','leyany-badge','leyany-badge','category2','uploads/badges/issuer_badgeclass_f4bbb5e5-2c4d-4e03-822e-7bbb95c46260.png',1,1,'get_full_url','Category 1','PAM','1'),(2,'2018-03-26 13:09:11','{\"description\":\"test-badge\",\"family\":\"PAM\",\"image\":\"http://localhost:8000/public/badges/test-badge/image\",\"id\":\"http://localhost:8000/public/badges/test-badge\",\"issuer\":\"http://localhost:8000/public/issuers/ceibal\",\"category\":\"Category 1\",\"name\":\"test-badge\",\"criteria\":\"http://localhost:8000/public/badges/test-badge/criteria\",\"@context\":\"https://w3id.org/openbadges/v1\",\"type\":\"BadgeClass\",\"order\":\"1\"}','test-badge','test-badge','test-badge','uploads/badges/issuer_badgeclass_26c22573-84ec-48eb-a26b-5b63e07ee7ce.png',1,1,'get_full_url','Category 1','PAM','1');
/*!40000 ALTER TABLE `issuer_badgeclass` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `issuer_badgeinstance`
--

DROP TABLE IF EXISTS `issuer_badgeinstance`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `issuer_badgeinstance` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `created_at` datetime NOT NULL,
  `json` longtext NOT NULL,
  `slug` varchar(255) NOT NULL,
  `image` varchar(100) NOT NULL,
  `revoked` tinyint(1) NOT NULL,
  `revocation_reason` varchar(255) DEFAULT NULL,
  `badgeclass_id` int(11) NOT NULL,
  `created_by_id` int(11) DEFAULT NULL,
  `issuer_id` int(11) NOT NULL,
  `identifier` varchar(1024) NOT NULL,
  `recipient_identifier` varchar(1024) NOT NULL,
  `expires` datetime,
  PRIMARY KEY (`id`),
  UNIQUE KEY `slug` (`slug`),
  KEY `issuer_badgeinstance_6384308d` (`badgeclass_id`),
  KEY `issuer_badgeinstance_e93cb7eb` (`created_by_id`),
  KEY `issuer_badgeinstance_dff64d5b` (`issuer_id`),
  CONSTRAINT `issuer_ba_badgeclass_id_15a14d5750b4892f_fk_issuer_badgeclass_id` FOREIGN KEY (`badgeclass_id`) REFERENCES `issuer_badgeclass` (`id`),
  CONSTRAINT `issuer_badgeinsta_issuer_id_4eb319bbbd34a005_fk_issuer_issuer_id` FOREIGN KEY (`issuer_id`) REFERENCES `issuer_issuer` (`id`),
  CONSTRAINT `issuer_badgeinstance_created_by_id_6de98ebc55ce9450_fk_users_id` FOREIGN KEY (`created_by_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `issuer_badgeinstance`
--

LOCK TABLES `issuer_badgeinstance` WRITE;
/*!40000 ALTER TABLE `issuer_badgeinstance` DISABLE KEYS */;
INSERT INTO `issuer_badgeinstance` VALUES (1,'2018-03-26 12:48:44','{\"issuedOn\":\"2018-03-26T05:48:44.551804\",\"badge\":\"http://localhost:8000/public/badges/leyany-badge\",\"uid\":\"49464b0a-43ba-46bb-9c16-fdf1f28016e8\",\"recipient\":{\"type\":\"email\",\"salt\":\"fad20335-f49a-41e9-8d8f-173dc4caadfd\",\"hashed\":true,\"identity\":\"sha256$3a9922086d961b629d5ce462f2906e7f43c652a87e31611ce730deb42d1bba49\"},\"image\":\"http://localhost:8000/public/assertions/49464b0a-43ba-46bb-9c16-fdf1f28016e8/image\",\"expires\":\"2019-12-15\",\"badge category\":\"Category 1\",\"badge family\":\"PAM\",\"verify\":{\"url\":\"http://localhost:8000/public/assertions/49464b0a-43ba-46bb-9c16-fdf1f28016e8\",\"type\":\"hosted\"},\"@context\":\"https://w3id.org/openbadges/v1\",\"badge order\":\"1\",\"type\":\"Assertion\",\"id\":\"http://localhost:8000/public/assertions/49464b0a-43ba-46bb-9c16-fdf1f28016e8\"}','49464b0a-43ba-46bb-9c16-fdf1f28016e8','',1,'Manually revoked by issuer.',1,1,1,'get_full_url','lyera@ceibal.edu.uy','2019-12-15 08:00:00'),(2,'2018-03-26 13:08:03','{\"issuedOn\":\"2018-03-26T06:08:03.647917\",\"badge\":\"http://localhost:8000/public/badges/leyany-badge\",\"uid\":\"5c665de1-a052-4b52-ab34-509c2e062c08\",\"recipient\":{\"type\":\"email\",\"salt\":\"6349cffb-6973-4e80-aed4-671e68157c1f\",\"hashed\":true,\"identity\":\"sha256$3d715424af2a1ef763f747a7772fcc7c8c86754207287ef690706a1054378b2a\"},\"image\":\"http://localhost:8000/public/assertions/5c665de1-a052-4b52-ab34-509c2e062c08/image\",\"expires\":null,\"badge category\":\"Category 1\",\"badge family\":\"PAM\",\"verify\":{\"url\":\"http://localhost:8000/public/assertions/5c665de1-a052-4b52-ab34-509c2e062c08\",\"type\":\"hosted\"},\"@context\":\"https://w3id.org/openbadges/v1\",\"badge order\":\"1\",\"type\":\"Assertion\",\"id\":\"http://localhost:8000/public/assertions/5c665de1-a052-4b52-ab34-509c2e062c08\"}','5c665de1-a052-4b52-ab34-509c2e062c08','',1,'Manually revoked by issuer.',1,1,1,'get_full_url','leyany@ceibal.edu.uy',NULL),(3,'2018-03-26 13:09:27','{\"issuedOn\":\"2018-03-26T06:09:27.483165\",\"uid\":\"9a3aa5c3-57df-4c28-b8bb-a241b08b92a9\",\"image\":\"http://localhost:8000/public/assertions/9a3aa5c3-57df-4c28-b8bb-a241b08b92a9/image\",\"expires\":\"2019-12-12\",\"evidence\":\"http://medallas.ceibal.edu.uy:8000/issuer/issuers/test-issuer\",\"type\":\"Assertion\",\"badge order\":\"1\",\"recipient\":{\"salt\":\"59e0bc62-4e33-4438-b82c-9c08c93938dd\",\"type\":\"email\",\"hashed\":true,\"identity\":\"sha256$4b576aa42fb2753a501535068e45dc46fa0568c6cff6ac5c4ec9019d580b2a31\"},\"id\":\"http://localhost:8000/public/assertions/9a3aa5c3-57df-4c28-b8bb-a241b08b92a9\",\"verify\":{\"url\":\"http://localhost:8000/public/assertions/9a3aa5c3-57df-4c28-b8bb-a241b08b92a9\",\"type\":\"hosted\"},\"badge category\":\"Category 1\",\"badge family\":\"PAM\",\"@context\":\"https://w3id.org/openbadges/v1\",\"badge\":\"http://localhost:8000/public/badges/test-badge\"}','9a3aa5c3-57df-4c28-b8bb-a241b08b92a9','uploads/badges/3d76c863c5f2a82566053d53e4db4902.png',0,NULL,2,1,1,'get_full_url','lyera@ceibal.edu.uy','2019-12-12 08:00:00'),(4,'2018-03-26 13:25:08','{\"issuedOn\":\"2018-03-26T06:25:08.014417\",\"badge\":\"http://localhost:8000/public/badges/leyany-badge\",\"uid\":\"1b6fc949-4846-442e-a8c1-1db5add00f5c\",\"recipient\":{\"type\":\"email\",\"salt\":\"df3f1abd-3078-4092-b88f-6e0845424891\",\"hashed\":true,\"identity\":\"sha256$a06b90f46a164ead74670f951e32da9200d5ff54125550a1b7801bb9a16294b7\"},\"image\":\"http://localhost:8000/public/assertions/1b6fc949-4846-442e-a8c1-1db5add00f5c/image\",\"expires\":\"2019-12-12\",\"evidence\":\"http://medallas.ceibal.edu.uy:8000/issuer/issuers/test-issuer\",\"badge category\":\"Category 1\",\"badge family\":\"PAM\",\"verify\":{\"url\":\"http://localhost:8000/public/assertions/1b6fc949-4846-442e-a8c1-1db5add00f5c\",\"type\":\"hosted\"},\"@context\":\"https://w3id.org/openbadges/v1\",\"badge order\":\"1\",\"type\":\"Assertion\",\"id\":\"http://localhost:8000/public/assertions/1b6fc949-4846-442e-a8c1-1db5add00f5c\"}','1b6fc949-4846-442e-a8c1-1db5add00f5c','',1,'Manually revoked by issuer.',1,1,1,'get_full_url','lyera@ceibal.edu.uy','2019-12-12 08:00:00'),(5,'2018-03-26 13:28:26','{\"issuedOn\":\"2018-03-26T06:28:26.893661\",\"uid\":\"390bca83-df83-4b26-823c-239b6e0af284\",\"image\":\"http://localhost:8000/public/assertions/390bca83-df83-4b26-823c-239b6e0af284/image\",\"expires\":null,\"type\":\"Assertion\",\"badge order\":\"1\",\"recipient\":{\"salt\":\"0a2c6f4d-0f1c-44ff-beef-dea8d0ba2a08\",\"type\":\"email\",\"hashed\":true,\"identity\":\"sha256$4292a0515f2e200f958b38df1daf4e6dcac0b89a64515380f8d92037d8e00ada\"},\"id\":\"http://localhost:8000/public/assertions/390bca83-df83-4b26-823c-239b6e0af284\",\"verify\":{\"url\":\"http://localhost:8000/public/assertions/390bca83-df83-4b26-823c-239b6e0af284\",\"type\":\"hosted\"},\"badge category\":\"Category 1\",\"badge family\":\"PAM\",\"@context\":\"https://w3id.org/openbadges/v1\",\"badge\":\"http://localhost:8000/public/badges/leyany-badge\"}','390bca83-df83-4b26-823c-239b6e0af284','uploads/badges/01b7002c8c027ecff061312c6836cc29.png',0,NULL,1,1,1,'get_full_url','leyany@ceibal.edu.uy',NULL),(6,'2018-04-09 13:38:03','{\"issuedOn\":\"2018-04-09T06:38:03.360259\",\"uid\":\"d92e9dda-d748-45ca-bfc7-e03289dcc59b\",\"image\":\"http://localhost:8000/public/assertions/d92e9dda-d748-45ca-bfc7-e03289dcc59b/image\",\"expires\":\"2018-05-05\",\"evidence\":\"http://localhost:8000/issuer/issuers/ceibal/badges/test-badge\",\"type\":\"Assertion\",\"badge order\":\"1\",\"recipient\":{\"salt\":\"eea239c6-c1f8-472c-b59f-5ac77d39c83f\",\"type\":\"email\",\"hashed\":true,\"identity\":\"sha256$27300e69b71a60dec74bc79cd270196918a38a63121bab4704afdf28181ec55c\"},\"id\":\"http://localhost:8000/public/assertions/d92e9dda-d748-45ca-bfc7-e03289dcc59b\",\"verify\":{\"url\":\"http://localhost:8000/public/assertions/d92e9dda-d748-45ca-bfc7-e03289dcc59b\",\"type\":\"hosted\"},\"badge category\":\"Category 1\",\"badge family\":\"PAM\",\"@context\":\"https://w3id.org/openbadges/v1\",\"badge\":\"http://localhost:8000/public/badges/test-badge\"}','d92e9dda-d748-45ca-bfc7-e03289dcc59b','uploads/badges/d57d34ab22bdf6d181305c0028ed254f.png',0,NULL,2,1,1,'get_full_url','yolmoya@gmail.com','2018-05-05 07:00:00'),(7,'2018-04-09 14:12:16','{\"issuedOn\":\"2018-04-09T07:12:16.644285\",\"badge\":\"http://localhost:8000/public/badges/leyany-badge\",\"uid\":\"8d40a78a-d92f-45cd-98c1-83bea1310d79\",\"recipient\":{\"type\":\"email\",\"salt\":\"912791cb-b721-43a7-9b22-90f9ddf73de1\",\"hashed\":true,\"identity\":\"sha256$4cd62ac98279918a9fcb8950e5d7fe0555e6854fb742fb6f346579fba3d646e0\"},\"image\":\"http://localhost:8000/public/assertions/8d40a78a-d92f-45cd-98c1-83bea1310d79/image\",\"expires\":\"2018-05-05\",\"evidence\":\"http://localhost:8000/issuer/issuers/ceibal\",\"badge category\":\"Category 1\",\"badge family\":\"PAM\",\"verify\":{\"url\":\"http://localhost:8000/public/assertions/8d40a78a-d92f-45cd-98c1-83bea1310d79\",\"type\":\"hosted\"},\"@context\":\"https://w3id.org/openbadges/v1\",\"badge order\":\"1\",\"type\":\"Assertion\",\"id\":\"http://localhost:8000/public/assertions/8d40a78a-d92f-45cd-98c1-83bea1310d79\"}','8d40a78a-d92f-45cd-98c1-83bea1310d79','',1,'Manually revoked by issuer.',1,1,1,'get_full_url','lyera@ceibal.edu.uy','2018-05-05 07:00:00'),(8,'2018-04-09 16:43:50','{\"issuedOn\":\"2018-04-09T09:43:50.198230\",\"uid\":\"0ec13711-dc86-4d4d-8527-56415e5deca3\",\"image\":\"http://localhost:8000/public/assertions/0ec13711-dc86-4d4d-8527-56415e5deca3/image\",\"expires\":\"2019-12-25\",\"evidence\":\"http://medallas.ceibal.edu.uy:8000/issuer/issuers/test-issuer\",\"type\":\"Assertion\",\"badge order\":\"1\",\"recipient\":{\"salt\":\"3cb7b03d-271b-4022-9770-223fc71257c6\",\"type\":\"email\",\"hashed\":true,\"identity\":\"sha256$2f43e64e14c88396dff8fad7bce29897f0a721bcfbf26796782f770e0196165b\"},\"id\":\"http://localhost:8000/public/assertions/0ec13711-dc86-4d4d-8527-56415e5deca3\",\"verify\":{\"url\":\"http://localhost:8000/public/assertions/0ec13711-dc86-4d4d-8527-56415e5deca3\",\"type\":\"hosted\"},\"badge category\":\"Category 1\",\"badge family\":\"PAM\",\"@context\":\"https://w3id.org/openbadges/v1\",\"badge\":\"http://localhost:8000/public/badges/leyany-badge\"}','0ec13711-dc86-4d4d-8527-56415e5deca3','uploads/badges/0ade4e1babe66a5daf6b84ea489a7343.png',0,NULL,1,1,1,'get_full_url','lyera@ceibal.edu.uy','2019-12-25 08:00:00'),(9,'2018-04-10 14:59:17','{\"issuedOn\":\"2018-04-10T07:59:17.112645\",\"uid\":\"234a8a99-a149-464a-b2fc-01512276aa6e\",\"image\":\"http://localhost:8000/public/assertions/234a8a99-a149-464a-b2fc-01512276aa6e/image\",\"expires\":\"2019-12-12\",\"evidence\":\"https://www.google.com.uy/\",\"type\":\"Assertion\",\"badge order\":\"1\",\"recipient\":{\"salt\":\"89fd7e5a-108d-41cf-a81a-61080c5827a0\",\"type\":\"email\",\"hashed\":true,\"identity\":\"sha256$913f7b75668c9ff3b668ad05dbb8c67934c246b27d144525fa49199a9749fa0f\"},\"id\":\"http://localhost:8000/public/assertions/234a8a99-a149-464a-b2fc-01512276aa6e\",\"verify\":{\"url\":\"http://localhost:8000/public/assertions/234a8a99-a149-464a-b2fc-01512276aa6e\",\"type\":\"hosted\"},\"badge category\":\"Category 1\",\"badge family\":\"PAM\",\"@context\":\"https://w3id.org/openbadges/v1\",\"badge\":\"http://localhost:8000/public/badges/leyany-badge\"}','234a8a99-a149-464a-b2fc-01512276aa6e','uploads/badges/0a8a95c9b5c71f3724ae679c4842d90b.png',0,NULL,1,1,1,'get_full_url','yolmoya@gmail.com','2019-12-12 08:00:00');
/*!40000 ALTER TABLE `issuer_badgeinstance` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `issuer_categoryclass`
--

DROP TABLE IF EXISTS `issuer_categoryclass`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `issuer_categoryclass` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `created_at` datetime NOT NULL,
  `identifier` varchar(1024) NOT NULL,
  `json` longtext NOT NULL,
  `name` varchar(255) NOT NULL,
  `slug` varchar(255) NOT NULL,
  `created_by_id` int(11) DEFAULT NULL,
  `family_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `slug` (`slug`),
  KEY `issuer_categoryclass_e93cb7eb` (`created_by_id`),
  KEY `issuer_categoryclass_0caa70f7` (`family_id`),
  CONSTRAINT `issuer_categ_family_id_6b362c9f49c26580_fk_issuer_familyclass_id` FOREIGN KEY (`family_id`) REFERENCES `issuer_familyclass` (`id`),
  CONSTRAINT `issuer_categoryclass_created_by_id_15055e8ab2305e18_fk_users_id` FOREIGN KEY (`created_by_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `issuer_categoryclass`
--

LOCK TABLES `issuer_categoryclass` WRITE;
/*!40000 ALTER TABLE `issuer_categoryclass` DISABLE KEYS */;
INSERT INTO `issuer_categoryclass` VALUES (1,'2018-03-26 12:04:34','get_full_url','{\"name\":\"Caterory 1\",\"slug\":\"category1\"}','Category 1','category1',NULL,1),(2,'2018-03-26 12:05:24','get_full_url','{\"name\":\"Category 2\",\"slug\":\"category2\"}','Category 2','category2',NULL,2);
/*!40000 ALTER TABLE `issuer_categoryclass` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `issuer_familyclass`
--

DROP TABLE IF EXISTS `issuer_familyclass`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `issuer_familyclass` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `created_at` datetime NOT NULL,
  `identifier` varchar(1024) NOT NULL,
  `json` longtext NOT NULL,
  `name` varchar(255) NOT NULL,
  `slug` varchar(255) NOT NULL,
  `created_by_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `slug` (`slug`),
  KEY `issuer_familyclass_e93cb7eb` (`created_by_id`),
  CONSTRAINT `issuer_familyclass_created_by_id_602d317cfaa4fc5e_fk_users_id` FOREIGN KEY (`created_by_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `issuer_familyclass`
--

LOCK TABLES `issuer_familyclass` WRITE;
/*!40000 ALTER TABLE `issuer_familyclass` DISABLE KEYS */;
INSERT INTO `issuer_familyclass` VALUES (1,'2018-03-26 12:03:35','get_full_url','{\"name\":\"PAM\",\"slug\":\"pam\"}','PAM','pam',NULL),(2,'2018-03-26 12:03:50','get_full_url','{\"name\":\"CREA\",\"slug\":\"crea\"}','CREA','crea',NULL);
/*!40000 ALTER TABLE `issuer_familyclass` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `issuer_issuer`
--

DROP TABLE IF EXISTS `issuer_issuer`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `issuer_issuer` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `created_at` datetime NOT NULL,
  `json` longtext NOT NULL,
  `name` varchar(1024) NOT NULL,
  `slug` varchar(255) NOT NULL,
  `image` varchar(100),
  `created_by_id` int(11) DEFAULT NULL,
  `owner_id` int(11) NOT NULL,
  `identifier` varchar(1024) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `slug` (`slug`),
  KEY `issuer_issuer_e93cb7eb` (`created_by_id`),
  KEY `issuer_issuer_5e7b1936` (`owner_id`),
  CONSTRAINT `issuer_issuer_created_by_id_57cc96d62d03d708_fk_users_id` FOREIGN KEY (`created_by_id`) REFERENCES `users` (`id`),
  CONSTRAINT `issuer_issuer_owner_id_4058825a1158440a_fk_users_id` FOREIGN KEY (`owner_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `issuer_issuer`
--

LOCK TABLES `issuer_issuer` WRITE;
/*!40000 ALTER TABLE `issuer_issuer` DISABLE KEYS */;
INSERT INTO `issuer_issuer` VALUES (1,'2018-03-26 12:02:21','{\"description\":\"Ceibal\",\"url\":\"https://www.ceibal.edu.uy/es\",\"image\":\"http://localhost:8000/public/issuers/ceibal/image\",\"id\":\"http://localhost:8000/public/issuers/ceibal\",\"@context\":\"https://w3id.org/openbadges/v1\",\"type\":\"Issuer\",\"email\":\"contacto@ceibal.edu.uy\",\"name\":\"Ceibal\"}','Ceibal','ceibal','uploads/issuers/issuer_logo_0d71b144-7d64-4758-8aed-9e1f05ac2ee3.svg',1,1,'get_full_url'),(2,'2018-03-26 12:11:09','{\"description\":\"test\",\"url\":\"https://www.ceibal.edu.uy/es\",\"id\":\"http://localhost:8000/public/issuers/test\",\"@context\":\"https://w3id.org/openbadges/v1\",\"type\":\"Issuer\",\"email\":\"lyera@ceibal.edu.uy\",\"name\":\"test\"}','test','test','',1,1,'get_full_url');
/*!40000 ALTER TABLE `issuer_issuer` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `issuer_issuerstaff`
--

DROP TABLE IF EXISTS `issuer_issuerstaff`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `issuer_issuerstaff` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `editor` tinyint(1) NOT NULL,
  `user_id` int(11),
  `issuer_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `issuer_issuerstaff_issuer_id_21ec9e7547be5a9_uniq` (`issuer_id`,`user_id`),
  KEY `issuer_issuerstaff_1cf89192` (`user_id`),
  KEY `issuer_issuerstaff_dff64d5b` (`issuer_id`),
  CONSTRAINT `issuer_issuerstaf_issuer_id_26f8a17e738978fe_fk_issuer_issuer_id` FOREIGN KEY (`issuer_id`) REFERENCES `issuer_issuer` (`id`),
  CONSTRAINT `issuer_issuerstaff_user_id_d0383c9df099dcc_fk_users_id` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `issuer_issuerstaff`
--

LOCK TABLES `issuer_issuerstaff` WRITE;
/*!40000 ALTER TABLE `issuer_issuerstaff` DISABLE KEYS */;
/*!40000 ALTER TABLE `issuer_issuerstaff` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `mainsite_emailblacklist`
--

DROP TABLE IF EXISTS `mainsite_emailblacklist`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `mainsite_emailblacklist` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `email` varchar(75) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `email` (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `mainsite_emailblacklist`
--

LOCK TABLES `mainsite_emailblacklist` WRITE;
/*!40000 ALTER TABLE `mainsite_emailblacklist` DISABLE KEYS */;
/*!40000 ALTER TABLE `mainsite_emailblacklist` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `reversion_revision`
--

DROP TABLE IF EXISTS `reversion_revision`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `reversion_revision` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `manager_slug` varchar(200) NOT NULL,
  `date_created` datetime NOT NULL,
  `comment` longtext NOT NULL,
  `user_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `reversion_revision_b16b0f06` (`manager_slug`),
  KEY `reversion_revision_c69e55a4` (`date_created`),
  KEY `reversion_revision_e8701ad4` (`user_id`),
  CONSTRAINT `reversion_revision_user_id_53d027e45b2ec55e_fk_users_id` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `reversion_revision`
--

LOCK TABLES `reversion_revision` WRITE;
/*!40000 ALTER TABLE `reversion_revision` DISABLE KEYS */;
/*!40000 ALTER TABLE `reversion_revision` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `reversion_version`
--

DROP TABLE IF EXISTS `reversion_version`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `reversion_version` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `object_id` longtext NOT NULL,
  `object_id_int` int(11) DEFAULT NULL,
  `format` varchar(255) NOT NULL,
  `serialized_data` longtext NOT NULL,
  `object_repr` longtext NOT NULL,
  `content_type_id` int(11) NOT NULL,
  `revision_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `reversion_version_0c9ba3a3` (`object_id_int`),
  KEY `reversion_version_417f1b1c` (`content_type_id`),
  KEY `reversion_version_5de09a8d` (`revision_id`),
  CONSTRAINT `revers_content_type_id_c01a11926d4c4a9_fk_django_content_type_id` FOREIGN KEY (`content_type_id`) REFERENCES `django_content_type` (`id`),
  CONSTRAINT `reversion_v_revision_id_48ec3744916a950_fk_reversion_revision_id` FOREIGN KEY (`revision_id`) REFERENCES `reversion_revision` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `reversion_version`
--

LOCK TABLES `reversion_version` WRITE;
/*!40000 ALTER TABLE `reversion_version` DISABLE KEYS */;
/*!40000 ALTER TABLE `reversion_version` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `users` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `password` varchar(128) NOT NULL,
  `last_login` datetime NOT NULL,
  `is_superuser` tinyint(1) NOT NULL,
  `username` varchar(30) NOT NULL,
  `first_name` varchar(30) NOT NULL,
  `last_name` varchar(30) NOT NULL,
  `email` varchar(75) NOT NULL,
  `is_staff` tinyint(1) NOT NULL,
  `is_active` tinyint(1) NOT NULL,
  `date_joined` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `username` (`username`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (1,'pbkdf2_sha256$12000$gnLZokVkJK2X$wVPNMRB/moTZj5zCIqGLCE0Hu24MVMHoOEmEZOhZt5Q=','2018-03-23 19:56:04',1,'badgr','','','lyera@ceibal.edu.uy',1,1,'2018-03-23 19:56:04');
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users_groups`
--

DROP TABLE IF EXISTS `users_groups`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `users_groups` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `badgeuser_id` int(11) NOT NULL,
  `group_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `badgeuser_id` (`badgeuser_id`,`group_id`),
  KEY `users_groups_1cf89192` (`badgeuser_id`),
  KEY `users_groups_0e939a4f` (`group_id`),
  CONSTRAINT `users_groups_badgeuser_id_3d9a13509a23d22c_fk_users_id` FOREIGN KEY (`badgeuser_id`) REFERENCES `users` (`id`),
  CONSTRAINT `users_groups_group_id_7450d1544dfa1b95_fk_auth_group_id` FOREIGN KEY (`group_id`) REFERENCES `auth_group` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users_groups`
--

LOCK TABLES `users_groups` WRITE;
/*!40000 ALTER TABLE `users_groups` DISABLE KEYS */;
/*!40000 ALTER TABLE `users_groups` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users_user_permissions`
--

DROP TABLE IF EXISTS `users_user_permissions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `users_user_permissions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `badgeuser_id` int(11) NOT NULL,
  `permission_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `badgeuser_id` (`badgeuser_id`,`permission_id`),
  KEY `users_user_permissions_1cf89192` (`badgeuser_id`),
  KEY `users_user_permissions_8373b171` (`permission_id`),
  CONSTRAINT `users_user__permission_id_176df51032da0c6c_fk_auth_permission_id` FOREIGN KEY (`permission_id`) REFERENCES `auth_permission` (`id`),
  CONSTRAINT `users_user_permissions_badgeuser_id_3d20c57604b592a_fk_users_id` FOREIGN KEY (`badgeuser_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users_user_permissions`
--

LOCK TABLES `users_user_permissions` WRITE;
/*!40000 ALTER TABLE `users_user_permissions` DISABLE KEYS */;
/*!40000 ALTER TABLE `users_user_permissions` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2018-04-13 10:59:57
