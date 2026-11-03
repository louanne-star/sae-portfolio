import { Routes } from '@angular/router';

/**
 * Table de routage de l'application (équivalent du switch($_GET['page'])
 * du routeur PHP dans l'ancienne version MVC, mais géré côté client ici).
 */
export const routes: Routes = [
  {
    path: '',
    loadComponent: () => import('./pages/accueil/accueil').then((m) => m.Accueil),
    title: 'Accueil — Portfolio'
  },
  {
    path: '**',
    loadComponent: () =>
      import('./pages/page-introuvable/page-introuvable').then((m) => m.PageIntrouvable),
    title: 'Page introuvable — Portfolio'
  }
];
