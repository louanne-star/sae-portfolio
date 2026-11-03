<?php
declare(strict_types=1);

/**
 * Database (Singleton)
 *
 * Garantit qu'une seule connexion PDO est ouverte pendant toute la durée
 * de vie d'une requête HTTP, même si plusieurs modèles ont besoin d'accéder
 * à la base de données. On évite ainsi d'ouvrir inutilement plusieurs
 * connexions coûteuses.
 */
class Database
{
    /** @var Database|null Unique instance de la classe (patron Singleton) */
    private static ?Database $instance = null;

    /** @var PDO Connexion PDO réellement utilisée par l'application */
    private PDO $connexion;

    /**
     * Le constructeur est privé : impossible de faire "new Database()"
     * depuis l'extérieur, on doit obligatoirement passer par getInstance().
     */
    private function __construct()
    {
        $dsn = 'mysql:host=' . DB_HOST . ';port=' . DB_PORT . ';dbname=' . DB_NAME . ';charset=' . DB_CHARSET;

        try {
            $this->connexion = new PDO($dsn, DB_USER, DB_PASS, [
                // Les erreurs SQL deviennent des exceptions PHP (try/catch possible)
                PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION,
                // Toutes les requêtes retournent des tableaux associatifs par défaut
                PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC,
                // Utilise les vraies requêtes préparées côté serveur MySQL (sécurité + perf)
                PDO::ATTR_EMULATE_PREPARES => false,
            ]);
        } catch (PDOException $exception) {
            // On ne renvoie jamais le message d'erreur brut (peut contenir des infos sensibles)
            if (MODE_DEBUG) {
                die('Erreur de connexion à la base de données : ' . $exception->getMessage());
            }
            die('Erreur de connexion à la base de données.');
        }
    }

    /** Empêche le clonage de l'instance unique */
    private function __clone(): void
    {
    }

    /**
     * Point d'accès unique à la connexion PDO.
     * Crée l'instance au premier appel, puis retourne toujours la même.
     */
    public static function getInstance(): PDO
    {
        if (self::$instance === null) {
            self::$instance = new self();
        }

        return self::$instance->connexion;
    }
}
