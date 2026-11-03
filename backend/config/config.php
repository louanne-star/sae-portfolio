<?php
declare(strict_types=1);

/**
 * Fichier de configuration générale de l'application.
 * Centralise les constantes pour éviter de disperser des "valeurs magiques"
 * dans le code (Modèle, Contrôleur).
 *
 * L'API ne sert que du JSON : elle n'a plus besoin de connaître d'URL de
 * base pour générer des liens (c'est Angular, côté client, qui gère les
 * routes et la navigation).
 */

// --- Paramètres de connexion à la base de données ---
// Note : avec MAMP, MySQL n'écoute pas sur le port standard (3306) mais sur
// le port 8889, et le PHP en ligne de commande (hors MAMP) ne connaît pas
// l'emplacement de sa socket Unix. On utilise donc 127.0.0.1 (force une
// connexion TCP) plutôt que "localhost" (qui tenterait une socket).
define('DB_HOST', '127.0.0.1');
define('DB_PORT', '8889');
define('DB_NAME', 'sae_portfolio');
define('DB_USER', 'root');
define('DB_PASS', 'root');
define('DB_CHARSET', 'utf8mb4');

// --- Environnement ---
// En développement, on affiche les erreurs PHP pour faciliter le débogage.
// À mettre à false en production.
define('MODE_DEBUG', true);

if (MODE_DEBUG) {
    ini_set('display_errors', '1');
    error_reporting(E_ALL);
} else {
    ini_set('display_errors', '0');
}
