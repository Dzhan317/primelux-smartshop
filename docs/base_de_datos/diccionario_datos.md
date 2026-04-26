# Diccionario de Datos — PrimeLux SmartShop

**Fase:** 0 — Base del sistema  
**Estado:** Descripción técnica base. La columna "Lógica de negocio" se completa en cada fase.

---

## usuarios

| Campo | Tipo | Nulo | Default | Descripción |
|-------|------|------|---------|-------------|
| id_usuario | INT UNSIGNED | NO | AUTO_INCREMENT | PK. Identificador único del usuario |
| nombre | VARCHAR(100) | NO | — | Nombre de pila del usuario |
| apellidos | VARCHAR(150) | NO | — | Apellidos del usuario |
| email | VARCHAR(150) | NO | — | Email único. Usado como identificador de login |
| contrasenia_hash | VARCHAR(255) | NO | — | Hash Bcrypt de la contraseña |
| rol | ENUM | NO | 'cliente' | Rol del usuario: 'admin' o 'cliente' |
| estado | ENUM | NO | 'activo' | Estado de la cuenta: 'activo', 'inactivo', 'bloqueado' |
| fecha_creacion | DATETIME | NO | CURRENT_TIMESTAMP | Fecha de registro |
| fecha_actualizacion | DATETIME | NO | CURRENT_TIMESTAMP | Última modificación (auto-actualizado) |

**Índices:** `idx_usuarios_rol_estado (rol, estado)`

---

## login_intentos

| Campo | Tipo | Nulo | Default | Descripción |
|---|---|---|---|---|
| id_intento | INT UNSIGNED | NO | AUTO_INCREMENT | PK |
| email | VARCHAR(255) | NO | — | Email con el que se intentó el login |
| ip | VARCHAR(45) | NO | — | IP de origen (soporta IPv6) |
| exito | BOOLEAN | NO | — | TRUE si el intento fue exitoso |
| fecha_creacion | DATETIME | NO | CURRENT_TIMESTAMP | Timestamp del intento |

**Índices:** `idx_email`, `idx_ip`, `idx_fecha`  
**Nota:** No tiene FK a `usuarios`. Registra intentos de cualquier email, exista o no.

---

## codigos_2fa

| Campo | Tipo | Nulo | Default | Descripción |
|---|---|---|---|---|
| id_2fa | INT UNSIGNED | NO | AUTO_INCREMENT | PK |
| id_usuario | INT UNSIGNED | NO | — | FK → usuarios.id_usuario |
| codigo_hash | CHAR(64) | NO | — | Hash SHA-256 del código de 6 dígitos |
| expiracion | DATETIME | NO | — | Momento en que el código deja de ser válido |
| fecha_creacion | DATETIME | NO | CURRENT_TIMESTAMP | Momento de generación |
| usado_en | DATETIME | SÍ | NULL | Momento en que fue usado (NULL = no usado) |
| intentos_fallidos | TINYINT UNSIGNED | NO | 0 | Intentos de verificación fallidos |
| bloqueado_hasta | DATETIME | SÍ | NULL | Bloqueo temporal tras exceder intentos |
| ip_solicitud | VARCHAR(45) | SÍ | NULL | IP desde la que se solicitó el código |

**FK:** `id_usuario` → `usuarios.id_usuario` ON DELETE CASCADE

---

## direcciones

| Campo | Tipo | Nulo | Default | Descripción |
|---|---|---|---|---|
| id_direccion | INT UNSIGNED | NO | AUTO_INCREMENT | PK |
| id_usuario | INT UNSIGNED | NO | — | FK → usuarios.id_usuario |
| calle | VARCHAR(255) | NO | — | Dirección completa |
| ciudad | VARCHAR(100) | NO | — | Ciudad |
| provincia | VARCHAR(100) | NO | — | Provincia |
| codigo_postal | VARCHAR(10) | NO | — | Código postal |
| pais | VARCHAR(100) | NO | 'España' | País |
| telefono | VARCHAR(15) | SÍ | NULL | Teléfono de contacto para el envío |
| es_principal | BOOLEAN | NO | FALSE | Indica si es la dirección predeterminada |

---

## categorias

| Campo | Tipo | Nulo | Default | Descripción |
|---|---|---|---|---|
| id_categoria | INT UNSIGNED | NO | AUTO_INCREMENT | PK |
| nombre | VARCHAR(100) | NO | — | Nombre visible de la categoría |
| slug | VARCHAR(100) | NO | — | Identificador URL-friendly. UNIQUE |
| descripcion | TEXT | SÍ | NULL | Descripción opcional |
| id_categoria_padre | INT UNSIGNED | SÍ | NULL | FK → categorias.id_categoria (autoreferencia) |
| estado | ENUM | NO | 'activa' | 'activa' o 'inactiva' |
| fecha_creacion | DATETIME | NO | CURRENT_TIMESTAMP | — |

