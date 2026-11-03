import { Directive, ElementRef, OnDestroy, OnInit, inject, input, signal } from '@angular/core';

/**
 * Ajoute une animation d'apparition en douceur lorsque l'élément hôte entre
 * dans le viewport (IntersectionObserver). Les classes CSS correspondantes
 * (.fade-in-scroll / .est-visible) sont définies dans src/styles.css.
 *
 * Usage : <article appFadeIn [appFadeInDelay]="i * 60"> ... </article>
 */
@Directive({
  selector: '[appFadeIn]',
  host: {
    class: 'fade-in-scroll',
    '[class.est-visible]': 'estVisible()',
    '[style.transition-delay.ms]': 'appFadeInDelay()',
  },
})
export class FadeIn implements OnInit, OnDestroy {
  private readonly element = inject(ElementRef<HTMLElement>);
  private observateur?: IntersectionObserver;

  /** Décalage optionnel (ms) pour créer un effet de cascade dans une liste. */
  readonly appFadeInDelay = input(0);

  protected readonly estVisible = signal(false);

  ngOnInit(): void {
    // Dégradation gracieuse : navigateurs anciens et environnements de test
    // (jsdom) n'implémentent pas IntersectionObserver. On affiche alors le
    // contenu directement plutôt que de bloquer sur une API absente.
    if (typeof IntersectionObserver === 'undefined') {
      this.estVisible.set(true);
      return;
    }

    this.observateur = new IntersectionObserver(
      ([entree]) => {
        if (entree.isIntersecting) {
          this.estVisible.set(true);
          this.observateur?.disconnect();
        }
      },
      { threshold: 0.15 }
    );
    this.observateur.observe(this.element.nativeElement);
  }

  ngOnDestroy(): void {
    this.observateur?.disconnect();
  }
}
