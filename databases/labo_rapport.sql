-- MySQL dump 10.13  Distrib 8.0.32, for Linux (x86_64)
--
-- Host: localhost    Database: labo_rapport
-- ------------------------------------------------------
-- Server version	8.0.32-0ubuntu0.22.04.2

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `rapport`
--

DROP TABLE IF EXISTS `rapport`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `rapport` (
  `idRapport` int NOT NULL AUTO_INCREMENT,
  `contenu` longtext,
  `fiche` longtext NOT NULL,
  `dateCreated` timestamp NULL DEFAULT NULL,
  `dateUpdated` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`idRapport`)
) ENGINE=InnoDB AUTO_INCREMENT=20 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `rapport`
--

LOCK TABLES `rapport` WRITE;
/*!40000 ALTER TABLE `rapport` DISABLE KEYS */;
INSERT INTO `rapport` VALUES (18,'[]','MkFIche {idFiche = 18, analyses = [\"1\",\"2\"], prescripteur = \"Dr Felix\", date = 2023-03-13 12:12:13.040045695 UTC, infoPatient = MkPatient {nom = \"Neudjieu\", prenom = \"Raoul\", datenaissance = 1996, genre = \"masculin\", email = \"elieraoulnet@gmail.com\"}, dateUpdate = 2023-03-13 12:12:13.040045695 UTC}','2023-03-13 11:12:13','2023-03-13 11:12:13'),(19,'[]','MkFIche {idFiche = 19, analyses = [\"1\",\"2\"], prescripteur = \"Dr Felix\", date = 2023-03-13 12:14:44.866182518 UTC, infoPatient = MkPatient {nom = \"Nkalla\", prenom = \"Raoul\", datenaissance = 1996, genre = \"masculin\", email = \"nkalla@wada.org\"}, dateUpdate = 2023-03-13 12:14:44.866182518 UTC}','2023-03-13 11:14:45','2023-03-13 11:14:45');
/*!40000 ALTER TABLE `rapport` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `resultat`
--

DROP TABLE IF EXISTS `resultat`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `resultat` (
  `idResult` int NOT NULL AUTO_INCREMENT,
  `idAnal` int NOT NULL,
  `interpretation` text NOT NULL,
  `conclusion` text NOT NULL,
  `fiche` int DEFAULT NULL,
  `prescripteur` varchar(255) DEFAULT NULL,
  `numDossier` int NOT NULL,
  `lineResults` longtext NOT NULL,
  `nomLaborantin` varchar(255) NOT NULL,
  `dateCreated` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `dateUpdated` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`idResult`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `resultat`
--

LOCK TABLES `resultat` WRITE;
/*!40000 ALTER TABLE `resultat` DISABLE KEYS */;
INSERT INTO `resultat` VALUES (1,1,'test','malade',16,'Dr',16,'[Negatif \"pas malade\",Positif \"malade\" 1.72]','Dr','2023-03-12 13:03:43','2023-03-12 13:03:43'),(2,2,'test','malade',16,'Dr',16,'[Negatif \"pas malade\",Positif \"malade\" 1.72]','Dr','2023-03-12 17:13:55','2023-03-12 17:13:55');
/*!40000 ALTER TABLE `resultat` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2023-03-14 10:12:09
