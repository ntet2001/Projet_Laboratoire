-- MySQL dump 10.13  Distrib 8.0.32, for Linux (x86_64)
--
-- Host: localhost    Database: haskell
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
-- Table structure for table `fiche`
--

DROP TABLE IF EXISTS `fiche`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `fiche` (
  `idFiche` int NOT NULL AUTO_INCREMENT,
  `idAnalyses` longtext,
  `prescripteur` varchar(255) DEFAULT NULL,
  `date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `infopatient` longtext,
  `dateUpdated` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`idFiche`)
) ENGINE=InnoDB AUTO_INCREMENT=23 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `fiche`
--

LOCK TABLES `fiche` WRITE;
/*!40000 ALTER TABLE `fiche` DISABLE KEYS */;
INSERT INTO `fiche` VALUES (1,'[\"1\",\"2\"]','Dr.Drey','2023-02-28 00:22:36','MkPatient {nom = \"gonzales\", prenom = \"raoul\", datenaissance = 2001, genre = \"Masculin\", email = \"ntet@wada.org\"}','2023-02-28 10:14:03'),(2,'[\"1\",\"2\"]','Dr.Kunde','2023-02-28 00:35:10','MkPatient {nom = \"ntet\", prenom = \"raoul\", datenaissance = 2001, genre = \"Masculin\", email = \"ntet@wada.org\"}','2023-02-28 09:53:23'),(4,'[\"3\",\"4\"]','Dr.Ronaldo','2023-03-10 01:49:39','MkPatient {nom = \"Peter\", prenom = \"Neymar\", datenaissance = 1998, genre = \"Masculin\", email = \"boricenoumedem\"}','2023-03-10 01:49:39'),(5,'[\"3\",\"4\"]','Dr.Ronaldo','2023-03-10 02:05:55','MkPatient {nom = \"Peter\", prenom = \"Neymar\", datenaissance = 1998, genre = \"Masculin\", email = \"boricenoumedem\"}','2023-03-10 02:05:55'),(6,'[\"3\",\"4\"]','Dr.Ronaldo','2023-03-10 02:17:14','MkPatient {nom = \"Peter\", prenom = \"Neymar\", datenaissance = 1998, genre = \"Masculin\", email = \"boricenoumedem\"}','2023-03-10 02:17:14'),(7,'[\"3\",\"4\"]','Dr.Ronaldo','2023-03-10 02:19:11','MkPatient {nom = \"Peter\", prenom = \"Neymar\", datenaissance = 1998, genre = \"Masculin\", email = \"boricenoumedem\"}','2023-03-10 02:19:11'),(8,'[\"3\",\"4\"]','Dr.Ronaldo','2023-03-10 02:31:51','MkPatient {nom = \"TORO\", prenom = \"Promax\", datenaissance = 1998, genre = \"Masculin\", email = \"boricenoumedem\"}','2023-03-10 02:31:51'),(9,'[\"3\",\"4\"]','Dr.Emma','2023-03-10 11:11:04','MkPatient {nom = \"ntet\", prenom = \"sammuel\", datenaissance = 2001, genre = \"Masculin\", email = \"manyamaigor\"}','2023-03-10 11:11:04'),(10,'[\"3\",\"4\"]','Dr.Emma','2023-03-10 11:22:45','MkPatient {nom = \"vlad\", prenom = \"loic\", datenaissance = 2002, genre = \"Masculin\", email = \"manyamaigor\"}','2023-03-10 11:22:45'),(11,'[\"3\",\"4\"]','Dr.Noumedem','2023-03-10 11:31:20','MkPatient {nom = \"Tsague\", prenom = \"raoul\", datenaissance = 1998, genre = \"Masculin\", email = \"tsague\"}','2023-03-10 11:31:20'),(12,'[\"3\",\"4\"]','Dr.Etoo','2023-03-10 12:18:43','MkPatient {nom = \"Kiki\", prenom = \"Franglish\", datenaissance = 2019, genre = \"Masculin\", email = \"Franglish\"}','2023-03-10 12:18:43'),(13,'[\"1\",\"2\"]','Dr Felix','2023-03-13 10:51:02','MkPatient {nom = \"noumedem\", prenom = \"borice\", datenaissance = 2000, genre = \"masculin\", email = \"boricenoumedem\"}','2023-03-13 10:51:02'),(14,'[\"1\",\"2\"]','Dr Felix','2023-03-13 11:15:39','MkPatient {nom = \"noumedem\", prenom = \"borice\", datenaissance = 2000, genre = \"masculin\", email = \"boricenoumedem\"}','2023-03-13 11:15:39'),(15,'[\"1\",\"2\"]','Dr Felix','2023-03-13 11:28:34','MkPatient {nom = \"noumedem\", prenom = \"borice\", datenaissance = 2000, genre = \"masculin\", email = \"boricenoumedem\"}','2023-03-13 11:28:34'),(16,'[\"1\",\"2\"]','Dr Felix','2023-03-13 11:36:59','MkPatient {nom = \"ntet\", prenom = \"manyama\", datenaissance = 2000, genre = \"masculin\", email = \"manyamaigor\"}','2023-03-13 11:36:59'),(17,'[\"1\",\"2\"]','Dr Felix','2023-03-13 11:43:05','MkPatient {nom = \"ntet\", prenom = \"manyama\", datenaissance = 2000, genre = \"masculin\", email = \"manyamaigor\"}','2023-03-13 11:43:05'),(18,'[\"1\",\"2\"]','Dr Felix','2023-03-13 11:58:42','MkPatient {nom = \"ntet\", prenom = \"manyama\", datenaissance = 2000, genre = \"masculin\", email = \"manyamaigor2001@gmail.com\"}','2023-03-13 11:58:42'),(19,'[\"1\",\"2\"]','Dr Felix','2023-03-13 12:00:43','MkPatient {nom = \"Neudjieu\", prenom = \"Raoul\", datenaissance = 1996, genre = \"masculin\", email = \"elieraoulnet@gmail.com\"}','2023-03-13 12:00:43'),(20,'[\"1\",\"2\"]','Dr Felix','2023-03-13 12:12:13','MkPatient {nom = \"Neudjieu\", prenom = \"Raoul\", datenaissance = 1996, genre = \"masculin\", email = \"elieraoulnet@gmail.com\"}','2023-03-13 12:12:13'),(21,'[\"1\",\"2\"]','Dr Felix','2023-03-13 12:14:35','MkPatient {nom = \"Nkalla\", prenom = \"Raoul\", datenaissance = 1996, genre = \"masculin\", email = \"nkalla@wada.org\"}','2023-03-13 12:14:35'),(22,'[\"1\",\"2\"]','Dr Felix','2023-03-13 12:14:44','MkPatient {nom = \"Nkalla\", prenom = \"Raoul\", datenaissance = 1996, genre = \"masculin\", email = \"nkalla@wada.org\"}','2023-03-13 12:14:44');
/*!40000 ALTER TABLE `fiche` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `users` (
  `userId` int NOT NULL,
  `userFirstName` varchar(255) DEFAULT NULL,
  `userLastName` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`userId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (1,'Ntet','Igor'),(2,'Noumedem','Stephane');
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2023-03-14 10:11:37
