/**
 * Environnement de production : le frontend (Netlify) et l'API PHP
 * (hébergeur distinct, ex. InfinityFree) sont sur des domaines différents,
 * il faut donc l'URL complète de l'API.
 *
 * À REMPLACER une fois l'hébergement backend créé, par l'URL réelle,
 * par exemple : https://sae-portfolio.infinityfreeapp.com/api
 */
export const environment = {
  production: true,
  apiUrl: 'https://A-REMPLACER.infinityfreeapp.com/api',
};
