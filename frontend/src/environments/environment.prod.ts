/**
 * Environnement de production : le frontend (Netlify) et l'API PHP
 * (InfinityFree) sont sur des domaines différents, il faut donc l'URL
 * complète de l'API.
 */
export const environment = {
  production: true,
  apiUrl: 'https://sae-portfolio-louanne.infinityfree.io/api',
};
