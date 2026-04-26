SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ============================================================
-- BLOQUE 1: USUARIOS Y SEGURIDAD
-- ============================================================

CREATE TABLE usuarios (
    id_usuario          INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,

    nombre              VARCHAR(100)  NOT NULL,
    apellidos           VARCHAR(150)  NOT NULL,
    email               VARCHAR(150)  UNIQUE NOT NULL,
    contrasenia_hash     VARCHAR(255)  NOT NULL,

    rol                 ENUM('admin','cliente') DEFAULT 'cliente',
    estado              ENUM('activo','inactivo','bloqueado') DEFAULT 'activo',

    fecha_creacion      DATETIME DEFAULT CURRENT_TIMESTAMP,
    fecha_actualizacion DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

    INDEX idx_usuarios_rol_estado (rol, estado)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE login_intentos (
    id_intento INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,

    email      VARCHAR(255) NOT NULL,
    ip         VARCHAR(45)  NOT NULL,
    exito      BOOLEAN      NOT NULL,
    creado_en  DATETIME DEFAULT CURRENT_TIMESTAMP,

    INDEX idx_email (email),
    INDEX idx_ip    (ip),
    INDEX idx_fecha (creado_en)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE codigos_2fa (
    id_2fa            INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    id_usuario        INT UNSIGNED NOT NULL,

    codigo_hash       CHAR(64)     NOT NULL,

    expiracion        DATETIME     NOT NULL,
    fecha_creacion         DATETIME DEFAULT CURRENT_TIMESTAMP,
    usado_en          DATETIME NULL,

    intentos_fallidos TINYINT UNSIGNED DEFAULT 0,
    bloqueado_hasta   DATETIME NULL,
    ip_solicitud      VARCHAR(45),

    FOREIGN KEY (id_usuario) REFERENCES usuarios(id_usuario) ON DELETE CASCADE,
    INDEX idx_2fa_usuario (id_usuario),
    INDEX idx_expiracion  (expiracion)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE direcciones (
    id_direccion  INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    id_usuario    INT UNSIGNED NOT NULL,

    calle         VARCHAR(255) NOT NULL,
    ciudad        VARCHAR(100) NOT NULL,
    provincia     VARCHAR(100) NOT NULL,
    codigo_postal VARCHAR(10)  NOT NULL,
    pais          VARCHAR(100) DEFAULT 'España',
    telefono      VARCHAR(15),
    es_principal  BOOLEAN DEFAULT FALSE,

    FOREIGN KEY (id_usuario) REFERENCES usuarios(id_usuario) ON DELETE CASCADE,

    INDEX idx_direcciones_usuario (id_usuario)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ============================================================
-- BLOQUE 2: CATÁLOGO
-- ============================================================

CREATE TABLE categorias (
    id_categoria       INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,

    nombre             VARCHAR(100) NOT NULL,
    slug               VARCHAR(100) UNIQUE NOT NULL,
    descripcion        TEXT,

    id_categoria_padre INT UNSIGNED NULL,
    estado             ENUM('activa','inactiva') DEFAULT 'activa',
    fecha_creacion     DATETIME DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY (id_categoria_padre) REFERENCES categorias(id_categoria) ON DELETE SET NULL,

    INDEX idx_categorias_padre (id_categoria_padre)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE productos (
    id_producto         INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,

    nombre              VARCHAR(150) NOT NULL,
    slug                VARCHAR(150) UNIQUE NOT NULL,
    descripcion         TEXT,

    precio_base         DECIMAL(10,2) UNSIGNED NOT NULL DEFAULT 0.00,
    estado              ENUM('activo','inactivo') DEFAULT 'activo',

    fecha_creacion      DATETIME DEFAULT CURRENT_TIMESTAMP,
    fecha_actualizacion DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

    INDEX idx_productos_nombre (nombre),
    INDEX idx_productos_estado (estado)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE producto_categoria (
    id_producto  INT UNSIGNED NOT NULL,
    id_categoria INT UNSIGNED NOT NULL,

    PRIMARY KEY (id_producto, id_categoria),
    FOREIGN KEY (id_producto)  REFERENCES productos(id_producto)   ON DELETE CASCADE,
    FOREIGN KEY (id_categoria) REFERENCES categorias(id_categoria) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE variantes (
    id_variante      INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    id_producto      INT UNSIGNED NOT NULL,

    nombre           VARCHAR(100) NOT NULL,
    precio_adicional DECIMAL(10,2) UNSIGNED DEFAULT 0.00,
    stock            INT UNSIGNED DEFAULT 0,

    FOREIGN KEY (id_producto) REFERENCES productos(id_producto) ON DELETE CASCADE,

    INDEX idx_variantes_producto (id_producto)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE imagenes (
    id_imagen    INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    id_producto  INT UNSIGNED NOT NULL,

    url_imagen   VARCHAR(255) NOT NULL,
    es_principal BOOLEAN DEFAULT FALSE,

    FOREIGN KEY (id_producto) REFERENCES productos(id_producto) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ============================================================
-- BLOQUE 3: VENTA Y CARRITO
-- ============================================================

CREATE TABLE carritos (
    id_carrito          BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    id_usuario          INT UNSIGNED NOT NULL,

    estado_carrito      ENUM('activo','abandonado','convertido') DEFAULT 'activo',

    fecha_creacion      DATETIME DEFAULT CURRENT_TIMESTAMP,
    fecha_actualizacion DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

    FOREIGN KEY (id_usuario) REFERENCES usuarios(id_usuario) ON DELETE CASCADE,

    INDEX idx_carrito_usuario (id_usuario, estado_carrito)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE carrito_variantes (
    id_item     BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    id_carrito  BIGINT UNSIGNED NOT NULL,
    id_variante INT UNSIGNED    NOT NULL,

    cantidad    INT UNSIGNED NOT NULL DEFAULT 1,

    FOREIGN KEY (id_carrito)  REFERENCES carritos(id_carrito)   ON DELETE CASCADE,
    FOREIGN KEY (id_variante) REFERENCES variantes(id_variante) ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE pedidos (
    id_pedido      BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    id_usuario     INT UNSIGNED NOT NULL,

    estado         ENUM('pendiente','pagado','enviado','entregado','cancelado') DEFAULT 'pendiente',
    tipo_envio     ENUM('estandar','express','punto_recogida') DEFAULT 'estandar',

    coste_envio    DECIMAL(10,2) UNSIGNED DEFAULT 0.00,
    total          DECIMAL(10,2) UNSIGNED NOT NULL,

    /* Guardar históricos */
    calle          VARCHAR(255),
    ciudad         VARCHAR(100),
    provincia      VARCHAR(100),
    cp             VARCHAR(10),
    pais           VARCHAR(100),
    telefono       VARCHAR(15),

    fecha_creacion DATETIME DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY (id_usuario) REFERENCES usuarios(id_usuario) ON DELETE RESTRICT,

    INDEX idx_pedidos_usuario_fecha (id_usuario, fecha_creacion),
    INDEX idx_pedidos_estado        (estado)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE pedido_variantes (
    id_item                   BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    id_pedido                 BIGINT UNSIGNED NOT NULL,
    id_variante               INT UNSIGNED    NOT NULL,

    nombre_producto_historico VARCHAR(150),
    cantidad                  INT UNSIGNED    NOT NULL,
    precio_unitario           DECIMAL(10,2) UNSIGNED NOT NULL,
    subtotal                  DECIMAL(10,2) UNSIGNED NOT NULL,

    FOREIGN KEY (id_pedido)   REFERENCES pedidos(id_pedido)      ON DELETE CASCADE,
    FOREIGN KEY (id_variante) REFERENCES variantes(id_variante)  ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE pagos (
    id_pago         BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    id_pedido       BIGINT UNSIGNED NOT NULL,

    proveedor_pago  VARCHAR(50),
    id_pago_externo VARCHAR(255),

    metodo_pago     ENUM('tarjeta','paypal','google_pay','apple_pay') NOT NULL,
    estado_pago     ENUM('pendiente','completado','fallido') DEFAULT 'pendiente',

    importe         DECIMAL(10,2) UNSIGNED NOT NULL,
    moneda          VARCHAR(10) DEFAULT 'EUR',
    fecha_pago      DATETIME DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY (id_pedido) REFERENCES pedidos(id_pedido) ON DELETE RESTRICT,

    INDEX idx_pagos_pedido  (id_pedido),
    INDEX idx_pagos_externo (id_pago_externo)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ============================================================
-- BLOQUE 4: SOCIAL, RECOMENDACIONES Y SOPORTE
-- ============================================================

CREATE TABLE interacciones (
    id_interaccion   BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    id_usuario       INT UNSIGNED NOT NULL,
    id_producto      INT UNSIGNED NOT NULL,

    tipo_interaccion ENUM('visto','click','carrito') NOT NULL,
    fecha_creacion   DATETIME DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY (id_usuario)  REFERENCES usuarios(id_usuario)   ON DELETE CASCADE,
    FOREIGN KEY (id_producto) REFERENCES productos(id_producto) ON DELETE CASCADE,

    INDEX idx_interacciones_analisis (id_usuario, tipo_interaccion)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE historial_vistas (
    id_vista       BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    id_usuario     INT UNSIGNED NOT NULL,
    id_producto    INT UNSIGNED NOT NULL,

    fecha_creacion DATETIME DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY (id_usuario)  REFERENCES usuarios(id_usuario)   ON DELETE CASCADE,
    FOREIGN KEY (id_producto) REFERENCES productos(id_producto) ON DELETE CASCADE,

    INDEX idx_usuario_vistas (id_usuario)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE intereses_usuario (
    id_usuario         INT UNSIGNED NOT NULL,
    id_categoria       INT UNSIGNED NOT NULL,

    puntuacion_interes INT DEFAULT 0,
    ultima_interaccion TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

    PRIMARY KEY (id_usuario, id_categoria),
    FOREIGN KEY (id_usuario)   REFERENCES usuarios(id_usuario)     ON DELETE CASCADE,
    FOREIGN KEY (id_categoria) REFERENCES categorias(id_categoria) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE resenas (
    id_resena      INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    id_usuario     INT UNSIGNED NOT NULL,
    id_producto    INT UNSIGNED NOT NULL,

    puntuacion     TINYINT UNSIGNED CHECK (puntuacion BETWEEN 1 AND 5),
    comentario     TEXT,
    fecha_creacion DATETIME DEFAULT CURRENT_TIMESTAMP,

    UNIQUE (id_usuario, id_producto),

    FOREIGN KEY (id_usuario)  REFERENCES usuarios(id_usuario)   ON DELETE CASCADE,
    FOREIGN KEY (id_producto) REFERENCES productos(id_producto) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE conversaciones (
    id_conversacion INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    id_usuario      INT UNSIGNED NOT NULL,

    asunto          VARCHAR(255),
    estado          ENUM('abierto','cerrado') DEFAULT 'abierto',
    fecha_creacion  DATETIME DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY (id_usuario) REFERENCES usuarios(id_usuario) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE mensajes (
    id_mensaje        BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    id_conversacion   INT UNSIGNED NOT NULL,
    id_usuario        INT UNSIGNED NOT NULL,

    mensaje           TEXT    NOT NULL,
    leido             BOOLEAN DEFAULT FALSE,
    fecha_creacion    DATETIME DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY (id_conversacion) REFERENCES conversaciones(id_conversacion) ON DELETE CASCADE,
    FOREIGN KEY (id_usuario)      REFERENCES usuarios(id_usuario)             ON DELETE CASCADE,
    
    INDEX idx_mensajes_conversacion (id_conversacion)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

SET FOREIGN_KEY_CHECKS = 1;
