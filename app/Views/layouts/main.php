<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><?= htmlspecialchars($pageTitle ?? APP_NAME) ?></title>
    <link rel="icon" type="image/png" href="<?= APP_URL ?>/assets/img/logos/favicon.png">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="<?= APP_URL ?>/assets/css/app.css">
</head>
<body>
    <header class="site-header">
        <div class="site-header-inner">
            <a href="<?= APP_URL ?>/">
                <img src="<?= APP_URL ?>/assets/img/logos/logo_principal.png"
                     alt="<?= APP_NAME ?>" class="header-logo-img">
            </a>
        </div>
    </header>

    <main class="main-content"><?= $content ?></main>

    <footer class="site-footer">
        <div class="footer-bottom">
            <span>&copy; <?= date('Y') ?> <?= APP_NAME ?></span>
        </div>
    </footer>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script src="<?= APP_URL ?>/assets/js/app.js"></script>
</body>
</html>
