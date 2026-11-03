-- ============================================================================
-- fixtures.sql — Jeu d'essai pour le portfolio (données fictives mais réalistes)
-- ============================================================================
-- Les codes AC (Apprentissages Critiques) ci-dessous sont donnés à titre
-- illustratif : remplace-les par les codes exacts de ton référentiel BUT
-- Informatique parcours Développement si besoin.
--
-- Ordre d'exécution : competences -> projets -> projet_competence
-- (contraintes de clé étrangère obliques : les tables référencées doivent
-- être peuplées avant les tables qui les référencent).
-- ============================================================================

-- --------------------------------------------------------------------------
-- 1) Compétences (portfolio_competences)
-- --------------------------------------------------------------------------
INSERT INTO portfolio_competences (id, code_ac, nom, description) VALUES
(1, 'AC11.02', 'Développer des composants d''accès aux données',
 'Concevoir et implémenter la couche d''accès aux données d''une application (ORM, requêtes SQL, API).'),
(2, 'AC12.03', 'Réaliser une application organisée en couches',
 'Structurer une application selon une architecture logicielle claire (ex: MVC) afin d''en faciliter la maintenance.'),
(3, 'AC13.01', 'Développer des interfaces utilisateurs',
 'Concevoir des interfaces web ergonomiques, accessibles et responsives à partir de maquettes.'),
(4, 'AC14.02', 'Sécuriser les développements et les données',
 'Identifier les vulnérabilités courantes et mettre en œuvre les bonnes pratiques de sécurisation d''une application.'),
(5, 'AC21.01', 'Gérer un projet informatique',
 'Planifier, découper et suivre l''avancement d''un développement en autonomie ou en équipe.');

-- --------------------------------------------------------------------------
-- 2) Projets (portfolio_projets)
-- --------------------------------------------------------------------------
INSERT INTO portfolio_projets (
    id, titre, slug, contexte_client, description_courte,
    problematique, solution, url_image, url_projet, url_github, est_vitrine, cree_le
) VALUES
(
    1,
    'API REST de gestion de bibliothèque',
    'api-rest-bibliotheque',
    'Projet réalisé en 2ᵉ année de BUT dans le cadre d''une SAÉ, en binôme.',
    'Une API REST sécurisée permettant à une médiathèque de gérer ses ouvrages, ses adhérents et ses emprunts.',
    'La médiathèque partenaire gérait encore ses emprunts sur un tableur partagé, ce qui provoquait des doublons de réservation et une absence totale d''historique fiable.',
    'Développement d''une API REST en PHP (sans framework) avec une base de données MySQL normalisée, une authentification par jeton JWT et une documentation OpenAPI. Les endpoints permettent la gestion complète des ouvrages, des adhérents et du cycle de vie des emprunts (réservation, retrait, retour, relance).',
    'https://picsum.photos/seed/api-bibliotheque/800/450',
    'https://api-bibliotheque.example.com',
    'https://github.com/exemple-etudiant/api-rest-bibliotheque',
    1,
    '2025-03-10 09:00:00'
),
(
    2,
    'Application React de suivi de tâches',
    'app-react-suivi-taches',
    'Projet personnel réalisé en 3ᵉ année de BUT pour approfondir React et la consommation d''API.',
    'Une application web de gestion de tâches (type Kanban) consommant une API REST, avec authentification et tableau de bord temps réel.',
    'Les outils de gestion de tâches existants étaient jugés trop complexes pour un usage personnel ou en petite équipe, avec une interface encombrée de fonctionnalités inutiles.',
    'Conception d''une interface React (Vite + TypeScript) organisée en composants réutilisables, avec gestion d''état via Context API, drag & drop des tâches entre colonnes, et synchronisation avec une API REST sécurisée par jeton. Le design a été pensé mobile-first avec CSS Grid.',
    'https://picsum.photos/seed/app-react-taches/800/450',
    'https://taches-react.example.com',
    'https://github.com/exemple-etudiant/app-react-suivi-taches',
    1,
    '2026-01-20 14:30:00'
),
(
    3,
    'Plateforme de covoiturage étudiant',
    'plateforme-covoiturage-etudiant',
    'Projet réalisé en 3ᵉ année de BUT dans le cadre d''une SAÉ, en groupe de quatre.',
    'Une plateforme web permettant aux étudiants du campus de proposer et réserver des trajets de covoiturage pour se rendre en cours.',
    'Beaucoup d''étudiants habitant loin du campus n''avaient aucun moyen simple de se coordonner pour partager un trajet, ce qui multipliait les voitures individuelles sur un parking déjà saturé.',
    'Développement d''une application web avec un frontend Vue.js et une API PHP consommant une base de données MySQL. Les étudiants peuvent publier un trajet avec horaires et places disponibles, rechercher un trajet compatible avec leur emploi du temps et réserver une place en un clic. Un système de notation entre utilisateurs a été ajouté pour renforcer la confiance entre conducteurs et passagers.',
    'https://picsum.photos/seed/covoiturage-etudiant/800/450',
    'https://covoiturage-campus.example.com',
    'https://github.com/exemple-etudiant/plateforme-covoiturage-etudiant',
    1,
    '2026-06-15 10:00:00'
);

