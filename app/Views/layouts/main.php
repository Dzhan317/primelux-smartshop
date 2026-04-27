<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><?= htmlspecialchars($pageTitle ?? APP_NAME) ?></title>
    <link rel="icon" type="image/png" href="<?= APP_URL ?>/assets/img/logos/favicon.png">
    <link rel="stylesheet" href="<?= APP_URL ?>/assets/css/app.css">
</head>
<body>

<header class="site-header">
    <div class="site-header-inner">

        <a href="<?= APP_URL ?>/" class="header-logo-link">
            <img
                src="<?= APP_URL ?>/assets/img/logos/logo_principal.png"
                alt="<?= htmlspecialchars(APP_NAME) ?>"
                class="header-logo-img"
            >
        </a>

        <nav class="header-user-nav">
            <?php if (isset($_SESSION['user_id'])): ?>
                <span class="header-user-greeting">
                    <?= htmlspecialchars($_SESSION['user_name'] ?? '') ?>
                </span>
                <a href="<?= APP_URL ?>/auth/logout" class="btn btn-danger btn-sm">
                    Cerrar sesión
                </a>
            <?php else: ?>
                <a href="<?= APP_URL ?>/auth/login"    class="btn btn-secondary btn-sm">Iniciar sesión</a>
                <a href="<?= APP_URL ?>/auth/register" class="btn btn-primary btn-sm">Registrarse</a>
            <?php endif; ?>
        </nav>

    </div>
</header>

<main class="main-content">
    <?= $content ?>
</main>

<footer class="site-footer">
    <div class="footer-bottom">
        <span>&copy; <?= date('Y') ?> <?= htmlspecialchars(APP_NAME) ?></span>
    </div>
</footer>

<script src="<?= APP_URL ?>/assets/js/app.js"></script>
</body>
</html>
