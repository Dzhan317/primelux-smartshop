<?php

namespace App\Models;

use App\Core\Database;
use PDO;

class UserModel
{
    private PDO $db;

    public function __construct()
    {
        $this->db = Database::getInstance();
    }

    public function findByEmail(string $email): ?array
    {
        $stmt = $this->db->prepare('SELECT * FROM usuarios WHERE email = :email LIMIT 1');
        $stmt->execute([':email' => $email]);
        return $stmt->fetch() ?: null;
    }

    public function findById(int $id): ?array
    {
        $stmt = $this->db->prepare('SELECT * FROM usuarios WHERE id_usuario = :id LIMIT 1');
        $stmt->execute([':id' => $id]);
        return $stmt->fetch() ?: null;
    }

    public function emailExists(string $email): bool
    {
        $stmt = $this->db->prepare('SELECT COUNT(*) FROM usuarios WHERE email = :email');
        $stmt->execute([':email' => $email]);
        return (int) $stmt->fetchColumn() > 0;
    }

    public function create(string $nombre, string $apellidos, string $email, string $hash): int
    {
        $stmt = $this->db->prepare(
            'INSERT INTO usuarios (nombre, apellidos, email, contasenia_hash)
             VALUES (:nombre, :apellidos, :email, :hash)'
        );
        $stmt->execute([
            ':nombre'    => $nombre,
            ':apellidos' => $apellidos,
            ':email'     => $email,
            ':hash'      => $hash,
        ]);
        return (int) $this->db->lastInsertId();
    }

    public function logLoginAttempt(string $email, string $ip, bool $success): void
    {
        $stmt = $this->db->prepare(
            'INSERT INTO login_intentos (email, ip, exito) VALUES (:email, :ip, :exito)'
        );
        $stmt->execute([':email' => $email, ':ip' => $ip, ':exito' => $success ? 1 : 0]);
    }

    public function countRecentFailedAttempts(string $email, string $ip, int $minutes = 15): int
    {
        $since = date('Y-m-d H:i:s', strtotime("-{$minutes} minutes"));
        $stmt  = $this->db->prepare(
            'SELECT COUNT(*) FROM login_intentos
             WHERE (email = :email OR ip = :ip) AND exito = 0 AND creado_en >= :since'
        );
        $stmt->execute([':email' => $email, ':ip' => $ip, ':since' => $since]);
        return (int) $stmt->fetchColumn();
    }
}
