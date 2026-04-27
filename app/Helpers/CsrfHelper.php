<?php

namespace App\Helpers;

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

    public static function verify(): void
    {
        $fromPost    = $_POST[CSRF_TOKEN_NAME]    ?? '';
        $fromSession = $_SESSION[CSRF_TOKEN_NAME] ?? '';

        if (!hash_equals($fromSession, $fromPost)) {
            http_response_code(403);
            die('Petición no válida.');
        }

        unset($_SESSION[CSRF_TOKEN_NAME]);
    }
}