---

## productos

| Campo | Tipo | Nulo | Default | Descripción |
|---|---|---|---|---|
| id_producto | INT UNSIGNED | NO | AUTO_INCREMENT | PK |
| nombre | VARCHAR(150) | NO | — | Nombre del producto |
| slug | VARCHAR(150) | NO | — | Identificador URL-friendly. UNIQUE |
| descripcion | TEXT | SÍ | NULL | Descripción larga del producto |
| precio_base | DECIMAL(10,2) | NO | 0.00 | Precio base sin variantes |
| estado | ENUM | NO | 'activo' | 'activo' o 'inactivo' |
| fecha_creacion | DATETIME | NO | CURRENT_TIMESTAMP | — |
| fecha_actualizacion | DATETIME | NO | CURRENT_TIMESTAMP | Auto-actualizado |

---

## producto_categoria

| Campo | Tipo | Descripción |
|---|---|---|
| id_producto | INT UNSIGNED | FK → productos.id_producto. Parte de PK compuesta |
| id_categoria | INT UNSIGNED | FK → categorias.id_categoria. Parte de PK compuesta |

**Tabla intermediaria** que resuelve la relación N:M entre productos y categorías.

---

## variantes

| Campo | Tipo | Nulo | Default | Descripción |
|---|---|---|---|---|
| id_variante | INT UNSIGNED | NO | AUTO_INCREMENT | PK |
| id_producto | INT UNSIGNED | NO | — | FK → productos.id_producto |
| nombre | VARCHAR(100) | NO | — | Nombre de la variante (ej: "Talla M", "Color Rojo") |
| precio_adicional | DECIMAL(10,2) | NO | 0.00 | Precio adicional sobre precio_base |
| stock | INT UNSIGNED | NO | 0 | Unidades disponibles |

---

## imagenes

| Campo | Tipo | Nulo | Default | Descripción |
|---|---|---|---|---|
| id_imagen | INT UNSIGNED | NO | AUTO_INCREMENT | PK |
| id_producto | INT UNSIGNED | NO | — | FK → productos.id_producto |
| url_imagen | VARCHAR(255) | NO | — | Ruta relativa o URL de la imagen |
| es_principal | BOOLEAN | NO | FALSE | Imagen principal del producto |

---

## carritos

| Campo | Tipo | Nulo | Default | Descripción |
|---|---|---|---|---|
| id_carrito | BIGINT UNSIGNED | NO | AUTO_INCREMENT | PK |
| id_usuario | INT UNSIGNED | NO | — | FK → usuarios.id_usuario |
| estado_carrito | ENUM | NO | 'activo' | 'activo', 'abandonado', 'convertido' |
| fecha_creacion | DATETIME | NO | CURRENT_TIMESTAMP | — |
| fecha_actualizacion | DATETIME | NO | CURRENT_TIMESTAMP | Auto-actualizado |

---

## carrito_variantes

| Campo | Tipo | Nulo | Default | Descripción |
|---|---|---|---|---|
| id_item | BIGINT UNSIGNED | NO | AUTO_INCREMENT | PK |
| id_carrito | BIGINT UNSIGNED | NO | — | FK → carritos.id_carrito |
| id_variante | INT UNSIGNED | NO | — | FK → variantes.id_variante |
| cantidad | INT UNSIGNED | NO | 1 | Unidades añadidas al carrito |

---

## pedidos

| Campo | Tipo | Nulo | Default | Descripción |
|---|---|---|---|---|
| id_pedido | BIGINT UNSIGNED | NO | AUTO_INCREMENT | PK |
| id_usuario | INT UNSIGNED | NO | — | FK → usuarios.id_usuario |
| estado | ENUM | NO | 'pendiente' | pendiente, pagado, enviado, entregado, cancelado |
| tipo_envio | ENUM | NO | 'estandar' | estandar, express, punto_recogida |
| coste_envio | DECIMAL(10,2) | NO | 0.00 | Coste del envío aplicado |
| total | DECIMAL(10,2) | NO | — | Total del pedido incluyendo envío |
| calle … pais | VARCHAR | SÍ | NULL | Snapshot de dirección en el momento del pedido |
| telefono | VARCHAR(15) | SÍ | NULL | Teléfono de contacto para el envío |
| fecha_creacion | DATETIME | NO | CURRENT_TIMESTAMP | — |

