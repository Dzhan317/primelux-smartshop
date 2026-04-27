<div class="home-hero">
    <div class="home-hero-inner">

        <img
            src="<?= APP_URL ?>/assets/img/logos/logo_secundario.png"
            alt="<?= htmlspecialchars(APP_NAME) ?>"
            class="home-hero-logo"
        >

        <h1 class="home-hero-title">
            Bienvenido a <span>PrimeLux SmartShop</span>
        </h1>

        <p class="home-hero-subtitle">Tu tienda inteligente de confianza</p>

        <?php if (isset($_SESSION['user_id'])): ?>
            <p class="home-hero-welcome">
                Hola de nuevo, <strong><?= htmlspecialchars($_SESSION['user_name'] ?? '') ?></strong>
            </p>
        <?php endif; ?>

    </div>
</div>
