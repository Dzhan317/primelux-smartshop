SET NAMES utf8mb4;

-- === TABLAS QUE VIENEN DE ENTIDADES === 

-- TABLA USUARIOS
CREATE TABLE usuarios (
    id_usuario INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    email VARCHAR(150) UNIQUE NOT NULL,
    contasenia_hash VARCHAR(255) NOT NULL,

    rol ENUM('admin', 'cliente') DEFAULT 'cliente',
    estado ENUM('activo', 'inactivo', 'bloqueado') DEFAULT 'activo',

    fecha_creacion DATETIME DEFAULT CURRENT_TIMESTAMP,
    fecha_actualizacion DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
)ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;;

-- TABLA 2FA (AUTENTICACIÓN)
CREATE TABLE codigos_2fa (
    id_2fa INT AUTO_INCREMENT PRIMARY KEY,
    id_usuario INT NOT NULL,
    codigo VARCHAR(10),
    expiracion DATETIME,
    verificado BOOLEAN DEFAULT FALSE,

    FOREIGN KEY (id_usuario) REFERENCES usuarios(id_usuario)
    ON DELETE CASCADE
)ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;;

-- TABLA DIRECCIONES
CREATE TABLE direcciones (
    id_direccion INT AUTO_INCREMENT PRIMARY KEY,
    id_usuario INT NOT NULL,

    calle VARCHAR(255) NOT NULL,
    ciudad VARCHAR(100) NOT NULL,
    provincia VARCHAR(100),
    codigo_postal VARCHAR(10),
    pais VARCHAR(100) DEFAULT 'España',

    es_principal BOOLEAN DEFAULT FALSE,

    FOREIGN KEY (id_usuario) REFERENCES usuarios(id_usuario)
    ON DELETE CASCADE
)ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;;

-- TABLA CATEGORIAS
CREATE TABLE categorias (
    id_categoria INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    descripcion TEXT,

    id_categoria_padre INT NULL,

    estado ENUM('activa', 'inactiva') DEFAULT 'inactiva',

    fecha_creacion DATETIME DEFAULT CURRENT_TIMESTAMP,
    fecha_actualizacion DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

    FOREIGN KEY (id_categoria_padre) REFERENCES categorias(id_categoria)
    ON DELETE SET NULL
)ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;;

-- TABLA PRODUCTOS (CORREGIDO: eliminado id_categoria)
CREATE TABLE productos (
    id_producto INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(150) NOT NULL,
    descripcion TEXT,

    precio_base DECIMAL(10,2) NOT NULL CHECK (precio_base >= 0),

    estado ENUM('activo', 'inactivo') DEFAULT 'activo',

    fecha_creacion DATETIME DEFAULT CURRENT_TIMESTAMP,
    fecha_actualizacion DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
)ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;;

-- TABLA VARIANTES
CREATE TABLE variantes (
    id_variante INT AUTO_INCREMENT PRIMARY KEY,
    id_producto INT NOT NULL,

    nombre VARCHAR(100),

    precio DECIMAL(10,2) DEFAULT 0 CHECK (precio >= 0),
    stock INT DEFAULT 0 CHECK (stock >= 0),

    FOREIGN KEY (id_producto) REFERENCES productos(id_producto)
    ON DELETE CASCADE
)ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;;

-- TABLA IMAGENES
CREATE TABLE imagenes (
    id_imagen INT AUTO_INCREMENT PRIMARY KEY,
    id_producto INT NOT NULL,

    url VARCHAR(255) NOT NULL,
    es_principal BOOLEAN DEFAULT FALSE,

    FOREIGN KEY (id_producto) REFERENCES productos(id_producto)
    ON DELETE CASCADE
)ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;;

-- TABLA CARRITOS
CREATE TABLE carritos (
    id_carrito INT AUTO_INCREMENT PRIMARY KEY,
    id_usuario INT NOT NULL,

    estado_carrito ENUM('activo', 'abandonado', 'convertido') DEFAULT 'activo',

    fecha_creacion DATETIME DEFAULT CURRENT_TIMESTAMP,
    fecha_actualizacion DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

    FOREIGN KEY (id_usuario) REFERENCES usuarios(id_usuario)
    ON DELETE CASCADE
)ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;;

-- TABLA PEDIDOS
CREATE TABLE pedidos (
    id_pedido INT AUTO_INCREMENT PRIMARY KEY,
    id_usuario INT NOT NULL,

    estado ENUM('pendiente', 'pagado', 'enviado', 'entregado', 'cancelado') DEFAULT 'pendiente',

    tipo_envio VARCHAR(50),
    coste_envio DECIMAL(10,2) DEFAULT 0,

    total DECIMAL(10,2) NOT NULL CHECK (total >= 0),

    -- HISTÓRICO DIRECCIÓN
    calle VARCHAR(255),
    ciudad VARCHAR(100),
    provincia VARCHAR(100),
    codigo_postal VARCHAR(10),
    pais VARCHAR(100),

    fecha_creacion DATETIME DEFAULT CURRENT_TIMESTAMP,
    fecha_actualizacion DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

    FOREIGN KEY (id_usuario) REFERENCES usuarios(id_usuario)
    ON DELETE RESTRICT
)ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;;

