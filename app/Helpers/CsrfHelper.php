<?php

namespace App\Helpers;

/**
 * CsrfHelper — Protección CSRF para formularios POST.
 *
 * Mecanismo de seguridad transversal presente en todos los formularios
 * del sistema, independientemente de la lógica de negocio.
 * Por eso pertenece a Fase 0 como base del sistema.
 *
 * Uso en vista:    <?= CsrfHelper::field() ?>
 * Uso en controller: CsrfHelper::verify();
 */
class CsrfHelper
{
    public static function generateToken(): string
    {
        if (empty($_SESSION[CSRF_TOKEN_NAME])) {
            $_SESSION[CSRF_TOKEN_NAME] = bin2hex(random_bytes(32));
        }
        return $_SESSION[CSRF_TOKEN_NAME];
    }

    public static function field(): string
    {
        return '<input type="hidden" name="' . CSRF_TOKEN_NAME
             . '" value="' . self::generateToken() . '">';
    }

    /**
     * Verifica el token. Usa hash_equals() para evitar timing attacks.
     * Regenera el token tras cada uso válido.
     */
    public static function verify(): void
    {
        $fromPost    = $_POST[CSRF_TOKEN_NAME]    ?? '';
        $fromSession = $_SESSION[CSRF_TOKEN_NAME] ?? '';

        if (!hash_equals($fromSession, $fromPost)) {
            http_response_code(403);
            die('Petición no válida. Token de seguridad incorrecto.');
        }

        unset($_SESSION[CSRF_TOKEN_NAME]);
    }
}
