import { Service, inject } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';
import { environment } from '../../../environments/environment';
import { Projet, ProjetDetail, Statistiques } from '../models/projet.model';

/**
 * Service HTTP : point d'accès unique de l'application aux données du
 * backend PHP. Les composants ne font jamais d'appel HttpClient directement,
 * ils passent par ce service (même logique de séparation des responsabilités
 * que le Modèle côté PHP).
 */
@Service()
export class Projets {
  private readonly http = inject(HttpClient);

  /** Base de l'API : relative en dev (proxy Angular), URL complète en prod (domaine distinct). */
  private readonly apiUrl = environment.apiUrl;

  /** Récupère les projets vitrine pour la page d'accueil (GET /api/projets). */
  getProjetsVitrine(): Observable<Projet[]> {
    return this.http.get<Projet[]>(`${this.apiUrl}/projets`);
  }

  /** Récupère un projet complet (avec compétences et analyse STAR) à partir de son slug. */
  getProjetParSlug(slug: string): Observable<ProjetDetail> {
    return this.http.get<ProjetDetail>(`${this.apiUrl}/projets/${encodeURIComponent(slug)}`);
  }

  /** Récupère les statistiques globales (bandeau de chiffres clés de l'accueil). */
  getStatistiques(): Observable<Statistiques> {
    return this.http.get<Statistiques>(`${this.apiUrl}/stats`);
  }
}
