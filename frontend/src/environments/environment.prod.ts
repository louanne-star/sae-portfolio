/**
 * Environnement de production : frontend et API sont servis depuis le même
 * domaine (InfinityFree), comme en développement — chemin relatif.
 *
 * (Note historique : un découpage frontend/Netlify + API/InfinityFree a été
 * tenté, mais la protection anti-bot d'InfinityFree bloque les requêtes
 * cross-origin vers l'API ; d'où ce retour à un déploiement mono-domaine.)
 */
export const environment = {
  production: true,
  apiUrl: '/api',
};
