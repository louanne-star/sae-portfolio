<?php
declare(strict_types=1);

/**
 * public/api.php — Point d'entrée unique de l'API JSON (patron "Front Controller").
 *
 * Toutes les requêtes /api/... sont redirigées ici par .htaccess (production,
 * Apache) ou par router.php (développement, serveur PHP intégré), avec le
 * chemin demandé passé dans $_GET['route'] (ex: "projets/mon-slug").
 *
 * Angular (frontend/) est totalement indépendant de ce fichier : il consomme
 * cette API en JSON, quel que soit l'endroit où elle est déployée.
 */

require_once __DIR__ . '/../backend/config/config.php';

/**
 * Autoload simple : cherche la classe demandée dans les dossiers du backend.
 */
spl_autoload_register(function (string $nomClasse): void {
    foreach (['config', 'models', 'controllers'] as $dossier) {
        $chemin = __DIR__ . '/../backend/' . $dossier . '/' . $nomClasse . '.php';

        if (file_exists($chemin)) {
            require_once $chemin;
            return;
        }
    }
});

header('Content-Type: application/json; charset=utf-8');

// API publique en lecture seule (aucune donnée sensible, pas d'authentification) :
// ouverte à tous les domaines pour que le frontend Angular hébergé ailleurs
// (ex: Netlify) puisse l'appeler directement.
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: GET');

/**
 * Envoie une réponse JSON avec le bon code HTTP puis arrête l'exécution.
 *
 * @param mixed $donnees
 */
function reponseJson($donnees, int $codeHttp = 200): void
{
    http_response_code($codeHttp);
    echo json_encode($donnees, JSON_UNESCAPED_UNICODE | JSON_UNESCAPED_SLASHES);
    exit;
}

// Découpage du chemin demandé, ex: "projets/mon-slug" -> ["projets", "mon-slug"]
$chemin = trim((string) ($_GET['route'] ?? ''), '/');
$segments = $chemin === '' ? [] : explode('/', $chemin);

$methode = $_SERVER['REQUEST_METHOD'];
$controleur = new PortfolioController();

// GET /api/projets — liste des projets vitrine (page d'accueil)
if ($methode === 'GET' && $segments === ['projets']) {
    reponseJson($controleur->listeProjetsVitrine());
}

// GET /api/projets/{slug} — détail d'un projet (compétences + analyse STAR)
if ($methode === 'GET' && count($segments) === 2 && $segments[0] === 'projets') {
    $projet = $controleur->detailProjet($segments[1]);

    if ($projet === null) {
        reponseJson(['erreur' => 'Projet introuvable.'], 404);
    }

    reponseJson($projet);
}

// GET /api/stats — statistiques globales (bandeau de chiffres clés de l'accueil)
if ($methode === 'GET' && $segments === ['stats']) {
    reponseJson($controleur->statistiques());
}

reponseJson(['erreur' => 'Route API inconnue.'], 404);