---

## pedido_variantes

| Campo | Tipo | Nulo | Default | Descripción |
|---|---|---|---|---|
| id_item | BIGINT UNSIGNED | NO | AUTO_INCREMENT | PK |
| id_pedido | BIGINT UNSIGNED | NO | — | FK → pedidos.id_pedido |
| id_variante | INT UNSIGNED | NO | — | FK → variantes.id_variante |
| nombre_producto_historico | VARCHAR(150) | SÍ | NULL | Nombre del producto en el momento de la compra |
| cantidad | INT UNSIGNED | NO | — | Unidades compradas |
| precio_unitario | DECIMAL(10,2) | NO | — | Precio unitario en el momento de la compra |
| subtotal | DECIMAL(10,2) | NO | — | cantidad × precio_unitario |

---

## pagos

| Campo | Tipo | Nulo | Default | Descripción |
|---|---|---|---|---|
| id_pago | BIGINT UNSIGNED | NO | AUTO_INCREMENT | PK |
| id_pedido | BIGINT UNSIGNED | NO | — | FK → pedidos.id_pedido |
| proveedor_pago | VARCHAR(50) | SÍ | NULL | Nombre del proveedor (ej: 'stripe') |
| id_pago_externo | VARCHAR(255) | SÍ | NULL | ID de la transacción en el proveedor externo |
| metodo_pago | ENUM | NO | — | tarjeta, paypal, google_pay, apple_pay |
| estado_pago | ENUM | NO | 'pendiente' | pendiente, completado, fallido |
| importe | DECIMAL(10,2) | NO | — | Importe procesado |
| moneda | VARCHAR(10) | NO | 'EUR' | Código de moneda ISO 4217 |
| fecha_pago | DATETIME | NO | CURRENT_TIMESTAMP | — |

---

## interacciones

| Campo | Tipo | Descripción |
|---|---|---|
| id_interaccion | BIGINT UNSIGNED | PK |
| id_usuario | INT UNSIGNED | FK → usuarios |
| id_producto | INT UNSIGNED | FK → productos |
| tipo_interaccion | ENUM | 'visto', 'click', 'carrito' |
| fecha_creacion | DATETIME | Timestamp del evento |

---

## historial_vistas

| Campo | Tipo | Descripción |
|---|---|---|
| id_vista | BIGINT UNSIGNED | PK |
| id_usuario | INT UNSIGNED | FK → usuarios |
| id_producto | INT UNSIGNED | FK → productos |
| fecha_creacion | DATETIME | Timestamp de la visita |

---

## intereses_usuario

| Campo | Tipo | Descripción |
|---|---|---|
| id_usuario | INT UNSIGNED | PK compuesta + FK → usuarios |
| id_categoria | INT UNSIGNED | PK compuesta + FK → categorias |
| puntuacion_interes | INT | Puntuación acumulada de interés |
| ultima_interaccion | TIMESTAMP | Auto-actualizado en cada interacción |

---

## resenas

| Campo | Tipo | Descripción |
|---|---|---|
| id_resena | INT UNSIGNED | PK |
| id_usuario | INT UNSIGNED | FK → usuarios |
| id_producto | INT UNSIGNED | FK → productos |
| puntuacion | TINYINT UNSIGNED | Valor entre 1 y 5 (CHECK constraint) |
| comentario | TEXT | Texto de la reseña (opcional) |
| fecha_creacion | DATETIME | Timestamp de la reseña |

**Restricción:** UNIQUE (id_usuario, id_producto) — Un usuario solo puede reseñar un producto a la vez.

---

## conversaciones

| Campo | Tipo | Descripción |
|---|---|---|
| id_conversacion | INT UNSIGNED | PK |
| id_usuario | INT UNSIGNED | FK → usuarios |
| asunto | VARCHAR(255) | Asunto de la conversación |
| estado | ENUM | 'abierto' o 'cerrado' |
| fecha_creacion | DATETIME | — |

---

## mensajes

| Campo | Tipo | Descripción |
|---|---|---|
| id_mensaje | BIGINT UNSIGNED | PK |
| id_conversacion | INT UNSIGNED | FK → conversaciones |
| id_usuario | INT UNSIGNED | FK → usuarios (puede ser cliente o admin) |
| mensaje | TEXT | Contenido del mensaje |
| leido | BOOLEAN | FALSE hasta que el destinatario lo lea |
| fecha_creacion | DATETIME | Timestamp del mensaje |
