/**
 * Modèles TypeScript reflétant la structure JSON renvoyée par l'API PHP
 * (backend/models/ProjetModel.php), elle-même construite à partir des
 * tables portfolio_projets / portfolio_competences / portfolio_projet_competence.
 */

/** Projet tel que renvoyé par GET /api/projets (liste vitrine, page d'accueil) */
export interface Projet {
  id: number;
  titre: string;
  slug: string;
  description_courte: string;
  url_image: string | null;
  /** 0 ou 1 (tinyint MySQL renvoyé tel quel par l'API JSON, pas un vrai booléen) */
  est_phare: number;
  /** Disciplines mobilisées, séparées par des virgules (ex: "Développement web, API") */
  disciplines: string | null;
}

/** Une compétence mobilisée par un projet, avec son analyse STAR (table pivot) */
export interface CompetenceProjet {
  id: number;
  code_ac: string;
  nom: string;
  description: string;
  star_situation: string;
  star_tache: string;
  star_action: string;
  star_resultat: string;
}

/** Projet complet tel que renvoyé par GET /api/projets/{slug} (page de détail) */
export interface ProjetDetail extends Projet {
  contexte_client: string | null;
  objectif: string | null;
  problematique: string;
  solution: string;
  url_projet: string | null;
  url_github: string | null;
  cree_le: string;
  competences: CompetenceProjet[];
}

/** Statistiques globales renvoyées par GET /api/stats (bandeau de chiffres clés) */
export interface Statistiques {
  nombre_projets: number;
  nombre_competences: number;
  nombre_analyses_star: number;
}
