<div class="auth-wrapper">
    <div class="auth-card">

        <div class="auth-header">
            <a href="<?= APP_URL ?>/">
                <img
                    src="<?= APP_URL ?>/assets/img/logos/logo_principal.png"
                    alt="<?= htmlspecialchars(APP_NAME) ?>"
                    class="auth-logo"
                >
            </a>
            <div class="auth-2fa-icon">
                <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none"
                     stroke="currentColor" stroke-width="1.5"
                     stroke-linecap="round" stroke-linejoin="round">
                    <path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z"/>
                </svg>
            </div>
            <h1 class="auth-title">Introduce el código</h1>
            <p class="auth-subtitle">
                Hemos enviado un código de 6 dígitos a tu correo electrónico.
                Expira en <?= TWO_FA_EXPIRY_MINUTES ?> minutos.
            </p>
        </div>

        <?php if (!empty($error)): ?>
            <div class="alert alert-error"><?= htmlspecialchars($error) ?></div>
        <?php endif; ?>

        <form method="POST" action="<?= APP_URL ?>/auth/verify" novalidate>
            <?= \App\Helpers\CsrfHelper::field() ?>

            <div class="form-group">
                <input
                    type="text"
                    id="codigo"
                    name="codigo"
                    class="form-control form-control-code"
                    placeholder="000000"
                    maxlength="6"
                    autocomplete="one-time-code"
                    inputmode="numeric"
                    pattern="[0-9]{6}"
                    autofocus
                    required
                >
            </div>

            <button type="submit" class="btn btn-primary btn-full">
                Verificar
            </button>
        </form>

        <div class="auth-footer">
            <p><a href="<?= APP_URL ?>/auth/login">Volver al inicio de sesión</a></p>
        </div>

    </div>
</div>
