<?php

spl_autoload_register(function (string $class): void {
    $prefix  = 'App\\';
    $baseDir = dirname(__DIR__) . '/app/';
    if (strncmp($prefix, $class, strlen($prefix)) !== 0) return;
    $file = $baseDir . str_replace('\\', '/', substr($class, strlen($prefix))) . '.php';
    if (file_exists($file)) require $file;
});

require_once dirname(__DIR__) . '/config/config.php';

session_name(SESSION_NAME);
session_set_cookie_params([
    'lifetime' => SESSION_LIFETIME,
    'path'     => '/',
    'secure'   => APP_ENV === 'production',
    'httponly' => true,
    'samesite' => 'Lax',
]);
session_start();

$url    = $_GET['url'] ?? '';
$router = new App\Core\Router($url);
$router->dispatch();
