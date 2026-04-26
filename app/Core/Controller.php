<?php

namespace App\Core;

/**
 * Controller — Clase base de la que heredan todos los controladores.
 *
 * Proporciona métodos de renderizado y redirección.
 * No contiene lógica de negocio ni de autenticación.
 *
 * Métodos de protección de rutas (requireLogin, requireAdmin)
 */
class Controller
{
    /**
     * Renderiza una vista dentro del layout principal.
     *
     * @param string $view  Ruta relativa desde Views/. Ej: 'home/index'
     * @param array  $data  Variables disponibles en la vista
     */
    protected function render(string $view, array $data = []): void
    {
        extract($data);
        ob_start();
        include VIEW_PATH . $view . '.php';
        $content = ob_get_clean();
        include VIEW_PATH . 'layouts/main.php';
    }

    /**
     * Renderiza dentro del layout de autenticación.
     * Sin header ni footer de la tienda.
     */
    protected function renderAuth(string $view, array $data = []): void
    {
        extract($data);
        ob_start();
        include VIEW_PATH . $view . '.php';
        $content = ob_get_clean();
        include VIEW_PATH . 'layouts/auth.php';
    }

    /**
     * Renderiza dentro del layout de administración.
     */
    protected function renderAdmin(string $view, array $data = []): void
    {
        extract($data);
        ob_start();
        include VIEW_PATH . $view . '.php';
        $content = ob_get_clean();
        include VIEW_PATH . 'layouts/admin.php';
    }

    /**
     * Renderiza dentro del layout de checkout.
     * Sin navbar de categorías, estructura enfocada en conversión.
     */
    protected function renderCheckout(string $view, array $data = []): void
    {
        extract($data);
        ob_start();
        include VIEW_PATH . $view . '.php';
        $content = ob_get_clean();
        include VIEW_PATH . 'layouts/checkout.php';
    }

    /**
     * Redirige a una ruta relativa a APP_URL.
     * Uso: $this->redirect('/auth/login')
     */
    protected function redirect(string $path): void
    {
        header('Location: ' . APP_URL . $path);
        exit;
    }
}