-- --------------------------------------------------------------------------
-- 3) Compétences mobilisées par projet, avec analyse STAR (portfolio_projet_competence)
-- --------------------------------------------------------------------------

-- Projet 1 : API REST de gestion de bibliothèque
INSERT INTO portfolio_projet_competence
    (projet_id, competence_id, star_situation, star_tache, star_action, star_resultat)
VALUES
(
    1, 1,
    'La médiathèque partenaire ne disposait d''aucun système centralisé pour suivre ses ouvrages et ses emprunts, tout étant géré manuellement sur un tableur.',
    'Concevoir et développer la couche d''accès aux données de l''API : modélisation de la base MySQL et écriture des requêtes préparées PDO pour chaque ressource (ouvrages, adhérents, emprunts).',
    'J''ai modélisé un schéma relationnel normalisé (3FN), écrit les scripts de création de tables avec contraintes de clés étrangères, puis développé une couche de repositories en PHP utilisant exclusivement des requêtes préparées PDO pour prévenir les injections SQL.',
    'La couche d''accès aux données a été testée avec plus de 200 requêtes de jeu d''essai sans erreur, et a permis de fiabiliser à 100% la gestion des emprunts lors de la démonstration finale.'
),
(
    1, 2,
    'Le projet devait rester maintenable par un autre binôme d''étudiants après notre passation, sans documentation d''architecture existante.',
    'Structurer l''API selon une architecture en couches claire (routage, contrôleurs, modèles) afin de séparer les responsabilités.',
    'J''ai mis en place une architecture inspirée du patron MVC adaptée à une API REST : un routeur central redirigeant vers des contrôleurs, eux-mêmes appelant des modèles dédiés à chaque ressource, avec une classe Database en Singleton pour mutualiser la connexion PDO.',
    'Le binôme suivant a pu reprendre le projet et ajouter une nouvelle ressource (gestion des réservations) en moins d''une journée grâce à cette architecture claire, saluée par l''équipe pédagogique.'
),
(
    1, 4,
    'Une première version de l''API laissait transiter les mots de passe en clair et ne vérifiait pas les droits d''accès aux routes sensibles.',
    'Sécuriser l''authentification et les échanges de données de l''API avant sa mise en production de démonstration.',
    'J''ai implémenté le hachage des mots de passe avec password_hash(), mis en place une authentification par jeton JWT avec expiration, et ajouté un middleware de vérification des droits sur les routes d''administration.',
    'Un audit croisé avec un autre groupe d''étudiants n''a révélé aucune faille critique, et l''API a obtenu la note maximale sur le critère sécurité de la grille d''évaluation.'
);

-- Projet 2 : Application React de suivi de tâches
INSERT INTO portfolio_projet_competence
    (projet_id, competence_id, star_situation, star_tache, star_action, star_resultat)
