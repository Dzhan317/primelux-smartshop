<?php

namespace App\Core;

class Router
{
    private string $url;

    public function __construct(string $url)
    {
        $this->url = trim(strtolower($url), '/');
    }

    public function dispatch(): void
    {
        $segments = $this->url !== '' ? explode('/', $this->url) : [];

        $controllerName  = $segments[0] ?? 'home';
        $methodName      = $segments[1] ?? 'index';
        $params          = array_slice($segments, 2);
        $controllerClass = 'App\\Controllers\\' . ucfirst($controllerName) . 'Controller';

        if (!class_exists($controllerClass)) {
            $this->notFound();
            return;
        }

        $controller = new $controllerClass();

        if (!method_exists($controller, $methodName)) {
            $this->notFound();
            return;
        }

        call_user_func_array([$controller, $methodName], $params);
    }

    private function notFound(): void
    {
        http_response_code(404);
        echo '404 — Página no encontrada';
    }
}
