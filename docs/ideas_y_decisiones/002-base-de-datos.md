# 002 — Diseño de la base de datos

**Fase:** 0  
**Tipo:** Base de datos

---

## Contexto

El proyecto es un e-commerce multicategoría que necesita gestionar usuarios, productos, pedidos, pagos, reseñas, soporte y un motor de recomendaciones básico.

---

## Decisión tomada

Base de datos MySQL con InnoDB, organizada en cuatro bloques funcionales: usuarios y seguridad, catálogo, venta y carrito, y social/recomendaciones/soporte. Todos los campos de texto usan `utf8mb4`.

---

## Decisiones específicas destacadas

**Slugs en productos y categorías:** campo `slug VARCHAR UNIQUE NOT NULL`. Las URLs públicas usan slug en lugar de ID. Los IDs se reservan para uso interno y relaciones entre tablas. Esto mejora SEO y evita exponer estructura interna en URLs.

**Snapshot en pedidos:** `pedido_variantes` almacena `nombre_producto_historico` y `precio_unitario` en el momento de la compra. Así el historial de pedidos no cambia si el catálogo se modifica posteriormente.

**Dirección en pedido:** los campos de dirección se copian directamente en la tabla `pedidos` en lugar de usar FK a `direcciones`. Mismo principio de snapshot: la dirección de un pedido ya realizado no debe cambiar si el usuario actualiza sus datos.

**Corrección aplicada:** la tabla `codigos_2fa` tenía la columna `intentos_fallidos` duplicada en el schema original. Se eliminó la segunda aparición manteniendo `TINYINT UNSIGNED DEFAULT 0`.

---

## Alternativas descartadas

| Decisión | Alternativa descartada | Motivo |
|---|---|---|
| Slugs en URLs | Usar IDs en URLs | Expone estructura interna, peor SEO |
| Snapshot en pedidos | FK a tabla de precios | Complejidad innecesaria, riesgo de inconsistencia histórica |
| InnoDB | MyISAM | InnoDB soporta FK y transacciones, necesario para integridad referencial |

---

## Justificación técnica

La separación en cuatro bloques funcionales facilita explicar el modelo ante tribunal. Cada bloque tiene responsabilidad clara y las dependencias entre bloques son unidireccionales (todos dependen de usuarios, el bloque de venta depende del catálogo).
