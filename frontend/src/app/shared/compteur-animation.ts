import { Directive, ElementRef, OnDestroy, OnInit, inject, input } from '@angular/core';

/**
 * Anime un chiffre de 0 jusqu'à sa valeur finale lorsque l'élément hôte
 * entre dans le viewport (IntersectionObserver), avec un ralentissement
 * en fin de course (easing "ease-out cubique").
 *
 * Usage : <span [appCompteurAnimation]="42">0</span>
 */
@Directive({
  selector: '[appCompteurAnimation]',
})
export class CompteurAnimation implements OnInit, OnDestroy {
  private readonly element = inject(ElementRef<HTMLElement>);
  private observateur?: IntersectionObserver;
  private idAnimation?: number;

  /** Valeur finale à atteindre. */
  readonly appCompteurAnimation = input.required<number>();

  /** Durée de l'animation en millisecondes. */
  readonly duree = input(1200);

  ngOnInit(): void {
    const cible = this.appCompteurAnimation();

    // Dégradation gracieuse : pas d'IntersectionObserver (vieux navigateurs,
    // environnement de test) -> on affiche directement la valeur finale.
    if (typeof IntersectionObserver === 'undefined') {
      this.element.nativeElement.textContent = String(cible);
      return;
    }

    this.element.nativeElement.textContent = '0';

    this.observateur = new IntersectionObserver(
      ([entree]) => {
        if (entree.isIntersecting) {
          this.animer(cible);
          this.observateur?.disconnect();
        }
      },
      { threshold: 0.4 }
    );
    this.observateur.observe(this.element.nativeElement);
  }

  private animer(cible: number): void {
    const debut = performance.now();
    const dureeMs = this.duree();

    const etape = (maintenant: number): void => {
      const progression = Math.min((maintenant - debut) / dureeMs, 1);
      const progressionAdoucie = 1 - Math.pow(1 - progression, 3);
      const valeur = Math.round(progressionAdoucie * cible);

      this.element.nativeElement.textContent = String(valeur);

      if (progression < 1) {
        this.idAnimation = requestAnimationFrame(etape);
      }
    };

    this.idAnimation = requestAnimationFrame(etape);
  }

  ngOnDestroy(): void {
    if (this.idAnimation !== undefined) {
      cancelAnimationFrame(this.idAnimation);
    }
    this.observateur?.disconnect();
  }
}
