-- MySQL dump 10.13  Distrib 8.0.40, for macos12.7 (arm64)
--
-- Host: 127.0.0.1    Database: sae_portfolio
-- ------------------------------------------------------
-- Server version	8.0.40

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
-- Table structure for table `portfolio_competences`
--

DROP TABLE IF EXISTS `portfolio_competences`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `portfolio_competences` (
  `id` int NOT NULL AUTO_INCREMENT,
  `code_ac` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Ex: AC31.01',
  `nom` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` text COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `portfolio_competences`
--

LOCK TABLES `portfolio_competences` WRITE;
/*!40000 ALTER TABLE `portfolio_competences` DISABLE KEYS */;
INSERT INTO `portfolio_competences` VALUES (1,'AC34.01','Développer à l\'aide d\'un framework de développement côté client','Compétence Développer, niveau 3 (BUT MMI, parcours Développement web et dispositifs interactifs) : développer un écosystème numérique complexe en s\'appuyant sur un framework de développement côté client.'),(5,'AC34.05','Maîtriser l\'hébergement et le déploiement d\'applications','Compétence Développer, niveau 3 (BUT MMI, parcours Développement web et dispositifs interactifs) : mettre en place et maîtriser une chaîne d\'hébergement et de déploiement pour une application complexe.'),(6,'AC34.03','Développer des dispositifs interactifs sophistiqués','Compétence Développer, niveau 3 (BUT MMI, parcours Développement web et dispositifs interactifs) : développer un écosystème numérique complexe en concevant des dispositifs interactifs sophistiqués.'),(7,'AC23.06','Élaborer et produire des animations, des designs spéciaux, des effets spéciaux, de la visualisation de données ou de la 3D','Compétence Exprimer, niveau 2 (BUT MMI, parcours Développement web et dispositifs interactifs) : exprimer une identité visuelle et éditoriale transmédia par la production d\'animations et de contenus 3D.');
/*!40000 ALTER TABLE `portfolio_competences` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `portfolio_projet_competence`
--

DROP TABLE IF EXISTS `portfolio_projet_competence`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `portfolio_projet_competence` (
  `projet_id` int NOT NULL,
  `competence_id` int NOT NULL,
  `star_situation` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `star_tache` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `star_action` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `star_resultat` text COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`projet_id`,`competence_id`),
  KEY `competence_id` (`competence_id`),
  CONSTRAINT `portfolio_projet_competence_ibfk_1` FOREIGN KEY (`projet_id`) REFERENCES `portfolio_projets` (`id`) ON DELETE CASCADE,
  CONSTRAINT `portfolio_projet_competence_ibfk_2` FOREIGN KEY (`competence_id`) REFERENCES `portfolio_competences` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `portfolio_projet_competence`
--

LOCK TABLES `portfolio_projet_competence` WRITE;
/*!40000 ALTER TABLE `portfolio_projet_competence` DISABLE KEYS */;
INSERT INTO `portfolio_projet_competence` VALUES (1,1,'Dans le cadre du projet KAVAL, nous devions concevoir une application mobile de visite guidée de l\'ancien bagne de l\'Île Nou (Nouville). Le visiteur se déplace physiquement sur le site, débloque les zones du parcours grâce à sa position GPS, découvre le contenu historique de chaque point (récits, témoignages, quiz) et gagne des badges en réussissant des mini-jeux.','Je devais concevoir l\'architecture de l\'application de bout en bout : un code unique pour le web, Android et iOS, un modèle de données pour le contenu et les données utilisateur, et surtout garantir que chaque utilisateur n\'accède qu\'à ses propres données (badges, notes, favoris, commentaires), sans serveur applicatif à maintenir.','J\'ai développé le frontend avec Ionic 8 et Angular 20. J\'ai structuré la logique métier en services dédiés (points, parcours/GPS, badges, synchronisation, notes, commentaires, favoris). Le service de parcours utilise watchPosition pour calculer la distance aux zones et débloquer une zone lorsque l\'utilisateur entre dans son rayon, avec une position de secours si le GPS est refusé.\r\n\r\nCôté données, j\'ai choisi Supabase (Postgres, API REST auto-générée, Auth) et modélisé le schéma : zones, points, sections de contenu, quiz, témoignages, et tables utilisateur. J\'ai porté la sécurité par des policies Row Level Security en SQL, avec l\'authentification email/mot de passe via Supabase Auth.\r\n\r\nJ\'ai aussi travaillé la robustesse : chargement du contenu avec fallback sur un cache local (Capacitor Preferences) si Supabase est injoignable, contenu non critique qui ne bloque jamais l\'affichage, et fonctionnement hors-ligne après la première connexion. Les mini-jeux sont des modules HTML/JS autonomes chargés en iframe, qui communiquent leur résultat par postMessage, ce qui les isole du reste de l\'application. Pour l\'intégration, j\'ai mis en place le déploiement continu sur Netlify à chaque push sur main, et intégré le calcul d\'itinéraire piéton via OSRM.','L\'application est en ligne (kaval.netlify.app) et fonctionnelle sur mobile. Le contenu (textes, quiz, témoignages) s\'enrichit par simple insertion en base, sans redéploiement. J\'ai également identifié les limites à traiter (absence de CI, pas d\'environnement de staging, appId Capacitor par défaut à changer avant publication), ce qui montre un regard critique sur la solution.'),(1,5,'Le projet nécessitait une solution hébergée et accessible publiquement dès les premières itérations, pour pouvoir tester l\'application directement sur le terrain (visite réelle du site du bagne) sans dépendre d\'un serveur à maintenir manuellement.','Je devais mettre en place une chaîne d\'hébergement et de déploiement fiable pour une application web/mobile hybride (Ionic/Capacitor), permettant de livrer rapidement chaque évolution sans étape manuelle.','J\'ai mis en place un déploiement continu sur Netlify, déclenché automatiquement à chaque push sur la branche main, couplé à Supabase pour l\'hébergement des données (Postgres managé, API REST auto-générée). J\'ai aussi identifié et documenté les points à sécuriser avant une mise en production réelle (absence d\'environnement de staging, appId Capacitor par défaut à changer avant publication sur les stores).','L\'application est accessible en continu à l\'adresse kaval.netlify.app, chaque mise à jour de contenu (textes, quiz, témoignages) est visible immédiatement sans redéploiement grâce à Supabase, et j\'ai un plan clair des améliorations à apporter avant publication sur les stores (CI de tests, environnement de staging, configuration de production).'),(5,6,'Trois fresques existaient déjà sur le campus (tortue, hibiscus, loriquet), deux autres étant prévues. Il fallait une expérience sans installation, lancée depuis un QR code, utilisable sur des téléphones très différents, en extérieur, avec des contraintes fortes : reconnaître des fresques réelles malgré la lumière, l\'angle et les éléments ajoutés sur les murs, animer des modèles 3D fluides sur mobile, et ne jamais modifier l\'œuvre de l\'artiste.','Concevoir et développer un prototype fonctionnel qui reconnaît plusieurs fresques dans une seule application, propose un mini-jeu en réalité augmentée (personnage 3D animé dirigé au joystick tactile, molécule à attraper, mode « Explorer »), enregistre la progression dans un Atlas, et fonctionne en HTTPS pour accéder à la caméra.','Développement itératif par petites étapes, chacune testée sur téléphone devant les vraies fresques puis corrigée selon nos retours (vitesse, taille, angle, fluidité). Reconnaissance des fresques avec MindAR (images cibles compilées dans un seul fichier, bascule automatique d\'une fresque à l\'autre) et rendu 3D avec Three.js, avec une fiche de réglages par fresque pour en ajouter facilement de nouvelles sans réécrire le code. Le code a été écrit avec l\'assistant IA Claude Code à partir de nos consignes et de nos retours de test ; les choix de design, de contenu et les validations sont restés de notre responsabilité, et plusieurs propositions ont dû être corrigées après nos tests.','Prototype fonctionnel en ligne : 3 fresques reconnues dans une seule app, chacune avec son personnage 3D animé, mini-jeu et Atlas opérationnels. Les tests en conditions réelles devant les fresques ont révélé des problèmes invisibles sur ordinateur (tortue non reconnue, oiseau vu de dessus, vol saccadé), tous corrigés. Réflexion critique : la photo de référence d\'une fresque décide de tout (la tortue n\'était plus reconnue après l\'ajout d\'un panneau sur le mur) ; nous ferions désormais les photos de face de toutes les fresques dès le premier jour, et testerions plus tôt sur téléphone plutôt que sur ordinateur.'),(5,7,'Chaque fresque associe une espèce calédonienne à sa molécule. Il fallait restituer ces personnages 3D animés et leurs formules chimiques de façon à la fois fidèle scientifiquement et vivante visuellement, sans dénaturer l\'œuvre originale de l\'artiste Kuby Kolor.','Produire ou adapter des modèles 3D animés fidèles (tortue, papillon, loriquet), générer les formules chimiques exactes des molécules associées, et composer une identité visuelle cohérente pour l\'application et l\'Atlas de la mémoire vivante.','Modèles 3D sourcés sur Sketchfab ou générés avec Meshy AI puis animés et allégés dans Blender (le loriquet, aux ailes soudées au corps sur les deux premiers essais, a été refait avec un squelette puis animé par script de battement d\'ailes, et allégé de 50 000 à 17 000 sommets). Les formules chimiques (cystine, cyanidine, DHICA) ont été générées à partir de leur notation SMILES standard plutôt que dessinées à la main — la cyanidine obtenue est identique à celle peinte sur la fresque. Les voix des espèces ont été enregistrées par Ondine Taukolo. Trois itérations de design ont été testées (sombre, puis clair, puis un style inspiré d\'une application de voyage avec cartes photo et police Poppins), avec une carte satellite du campus (Leaflet + Esri) et les crédits/licences consignés dans l\'Atlas.','Personnages 3D crédibles et fluides sur mobile, formules scientifiquement exactes, identité visuelle finalisée et cohérente. Réflexion critique : trois modèles 3D ont été testés en vain pour le loriquet avant de trouver le bon, ce qui a fait perdre beaucoup de temps — nous définirions désormais un cahier des charges des modèles (format .glb, poids maximal, animation de vol déjà incluse, licence compatible) avant de les chercher, et fixerions l\'identité visuelle dès le début plutôt que de la faire évoluer trois fois.');
/*!40000 ALTER TABLE `portfolio_projet_competence` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `portfolio_projets`
--

DROP TABLE IF EXISTS `portfolio_projets`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `portfolio_projets` (
  `id` int NOT NULL AUTO_INCREMENT,
  `titre` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `slug` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `contexte_client` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Client ou Contexte scolaire',
  `objectif` text COLLATE utf8mb4_unicode_ci,
  `description_courte` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `problematique` text COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Le problème initial',
  `solution` text COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'La solution apportée',
  `url_image` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `url_projet` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `url_github` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `est_vitrine` tinyint(1) DEFAULT '1' COMMENT '1 = Affiché en page pro, 0 = Preuve académique uniquement',
  `est_phare` tinyint(1) NOT NULL DEFAULT '0',
  `disciplines` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `cree_le` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `slug` (`slug`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `portfolio_projets`
--

LOCK TABLES `portfolio_projets` WRITE;
/*!40000 ALTER TABLE `portfolio_projets` DISABLE KEYS */;
INSERT INTO `portfolio_projets` VALUES (1,'Forçats\'Nou','forcats-nou','Scolaire (SAÉ)',NULL,'Application mobile de visite guidée de l\'ancien bagne de l\'Île Nou (Nouvelle-Calédonie)..','Le bagne de l\'Île Nou est un site historique riche mais peu documenté, difficile à appréhender sans accompagnement. KAVAL à pour but d\'offrir une médiation culturelle accessible aussi bien aux visiteurs sur place qu\'à distance, en ligne. L\'application rend l\'histoire du lieu compréhensible en superposant passé et présent, et transforme la visite en parcours actif avec zones à débloquer, mini-jeux et objets à collectionner.','blablabala','images/kaval.png','https://kaval.netlify.app/','https://github.com/louanne-star/KAVAL',1,1,NULL,'2026-07-01 14:32:38'),(5,'Empreintes','empreintes','Projet en binôme avec Ondine Taukolo, pour « Micro-Mondes : trajectoires du vivant » (Festival Kaledoscope, Université de la Nouvelle-Calédonie)','Prolonger le parcours de fresques de l\'artiste Kuby Kolor sur le campus par une expérience de réalité augmentée : faire sortir en 3D le personnage peint sur chaque fresque, le diriger pour attraper une « Empreinte » (sa molécule), et constituer un Atlas de la mémoire vivante pour sensibiliser à la fragilité du vivant calédonien.','Une application web de réalité augmentée qui fait sortir en 3D les personnages peints sur les fresques du campus, pour sensibiliser à la biodiversité calédonienne.','Trois fresques de l\'artiste Kuby Kolor existent déjà sur le campus (tortue, hibiscus, loriquet), avec deux autres prévues. Il fallait concevoir une expérience accessible sans installation, lancée depuis un simple QR code, utilisable sur des téléphones très différents, en extérieur. Les contraintes techniques étaient nombreuses : reconnaître des fresques réelles malgré la lumière, l\'angle et les éléments ajoutés sur les murs ; animer des modèles 3D fluides sur mobile ; assurer la cohérence scientifique des molécules associées à chaque espèce ; respecter les licences des modèles 3D utilisés ; et ne jamais modifier l\'œuvre originale de l\'artiste, l\'Empreinte restant un objet purement numérique.','Développement itératif par petites étapes, chacune testée sur téléphone devant les vraies fresques puis ajustée (vitesse, taille, angle, fluidité). Reconnaissance des fresques avec MindAR (plusieurs images cibles compilées dans un seul fichier, bascule automatique d\'une fresque à l\'autre) et rendu 3D avec Three.js, avec une fiche de réglages par fresque pour en ajouter facilement de nouvelles. Les modèles 3D (tortue, papillon, loriquet) ont été sourcés sur Sketchfab ou générés avec Meshy AI, puis optimisés pour mobile (le loriquet est passé de 51 Mo à 1,3 Mo et de 50 000 à 17 000 sommets). Les formules chimiques affichées (cystine, cyanidine, DHICA...) ont été générées à partir de leur notation SMILES plutôt que dessinées à la main. Les voix des espèces ont été enregistrées par Ondine Taukolo, avec repli sur la synthèse vocale du téléphone en cas d\'absence de fichier. Le code a été écrit avec l\'assistant IA Claude Code à partir de nos consignes et retours de test ; les choix de design, de contenu et les validations sont restés de notre responsabilité. Travail à deux sur un dépôt Git/GitHub partagé (33 commits).','images/empreintes.jpg','https://empreintess.netlify.app/','https://github.com/louanne-star/EMPREINTES',1,1,'Dispositif interactif, Développement web','2026-11-03 15:00:32'),(6,'Primeur 3D','primeur-3d','À compléter',NULL,'À compléter','À compléter','À compléter',NULL,NULL,NULL,1,0,'Développement web, API','2026-11-03 15:00:32'),(7,'CV vidéo','cv-video','À compléter',NULL,'À compléter','À compléter','À compléter',NULL,NULL,NULL,1,1,'Audiovisuel','2026-11-03 15:00:32'),(8,'Webdoc','webdoc','À compléter',NULL,'À compléter','À compléter','À compléter',NULL,NULL,NULL,1,0,'Audiovisuel','2026-11-03 15:00:32'),(9,'Autopromo','autopromo','À compléter',NULL,'À compléter','À compléter','À compléter',NULL,NULL,NULL,1,0,'Audiovisuel, Motion design','2026-11-03 15:00:32'),(10,'VR forum','vr-forum','À compléter',NULL,'À compléter','À compléter','À compléter',NULL,NULL,NULL,1,0,'Blender, Développement web','2026-11-03 15:00:32');
/*!40000 ALTER TABLE `portfolio_projets` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-11-03 15:23:53
