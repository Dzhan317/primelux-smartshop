# Arquitectura MVC — PrimeLux SmartShop

**Fase:** 0 — Base del sistema  

---

## Patrón arquitectónico

El proyecto implementa el patrón **MVC (Model-View-Controller)** en PHP puro, sin frameworks externos. Esta decisión responde a los requisitos académicos del ciclo formativo DAW y permite demostrar el dominio de los fundamentos del desarrollo web en servidor.

---

## Estructura de capas (estado en Fase 0)

### Controller (Controlador)
Recibe la petición HTTP, coordina modelos y vistas, y devuelve la respuesta. No contiene lógica de negocio ni acceso directo a la base de datos.

Clase base: `app/Core/Controller.php`  
Proporciona métodos de renderizado (`render`, `renderAuth`, `renderAdmin`, `renderCheckout`) y redirección (`redirect`).

### Model (Modelo)
Acceso a datos mediante PDO con prepared statements. Cada modelo representa una entidad del dominio. No genera HTML ni gestiona sesiones.

En Fase 0 no hay modelos funcionales. Se crearán en las fases correspondientes a cada entidad.

### View (Vista)
Archivos PHP que generan HTML. Reciben datos del controlador mediante `extract()`. No contienen lógica de negocio.

Organizadas por entidad dentro de `app/Views/`. Los layouts (main, auth, admin, checkout) envuelven el contenido con `ob_start()` / `ob_get_clean()`.

---

## Flujo de una petición

```
1. Cliente (Navegador)
        │
        ▼
2. Servidor web (Apache / IONOS)
   - Procesa la petición HTTP
   - Aplica reglas de reescritura (URL rewriting)
   - Diferencia entre recursos estáticos y aplicación dinámica
        │
        ▼
3. Front Controller
   public/index.php
   - Punto único de entrada del sistema
   - Carga configuración global
   - Inicializa autoload (PSR-4)
   - Inicia sesión del usuario
   - Instancia el Router
        │
        ▼
4. Router (App\Core\Router)
   - Analiza la URL solicitada
   - Determina controlador y método correspondiente
   - Gestiona parámetros dinámicos
        │
        ▼
5. Controller (Capa de aplicación)
   - Implementa la lógica de negocio
   - Orquesta la interacción con los modelos
   - Aplica validaciones y reglas de flujo
        │
        ▼
6. Model (Capa de datos)
   - Acceso a base de datos mediante PDO
   - Ejecuta consultas SQL
   - Devuelve datos estructurados al controlador
        │
        ▼
7. View (Capa de presentación)
   - Genera la salida parcial de la interfaz
   - Utiliza buffering de salida (ob_start)
        │
        ▼
8. Layout (Plantilla base)
   - Integra vistas en una estructura común
   - Define header, footer y estructura visual global
        │
        ▼
9. Respuesta HTTP
   - Se genera HTML final
   - Se envía al navegador del cliente
```

---

## Estructura de carpetas

```
primelux-smartshop/
├── public/                      ← Único directorio accesible desde web
│   ├── index.php                ← Punto de entrada único
│   ├── .htaccess                ← URLs limpias
│   └── assets/
│       ├── css/app.css
│       ├── js/app.js
│       └── img/logos/
│
├── app/
│   ├── Core/
│   │   ├── Router.php           ← Enrutador por segmentos de URL
│   │   ├── Controller.php       ← Clase base de controladores
│   │   └── Database.php         ← Conexión PDO Singleton
│   │
│   ├── Controllers/             ← Un archivo por entidad
│   ├── Models/                  ← Un archivo por entidad
│   ├── Services/                ← Lógica compleja transversal (2FA, Stripe)
│   ├── Helpers/                 ← Funciones de apoyo (CSRF, sesión, email)
│   └── Views/
│       ├── layouts/             ← main, auth, admin, checkout
│       ├── home/
│       ├── auth/
│       ├── products/
│       ├── cart/
│       ├── orders/
│       ├── user/
│       └── admin/
│
├── config/
│   └── config.php               ← Constantes globales
│
├── docs/                        ← Documentación del proyecto
│
└── .htaccess                    ← Redirige raíz a public/
```

---

## Componentes activos en Fase 0

| Componente | Archivo | Estado |
|---|---|---|
| Punto de entrada | `public/index.php` | ✅ Activo |
| Enrutador | `app/Core/Router.php` | ✅ Activo |
| Conexión BD | `app/Core/Database.php` | ✅ Activo |
| Controlador base | `app/Core/Controller.php` | ✅ Activo |
| Protección CSRF | `app/Helpers/CsrfHelper.php` | ✅ Activo |
| Gestión sesión | `app/Helpers/SessionHelper.php` | ✅ Base |
| Controlador home | `app/Controllers/HomeController.php` | ✅ Mínimo |
| Layouts | `app/Views/layouts/*.php` | ✅ Preparatorios |

---

## Evolución prevista (alto nivel)

En fases posteriores la arquitectura se extiende sin modificar su base:

- **Fase 1:** `AuthController`, `User` model, lógica de sesión completa en `SessionHelper`
- **Fase 2:** `AuthService` para lógica 2FA, `EmailHelper`
- **Fase 3B en adelante:** modelos de `Product`, `Category`, `Order`, `Cart` y sus controllers correspondientes

Los `Services` se crean únicamente cuando existe lógica que no pertenece ni al Controller ni al Model (casos reales: 2FA, integración Stripe).

---

## Decisiones de diseño destacadas

**Autoload PSR-4 manual:** sin Composer por simplicidad y compatibilidad con el hosting IONOS. El autoloader registrado en `index.php` mapea `App\Core\Router` → `app/Core/Router.php`.

**PDO Singleton:** garantiza una única conexión por request. `PDO::ATTR_EMULATE_PREPARES = false` activa prepared statements reales, protegiendo contra SQL injection.

**Cuatro layouts:** `main` (tienda pública), `auth` (sin navegación), `admin` (sidebar), `checkout` (sin categorías). Esta separación evita condicionales complejos en un único layout.

**URLs limpias con slugs:** el `.htaccess` de `public/` redirige cualquier ruta no-archivo a `index.php?url=...`. El Router parsea la URL por segmentos. Los slugs de productos y categorías se usan en URLs públicas; los IDs solo internamente.