VALUES
(
    2, 3,
    'Je souhaitais approfondir la création d''interfaces React réutilisables après un premier semestre centré sur PHP côté serveur.',
    'Concevoir une interface de type Kanban permettant de visualiser et déplacer des tâches entre plusieurs colonnes (À faire, En cours, Terminé).',
    'J''ai découpé l''interface en composants React réutilisables (Carte, Colonne, Tableau), géré le drag & drop avec la librairie dnd-kit, et construit une mise en page responsive avec CSS Grid en approche mobile-first.',
    'L''application est pleinement fonctionnelle sur mobile comme sur desktop, avec un temps de prise en main mesuré à moins de 2 minutes lors de tests utilisateurs informels auprès de 5 camarades.'
),
(
    2, 5,
    'Le projet était personnel et devait être mené en autonomie complète sur un créneau de 3 semaines, sans encadrement quotidien.',
    'Planifier les différentes étapes du développement (maquettage, API, interface, tests) et respecter l''échéance fixée.',
    'J''ai découpé le projet en tickets sur un tableau Kanban personnel (Trello), fixé des jalons hebdomadaires, et priorisé les fonctionnalités essentielles (authentification, CRUD des tâches) avant les améliorations secondaires (thème sombre, filtres).',
    'Le projet a été livré dans les délais avec l''ensemble des fonctionnalités essentielles prévues, et deux fonctionnalités bonus (thème sombre, filtres par étiquette) ont pu être ajoutées grâce à la marge dégagée par cette planification.'
);

-- Projet 3 : Plateforme de covoiturage étudiant
INSERT INTO portfolio_projet_competence
    (projet_id, competence_id, star_situation, star_tache, star_action, star_resultat)
VALUES
(
    3, 2,
    'Le projet, mené en groupe de quatre, devait rester compréhensible et modifiable par chaque membre malgré un périmètre fonctionnel large (trajets, réservations, notation).',
    'Structurer l''application selon une architecture en couches claire côté API PHP, afin que chaque membre du groupe puisse travailler sur une ressource sans marcher sur les fichiers des autres.',
    'J''ai mis en place un découpage en contrôleurs et modèles dédiés à chaque ressource (trajets, réservations, avis), avec une couche d''accès aux données commune, et rédigé un court guide de contribution pour le reste du groupe.',
    'Les quatre membres ont pu développer leurs fonctionnalités en parallèle sans conflit de fusion majeur, et le projet a été intégré et livré en une seule session de travail commune la veille de la soutenance.'
),
(
    3, 3,
    'Les étudiants du campus consultent la plateforme aussi bien depuis leur téléphone entre deux cours que depuis un ordinateur le soir, avec des attentes de rapidité très différentes.',
    'Concevoir une interface Vue.js responsive permettant de publier ou de réserver un trajet en quelques clics, aussi bien sur mobile que sur desktop.',
    'J''ai découpé l''interface en composants réutilisables (formulaire de trajet, carte de résultat, filtre d''horaires), mis en place une recherche instantanée sur les trajets disponibles, et testé l''ergonomie du formulaire de réservation avec plusieurs camarades de promotion.',
    'Le temps moyen pour réserver un trajet est passé sous les 30 secondes lors des tests utilisateurs, et la plateforme a été utilisée par une trentaine d''étudiants dès la première semaine de mise en ligne interne.'
),
(
    3, 4,
    'Le système de réservation et de notation manipulait des données personnelles (numéro de téléphone, avis nominatifs) qui devaient rester protégées entre utilisateurs non habilités.',
    'Sécuriser les échanges de données sensibles entre passagers et conducteurs et restreindre l''accès aux informations de contact aux seuls trajets réservés.',
    'J''ai mis en place une authentification par jeton, chiffré les champs de contact en base, et ajouté des contrôles côté API pour qu''un numéro de téléphone ne soit révélé qu''après confirmation d''une réservation par les deux parties.',
    'Aucune fuite de donnée personnelle n''a été constatée lors de la relecture croisée du code par un autre groupe, et cette gestion des accès a été mise en avant comme bonne pratique lors de la soutenance.'
);
