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
            <h1 class="auth-title">Bienvenido a <?= htmlspecialchars(APP_NAME) ?></h1>
            <p class="auth-subtitle">(*) Campos obligatorios</p>
        </div>

        <form method="POST" action="<?= APP_URL ?>/auth/register" novalidate>
            <?= \App\Helpers\CsrfHelper::field() ?>

            <div class="form-group">
                <label for="email" class="form-label">Correo electrónico *</label>
                <input
                    type="email"
                    id="email"
                    name="email"
                    class="form-control <?= !empty($errors['email']) ? 'is-invalid' : '' ?>"
                    placeholder="tu@email.com"
                    value="<?= htmlspecialchars($old['email'] ?? '') ?>"
                    autocomplete="email"
                    required
                >
                <?php if (!empty($errors['email'])): ?>
                    <span class="form-error"><?= htmlspecialchars($errors['email']) ?></span>
                <?php endif; ?>
            </div>

            <div class="form-row">
                <div class="form-group">
                    <label for="nombre" class="form-label">Nombre *</label>
                    <input
                        type="text"
                        id="nombre"
                        name="nombre"
                        class="form-control <?= !empty($errors['nombre']) ? 'is-invalid' : '' ?>"
                        placeholder="Nombre"
                        value="<?= htmlspecialchars($old['nombre'] ?? '') ?>"
                        autocomplete="given-name"
                        required
                    >
                    <?php if (!empty($errors['nombre'])): ?>
                        <span class="form-error"><?= htmlspecialchars($errors['nombre']) ?></span>
                    <?php endif; ?>
                </div>
                <div class="form-group">
                    <label for="apellidos" class="form-label">Apellidos *</label>
                    <input
                        type="text"
                        id="apellidos"
                        name="apellidos"
                        class="form-control <?= !empty($errors['apellidos']) ? 'is-invalid' : '' ?>"
                        placeholder="Apellidos"
                        value="<?= htmlspecialchars($old['apellidos'] ?? '') ?>"
                        autocomplete="family-name"
                        required
                    >
                    <?php if (!empty($errors['apellidos'])): ?>
                        <span class="form-error"><?= htmlspecialchars($errors['apellidos']) ?></span>
                    <?php endif; ?>
                </div>
            </div>

            <div class="form-group">
                <label for="password" class="form-label">Contraseña *</label>
                <div class="input-password-wrapper">
                    <input
                        type="password"
                        id="password"
                        name="password"
                        class="form-control <?= !empty($errors['password']) ? 'is-invalid' : '' ?>"
                        placeholder="Mínimo 10 caracteres"
                        autocomplete="new-password"
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
                <?php if (!empty($errors['password'])): ?>
                    <span class="form-error"><?= htmlspecialchars($errors['password']) ?></span>
                <?php else: ?>
                    <div class="password-hints">
                        <span>Mínimo 10 caracteres</span>
                        <span>Al menos 1 mayúscula y 1 número</span>
                    </div>
                <?php endif; ?>
            </div>

            <div class="form-group">
                <label for="password_confirm" class="form-label">Confirmar contraseña *</label>
                <div class="input-password-wrapper">
                    <input
                        type="password"
                        id="password_confirm"
                        name="password_confirm"
                        class="form-control <?= !empty($errors['password_confirm']) ? 'is-invalid' : '' ?>"
                        placeholder="Repite tu contraseña"
                        autocomplete="new-password"
                        required
                    >
                    <button
                        type="button"
                        class="input-password-toggle"
                        data-target="password_confirm"
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
                <?php if (!empty($errors['password_confirm'])): ?>
                    <span class="form-error"><?= htmlspecialchars($errors['password_confirm']) ?></span>
                <?php endif; ?>
            </div>

            <button type="submit" class="btn btn-primary btn-full">
                Crear cuenta
            </button>
        </form>

        <div class="auth-footer">
            <p>¿Ya tienes cuenta? <a href="<?= APP_URL ?>/auth/login">Inicia sesión</a></p>
        </div>

    </div>
</div>
