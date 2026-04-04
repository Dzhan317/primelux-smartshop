-- =============================
-- CONFIGURACIÓN INICIAL
-- =============================
SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- =============================
-- TABLA: USUARIOS
-- =============================
CREATE TABLE usuarios (
    id_usuario INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    apellidos VARCHAR(100),
    email VARCHAR(150) NOT NULL UNIQUE,
    contrasenia_hash VARCHAR(255) NOT NULL,
    rol ENUM('admin', 'usuario') NOT NULL DEFAULT 'usuario',
    estado ENUM('activo', 'bloqueado', 'eliminado') NOT NULL DEFAULT 'activo',
    fecha_registro DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    fa_activado BOOLEAN DEFAULT FALSE,
    deleted_at DATETIME NULL,

    INDEX idx_usuarios_estado (estado),
    INDEX idx_usuarios_deleted (deleted_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE codigos_2fa (
    id_codigo INT AUTO_INCREMENT PRIMARY KEY,
    usuario_id INT NOT NULL,
    codigo VARCHAR(10) NOT NULL,
    expiracion DATETIME NOT NULL,
    usado BOOLEAN NOT NULL DEFAULT FALSE,

    INDEX idx_2fa_usuario (usuario_id),

    FOREIGN KEY (usuario_id) REFERENCES usuarios(id_usuario)
        ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- =============================
-- TABLA: DIRECCIONES
-- =============================
CREATE TABLE direcciones (
    id_direccion INT AUTO_INCREMENT PRIMARY KEY,
    id_usuario INT NOT NULL,
    direccion VARCHAR(200) NOT NULL,
    ciudad VARCHAR(100) NOT NULL,
    cp VARCHAR(10) NOT NULL,
    pais VARCHAR(100) NOT NULL,
    telefono VARCHAR(20) NOT NULL,
    deleted_at DATETIME NULL,

    es_principal BOOLEAN NOT NULL DEFAULT FALSE,

    INDEX idx_direcciones_usuario (id_usuario),
    FOREIGN KEY (id_usuario) REFERENCES usuarios(id_usuario)
        ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- =============================
-- TABLA: CATEGORIAS
-- =============================
CREATE TABLE categorias (
    id_categoria INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    descripcion VARCHAR(255),
    id_categoria_padre INT NULL,
    deleted_at DATETIME NULL,

    INDEX idx_categorias_padre (id_categoria_padre),
    FOREIGN KEY (id_categoria_padre) REFERENCES categorias(id_categoria)
        ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- =============================
-- TABLA: PRODUCTOS
-- =============================
CREATE TABLE productos (
    id_producto INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(150) NOT NULL,
    precio_base DECIMAL(10,2) NOT NULL CHECK (precio_base >= 0),
    descripcion TEXT,
    estado_producto ENUM('activo', 'inactivo', 'agotado') NOT NULL DEFAULT 'activo',
    fecha_creacion DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    deleted_at DATETIME NULL,

    INDEX idx_productos_estado (estado_producto),
    INDEX idx_productos_deleted (deleted_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- =============================
-- TABLA: VARIANTES
-- =============================
CREATE TABLE variantes (
    id_variante INT AUTO_INCREMENT PRIMARY KEY,
    id_producto INT NOT NULL,
    sku VARCHAR(50) NOT NULL UNIQUE,
    precio DECIMAL(10,2) NOT NULL CHECK (precio >= 0),
    stock INT NOT NULL DEFAULT 0 CHECK (stock >= 0),
    deleted_at DATETIME NULL,

    INDEX idx_variantes_producto (id_producto),
    FOREIGN KEY (id_producto) REFERENCES productos(id_producto)
        ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- =============================
-- TABLA: CARRITOS
-- =============================
CREATE TABLE carritos (
    id_carrito INT AUTO_INCREMENT PRIMARY KEY,
    id_usuario INT NOT NULL,
    estado_carrito ENUM('activo', 'abandonado', 'convertido') NOT NULL DEFAULT 'activo',
    fecha_creacion DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,

    INDEX idx_carritos_usuario (id_usuario),
    FOREIGN KEY (id_usuario) REFERENCES usuarios(id_usuario)
        ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- =============================
-- TABLA: PEDIDOS
-- =============================
CREATE TABLE pedidos (
    id_pedido INT AUTO_INCREMENT PRIMARY KEY,
    id_usuario INT NOT NULL,
    id_direccion INT NOT NULL,
    estado_pedido ENUM('pendiente_pago', 'pagado', 'enviado', 'cancelado') NOT NULL DEFAULT 'pendiente_pago',
    tipo_envio VARCHAR(50),
    coste_envio DECIMAL(10,2),
    total DECIMAL(10,2) NOT NULL CHECK (total >= 0),
    fecha DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,

    INDEX idx_pedidos_usuario (id_usuario),
    INDEX idx_pedidos_estado (estado_pedido),

    FOREIGN KEY (id_usuario) REFERENCES usuarios(id_usuario)
        ON DELETE RESTRICT ON UPDATE CASCADE,
    FOREIGN KEY (id_direccion) REFERENCES direcciones(id_direccion)
        ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- =============================
-- TABLA: PAGOS
-- =============================
CREATE TABLE pagos (
    id_pago INT AUTO_INCREMENT PRIMARY KEY,
    id_pedido INT NOT NULL,
    proveedor_pago VARCHAR(50) NOT NULL,
    id_pago_externo VARCHAR(255) NULL,
    metodo_pago ENUM('tarjeta', 'paypal', 'google_pay', 'apple_pay') NOT NULL,
    estado_pago ENUM('pendiente', 'completado', 'fallido') NOT NULL DEFAULT 'pendiente',
    importe DECIMAL(10,2) NOT NULL CHECK (importe >= 0),
    fecha DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    fecha_confirmacion DATETIME NULL,

    INDEX idx_pagos_pedido (id_pedido),
    FOREIGN KEY (id_pedido) REFERENCES pedidos(id_pedido)
        ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- =============================
-- TABLA: CONVERSACIONES
-- =============================
CREATE TABLE conversaciones (
    id_conversacion INT AUTO_INCREMENT PRIMARY KEY,
    id_usuario INT NOT NULL,
    fecha_creacion DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    estado ENUM('abierta', 'cerrada') DEFAULT 'abierta',
    asunto VARCHAR(150) NOT NULL,

    INDEX idx_conversaciones_usuario (id_usuario),
    FOREIGN KEY (id_usuario) REFERENCES usuarios(id_usuario)
        ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- =============================
-- TABLA: MENSAJES
-- =============================
CREATE TABLE mensajes (
    id_mensaje INT AUTO_INCREMENT PRIMARY KEY,
    id_conversacion INT NOT NULL,
    id_emisor INT NOT NULL,
    tipo_emisor ENUM('usuario','admin') NOT NULL,
    contenido TEXT NOT NULL,
    leido BOOLEAN NOT NULL DEFAULT FALSE,
    fecha DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,

    INDEX idx_mensajes_conversacion (id_conversacion, FECHA),
    INDEX idx_mensajes_fecha (fecha),
    INDEX idx_mensajes_emisor (id_emisor),

    FOREIGN KEY (id_conversacion) REFERENCES conversaciones(id_conversacion)
        ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (id_emisor) REFERENCES usuarios(id_usuario)
        ON DELETE RESTRICT ON UPDATE CASCADE

) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- =============================
-- TABLA: INTERACCIONES
-- =============================
CREATE TABLE interacciones (
    id_interaccion INT AUTO_INCREMENT PRIMARY KEY,
    id_usuario INT NOT NULL,
    id_producto INT NOT NULL,
    tipo_interaccion ENUM('vista', 'carrito', 'compra') NOT NULL,
    fecha DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,

    INDEX idx_interacciones_usuario (id_usuario),
    INDEX idx_interacciones_producto (id_producto),
    INDEX idx_interacciones_user_producto (id_usuario, id_producto),
    INDEX idx_tipo (tipo_interaccion),

    FOREIGN KEY (id_usuario) REFERENCES usuarios(id_usuario)
        ON DELETE RESTRICT ON UPDATE CASCADE,
    FOREIGN KEY (id_producto) REFERENCES productos(id_producto)
        ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- =============================
-- TABLA: IMAGENES
-- =============================
CREATE TABLE imagenes (
    id_imagen INT AUTO_INCREMENT PRIMARY KEY,
    id_producto INT NOT NULL,
    url_imagen VARCHAR(255) NOT NULL,
    orden INT NOT NULL DEFAULT 1,

    INDEX idx_imagenes_producto (id_producto),
    FOREIGN KEY (id_producto) REFERENCES productos(id_producto)
        ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- =============================
-- TABLA: RESENAS
-- =============================
CREATE TABLE resenas (
    id_resena INT AUTO_INCREMENT PRIMARY KEY,
    id_usuario INT NOT NULL,
    id_producto INT NOT NULL,
    puntuacion TINYINT NOT NULL CHECK (puntuacion BETWEEN 1 AND 5),
    comentario TEXT,
    fecha DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,

    INDEX idx_resenas_producto (id_producto),
    INDEX idx_resenas_usuario (id_usuario),

    FOREIGN KEY (id_usuario) REFERENCES usuarios(id_usuario)
        ON DELETE RESTRICT ON UPDATE CASCADE,
    FOREIGN KEY (id_producto) REFERENCES productos(id_producto)
        ON DELETE CASCADE ON UPDATE CASCADE,

    UNIQUE (id_usuario, id_producto)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- =============================
-- TABLAS INTERMEDIAS
-- =============================
CREATE TABLE producto_categoria (
    id_producto INT NOT NULL,
    id_categoria INT NOT NULL,

    PRIMARY KEY (id_producto, id_categoria),
    INDEX idx_pc_categoria (id_categoria),

    FOREIGN KEY (id_producto) REFERENCES productos(id_producto)
        ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (id_categoria) REFERENCES categorias(id_categoria)
        ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE carrito_variantes (
    id_carrito INT NOT NULL,
    id_variante INT NOT NULL,
    cantidad INT NOT NULL CHECK (cantidad > 0),

    PRIMARY KEY (id_carrito, id_variante),

    INDEX idx_cv_variante (id_variante),
    INDEX idx_cv_carrito (id_carrito),

    FOREIGN KEY (id_carrito) REFERENCES carritos(id_carrito)
        ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (id_variante) REFERENCES variantes(id_variante)
        ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE pedido_variantes (
    id_pedido INT NOT NULL,
    id_variante INT NOT NULL,
    cantidad INT NOT NULL CHECK (cantidad > 0),
    precio_unitario DECIMAL(10,2) NOT NULL CHECK (precio_unitario >= 0),

    PRIMARY KEY (id_pedido, id_variante),

    INDEX idx_pv_variante (id_variante),
    INDEX idx_pv_pedido (id_pedido),

    FOREIGN KEY (id_pedido) REFERENCES pedidos(id_pedido)
        ON DELETE RESTRICT ON UPDATE CASCADE,
    FOREIGN KEY (id_variante) REFERENCES variantes(id_variante)
        ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

SET FOREIGN_KEY_CHECKS = 1;