-- TABLA PAGOS
CREATE TABLE pagos (
    id_pago INT AUTO_INCREMENT PRIMARY KEY,
    id_pedido INT NOT NULL,

    proveedor_pago VARCHAR(50),
    id_pago_externo VARCHAR(255),

    metodo_pago ENUM('tarjeta', 'paypal', 'google_pay', 'apple_pay') NOT NULL,

    estado_pago ENUM('pendiente', 'completado', 'fallido') DEFAULT 'pendiente',

    importe DECIMAL(10,2) NOT NULL CHECK (importe >= 0),
    moneda VARCHAR(10) DEFAULT 'EUR',

    fecha_confirmacion DATETIME NULL,
    fecha DATETIME DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY (id_pedido) REFERENCES pedidos(id_pedido)
    ON DELETE RESTRICT
)ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;;

-- TABLA CONVERSACIONES
CREATE TABLE conversaciones (
    id_conversacion INT AUTO_INCREMENT PRIMARY KEY,
    id_usuario INT NOT NULL,

    asunto VARCHAR(255),
    estado ENUM('abierto', 'cerrado') DEFAULT 'abierto',

    fecha_creacion DATETIME DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY (id_usuario) REFERENCES usuarios(id_usuario)
    ON DELETE CASCADE
)ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;;

-- TABLA MENSAJES
CREATE TABLE mensajes (
    id_mensaje INT AUTO_INCREMENT PRIMARY KEY,

    id_conversacion INT NOT NULL,
    id_usuario INT NOT NULL,

    mensaje TEXT NOT NULL,
    leido BOOLEAN DEFAULT FALSE,

    fecha DATETIME DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY (id_conversacion) REFERENCES conversaciones(id_conversacion)
    ON DELETE CASCADE,

    FOREIGN KEY (id_usuario) REFERENCES usuarios(id_usuario)
    ON DELETE CASCADE
)ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;;

-- TABLA RESENAS
CREATE TABLE resenas (
    id_resena INT AUTO_INCREMENT PRIMARY KEY,

    id_usuario INT NOT NULL,
    id_producto INT NOT NULL,

    puntuacion INT CHECK (puntuacion BETWEEN 1 AND 5),
    comentario TEXT,

    fecha DATETIME DEFAULT CURRENT_TIMESTAMP,

    UNIQUE (id_usuario, id_producto),

    FOREIGN KEY (id_usuario) REFERENCES usuarios(id_usuario)
        ON DELETE CASCADE,

    FOREIGN KEY (id_producto) REFERENCES productos(id_producto)
        ON DELETE CASCADE
)ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;;

-- === TABLAS RELACIONALES ===

-- PRODUCTO_CATEGORIA
CREATE TABLE producto_categoria (
    id_producto INT,
    id_categoria INT,

    PRIMARY KEY (id_producto, id_categoria),

    FOREIGN KEY (id_producto) REFERENCES productos(id_producto)
        ON DELETE CASCADE,

    FOREIGN KEY (id_categoria) REFERENCES categorias(id_categoria)
        ON DELETE CASCADE
)ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;;

-- CARRITO_VARIANTES
CREATE TABLE carrito_variantes (
    id_item INT AUTO_INCREMENT PRIMARY KEY,

    id_carrito INT NOT NULL,
    id_variante INT NOT NULL,

    cantidad INT NOT NULL CHECK (cantidad > 0),

    FOREIGN KEY (id_carrito) REFERENCES carritos(id_carrito)
        ON DELETE CASCADE,

    FOREIGN KEY (id_variante) REFERENCES variantes(id_variante)
        ON DELETE RESTRICT
)ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;;

-- PEDIDO_VARIANTES (CORREGIDO: AÑADIDO HISTÓRICO)
CREATE TABLE pedido_variantes (
    id_item INT AUTO_INCREMENT PRIMARY KEY,

    id_pedido INT NOT NULL,
    id_variante INT NOT NULL,

    nombre_producto VARCHAR(150),

    cantidad INT NOT NULL CHECK (cantidad > 0),
    precio_unitario DECIMAL(10,2) NOT NULL CHECK (precio_unitario >= 0),
    subtotal DECIMAL(10,2) NOT NULL,

    FOREIGN KEY (id_pedido) REFERENCES pedidos(id_pedido)
        ON DELETE CASCADE,

    FOREIGN KEY (id_variante) REFERENCES variantes(id_variante)
        ON DELETE RESTRICT
)ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;;

-- === INDICES ===
CREATE INDEX idx_producto_nombre ON productos(nombre);

CREATE INDEX idx_producto_categoria_cat ON producto_categoria(id_categoria);
CREATE INDEX idx_producto_categoria_prod ON producto_categoria(id_producto);

CREATE INDEX idx_variante_producto ON variantes(id_producto);

CREATE INDEX idx_carrito_usuario ON carritos(id_usuario);
CREATE INDEX idx_carrito_usuario_estado ON carritos(id_usuario, estado_carrito);
CREATE INDEX idx_carrito_usuario_estado ON carritos(id_usuario, estado_carrito);

CREATE INDEX idx_pedido_usuario ON pedidos(id_usuario);
CREATE INDEX idx_pedido_estado ON pedidos(estado);

CREATE INDEX idx_pago_pedido ON pagos(id_pedido);

CREATE INDEX idx_conversacion_usuario ON conversaciones(id_usuario);

CREATE INDEX idx_mensaje_conversacion ON mensajes(id_conversacion);
CREATE INDEX idx_mensajes_conversacion_fecha ON mensajes(id_conversacion, fecha);
