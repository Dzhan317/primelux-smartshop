<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><?= htmlspecialchars($pageTitle ?? 'Checkout — ' . APP_NAME) ?></title>
    <link rel="icon" type="image/png" href="<?= APP_URL ?>/assets/img/logos/favicon.png">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="<?= APP_URL ?>/assets/css/app.css">
</head>
<body style="background:var(--bg-main);min-height:100vh;">
    <!-- Header y stepper: se implementan en Fase 6 -->
    <main><?= $content ?></main>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script src="<?= APP_URL ?>/assets/js/app.js"></script>
</body>
</html>
