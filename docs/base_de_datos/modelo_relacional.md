# Modelo Relacional — PrimeLux SmartShop

**Fase:** 0 — Base del sistema  
**Estado:** Base completa. Se ampliará con lógica de negocio en fases posteriores.

---

## Bloques del modelo

El esquema se organiza en cuatro bloques funcionales con relaciones entre ellos.

---

### Bloque 1: Usuarios y seguridad

```
usuarios (PK: id_usuario)
    │
    ├──< login_intentos       [1:N] Un usuario puede tener múltiples intentos registrados
    ├──< codigos_2fa          [1:N] Un usuario puede tener múltiples códigos 2FA (uno activo)
    └──< direcciones          [1:N] Un usuario puede tener múltiples direcciones
```

**Reglas:**
- `codigos_2fa.id_usuario` → `usuarios.id_usuario` ON DELETE CASCADE
- `direcciones.id_usuario` → `usuarios.id_usuario` ON DELETE CASCADE
- `login_intentos` no tiene FK a usuarios (registra intentos por email/IP, incluso de emails no existentes)

---

### Bloque 2: Catálogo

```
categorias (PK: id_categoria)
    │
    └──< categorias           [1:N] Autoreferencia: una categoría puede tener subcategorías
    │    (id_categoria_padre)
    │
    └──< producto_categoria   [N:M con productos]

productos (PK: id_producto)
    │
    ├──< producto_categoria   [N:M con categorias] Un producto puede estar en varias categorías
    ├──< variantes            [1:N] Un producto tiene al menos una variante
    └──< imagenes             [1:N] Un producto puede tener múltiples imágenes
```

**Tabla pivote:**
- `producto_categoria (id_producto, id_categoria)` → PK compuesta, resuelve la relación N:M

**Slugs:**
- `categorias.slug` y `productos.slug` son UNIQUE. Se usan en URLs públicas en lugar del ID.

---

### Bloque 3: Venta y carrito

```
usuarios
    └──< carritos             [1:N] Un usuario puede tener múltiples carritos (uno activo)
            └──< carrito_variantes [1:N] Un carrito contiene líneas de variantes

variantes
    ├──< carrito_variantes    [1:N] Una variante puede estar en múltiples carritos
    └──< pedido_variantes     [1:N] Una variante puede estar en múltiples pedidos

usuarios
    └──< pedidos              [1:N] Un usuario puede tener múltiples pedidos
            ├──< pedido_variantes [1:N] Un pedido contiene líneas con snapshot de precio
            └──< pagos            [1:1] Un pedido tiene un pago asociado
```

**Notas:**
- `pedido_variantes.nombre_producto_historico` almacena el nombre en el momento de la compra (snapshot), evitando dependencia del catálogo actual.
- `pedidos` almacena la dirección de envío directamente (snapshot), no FK a `direcciones`.

---

### Bloque 4: Social, recomendaciones y soporte

```
usuarios
    ├──< interacciones        [1:N] Eventos de comportamiento (visto, click, carrito)
    ├──< historial_vistas     [1:N] Registro de productos vistos
    ├──< intereses_usuario    [1:N] Puntuación de interés por categoría (motor recomendaciones)
    ├──< resenas              [1:N] Un usuario puede reseñar cada producto una vez (UNIQUE)
    └──< conversaciones       [1:N] Conversaciones de soporte abiertas por el usuario
            └──< mensajes     [1:N] Mensajes dentro de una conversación

productos
    ├──< interacciones        [1:N]
    ├──< historial_vistas     [1:N]
    └──< resenas              [1:N]

categorias
    └──< intereses_usuario    [1:N]
```

---

## Diagrama de dependencias entre bloques

```
[Bloque 1: Usuarios] ──────────────────────────────┐
        │                                           │
        ▼                                           ▼
[Bloque 3: Venta] ←── [Bloque 2: Catálogo]    [Bloque 4: Social]
```

Todos los bloques dependen de `usuarios`. El Bloque 3 depende además de `variantes` del Bloque 2.

---

## Convenciones del esquema

| Convención | Descripción |
|---|---|
| Claves primarias | `id_tabla` INT/BIGINT UNSIGNED AUTO_INCREMENT |
| Claves foráneas | Nombradas como `id_tabla_referenciada` |
| Slugs | VARCHAR UNIQUE NOT NULL en `categorias` y `productos` |
| Timestamps | `fecha_creacion` DATETIME DEFAULT CURRENT_TIMESTAMP |
| Soft states | Campo `estado` ENUM en lugar de DELETE físico donde aplica |
| Snapshots | Datos históricos copiados en pedidos para independencia del catálogo |
