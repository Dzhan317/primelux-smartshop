# 003 — Sistema de routing y .htaccess

**Fase:** 0  
**Tipo:** Arquitectónica / Seguridad

---

## Contexto

PHP por defecto expone todos los archivos del proyecto si el document root apunta a la raíz. Se necesita un sistema de URLs limpias y protección de archivos sensibles (config, modelos, etc.).

---

## Decisión tomada

`.htaccess (public):` gestiona las URL's limpias del sistema. Si la petición no corresponde a un archivo o directorio existente, se redirige a `index.php?url=...`, que actúa como punto de entrada único de la aplicación.


---

## Justificación técnica

Con este sistema, los únicos archivos accesibles desde el navegador son los de `public/assets/`. Todo el código PHP, credenciales y documentación quedan fuera del alcance del servidor web. Es el mismo patrón que usan Laravel y Symfony con su carpeta `public/`.

En IONOS: si el hosting permite configurar el document root al directorio `public/`, el `.htaccess` de raíz no es necesario. Si no (hosting compartido básico), es imprescindible. Se incluyen ambos para funcionar en cualquier configuración.

---
