-- Active: 1759446392079@@127.0.0.1@3306@sistema_expedientes
DROP DATABASE IF EXISTS sistema_expedientes;
CREATE DATABASE sistema_expedientes;
USE sistema_expedientes;

-- ==========================================
-- TABLAS BASE
-- ==========================================

-- Tabla de usuarios
CREATE TABLE usuarios (
    id_usuario INT AUTO_INCREMENT PRIMARY KEY,
    nombre_usuario VARCHAR(100) NOT NULL,
    contrasena_usuario VARCHAR(255) NOT NULL,
    rol_usuario ENUM('admin', 'operador') DEFAULT 'operador',
    estado_usuario ENUM('activo', 'inactivo') DEFAULT 'activo',
    fecha_registro_usuario DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Tabla de aseguradoras
CREATE TABLE aseguradoras (
    id_aseguradora INT AUTO_INCREMENT PRIMARY KEY,
    nombre_aseguradora VARCHAR(100) NOT NULL,
    direccion_aseguradora VARCHAR(255) NULL,
    telefono_aseguradora VARCHAR(20) NULL,
    correo_corporativo_aseguradora VARCHAR(100) NULL
);

-- Tabla de asegurados
CREATE TABLE asegurados (
    id_asegurado INT AUTO_INCREMENT PRIMARY KEY,
    nombre_asegurado VARCHAR(100) NOT NULL,
    apellido_asegurado VARCHAR(100) NOT NULL,
    direccion_asegurado VARCHAR(255) NULL,
    telefono_asegurado VARCHAR(20) NULL,
    correo_asegurado VARCHAR(100) NULL
);

-- Tabla de juzgados
CREATE TABLE juzgados (
    id_juzgado INT AUTO_INCREMENT PRIMARY KEY,
    nombre_juzgado VARCHAR(100) NOT NULL,
    direccion_juzgado VARCHAR(255) NULL,
    telefono_juzgado VARCHAR(20) NULL,
    correo_juzgado VARCHAR(100) NULL,
    tipo_seguro VARCHAR(50) NULL,
    fecha_afiliacion DATE NULL,
    estado VARCHAR(20) NULL,
    numero_poliza VARCHAR(20) NULL,
    monto_cobertura DECIMAL(10,2) NULL
);

-- ==========================================
-- TABLAS CON DEPENDENCIAS
-- ==========================================

-- Tabla de expedientes
CREATE TABLE expedientes (
    id_expediente INT AUTO_INCREMENT PRIMARY KEY,
    id_aseguradora INT NOT NULL,
    id_asegurado INT NOT NULL,
    id_juzgado INT NOT NULL,
    estado_expediente ENUM('pendiente', 'en_curso', 'cerrado') DEFAULT 'pendiente',
    fecha_creacion DATETIME DEFAULT CURRENT_TIMESTAMP,
    
    FOREIGN KEY (id_aseguradora) REFERENCES aseguradoras(id_aseguradora),
    FOREIGN KEY (id_asegurado) REFERENCES asegurados(id_asegurado),
    FOREIGN KEY (id_juzgado) REFERENCES juzgados(id_juzgado)
);

-- Tabla de agenda de expedientes
CREATE TABLE agendas_expedientes (
    id_agenda INT AUTO_INCREMENT PRIMARY KEY,
    id_usuario INT NOT NULL,
    id_expediente INT NOT NULL,
    fecha_agenda DATE NOT NULL,
    estado_agenda ENUM('activo', 'inactivo') DEFAULT 'activo',
    
    FOREIGN KEY (id_usuario) REFERENCES usuarios(id_usuario),
    FOREIGN KEY (id_expediente) REFERENCES expedientes(id_expediente)
);

-- ==========================================
-- VISTAS PARA LA API
-- ==========================================

-- Vista para la agenda diaria con JOINs
CREATE VIEW vista_agenda_diaria AS
SELECT 
    e.id_expediente,
    e.estado_expediente,
    e.fecha_creacion,
    aseg.nombre_aseguradora,
    aseg.telefono_aseguradora,
    ase.nombre_asegurado,
    ase.apellido_asegurado,
    ase.telefono_asegurado,
    j.nombre_juzgado,
    j.direccion_juzgado
FROM expedientes e
INNER JOIN aseguradoras aseg ON e.id_aseguradora = aseg.id_aseguradora
INNER JOIN asegurados ase ON e.id_asegurado = ase.id_asegurado
INNER JOIN juzgados j ON e.id_juzgado = j.id_juzgado
ORDER BY e.fecha_creacion DESC;

-- ==========================================
-- INSERCIONES DE DATOS DE PRUEBA
-- ==========================================

-- Usuarios
INSERT INTO usuarios (nombre_usuario, contrasena_usuario, rol_usuario) VALUES
('admin', 'admin123', 'admin'),
('operador1', 'pass123', 'operador'),
('operador2', 'pass456', 'operador');

-- Aseguradoras
INSERT INTO aseguradoras (nombre_aseguradora, direccion_aseguradora, telefono_aseguradora, correo_corporativo_aseguradora) VALUES
('ASSA',    'CALLE 50',         '231-4113', 'ASSAPTY@RECLAMOS.COM'),
('ANCON',   'BETHANIA',         '399-4545', 'ANCONPTY@RECLAMOS.COM'),
('CONANCE', 'CIUDAD DEL SABER', '398-6565', 'CONANCEPTY@RECLAMOS.COM'),
('MAPFRE',  'VIA VENETO',       '456-4545', 'MAPFREPTY@RECLAMOS.COM'),
('SURA',    'SANTA MARIA',      '321-1414', 'SURAPTY@RECLAMOS.COM');

-- Asegurados
INSERT INTO asegurados (nombre_asegurado, apellido_asegurado, direccion_asegurado, telefono_asegurado, correo_asegurado) VALUES
('Ana',     'Tulia',    'Calidonia',        '6565-9985', 'ana.tulia@hotmail.com'),
('Aaron',   'Ojo',      'BETHANIA',         '6969-4545', 'aaron.ojo@hotmail.com'),
('Maria',   'Nunez',    'CIUDAD DEL SABER', '6363-5555', 'maria.nunez@hotmail.com'),
('Oscar',   'Perez',    'VIA VENETO',       '6767-1111', 'oscar.perez@hotmail.com'),
('Luis',    'Casique',  'SANTA MARIA',      '6868-2222', 'luis.casique@hotmail.com'),
('Omar',    'Petunio',  'COSTA DEL ESTE',   '6464-8888', 'omar.petunio@hotmail.com'),
('Octavio', 'Noveno',   'SANTA MARIA',      '6262-7777', 'octavio.noveno@hotmail.com');

-- Juzgados
INSERT INTO juzgados (nombre_juzgado, direccion_juzgado, telefono_juzgado, correo_juzgado, tipo_seguro, fecha_afiliacion, estado, numero_poliza, monto_cobertura) VALUES
('Juzgado Civil 1',     'Calidonia',        '6848-9775', 'civil1@juzgado.gob.pa',    'Salud',    '2022-03-15', 'Activo',    'POL-00125', 25000),
('Juzgado Penal 2',     'Bethania',         '6879-4555', 'penal2@juzgado.gob.pa',    'Vida',     '2021-11-20', 'Activo',    'POL-00478', 50000),
('Juzgado Laboral 3',   'Ciudad del Saber', '6563-5955', 'laboral3@juzgado.gob.pa',  'Vehículo', '2023-01-10', 'Suspendido','POL-00987', 15000),
('Juzgado Familia 4',   'Via Veneto',       '6747-1122', 'familia4@juzgado.gob.pa',  'Salud',    '2020-06-05', 'Inactivo',  'POL-00234', 30000),
('Juzgado Civil 5',     'Santa Maria',      '6168-2258', 'civil5@juzgado.gob.pa',    'Vida',     '2022-09-12', 'Activo',    'POL-00765', 45000);

-- Expedientes
INSERT INTO expedientes (id_aseguradora, id_asegurado, id_juzgado, estado_expediente, fecha_creacion) VALUES
(1, 1, 1, 'pendiente', '2025-10-30 08:00:00'),
(2, 2, 2, 'pendiente', '2025-10-30 09:00:00'),
(3, 3, 3, 'en_curso',  '2025-10-29 10:00:00'),
(4, 4, 4, 'en_curso',  '2025-10-28 11:00:00'),
(5, 5, 5, 'cerrado',   '2025-10-27 12:00:00'),
(1, 6, 1, 'pendiente', '2025-10-31 08:30:00'),
(2, 7, 2, 'en_curso',  '2025-10-31 09:30:00');

-- Agenda de expedientes
INSERT INTO agendas_expedientes (id_usuario, id_expediente, fecha_agenda) VALUES
(1, 1, '2025-10-31'),
(1, 2, '2025-10-31'),
(2, 3, '2025-10-31'),
(2, 4, '2025-10-31'),
(3, 5, '2025-10-31');

-- ==========================================
-- CONSULTAS DE VERIFICACIÓN
-- ==========================================

SELECT * FROM usuarios;
SELECT * FROM aseguradoras;
SELECT * FROM asegurados;
SELECT * FROM juzgados;
SELECT * FROM expedientes;
SELECT * FROM agendas_expedientes;

-- Probar la vista
SELECT * FROM vista_agenda_diaria;