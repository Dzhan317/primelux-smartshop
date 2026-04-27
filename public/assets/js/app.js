/* ============================================================
   PRIMELUX SMARTSHOP — app.js
   Fase 1
   ============================================================ */

document.addEventListener('DOMContentLoaded', function () {

    /* ============================================================
       TOGGLE DE CONTRASEÑA
       Mecanismo: cambio de src en <img> usando data-icon-show
       y data-icon-hide definidos en el botón del HTML.
       Sin SVG hardcodeado en JS.
       Compatible con Vue: mismo patrón data-* que usaría
       un componente Vue con :src binding.
       ============================================================ */
    document.querySelectorAll('.input-password-toggle').forEach(function (btn) {
        btn.addEventListener('click', function () {
            var targetId  = btn.getAttribute('data-target');
            var input     = document.getElementById(targetId);
            var icon      = btn.querySelector('.toggle-icon');

            if (!input || !icon) return;

            var isPassword = input.type === 'password';

            input.type = isPassword ? 'text' : 'password';

            icon.src = isPassword
                ? btn.getAttribute('data-icon-hide')
                : btn.getAttribute('data-icon-show');

            btn.setAttribute(
                'aria-label',
                isPassword ? 'Ocultar contraseña' : 'Mostrar contraseña'
            );
        });
    });

    /* ============================================================
       AUTO-OCULTAR ALERTS FLASH
       ============================================================ */
    document.querySelectorAll('.alert').forEach(function (alert) {
        setTimeout(function () {
            alert.style.transition = 'opacity 0.5s';
            alert.style.opacity    = '0';
            setTimeout(function () {
                if (alert.parentNode) {
                    alert.parentNode.removeChild(alert);
                }
            }, 500);
        }, 4000);
    });

});
