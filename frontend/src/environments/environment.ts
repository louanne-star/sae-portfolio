/**
 * Environnement de développement local : le frontend et l'API tournent sur
 * des serveurs différents mais le proxy Angular (proxy.conf.json) redirige
 * /api vers localhost:8000, donc un chemin relatif suffit.
 */
export const environment = {
  production: false,
  apiUrl: '/api',
};
