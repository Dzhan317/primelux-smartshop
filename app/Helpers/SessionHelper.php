<?php

namespace App\Helpers;

class SessionHelper
{
    /* ============================================================
       SESIÓN DE USUARIO
       ============================================================ */

    public static function loginUser(array $user): void
    {
        session_regenerate_id(true);
        $_SESSION['user_id']    = (int) $user['id_usuario'];
        $_SESSION['user_name']  = $user['nombre'];
        $_SESSION['user_role']  = $user['rol'];
        $_SESSION['user_email'] = $user['email'];
    }

    public static function logout(): void
    {
        $_SESSION = [];
        if (ini_get('session.use_cookies')) {
            $p = session_get_cookie_params();
            setcookie(session_name(), '', time() - 42000,
                $p['path'], $p['domain'], $p['secure'], $p['httponly']);
        }
        session_destroy();
    }

    public static function isLoggedIn(): bool
    {
        return isset($_SESSION['user_id']);
    }

    public static function isAdmin(): bool
    {
        return self::isLoggedIn() && ($_SESSION['user_role'] ?? '') === 'admin';
    }

    public static function getUserId(): ?int    { return $_SESSION['user_id']    ?? null; }
    public static function getUserName(): ?string  { return $_SESSION['user_name']  ?? null; }
    public static function getUserRole(): ?string  { return $_SESSION['user_role']  ?? null; }
    public static function getUserEmail(): ?string { return $_SESSION['user_email'] ?? null; }

    /* ============================================================
       PENDIENTE 2FA — preparado para Fase 2, no modificar aquí
       ============================================================ */

    public static function set2faPending(int $userId): void    { $_SESSION['2fa_pending_user_id'] = $userId; }
    public static function get2faPendingUserId(): ?int         { return $_SESSION['2fa_pending_user_id'] ?? null; }
    public static function clear2faPending(): void             { unset($_SESSION['2fa_pending_user_id']); }
    public static function has2faPending(): bool               { return isset($_SESSION['2fa_pending_user_id']); }

    /* ============================================================
       MENSAJES FLASH
       ============================================================ */

    public static function setFlash(string $type, string $message): void
    {
        $_SESSION['flash'] = ['type' => $type, 'message' => $message];
    }

    public static function getFlash(): ?array
    {
        if (!isset($_SESSION['flash'])) return null;
        $flash = $_SESSION['flash'];
        unset($_SESSION['flash']);
        return $flash;
    }
}
