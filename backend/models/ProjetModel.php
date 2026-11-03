<?php
declare(strict_types=1);

/**
 * ProjetModel
 *
 * Modèle (au sens MVC) : c'est la SEULE classe autorisée à écrire du SQL
 * concernant les projets. Le contrôleur ne fait que lui demander des
 * données déjà prêtes à l'emploi ; il ignore comment elles sont stockées.
 */
class ProjetModel
{
    private PDO $pdo;

    public function __construct()
    {
        $this->pdo = Database::getInstance();
    }

    /**
     * Récupère les projets mis en avant ("vitrine") pour la page d'accueil.
     * On ne sélectionne que les colonnes nécessaires à l'affichage en grille.
     *
     * @return array<int, array<string, mixed>>
     */
    public function getProjetsVitrine(): array
    {
        $requete = $this->pdo->prepare(
            'SELECT id, titre, slug, description_courte, url_image, est_phare, disciplines
             FROM portfolio_projets
             WHERE est_vitrine = 1
             ORDER BY est_phare DESC, cree_le DESC'
        );
        $requete->execute();

        return $requete->fetchAll();
    }

    /**
     * Récupère un projet complet à partir de son slug (identifiant lisible
     * dans l'URL), enrichi des compétences liées et de leur analyse STAR.
     *
     * Deux requêtes distinctes plutôt qu'une seule grosse jointure :
     * - la 1ʳᵉ récupère le projet (une seule ligne),
     * - la 2ᵉ récupère la liste de ses compétences (plusieurs lignes),
     * ce qui évite de dupliquer les colonnes du projet à chaque ligne
     * de compétence, comme le ferait une jointure unique aplatie.
     *
     * @return array<string, mixed>|null null si aucun projet ne correspond au slug
     */
    public function getProjetParSlug(string $slug): ?array
    {
        $requeteProjet = $this->pdo->prepare(
            'SELECT id, titre, slug, contexte_client, objectif, description_courte,
                    problematique, solution, url_image, url_projet, url_github, est_phare, disciplines, cree_le
             FROM portfolio_projets
             WHERE slug = :slug
             LIMIT 1'
        );
        $requeteProjet->execute(['slug' => $slug]);
        $projet = $requeteProjet->fetch();

        if ($projet === false) {
            return null;
        }

        // Jointure portfolio_projet_competence <-> portfolio_competences
        // pour récupérer, pour ce projet, chaque compétence mobilisée
        // ainsi que le détail STAR (Situation, Tâche, Action, Résultat) associé.
        $requeteCompetences = $this->pdo->prepare(
            'SELECT c.id, c.code_ac, c.nom, c.description,
                    pc.star_situation, pc.star_tache, pc.star_action, pc.star_resultat
             FROM portfolio_projet_competence pc
             INNER JOIN portfolio_competences c ON c.id = pc.competence_id
             WHERE pc.projet_id = :projet_id
             ORDER BY c.code_ac ASC'
        );
        $requeteCompetences->execute(['projet_id' => $projet['id']]);
        $projet['competences'] = $requeteCompetences->fetchAll();

        return $projet;
    }

    /**
     * Statistiques globales affichées sur la page d'accueil (bandeau de
     * chiffres clés). Uniquement des COUNT() réels sur les données en base,
     * aucune valeur inventée.
     *
     * @return array{nombre_projets: int, nombre_competences: int, nombre_analyses_star: int}
     */
    public function getStatistiques(): array
    {
        $nombreProjets = (int) $this->pdo
            ->query('SELECT COUNT(*) FROM portfolio_projets WHERE est_vitrine = 1')
            ->fetchColumn();

        // Compétences du référentiel réellement mobilisées par au moins un projet
        $nombreCompetences = (int) $this->pdo
            ->query('SELECT COUNT(DISTINCT competence_id) FROM portfolio_projet_competence')
            ->fetchColumn();

        $nombreAnalysesStar = (int) $this->pdo
            ->query('SELECT COUNT(*) FROM portfolio_projet_competence')
            ->fetchColumn();

        return [
            'nombre_projets' => $nombreProjets,
            'nombre_competences' => $nombreCompetences,
            'nombre_analyses_star' => $nombreAnalysesStar,
        ];
    }
}
