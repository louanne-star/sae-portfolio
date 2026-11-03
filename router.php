<?php
declare(strict_types=1);

/**
 * router.php — Routeur pour le serveur PHP intégré (`php -S`), utilisé en
 * développement local ou pour prévisualiser un build de production.
 *
 * Usage (la racine documentaire DOIT être public/, sinon les fichiers
 * statiques du build Angular ne seront pas trouvés par le serveur intégré) :
 *   php -S localhost:8000 -t public router.php
 *
 * Reproduit en PHP la logique du .htaccess (Apache), que le serveur intégré
 * ne peut pas interpréter directement :
 *   1) fichier statique existant -> servi tel quel par le serveur intégré
 *   2) requête /api/... -> déléguée à public/api.php
 *   3) toute autre route -> index.html (Angular gère le routage client)
 */

$uri = urldecode(parse_url($_SERVER['REQUEST_URI'], PHP_URL_PATH));
$racinePublique = __DIR__ . '/public';

// 1) Fichier statique réellement présent (JS/CSS/images buildés par Angular)
if ($uri !== '/' && file_exists($racinePublique . $uri) && !is_dir($racinePublique . $uri)) {
    return false;
}

// 2) Requêtes API : on reconstitue le paramètre "route" attendu par api.php
if (str_starts_with($uri, '/api')) {
    $_GET['route'] = ltrim(substr($uri, strlen('/api')), '/');
    require $racinePublique . '/api.php';
    return true;
}

// 3) Toute autre route : page d'entrée Angular (absente tant qu'aucun build
//    n'a été copié dans public/, cf. README / npm run build:prod)
$indexHtml = $racinePublique . '/index.html';

if (!file_exists($indexHtml)) {
    http_response_code(503);
    echo 'Aucun build Angular trouvé dans public/. Lancez "cd frontend && npm run build:prod", '
        . 'ou démarrez Angular séparément avec "cd frontend && npm start" en développement.';
    return true;
}

require $indexHtml;
