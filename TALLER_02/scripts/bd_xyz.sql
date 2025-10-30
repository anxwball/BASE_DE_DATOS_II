-- Active: 1759446392079@@127.0.0.1@3306@fidelizacion_xyz
CREATE DATABASE IF NOT EXISTS fidelizacion_xyz;
USE fidelizacion_xyz;

-- Perfiles: información básica de perfiles
CREATE TABLE perfiles (
    id_perfil INT AUTO_INCREMENT PRIMARY KEY,
    nombre_perfil VARCHAR(50) NOT NULL,
    fecha_vigencia_perfil DATE,
    descripcion_perfil TEXT,
    encargado_perfil_id INT NULL
);

-- Cargos: lista de cargos
CREATE TABLE cargos (
    id_cargo INT AUTO_INCREMENT PRIMARY KEY,
    nombre_cargo VARCHAR(50) NOT NULL
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
    id_perfil INT NULL
);

-- Login: registros de acceso
CREATE TABLE login (
    id_login INT AUTO_INCREMENT PRIMARY KEY,
    id_usuario INT NOT NULL,
    fecha_hora_login DATETIME NOT NULL,
    estado_login VARCHAR(20) NOT NULL
);

-- Fidelizacion: actividades y puntos asociados a usuarios
CREATE TABLE fidelizacion (
    id_actividad INT AUTO_INCREMENT PRIMARY KEY,
    id_usuario INT NOT NULL,
    fecha_actividad DATE NOT NULL,
    tipo_actividad VARCHAR(100) NULL,
    descripcion_actividad TEXT NULL,
    puntos_otorgados INT DEFAULT 0
);

-- Vistas: consultas predefinidas para análisis
CREATE OR REPLACE VIEW v_DesempenoColaboradores AS
SELECT 
    u.id_usuario,
    CONCAT(u.nombre, ' ', u.apellido) AS nombre_completo,
    c.nombre_cargo AS cargo,
    u.salario,
    u.fecha_ingreso,
    IFNULL(SUM(f.puntos_otorgados), 0) AS total_puntos_fidelizacion_acumulados,
    IFNULL(AVG(f.puntos_otorgados), 0) AS promedio_puntos_por_actividad,
    CASE
        WHEN SUM(f.puntos_otorgados) > 500 THEN 'Excelente'
        WHEN SUM(f.puntos_otorgados) BETWEEN 200 AND 500 THEN 'Bueno'
        ELSE 'Regular'
    END AS estado_fidelizacion,
    DATEDIFF(CURDATE(), (
        SELECT MAX(l.fecha_hora_login)
        FROM login l
        WHERE l.id_usuario = u.id_usuario AND l.estado_login = 'exitoso'
    )) AS dias_desde_ultimo_login
FROM usuarios u
LEFT JOIN fidelizacion f ON u.id_usuario = f.id_usuario
LEFT JOIN cargos c ON u.id_cargo = c.id_cargo
GROUP BY u.id_usuario;

CREATE OR REPLACE VIEW v_actividadesPorPerfil AS
SELECT 
    p.id_perfil,
    p.nombre_perfil,
    p.descripcion_perfil,
    COUNT(DISTINCT u.id_usuario) AS cantidad_usuarios_con_este_perfil,
    COUNT(f.id_actividad) AS total_actividades_participadas_por_perfil,
    IFNULL(AVG(f.puntos_otorgados), 0) AS promedio_puntos_por_usuario_en_este_perfil,
    CASE WHEN (SELECT COUNT(*) FROM fidelizacion) = 0 THEN 0
         ELSE ROUND((COUNT(f.id_actividad) / (SELECT COUNT(*) FROM fidelizacion)) * 100, 2)
    END AS porcentaje_participacion_total
FROM perfiles p
LEFT JOIN usuarios u ON u.id_perfil = p.id_perfil
LEFT JOIN fidelizacion f ON f.id_usuario = u.id_usuario
GROUP BY p.id_perfil;

CREATE OR REPLACE VIEW v_historialLoginDetallado AS
SELECT 
    u.nombre AS nombre_usuario,
    u.apellido AS apellido_usuario,
    c.nombre_cargo AS cargo_usuario,
    l.fecha_hora_login,
    l.estado_login,
    TIMESTAMPDIFF(
        MINUTE,
        (
            SELECT MAX(l2.fecha_hora_login)
            FROM login l2
            WHERE l2.id_usuario = l.id_usuario
            AND l2.fecha_hora_login < l.fecha_hora_login
        ),
        l.fecha_hora_login
    ) AS tiempo_desde_anterior_login
FROM login l
JOIN usuarios u ON u.id_usuario = l.id_usuario
LEFT JOIN cargos c ON u.id_cargo = c.id_cargo
ORDER BY u.id_usuario, l.fecha_hora_login;

SELECT nombre_completo, cargo, total_puntos_fidelizacion_acumulados
FROM v_DesempenoColaboradores
ORDER BY total_puntos_fidelizacion_acumulados DESC
LIMIT 5;

SELECT nombre_perfil, total_actividades_participadas_por_perfil
FROM v_actividadesPorPerfil
ORDER BY total_actividades_participadas_por_perfil ASC
LIMIT 5;

SELECT nombre_completo, cargo, dias_desde_ultimo_login
FROM v_DesempenoColaboradores
WHERE dias_desde_ultimo_login > 30;

SELECT 
    DATE_FORMAT(fecha_hora_login, '%Y-%m') AS mes,
    SUM(estado_login = 'exitoso') AS logins_exitosos,
    SUM(estado_login = 'fallido') AS logins_fallidos
FROM login
GROUP BY mes
ORDER BY mes;

