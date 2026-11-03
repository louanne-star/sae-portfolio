<?php
declare(strict_types=1);

/**
 * PortfolioController
 *
 * Contrôleur (au sens MVC) : reçoit une demande transmise par le routeur
 * de l'API (public/api.php), interroge le Modèle pour obtenir des données,
 * puis retourne des données brutes (tableaux PHP) prêtes à être sérialisées
 * en JSON. Il ne fait ni SQL, ni mise en forme HTML : la présentation est
 * entièrement déléguée au frontend Angular.
 */
class PortfolioController
{
    private ProjetModel $projetModel;

    public function __construct()
    {
        $this->projetModel = new ProjetModel();
    }

    /**
     * Action "liste des projets vitrine" (GET /api/projets).
     *
     * @return array<int, array<string, mixed>>
     */
    public function listeProjetsVitrine(): array
    {
        return $this->projetModel->getProjetsVitrine();
    }

    /**
     * Action "détail d'un projet" (GET /api/projets/{slug}), avec ses
     * compétences et l'analyse STAR associée.
     *
     * @return array<string, mixed>|null null si le slug ne correspond à aucun projet
     */
    public function detailProjet(string $slug): ?array
    {
        $slug = trim($slug);

        if ($slug === '') {
            return null;
        }

        return $this->projetModel->getProjetParSlug($slug);
    }

    /**
     * Action "statistiques globales" (GET /api/stats), pour le bandeau de
     * chiffres clés de la page d'accueil.
     *
     * @return array{nombre_projets: int, nombre_competences: int, nombre_analyses_star: int}
     */
    public function statistiques(): array
    {
        return $this->projetModel->getStatistiques();
    }
}
