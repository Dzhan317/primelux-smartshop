<?php

namespace App\Helpers;

/**
 * SessionHelper — Infraestructura base del sistema de sesiones.
 *
 * Fase 0: solo ciclo de vida de sesión y mensajes flash.
 * Sin lógica de usuario, roles ni autenticación.
 *
 * En Fase 1 se extenderá con:
 *   - loginUser(), logout() completo
 *   - isLoggedIn(), isAdmin(), getUserId()
 *   - set2faPending(), get2faPendingUserId()
 */
class SessionHelper
{
    /**
     * Destruye la sesión de forma completa y segura.
     */
    public static function destroy(): void
    {
        $_SESSION = [];

        if (ini_get('session.use_cookies')) {
            $params = session_get_cookie_params();
            setcookie(
                session_name(), '',
                time() - 42000,
                $params['path'],
                $params['domain'],
                $params['secure'],
                $params['httponly']
            );
        }

        session_destroy();
    }

    /**
     * Guarda un mensaje flash en sesión (se muestra una sola vez).
     *
     * @param string $type    'success' | 'error' | 'warning' | 'info'
     * @param string $message Texto del mensaje
     */
    public static function setFlash(string $type, string $message): void
    {
        $_SESSION['flash'] = ['type' => $type, 'message' => $message];
    }

    /**
     * Recupera y elimina el mensaje flash.
     * Devuelve null si no hay ninguno pendiente.
     */
    public static function getFlash(): ?array
    {
        if (!isset($_SESSION['flash'])) {
            return null;
        }
        $flash = $_SESSION['flash'];
        unset($_SESSION['flash']);
        return $flash;
    }
}
