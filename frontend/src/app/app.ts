import { Component } from '@angular/core';
import { RouterLink, RouterOutlet } from '@angular/router';

/**
 * Composant racine : joue le rôle du layout.php de l'ancienne version PHP
 * (header/footer communs). Le <router-outlet> affiche la page correspondant
 * à la route active (Accueil, PageIntrouvable).
 */
@Component({
  selector: 'app-root',
  imports: [RouterLink, RouterOutlet],
  templateUrl: './app.html',
  styleUrl: './app.css',
})
export class App {}
