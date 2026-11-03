import { Component, HostListener, inject, signal } from '@angular/core';
import { DomSanitizer, SafeResourceUrl } from '@angular/platform-browser';
import { Projets } from '../../core/services/projets';
import { Projet, ProjetDetail, Statistiques } from '../../core/models/projet.model';
import { FadeIn } from '../../shared/fade-in';
import { CompteurAnimation } from '../../shared/compteur-animation';
import { Parallax } from '../../shared/parallax';

@Component({
  selector: 'app-accueil',
  imports: [FadeIn, CompteurAnimation, Parallax],
  templateUrl: './accueil.html',
  styleUrl: './accueil.css',
})
export class Accueil {
  private readonly projetsService = inject(Projets);
  private readonly sanitizer = inject(DomSanitizer);

  protected readonly projets = signal<Projet[]>([]);
  protected readonly chargementEnCours = signal(true);
  protected readonly erreur = signal(false);

  protected readonly statistiques = signal<Statistiques | null>(null);

  /** État de la modale de détail projet, ouverte au clic sur une carte. */
  protected readonly modalOuverte = signal(false);
  protected readonly modalChargementEnCours = signal(false);
  protected readonly modalErreur = signal(false);
  protected readonly projetSelectionne = signal<ProjetDetail | null>(null);

  protected readonly nom = 'Lou-Anne Grosjean';
  protected readonly role = 'Alternante Développeuse — BUT Informatique, chez Ifingo';
  protected readonly email = 'louannegjean@gmail.com';
  protected readonly urlLinkedin = 'https://www.linkedin.com/in/lou-anne-grosjean/';
  protected readonly urlGithub = 'https://github.com/louanne-star';

  constructor() {
    this.projetsService.getProjetsVitrine().subscribe({
      next: (projets) => {
        this.projets.set(projets);
        this.chargementEnCours.set(false);
      },
      error: () => {
        this.erreur.set(true);
        this.chargementEnCours.set(false);
      },
    });

    this.projetsService.getStatistiques().subscribe({
      next: (stats) => this.statistiques.set(stats),
    });
  }

  /** Ouvre la modale de détail et charge le projet complet (compétences + analyse STAR). */
  protected ouvrirProjet(slug: string): void {
    this.modalOuverte.set(true);
    this.modalChargementEnCours.set(true);
    this.modalErreur.set(false);
    this.projetSelectionne.set(null);
    document.body.style.overflow = 'hidden';

    this.projetsService.getProjetParSlug(slug).subscribe({
      next: (projet) => {
        this.projetSelectionne.set(projet);
        this.modalChargementEnCours.set(false);
      },
      error: () => {
        this.modalErreur.set(true);
        this.modalChargementEnCours.set(false);
      },
    });
  }

  protected fermerModal(): void {
    this.modalOuverte.set(false);
    document.body.style.overflow = '';
  }

  @HostListener('document:keydown.escape')
  protected fermerModalSurEchap(): void {
    if (this.modalOuverte()) {
      this.fermerModal();
    }
  }

  /** Transforme la chaîne "Développement web, API" en tags affichables. */
  protected listeDisciplines(disciplines: string | null): string[] {
    return disciplines
      ? disciplines
          .split(',')
          .map((discipline) => discipline.trim())
          .filter(Boolean)
      : [];
  }

  /**
   * Détecte un lien YouTube/Vimeo dans url_projet et renvoie l'URL d'intégration
   * correspondante (pour les projets audiovisuels : CV vidéo, Webdoc, Autopromo...).
   * Renvoie null pour un lien de site classique (projet web).
   */
  protected urlVideoIncorporee(url: string | null): SafeResourceUrl | null {
    if (!url) {
      return null;
    }

    const youtube = url.match(/(?:youtu\.be\/|youtube\.com\/(?:watch\?v=|embed\/))([a-zA-Z0-9_-]{6,})/);
    if (youtube) {
      return this.sanitizer.bypassSecurityTrustResourceUrl(`https://www.youtube-nocookie.com/embed/${youtube[1]}`);
    }

    const vimeo = url.match(/vimeo\.com\/(\d+)/);
    if (vimeo) {
      return this.sanitizer.bypassSecurityTrustResourceUrl(`https://player.vimeo.com/video/${vimeo[1]}`);
    }

    return null;
  }
}
