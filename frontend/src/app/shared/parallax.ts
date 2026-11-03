import { Directive, ElementRef, OnDestroy, OnInit, inject, input } from '@angular/core';

/**
 * Fait légèrement translater l'élément hôte à la verticale en fonction de
 * sa position dans la fenêtre pendant le défilement, pour donner une
 * impression de profondeur (effet de parallax).
 *
 * Usage : <div appParallax [appParallax]="0.15"> ... </div>
 * (plus la valeur est grande, plus le décalage est marqué)
 */
@Directive({
  selector: '[appParallax]',
})
export class Parallax implements OnInit, OnDestroy {
  private readonly element = inject(ElementRef<HTMLElement>);
  private idAnimation?: number;
  private actif = false;

  readonly appParallax = input(0.15);

  ngOnInit(): void {
    const prefereMoinsAnimations =
      typeof window !== 'undefined' &&
      typeof window.matchMedia === 'function' &&
      window.matchMedia('(prefers-reduced-motion: reduce)').matches;

    if (prefereMoinsAnimations || typeof requestAnimationFrame === 'undefined') {
      return;
    }

    this.actif = true;
    this.boucle();
  }

  private boucle = (): void => {
    if (!this.actif) {
      return;
    }

    const rect = this.element.nativeElement.getBoundingClientRect();
    const centreEcran = window.innerHeight / 2;
    const decalageDepuisCentre = rect.top + rect.height / 2 - centreEcran;
    const translation = decalageDepuisCentre * -this.appParallax();

    this.element.nativeElement.style.transform = `translateY(${translation}px)`;

    this.idAnimation = requestAnimationFrame(this.boucle);
  };

  ngOnDestroy(): void {
    this.actif = false;
    if (this.idAnimation !== undefined) {
      cancelAnimationFrame(this.idAnimation);
    }
  }
}
