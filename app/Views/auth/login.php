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
            <h1 class="auth-title">¡Te damos la bienvenida!</h1>
        </div>

        <?php if (!empty($flash)): ?>
            <div class="alert alert-<?= htmlspecialchars($flash['type']) ?>">
                <?= htmlspecialchars($flash['message']) ?>
            </div>
        <?php endif; ?>

        <?php if (!empty($error)): ?>
            <div class="alert alert-error"><?= htmlspecialchars($error) ?></div>
        <?php endif; ?>

        <form method="POST" action="<?= APP_URL ?>/auth/login" novalidate>
            <?= \App\Helpers\CsrfHelper::field() ?>

            <div class="form-group">
                <label for="email" class="form-label">Correo electrónico</label>
                <input
                    type="email"
                    id="email"
                    name="email"
                    class="form-control"
                    placeholder="tu@email.com"
                    value="<?= htmlspecialchars($_POST['email'] ?? '') ?>"
                    autocomplete="email"
                    required
                >
            </div>

            <div class="form-group">
                <label for="password" class="form-label">Contraseña</label>
                <div class="input-password-wrapper">
                    <input
                        type="password"
                        id="password"
                        name="password"
                        class="form-control"
                        placeholder="••••••••••"
                        autocomplete="current-password"
                        required
                    >
                    <button
                        type="button"
                        class="input-password-toggle"
                        data-target="password"
                        data-icon-show="<?= APP_URL ?>/assets/img/icons/eye.svg"
                        data-icon-hide="<?= APP_URL ?>/assets/img/icons/eye-off.svg"
                        aria-label="Mostrar contraseña"
                    >
                        <img
                            src="<?= APP_URL ?>/assets/img/icons/eye.svg"
                            alt=""
                            class="toggle-icon"
                            aria-hidden="true"
                        >
                    </button>
                </div>
            </div>

            <div class="form-group-link">
                <a href="#">¿Has olvidado tu contraseña?</a>
            </div>

            <button type="submit" class="btn btn-primary btn-full">
                Iniciar sesión
            </button>
        </form>

        <div class="auth-footer">
            <p>¿No tienes cuenta? <a href="<?= APP_URL ?>/auth/register">Regístrate</a></p>
        </div>

    </div>
</div>
