<?php

namespace App\Controllers;

use App\Core\Controller;

/**
 * HomeController — Controlador de inicio.
 * Fase 0: Verificar que el sistema base funciona.
 * Se completará en Fase 4 con el catálogo real.
 */
class HomeController extends Controller
{
    public function index(): void
    {
        $this->render('home/index', [
            'pageTitle' => APP_NAME,
        ]);
    }
}
