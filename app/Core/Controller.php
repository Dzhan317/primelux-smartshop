<?php

namespace App\Core;

class Controller
{
    protected function render(string $view, array $data = []): void
    {
        extract($data);
        ob_start();
        include VIEW_PATH . $view . '.php';
        $content = ob_get_clean();
        include VIEW_PATH . 'layouts/main.php';
    }

    protected function renderAuth(string $view, array $data = []): void
    {
        extract($data);
        ob_start();
        include VIEW_PATH . $view . '.php';
        $content = ob_get_clean();
        include VIEW_PATH . 'layouts/auth.php';
    }

    protected function redirect(string $path): void
    {
        header('Location: ' . APP_URL . $path);
        exit;
    }

    protected function requireLogin(): void
    {
        if (!isset($_SESSION['user_id'])) {
            $this->redirect('/auth/login');
        }
    }
}
