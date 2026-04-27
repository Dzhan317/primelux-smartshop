<?php

namespace App\Controllers;

use App\Core\Controller;
use App\Models\UserModel;
use App\Helpers\CsrfHelper;
use App\Helpers\SessionHelper;

class AuthController extends Controller
{
    private UserModel $userModel;

    public function __construct()
    {
        $this->userModel = new UserModel();
    }

    /* ============================================================
       REGISTRO
       ============================================================ */

    public function register(): void
    {
        if (SessionHelper::isLoggedIn()) {
            $this->redirect('/');
        }

        if ($_SERVER['REQUEST_METHOD'] === 'POST') {
            $this->handleRegister();
            return;
        }

        $this->renderAuth('auth/register', [
            'pageTitle' => 'Crear cuenta — ' . APP_NAME,
            'errors'    => [],
            'old'       => [],
            'flash'     => SessionHelper::getFlash(),
        ]);
    }

    private function handleRegister(): void
    {
        CsrfHelper::verify();

        $nombre          = trim($_POST['nombre']          ?? '');
        $apellidos       = trim($_POST['apellidos']       ?? '');
        $email           = trim($_POST['email']           ?? '');
        $password        = $_POST['password']             ?? '';
        $passwordConfirm = $_POST['password_confirm']     ?? '';

        $errors = $this->validateRegister($nombre, $apellidos, $email, $password, $passwordConfirm);

        if (!empty($errors)) {
            $this->renderAuth('auth/register', [
                'pageTitle' => 'Crear cuenta — ' . APP_NAME,
                'errors'    => $errors,
                'old'       => compact('nombre', 'apellidos', 'email'),
                'flash'     => null,
            ]);
            return;
        }

        if ($this->userModel->emailExists($email)) {
            $this->renderAuth('auth/register', [
                'pageTitle' => 'Crear cuenta — ' . APP_NAME,
                'errors'    => ['email' => 'Este correo electrónico ya está registrado.'],
                'old'       => compact('nombre', 'apellidos', 'email'),
                'flash'     => null,
            ]);
            return;
        }

        $this->userModel->create($nombre, $apellidos, $email, password_hash($password, PASSWORD_BCRYPT));
        SessionHelper::setFlash('success', 'Cuenta creada correctamente. Ya puedes iniciar sesión.');
        $this->redirect('/auth/login');
    }

    /* Política NIST SP 800-63B: 10 chars + 1 mayúscula + 1 número */
    private function validateRegister(
        string $nombre, string $apellidos, string $email,
        string $password, string $passwordConfirm
    ): array {
        $errors = [];

        if (empty($nombre))    $errors['nombre']    = 'El nombre es obligatorio.';
        if (empty($apellidos)) $errors['apellidos'] = 'Los apellidos son obligatorios.';

        if (empty($email)) {
            $errors['email'] = 'El correo electrónico es obligatorio.';
        } elseif (!filter_var($email, FILTER_VALIDATE_EMAIL)) {
            $errors['email'] = 'El formato del correo no es válido.';
        }

        if (empty($password)) {
            $errors['password'] = 'La contraseña es obligatoria.';
        } elseif (strlen($password) < 10) {
            $errors['password'] = 'La contraseña debe tener al menos 10 caracteres.';
        } elseif (!preg_match('/[A-Z]/', $password)) {
            $errors['password'] = 'La contraseña debe contener al menos una mayúscula.';
        } elseif (!preg_match('/[0-9]/', $password)) {
            $errors['password'] = 'La contraseña debe contener al menos un número.';
        }

        if ($password !== $passwordConfirm) {
            $errors['password_confirm'] = 'Las contraseñas no coinciden.';
        }

        return $errors;
    }

    /* ============================================================
       LOGIN
       ============================================================ */

    public function login(): void
    {
        if (SessionHelper::isLoggedIn()) {
            $this->redirect('/');
        }

        if ($_SERVER['REQUEST_METHOD'] === 'POST') {
            $this->handleLogin();
            return;
        }

        $this->renderAuth('auth/login', [
            'pageTitle' => 'Iniciar sesión — ' . APP_NAME,
            'error'     => null,
            'flash'     => SessionHelper::getFlash(),
        ]);
    }

    private function handleLogin(): void
    {
        CsrfHelper::verify();

        $email    = trim($_POST['email']    ?? '');
        $password = $_POST['password']      ?? '';
        $ip       = $_SERVER['REMOTE_ADDR'] ?? '0.0.0.0';

        if ($this->userModel->countRecentFailedAttempts($email, $ip) >= 5) {
            $this->renderAuth('auth/login', [
                'pageTitle' => 'Iniciar sesión — ' . APP_NAME,
                'error'     => 'Demasiados intentos fallidos. Espera 15 minutos e inténtalo de nuevo.',
                'flash'     => null,
            ]);
            return;
        }

        if (empty($email) || empty($password)) {
            $this->renderAuth('auth/login', [
                'pageTitle' => 'Iniciar sesión — ' . APP_NAME,
                'error'     => 'Por favor, introduce tu correo y contraseña.',
                'flash'     => null,
            ]);
            return;
        }

        $user = $this->userModel->findByEmail($email);

        /* Mensaje genérico: evita user enumeration attack */
        $genericError = 'Correo electrónico o contraseña incorrectos.';

        if (!$user || !password_verify($password, $user['contasenia_hash'])) {
            $this->userModel->logLoginAttempt($email, $ip, false);
            $this->renderAuth('auth/login', [
                'pageTitle' => 'Iniciar sesión — ' . APP_NAME,
                'error'     => $genericError,
                'flash'     => null,
            ]);
            return;
        }

        if ($user['estado'] !== 'activo') {
            $this->renderAuth('auth/login', [
                'pageTitle' => 'Iniciar sesión — ' . APP_NAME,
                'error'     => 'Tu cuenta no está activa. Contacta con soporte.',
                'flash'     => null,
            ]);
            return;
        }

        $this->userModel->logLoginAttempt($email, $ip, true);

        /* Fase 1: sesión directa.
           Fase 2 cambiará estas dos líneas por:
           SessionHelper::set2faPending($user['id_usuario']);
           $this->redirect('/auth/verify'); */
        SessionHelper::loginUser($user);
        $this->redirect('/');
    }

    /* ============================================================
       LOGOUT
       ============================================================ */

    public function logout(): void
    {
        /* Flash ANTES de destroy — sesión todavía activa */
        SessionHelper::setFlash('success', 'Has cerrado sesión correctamente.');
        SessionHelper::logout();
        session_name(SESSION_NAME);
        session_start();
        $this->redirect('/auth/login');
    }

    /* ============================================================
       VERIFY — Vista 2FA preparada. Lógica completa en Fase 2.
       ============================================================ */

    public function verify(): void
    {
        if (!SessionHelper::has2faPending()) {
            $this->redirect('/auth/login');
        }

        $this->renderAuth('auth/verify', [
            'pageTitle' => 'Verificación — ' . APP_NAME,
            'error'     => null,
        ]);
    }
}
