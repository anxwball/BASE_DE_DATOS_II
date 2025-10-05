-- Crear la base de datos
CREATE DATABASE tienda;
USE tienda;

-- Tabla de Categorías
CREATE TABLE Categoria (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL UNIQUE
);

-- Tabla de Productos (superclase)
CREATE TABLE Producto (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    precio DECIMAL(10,2) NOT NULL,
    categoria_id INT NOT NULL,
    FOREIGN KEY (categoria_id) REFERENCES Categoria(id)
);

-- Subtipo: Alimentos
CREATE TABLE Alimento (
    producto_id INT PRIMARY KEY,
    fecha_expiracion DATE NOT NULL,
    calorias INT,
    FOREIGN KEY (producto_id) REFERENCES Producto(id)
);

-- Subtipo: Muebles
CREATE TABLE Mueble (
    producto_id INT PRIMARY KEY,
    fecha_fabricacion DATE NOT NULL,
    FOREIGN KEY (producto_id) REFERENCES Producto(id)
);

-- Tabla de Pedidos
CREATE TABLE Pedido (
    id INT AUTO_INCREMENT PRIMARY KEY
);

-- Tabla de líneas de pedido
CREATE TABLE Linea_Pedido (
    id INT AUTO_INCREMENT PRIMARY KEY,
    pedido_id INT NOT NULL,
    producto_id INT NOT NULL,
    cantidad INT NOT NULL,
    FOREIGN KEY (pedido_id) REFERENCES Pedido(id),
    FOREIGN KEY (producto_id) REFERENCES Producto(id)
);

-- Insertar categorías
INSERT INTO Categoria (nombre) VALUES ('Alimentos');
INSERT INTO Categoria (nombre) VALUES ('Muebles');

-- Insertar productos y sus subtipos

-- Producto tipo alimento
INSERT INTO Producto (nombre, precio, categoria_id)
VALUES ('Manzana', 0.50, 1);

INSERT INTO Alimento (producto_id, fecha_expiracion, calorias)
VALUES (1, '2025-10-10', 52);

-- Producto tipo mueble
INSERT INTO Producto (nombre, precio, categoria_id)
VALUES ('Silla de madera', 45.00, 2);

INSERT INTO Mueble (producto_id, fecha_fabricacion)
VALUES (2, '2025-01-15');

-- Insertar un pedido
INSERT INTO Pedido VALUES ();

-- Insertar líneas de pedido
INSERT INTO Linea_Pedido (pedido_id, producto_id, cantidad)
VALUES (1, 1, 10); -- 10 manzanas

INSERT INTO Linea_Pedido (pedido_id, producto_id, cantidad)
VALUES (1, 2, 2); -- 2 sillas

-- Consultas de ejemplo
-- 1. Obtener todos pedidos con sus productos y cantidades
SELECT p.id AS pedido_id, pr.nombre AS producto, lp.cantidad, pr.precio,
    (lp.cantidad * pr.precio) AS subtotal
FROM Pedido p
JOIN Linea_Pedido lp ON p.id = lp.pedido_id
JOIN Producto pr ON lp.producto_id = pr.id;

-- 2. Obtener todos los productos de tipo alimento con sus detalles
SELECT pr.id, pr.nombre, pr.precio, a.fecha_expiracion, a.calorias
FROM Producto pr
JOIN Alimento a ON pr.id = a.producto_id;

-- 3. Obtener todos los productos de tipo mueble con sus detalles
SELECT pr.id, pr.nombre, pr.precio, m.fecha_fabricacion
FROM Producto pr
JOIN Mueble m ON pr.id = m.producto_id;