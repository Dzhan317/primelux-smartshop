<?php

// =============================================================
// PUNTO DE ENTRADA ÚNICO — PRIMELUX SMARTSHOP
// =============================================================

// --- Autoload PSR-4 manual -----------------------------------
spl_autoload_register(function (string $class): void {
    $prefix  = 'App\\';
    $baseDir = dirname(__DIR__) . '/app/';
    if (strncmp($prefix, $class, strlen($prefix)) !== 0) return;
    $file = $baseDir . str_replace('\\', '/', substr($class, strlen($prefix))) . '.php';
    if (file_exists($file)) require $file;
});

// --- Configuración -------------------------------------------
require_once dirname(__DIR__) . '/config/config.php';

// --- Sesión segura -------------------------------------------
session_name(SESSION_NAME);
session_set_cookie_params([
    'lifetime' => SESSION_LIFETIME,
    'path'     => '/',
    'secure'   => APP_ENV === 'production',
    'httponly' => true,
    'samesite' => 'Lax',
]);
session_start();

// --- Router --------------------------------------------------
$url    = $_GET['url'] ?? '';
$router = new App\Core\Router($url);
$router->dispatch();
