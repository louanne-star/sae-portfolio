<?php
declare(strict_types=1);

/**
 * Modèle de configuration — copie ce fichier en config.php (non versionné,
 * voir .gitignore) et renseigne tes propres identifiants :
 * - en local : les identifiants MAMP
 * - en production : les identifiants fournis par l'hébergeur (ex. InfinityFree)
 */

define('DB_HOST', 'à_renseigner');
define('DB_PORT', 'à_renseigner');
define('DB_NAME', 'à_renseigner');
define('DB_USER', 'à_renseigner');
define('DB_PASS', 'à_renseigner');
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
