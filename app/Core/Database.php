<?php

namespace App\Core;

use PDO;
use PDOException;

/**
 * Database — Conexión PDO en patrón Singleton.
 *
 * Compatible con hosting IONOS y entorno local.
 * Puerto explícito en el DSN para evitar problemas con hosts remotos.
 * Una única instancia de PDO por request. Sin lógica de negocio.
 *
 * Uso: $db = Database::getInstance();
 */
class Database
{
    private static ?PDO $instance = null;

    private function __construct() {}
    private function __clone()     {}

    public static function getInstance(): PDO
    {
        if (self::$instance === null) {
            // Puerto explícito: necesario en IONOS y otros hosts remotos
            $dsn = sprintf(
                'mysql:host=%s;port=%s;dbname=%s;charset=%s',
                DB_HOST,
                DB_PORT,
                DB_NAME,
                DB_CHARSET
            );

            $options = [
                PDO::ATTR_ERRMODE            => PDO::ERRMODE_EXCEPTION,
                PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC,
                PDO::ATTR_EMULATE_PREPARES   => false,
                PDO::ATTR_TIMEOUT            => 10,
            ];

            try {
                self::$instance = new PDO($dsn, DB_USER, DB_PASS, $options);
            } catch (PDOException $e) {
                if (APP_ENV === 'development') {
                    die('Error de conexión: ' . $e->getMessage());
                }
                die('Error interno del servidor.');
            }
        }

        return self::$instance;
    }

    /**
     * Verifica la conexión. Solo para desarrollo y verificación inicial.
     * No usar en lógica de negocio ni en producción.
     */
    public static function testConnection(): array
    {
        try {
            $db     = self::getInstance();
            $result = $db->query('SELECT 1 AS test')->fetch();

            if ($result && $result['test'] === 1) {
                $version = $db->query('SELECT VERSION() AS v')->fetch();
                $dbName  = $db->query('SELECT DATABASE() AS d')->fetch();
                return [
                    'success' => true,
                    'host'    => DB_HOST,
                    'db'      => $dbName['d'],
                    'version' => $version['v'],
                ];
            }

            return ['success' => false, 'message' => 'Respuesta inesperada del servidor.'];

        } catch (PDOException $e) {
            return ['success' => false, 'message' => $e->getMessage()];
        }
    }
}
