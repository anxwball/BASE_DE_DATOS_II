-- Active: 1759446392079@@127.0.0.1@3306@fidelizacion_xyz
CREATE DATABASE IF NOT EXISTS fidelizacion_xyz;
USE fidelizacion_xyz;

-- Cargos: lista de cargos
CREATE TABLE cargos (
    id_cargo INT AUTO_INCREMENT PRIMARY KEY,
    nombre_cargo VARCHAR(50) NOT NULL
);

-- Perfiles: información básica de perfiles
CREATE TABLE perfiles (
    id_perfil INT AUTO_INCREMENT PRIMARY KEY,
    nombre_perfil VARCHAR(50) NOT NULL,
    fecha_vigencia_perfil DATE,
    descripcion_perfil TEXT,
    encargado_perfil_id INT NULL
);

-- Usuarios: datos básicos de usuarios
CREATE TABLE usuarios (
    id_usuario INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL,
    apellido VARCHAR(50) NOT NULL,
    estado VARCHAR(20) DEFAULT 'activo',
    contrasena VARCHAR(255) NOT NULL,
    id_cargo INT NULL,
    salario DECIMAL(10,2) NULL,
    fecha_ingreso DATE NULL,
    id_perfil INT NULL,
    FOREIGN KEY (id_cargo) REFERENCES cargos(id_cargo) ON DELETE SET NULL ON UPDATE CASCADE,
    FOREIGN KEY (id_perfil) REFERENCES perfiles(id_perfil) ON DELETE SET NULL ON UPDATE CASCADE
);

-- Login: registros de acceso
CREATE TABLE login (
    id_login INT AUTO_INCREMENT PRIMARY KEY,
    id_usuario INT NOT NULL,
    fecha_hora_login DATETIME NOT NULL,
    estado_login VARCHAR(20) NOT NULL,
    FOREIGN KEY (id_usuario) REFERENCES usuarios(id_usuario) ON DELETE CASCADE ON UPDATE CASCADE
);

-- Fidelizacion: actividades y puntos asociados a usuarios
CREATE TABLE fidelizacion (
    id_actividad INT AUTO_INCREMENT PRIMARY KEY,
    id_usuario INT NOT NULL,
    fecha_actividad DATE NOT NULL,
    tipo_actividad VARCHAR(100) NULL,
    descripcion_actividad TEXT NULL,
    puntos_otorgados INT DEFAULT 0,
    FOREIGN KEY (id_usuario) REFERENCES usuarios(id_usuario) ON DELETE CASCADE ON UPDATE CASCADE
);

-- Relación para encargado de perfil (se agrega después de crear usuarios)
ALTER TABLE perfiles
ADD FOREIGN KEY (encargado_perfil_id) REFERENCES usuarios(id_usuario) ON DELETE SET NULL ON UPDATE CASCADE;

-- Vistas: consultas predefinidas para análisis
CREATE OR REPLACE VIEW v_DesempenoColaboradores AS
SELECT
    u.id_usuario,
    CONCAT(u.nombre, ' ', u.apellido) AS nombre_completo,
    c.nombre_cargo AS cargo,
    u.salario,
    COALESCE(SUM(f.puntos_otorgados), 0) AS total_puntos,
    CASE
        WHEN COALESCE(SUM(f.puntos_otorgados), 0) > 500 THEN 'Excelente'
        WHEN COALESCE(SUM(f.puntos_otorgados), 0) >= 200 THEN 'Bueno'
        ELSE 'Regular'
    END AS estado,
    MAX(l.fecha_hora_login) AS ultimo_login
FROM usuarios u
LEFT JOIN fidelizacion f ON u.id_usuario = f.id_usuario
LEFT JOIN cargos c ON u.id_cargo = c.id_cargo
LEFT JOIN login l ON u.id_usuario = l.id_usuario AND l.estado_login = 'exitoso'
GROUP BY u.id_usuario;

CREATE OR REPLACE VIEW v_actividadesPorPerfil AS
SELECT
    p.id_perfil,
    p.nombre_perfil,
    COUNT(DISTINCT u.id_usuario) AS total_usuarios,
    COUNT(f.id_actividad) AS total_actividades,
    IFNULL(AVG(f.puntos_otorgados), 0) AS promedio_puntos
FROM perfiles p
LEFT JOIN usuarios u ON u.id_perfil = p.id_perfil
LEFT JOIN fidelizacion f ON f.id_usuario = u.id_usuario
GROUP BY p.id_perfil;

CREATE OR REPLACE VIEW v_historialLoginDetallado AS
SELECT
    l.id_login,
    l.id_usuario,
    u.nombre,
    u.apellido,
    c.nombre_cargo AS cargo,
    l.fecha_hora_login,
    l.estado_login,
    TIMESTAMPDIFF(
        MINUTE,
        LAG(l.fecha_hora_login) OVER (PARTITION BY l.id_usuario ORDER BY l.fecha_hora_login),
        l.fecha_hora_login
    ) AS minutos_desde_anterior
FROM login l
LEFT JOIN usuarios u ON u.id_usuario = l.id_usuario
LEFT JOIN cargos c ON u.id_cargo = c.id_cargo;

-- Ejemplos de consultas sobre las vistas.
SELECT nombre_completo, cargo, total_puntos
FROM v_DesempenoColaboradores
ORDER BY total_puntos DESC
LIMIT 5;

SELECT nombre_perfil, total_actividades
FROM v_actividadesPorPerfil
ORDER BY total_actividades ASC
LIMIT 5;

SELECT nombre_completo, cargo, DATEDIFF(CURDATE(), ultimo_login) AS dias_inactivo
FROM v_DesempenoColaboradores
WHERE DATEDIFF(CURDATE(), ultimo_login) > 30;

SELECT
    DATE_FORMAT(fecha_hora_login, '%Y-%m') AS mes,
    COUNT(CASE WHEN estado_login = 'exitoso' THEN 1 END) AS exitosos,
    COUNT(CASE WHEN estado_login = 'fallido' THEN 1 END) AS fallidos
FROM login
GROUP BY mes
ORDER BY mes;

