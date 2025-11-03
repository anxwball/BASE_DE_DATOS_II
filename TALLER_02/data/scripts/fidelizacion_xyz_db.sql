-- =====================================================
-- TALLER 02: Sistema de Fidelización XYZ
-- Base de Datos: Gestión de Usuarios y Fidelización
-- Autor: Aaron Newball
-- Fecha: Noviembre 2025
-- =====================================================

-- Eliminar base de datos si existe y crearla nuevamente
DROP DATABASE IF EXISTS fidelizacion_xyz;
CREATE DATABASE fidelizacion_xyz;
USE fidelizacion_xyz;

-- =====================================================
-- CREACIÓN DE TABLAS
-- =====================================================

-- Tabla: Perfiles
-- Almacena los diferentes perfiles/roles de usuarios
CREATE TABLE Perfiles (
    id_perfil INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    nombre_perfil VARCHAR(50) NOT NULL,
    descripcion_perfil VARCHAR(500),
    fecha_vigencia_perfil DATE NOT NULL,
    encargado_perfil VARCHAR(100),
    estado TINYINT(1) NOT NULL DEFAULT 1 COMMENT '1=activo, 0=inactivo',
    fecha_creacion DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Tabla: Usuarios
-- Almacena la información de los colaboradores/usuarios
CREATE TABLE Usuarios (
    id_usuario INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL,
    apellido VARCHAR(50) NOT NULL,
    cargo VARCHAR(80) NOT NULL,
    salario DECIMAL(10, 2) UNSIGNED NOT NULL,
    fecha_ingreso DATE NOT NULL,
    estado TINYINT(1) NOT NULL DEFAULT 1 COMMENT '1=activo, 0=inactivo',
    contrasena VARCHAR(255) NOT NULL COMMENT 'Hash bcrypt o argon2',
    id_perfil INT UNSIGNED NOT NULL,
    fecha_creacion DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    fecha_actualizacion DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Tabla: Login
-- Registra cada intento de inicio de sesión
CREATE TABLE Login (
    id_login BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    id_usuario INT UNSIGNED NOT NULL,
    fecha_hora_login DATETIME NOT NULL,
    estado_login TINYINT(1) NOT NULL COMMENT '1=exitoso, 0=fallido',
    ip_address VARCHAR(45) COMMENT 'IPv4 o IPv6',
    dispositivo VARCHAR(100)
);

-- Tabla: Actividades
-- Almacena las actividades de fidelización de la empresa
CREATE TABLE Actividades (
    id_actividad INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    fecha_actividad DATE NOT NULL,
    tipo_actividad VARCHAR(50) NOT NULL,
    descripcion_actividad VARCHAR(500),
    puntos_base DECIMAL(6, 2) UNSIGNED NOT NULL DEFAULT 0,
    estado TINYINT(1) NOT NULL DEFAULT 0 COMMENT '0 = programada, 1 = realizada, 2 = cancelada',
    fecha_creacion DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Tabla: Participacion_Actividades
-- Registra la participación de usuarios en actividades y los puntos otorgados
CREATE TABLE Participacion_Actividades (
    id_participacion INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    id_usuario INT UNSIGNED NOT NULL,
    id_actividad INT UNSIGNED NOT NULL,
    puntos_otorgados DECIMAL(6, 2) UNSIGNED NOT NULL,
    fecha_participacion DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    observaciones VARCHAR(500)
);

-- =====================================================
-- INSERCIÓN DE DATOS DE SIMULACIÓN
-- =====================================================

-- Insertar 10 Perfiles
INSERT INTO Perfiles (nombre_perfil, descripcion_perfil, fecha_vigencia_perfil, encargado_perfil, estado) VALUES
('Administrador', 'Acceso completo al sistema, gestión de usuarios y configuraciones', '2024-01-01', 'Gerencia General', 1),
('Gerente', 'Gestión de departamentos y equipos de trabajo', '2024-01-01', 'Dirección Ejecutiva', 1),
('Supervisor', 'Supervisión de equipos operativos y seguimiento de metas', '2024-01-01', 'Gerencia de Operaciones', 1),
('Analista', 'Análisis de datos y generación de reportes', '2024-01-01', 'Gerencia de TI', 1),
('Desarrollador', 'Desarrollo y mantenimiento de aplicaciones', '2024-01-01', 'Gerencia de Tecnología', 1),
('Recursos Humanos', 'Gestión de personal y nómina', '2024-01-01', 'Gerencia de RRHH', 1),
('Ventas', 'Gestión de clientes y ventas', '2024-01-01', 'Gerencia Comercial', 1),
('Marketing', 'Campañas y estrategias de marketing', '2024-01-01', 'Gerencia de Marketing', 1),
('Soporte Técnico', 'Atención y soporte a usuarios', '2024-01-01', 'Gerencia de TI', 1),
('Operaciones', 'Ejecución de procesos operativos', '2024-01-01', 'Gerencia de Operaciones', 1);

-- Insertar 20 Usuarios
INSERT INTO Usuarios (nombre, apellido, cargo, salario, fecha_ingreso, estado, contrasena, id_perfil) VALUES
('Juan', 'Pérez', 'Director General', 8500.00, '2020-01-15', 1, 'hash_pass_001', 1),
('María', 'González', 'Gerente de Operaciones', 6500.00, '2020-03-20', 1, 'hash_pass_002', 2),
('Carlos', 'Rodríguez', 'Gerente de TI', 7000.00, '2020-06-10', 1, 'hash_pass_003', 2),
('Ana', 'Martínez', 'Supervisor de Ventas', 4500.00, '2021-01-05', 1, 'hash_pass_004', 3),
('Luis', 'García', 'Supervisor de Producción', 4200.00, '2021-02-15', 1, 'hash_pass_005', 3),
('Carmen', 'López', 'Analista de Datos', 3800.00, '2021-04-20', 1, 'hash_pass_006', 4),
('Roberto', 'Hernández', 'Analista Financiero', 4000.00, '2021-06-01', 1, 'hash_pass_007', 4),
('Laura', 'Díaz', 'Desarrolladora Senior', 5500.00, '2021-08-10', 1, 'hash_pass_008', 5),
('Diego', 'Torres', 'Desarrollador Junior', 3200.00, '2022-01-15', 1, 'hash_pass_009', 5),
('Patricia', 'Ramírez', 'Especialista en RRHH', 3900.00, '2022-03-01', 1, 'hash_pass_010', 6),
('Jorge', 'Flores', 'Ejecutivo de Ventas', 3500.00, '2022-05-10', 1, 'hash_pass_011', 7),
('Sofía', 'Cruz', 'Ejecutiva de Ventas', 3600.00, '2022-07-15', 1, 'hash_pass_012', 7),
('Fernando', 'Morales', 'Especialista en Marketing', 4100.00, '2022-09-01', 1, 'hash_pass_013', 8),
('Andrea', 'Ortiz', 'Community Manager', 3300.00, '2022-11-10', 1, 'hash_pass_014', 8),
('Ricardo', 'Vargas', 'Técnico de Soporte', 2800.00, '2023-01-20', 1, 'hash_pass_015', 9),
('Daniela', 'Castillo', 'Técnico de Soporte', 2900.00, '2023-03-15', 1, 'hash_pass_016', 9),
('Miguel', 'Reyes', 'Operador de Planta', 2500.00, '2023-05-01', 1, 'hash_pass_017', 10),
('Gabriela', 'Jiménez', 'Operadora de Planta', 2500.00, '2023-07-10', 1, 'hash_pass_018', 10),
('Pablo', 'Mendoza', 'Asistente Administrativo', 2600.00, '2023-09-15', 0, 'hash_pass_019', 10),
('Valeria', 'Navarro', 'Asistente de Gerencia', 3100.00, '2024-01-10', 1, 'hash_pass_020', 2);

-- Insertar 24 Actividades (2 por mes durante 12 meses)
INSERT INTO Actividades (fecha_actividad, tipo_actividad, descripcion_actividad, puntos_base, estado) VALUES
('2024-01-10', 'Capacitación', 'Taller de Liderazgo y Gestión de Equipos', 50.00, 1),
('2024-01-25', 'Deportiva', 'Torneo de Fútbol Interáreas', 30.00, 1),
('2024-02-08', 'Voluntariado', 'Jornada de Limpieza Ambiental', 40.00, 1),
('2024-02-22', 'Cultural', 'Día de la Creatividad e Innovación', 35.00, 1),
('2024-03-12', 'Capacitación', 'Curso de Excel Avanzado', 45.00, 1),
('2024-03-28', 'Social', 'Celebración de Aniversario de la Empresa', 25.00, 1),
('2024-04-15', 'Bienestar', 'Taller de Manejo de Estrés', 40.00, 1),
('2024-04-29', 'Deportiva', 'Caminata Ecológica', 30.00, 1),
('2024-05-10', 'Capacitación', 'Seminario de Atención al Cliente', 50.00, 1),
('2024-05-24', 'Cultural', 'Concurso de Talentos', 35.00, 1),
('2024-06-12', 'Voluntariado', 'Donación de Sangre', 45.00, 1),
('2024-06-26', 'Deportiva', 'Torneo de Volleyball', 30.00, 1),
('2024-07-15', 'Capacitación', 'Taller de Seguridad Industrial', 50.00, 1),
('2024-07-29', 'Social', 'Día de la Familia', 25.00, 1),
('2024-08-10', 'Bienestar', 'Jornada de Salud y Bienestar', 40.00, 1),
('2024-08-24', 'Cultural', 'Festival Gastronómico', 35.00, 1),
('2024-09-12', 'Capacitación', 'Curso de Trabajo en Equipo', 45.00, 1),
('2024-09-28', 'Deportiva', 'Maratón Recreativa', 30.00, 1),
('2024-10-15', 'Voluntariado', 'Visita a Hogar de Ancianos', 40.00, 1),
('2024-10-29', 'Cultural', 'Concurso de Disfraces Halloween', 25.00, 1),
('2024-11-10', 'Capacitación', 'Taller de Comunicación Efectiva', 50.00, 1),
('2024-11-24', 'Social', 'Celebración de Fin de Año', 30.00, 1),
('2024-12-12', 'Bienestar', 'Yoga y Meditación', 40.00, 1),
('2024-12-28', 'Cultural', 'Intercambio de Regalos Navideños', 35.00, 1);

-- Insertar Participaciones en Actividades
INSERT INTO Participacion_Actividades (id_usuario, id_actividad, puntos_otorgados, observaciones) VALUES
(1, 1, 50, 'Participación activa'), (1, 3, 40, 'Lideró el equipo'), (1, 5, 45, 'Completó el curso'),
(1, 7, 40, 'Excelente asistencia'), (1, 9, 50, 'Organizador'), (1, 11, 45, 'Donante frecuente'),
(1, 13, 50, 'Certificación obtenida'), (1, 15, 40, 'Participación destacada'), (1, 17, 45, 'Asistencia perfecta'),
(1, 19, 40, 'Voluntario activo'), (1, 21, 50, 'Facilitador del taller'), (1, 23, 40, 'Instructor'),
(2, 1, 50, 'Excelente participación'), (2, 2, 30, 'Jugadora destacada'), (2, 4, 35, 'Ideas innovadoras'),
(2, 6, 25, 'Buena asistencia'), (2, 8, 30, 'Completó la ruta'), (2, 10, 35, 'Ganadora del concurso'),
(2, 12, 30, 'Participación deportiva'), (2, 14, 25, 'Con familia'), (2, 16, 35, 'Participó activamente'),
(2, 18, 30, 'Completó la carrera'), (2, 20, 25, 'Disfraz creativo'), (2, 22, 30, 'Buena asistencia'),
(3, 1, 50, 'Curso completado'), (3, 3, 40, 'Voluntario activo'), (3, 5, 45, 'Excel avanzado'),
(3, 7, 40, 'Taller completado'), (3, 9, 50, 'Certificado'), (3, 11, 45, 'Donante'),
(3, 13, 50, 'Seguridad industrial'), (3, 15, 40, 'Salud integral'), (3, 17, 45, 'Trabajo en equipo'),
(3, 19, 40, 'Voluntariado'), (3, 21, 50, 'Comunicación'), (3, 23, 40, 'Bienestar'),
(4, 2, 30, 'Deporte'), (4, 4, 35, 'Creatividad'), (4, 6, 25, 'Social'),
(4, 8, 30, 'Caminata'), (4, 10, 35, 'Talento'), (4, 12, 30, 'Volleyball'),
(4, 14, 25, 'Familia'), (4, 16, 35, 'Gastronomía'), (4, 18, 30, 'Maratón'),
(4, 22, 30, 'Fin de año'),
(5, 1, 50, 'Liderazgo'), (5, 3, 40, 'Limpieza'), (5, 5, 45, 'Excel'),
(5, 9, 50, 'Cliente'), (5, 11, 45, 'Donación'), (5, 13, 50, 'Seguridad'),
(5, 17, 45, 'Equipo'), (5, 19, 40, 'Hogar ancianos'), (5, 21, 50, 'Comunicación'),
(6, 1, 50, 'Capacitación'), (6, 5, 45, 'Excel'), (6, 9, 50, 'Seminario'),
(6, 13, 50, 'Seguridad'), (6, 17, 45, 'Trabajo equipo'), (6, 21, 50, 'Comunicación'),
(7, 2, 30, 'Fútbol'), (7, 6, 25, 'Aniversario'), (7, 10, 35, 'Talentos'),
(7, 14, 25, 'Familia'), (7, 18, 30, 'Maratón'), (7, 22, 30, 'Celebración'),
(8, 1, 50, 'Liderazgo'), (8, 3, 40, 'Voluntariado'), (8, 5, 45, 'Excel'),
(8, 7, 40, 'Estrés'), (8, 11, 45, 'Sangre'), (8, 15, 40, 'Salud'),
(8, 19, 40, 'Ancianos'), (8, 23, 40, 'Yoga'),
(9, 2, 30, 'Deporte'), (9, 8, 30, 'Caminata'), (9, 12, 30, 'Volleyball'),
(9, 18, 30, 'Maratón'),
(10, 1, 50, 'RRHH capacitación'), (10, 7, 40, 'Manejo estrés'), (10, 15, 40, 'Bienestar'),
(10, 21, 50, 'Comunicación'), (10, 23, 40, 'Yoga'),
(11, 4, 35, 'Creatividad'), (11, 9, 50, 'Atención cliente'), (11, 10, 35, 'Talentos'),
(11, 16, 35, 'Gastronomía'), (11, 20, 25, 'Halloween'),
(12, 4, 35, 'Innovación'), (12, 9, 50, 'Cliente'), (12, 16, 35, 'Cocina'),
(12, 20, 25, 'Disfraz'), (12, 22, 30, 'Social'),
(13, 4, 35, 'Marketing'), (13, 6, 25, 'Empresa'), (13, 10, 35, 'Talentos'),
(13, 14, 25, 'Familia'), (13, 16, 35, 'Gastro'), (13, 20, 25, 'Halloween'),
(13, 22, 30, 'Fin año'), (13, 24, 35, 'Navidad'),
(14, 4, 35, 'Creatividad'), (14, 10, 35, 'Talentos'), (14, 16, 35, 'Gastro'),
(14, 20, 25, 'Disfraz'),
(15, 2, 30, 'Fútbol'), (15, 8, 30, 'Caminata'), (15, 12, 30, 'Volley'),
(16, 6, 25, 'Aniversario'), (16, 14, 25, 'Familia'), (16, 22, 30, 'Celebración'),
(16, 24, 35, 'Navidad'),
(17, 2, 30, 'Fútbol'), (17, 12, 30, 'Volley'),
(18, 6, 25, 'Social'), (18, 14, 25, 'Familia'), (18, 24, 35, 'Navidad'),
(20, 19, 40, 'Primera actividad'), (20, 21, 50, 'Comunicación'), (20, 23, 40, 'Yoga');

-- Insertar 100 Registros de Login
INSERT INTO Login (id_usuario, fecha_hora_login, estado_login, ip_address, dispositivo) VALUES
(1, '2024-01-02 08:15:23', 1, '192.168.1.10', 'Windows PC'),
(1, '2024-01-02 08:16:45', 0, '192.168.1.10', 'Windows PC'),
(2, '2024-01-02 08:30:12', 1, '192.168.1.15', 'MacBook Pro'),
(3, '2024-01-02 09:00:34', 1, '192.168.1.20', 'Windows PC'),
(4, '2024-01-03 08:45:22', 1, '192.168.1.25', 'iPad'),
(5, '2024-01-03 09:15:11', 1, '192.168.1.30', 'Windows PC'),
(1, '2024-01-04 08:10:05', 1, '192.168.1.10', 'Windows PC'),
(2, '2024-01-04 08:25:33', 1, '192.168.1.15', 'MacBook Pro'),
(6, '2024-01-05 08:55:44', 1, '192.168.1.35', 'Linux Laptop'),
(7, '2024-01-05 09:20:15', 1, '192.168.1.40', 'Windows PC'),
(8, '2024-02-01 08:30:22', 1, '192.168.1.45', 'MacBook Air'),
(9, '2024-02-01 08:35:44', 0, '192.168.1.50', 'Windows PC'),
(9, '2024-02-01 08:37:12', 1, '192.168.1.50', 'Windows PC'),
(10, '2024-02-02 08:40:33', 1, '192.168.1.55', 'Windows PC'),
(1, '2024-02-05 08:12:45', 1, '192.168.1.10', 'Windows PC'),
(2, '2024-02-05 08:28:11', 1, '192.168.1.15', 'MacBook Pro'),
(3, '2024-02-06 09:05:22', 1, '192.168.1.20', 'Windows PC'),
(11, '2024-02-07 08:50:33', 1, '192.168.1.60', 'iPhone'),
(12, '2024-02-08 09:10:44', 1, '192.168.1.65', 'Android'),
(13, '2024-02-09 08:45:55', 1, '192.168.1.70', 'Windows PC'),
(14, '2024-03-01 08:35:12', 1, '192.168.1.75', 'MacBook Pro'),
(15, '2024-03-01 09:00:23', 1, '192.168.1.80', 'Windows PC'),
(1, '2024-03-04 08:15:34', 1, '192.168.1.10', 'Windows PC'),
(2, '2024-03-04 08:30:45', 1, '192.168.1.15', 'MacBook Pro'),
(3, '2024-03-05 09:02:11', 0, '192.168.1.20', 'Windows PC'),
(3, '2024-03-05 09:03:22', 1, '192.168.1.20', 'Windows PC'),
(16, '2024-03-06 08:55:33', 1, '192.168.1.85', 'Windows PC'),
(17, '2024-03-07 09:15:44', 1, '192.168.1.90', 'Linux Laptop'),
(18, '2024-03-08 08:40:55', 1, '192.168.1.95', 'Windows PC'),
(4, '2024-03-10 08:50:12', 1, '192.168.1.25', 'iPad'),
(5, '2024-04-01 09:10:23', 1, '192.168.1.30', 'Windows PC'),
(6, '2024-04-01 08:58:34', 1, '192.168.1.35', 'Linux Laptop'),
(7, '2024-04-02 09:25:45', 1, '192.168.1.40', 'Windows PC'),
(8, '2024-04-03 08:32:11', 1, '192.168.1.45', 'MacBook Air'),
(1, '2024-04-05 08:18:22', 1, '192.168.1.10', 'Windows PC'),
(2, '2024-04-05 08:32:33', 1, '192.168.1.15', 'MacBook Pro'),
(9, '2024-04-08 08:40:44', 0, '192.168.1.50', 'Windows PC'),
(9, '2024-04-08 08:42:55', 1, '192.168.1.50', 'Windows PC'),
(10, '2024-04-10 08:45:12', 1, '192.168.1.55', 'Windows PC'),
(11, '2024-04-12 08:52:23', 1, '192.168.1.60', 'iPhone'),
(12, '2024-05-02 09:12:34', 1, '192.168.1.65', 'Android'),
(13, '2024-05-02 08:48:45', 1, '192.168.1.70', 'Windows PC'),
(14, '2024-05-03 08:38:11', 1, '192.168.1.75', 'MacBook Pro'),
(1, '2024-05-06 08:20:22', 1, '192.168.1.10', 'Windows PC'),
(2, '2024-05-06 08:35:33', 1, '192.168.1.15', 'MacBook Pro'),
(3, '2024-05-07 09:08:44', 1, '192.168.1.20', 'Windows PC'),
(15, '2024-05-08 09:05:55', 1, '192.168.1.80', 'Windows PC'),
(16, '2024-05-09 08:58:12', 1, '192.168.1.85', 'Windows PC'),
(4, '2024-05-12 08:52:23', 1, '192.168.1.25', 'iPad'),
(5, '2024-05-14 09:12:34', 1, '192.168.1.30', 'Windows PC'),
(6, '2024-06-03 09:00:45', 1, '192.168.1.35', 'Linux Laptop'),
(7, '2024-06-03 09:28:11', 1, '192.168.1.40', 'Windows PC'),
(8, '2024-06-04 08:35:22', 1, '192.168.1.45', 'MacBook Air'),
(1, '2024-06-05 08:22:33', 1, '192.168.1.10', 'Windows PC'),
(2, '2024-06-05 08:38:44', 1, '192.168.1.15', 'MacBook Pro'),
(17, '2024-06-06 09:18:55', 1, '192.168.1.90', 'Linux Laptop'),
(18, '2024-06-07 08:42:12', 0, '192.168.1.95', 'Windows PC'),
(18, '2024-06-07 08:43:23', 1, '192.168.1.95', 'Windows PC'),
(9, '2024-06-10 08:45:34', 1, '192.168.1.50', 'Windows PC'),
(10, '2024-06-12 08:48:45', 1, '192.168.1.55', 'Windows PC'),
(11, '2024-07-01 08:55:11', 1, '192.168.1.60', 'iPhone'),
(12, '2024-07-02 09:15:22', 1, '192.168.1.65', 'Android'),
(13, '2024-07-03 08:50:33', 1, '192.168.1.70', 'Windows PC'),
(1, '2024-07-05 08:25:44', 1, '192.168.1.10', 'Windows PC'),
(2, '2024-07-05 08:40:55', 1, '192.168.1.15', 'MacBook Pro'),
(3, '2024-07-08 09:10:12', 1, '192.168.1.20', 'Windows PC'),
(14, '2024-07-10 08:40:23', 1, '192.168.1.75', 'MacBook Pro'),
(4, '2024-07-12 08:55:34', 1, '192.168.1.25', 'iPad'),
(5, '2024-07-15 09:15:45', 1, '192.168.1.30', 'Windows PC'),
(15, '2024-07-18 09:08:11', 1, '192.168.1.80', 'Windows PC'),
(6, '2024-08-02 09:02:22', 1, '192.168.1.35', 'Linux Laptop'),
(7, '2024-08-05 09:30:33', 1, '192.168.1.40', 'Windows PC'),
(8, '2024-08-08 08:38:44', 1, '192.168.1.45', 'MacBook Air'),
(1, '2024-08-12 08:28:55', 1, '192.168.1.10', 'Windows PC'),
(2, '2024-08-12 08:42:12', 1, '192.168.1.15', 'MacBook Pro'),
(16, '2024-08-15 09:00:23', 1, '192.168.1.85', 'Windows PC'),
(9, '2024-08-18 08:48:34', 1, '192.168.1.50', 'Windows PC'),
(10, '2024-08-20 08:50:45', 0, '192.168.1.55', 'Windows PC'),
(10, '2024-08-20 08:52:11', 1, '192.168.1.55', 'Windows PC'),
(11, '2024-08-22 08:58:22', 1, '192.168.1.60', 'iPhone'),
(12, '2024-09-03 09:18:33', 1, '192.168.1.65', 'Android'),
(13, '2024-09-05 08:52:44', 1, '192.168.1.70', 'Windows PC'),
(1, '2024-09-09 08:30:55', 1, '192.168.1.10', 'Windows PC'),
(2, '2024-09-09 08:45:12', 1, '192.168.1.15', 'MacBook Pro'),
(3, '2024-09-10 09:12:23', 1, '192.168.1.20', 'Windows PC'),
(17, '2024-09-12 09:20:34', 1, '192.168.1.90', 'Linux Laptop'),
(4, '2024-09-15 08:58:45', 1, '192.168.1.25', 'iPad'),
(14, '2024-09-18 08:42:11', 1, '192.168.1.75', 'MacBook Pro'),
(5, '2024-09-20 09:18:22', 1, '192.168.1.30', 'Windows PC'),
(20, '2024-09-25 08:30:33', 1, '192.168.1.100', 'Windows PC'),
(6, '2024-10-02 09:05:44', 1, '192.168.1.35', 'Linux Laptop'),
(7, '2024-10-05 09:32:55', 1, '192.168.1.40', 'Windows PC'),
(8, '2024-10-08 08:40:12', 1, '192.168.1.45', 'MacBook Air'),
(1, '2024-10-10 08:32:23', 1, '192.168.1.10', 'Windows PC'),
(2, '2024-10-10 08:48:34', 1, '192.168.1.15', 'MacBook Pro'),
(15, '2024-10-12 09:10:45', 1, '192.168.1.80', 'Windows PC'),
(18, '2024-10-15 08:45:11', 1, '192.168.1.95', 'Windows PC'),
(9, '2024-10-18 08:50:22', 1, '192.168.1.50', 'Windows PC'),
(20, '2024-10-20 08:35:33', 1, '192.168.1.100', 'Windows PC'),
(10, '2024-10-22 08:52:44', 1, '192.168.1.55', 'Windows PC'),
(11, '2024-11-01 09:00:55', 1, '192.168.1.60', 'iPhone'),
(12, '2024-11-01 09:20:12', 1, '192.168.1.65', 'Android');

-- =====================================================
-- CREACIÓN DE VISTAS
-- =====================================================

-- Vista 1: Desempeño de Colaboradores
DROP VIEW IF EXISTS v_DesempenoColaboradores;

CREATE VIEW v_DesempenoColaboradores AS
SELECT 
    u.id_usuario,
    CONCAT(u.nombre, ' ', u.apellido) AS nombre_completo,
    u.cargo,
    u.salario,
    u.fecha_ingreso,
    COALESCE(SUM(pa.puntos_otorgados), 0) AS total_puntos_fidelizacion_acumulados,
    COALESCE(AVG(pa.puntos_otorgados), 0) AS promedio_puntos_por_actividad,
    CASE 
        WHEN COALESCE(SUM(pa.puntos_otorgados), 0) > 500 THEN 'Excelente'
        WHEN COALESCE(SUM(pa.puntos_otorgados), 0) BETWEEN 200 AND 500 THEN 'Bueno'
        ELSE 'Regular'
    END AS estado_fidelizacion,
    COALESCE(
        DATEDIFF(
            CURDATE(), 
            (SELECT MAX(l.fecha_hora_login) 
             FROM Login l 
             WHERE l.id_usuario = u.id_usuario 
             AND l.estado_login = 1)
        ), 
        NULL
    ) AS dias_desde_ultimo_login
FROM 
    Usuarios u
LEFT JOIN 
    Participacion_Actividades pa ON u.id_usuario = pa.id_usuario
GROUP BY 
    u.id_usuario, u.nombre, u.apellido, u.cargo, u.salario, u.fecha_ingreso;

-- Vista 2: Actividades por Perfil
DROP VIEW IF EXISTS v_actividadesPorPerfil;

CREATE VIEW v_actividadesPorPerfil AS
SELECT 
    p.id_perfil,
    p.nombre_perfil,
    p.descripcion_perfil,
    COUNT(DISTINCT u.id_usuario) AS cantidad_usuarios_con_este_perfil,
    COALESCE(COUNT(pa.id_participacion), 0) AS total_actividades_participadas_por_perfil,
    COALESCE(
        AVG(total_puntos.puntos_usuario), 0
    ) AS promedio_puntos_por_usuario_en_este_perfil,
    ROUND(
        (COALESCE(COUNT(pa.id_participacion), 0) * 100.0) / 
        NULLIF((SELECT COUNT(*) FROM Participacion_Actividades), 0),
        2
    ) AS porcentaje_participacion_total
FROM 
    Perfiles p
LEFT JOIN 
    Usuarios u ON p.id_perfil = u.id_perfil
LEFT JOIN 
    Participacion_Actividades pa ON u.id_usuario = pa.id_usuario
LEFT JOIN (
    SELECT 
        u2.id_usuario,
        u2.id_perfil,
        SUM(pa2.puntos_otorgados) AS puntos_usuario
    FROM 
        Usuarios u2
    LEFT JOIN 
        Participacion_Actividades pa2 ON u2.id_usuario = pa2.id_usuario
    GROUP BY 
        u2.id_usuario, u2.id_perfil
) AS total_puntos ON u.id_usuario = total_puntos.id_usuario
GROUP BY 
    p.id_perfil, p.nombre_perfil, p.descripcion_perfil;

-- Vista 3: Historial de Login Detallado
DROP VIEW IF EXISTS v_historialLoginDetallado;

CREATE VIEW v_historialLoginDetallado AS
SELECT 
    l.id_login,
    u.nombre AS nombre_usuario,
    u.apellido AS apellido_usuario,
    u.cargo AS cargo_usuario,
    l.fecha_hora_login,
    l.estado_login,
    TIMESTAMPDIFF(
        MINUTE,
        COALESCE(
            (SELECT l2.fecha_hora_login 
             FROM Login l2 
             WHERE l2.id_usuario = l.id_usuario 
             AND l2.fecha_hora_login < l.fecha_hora_login 
             ORDER BY l2.fecha_hora_login DESC 
             LIMIT 1),
            NULL
        ),
        l.fecha_hora_login
    ) AS tiempo_desde_anterior_login_minutos
FROM 
    Login l
INNER JOIN 
    Usuarios u ON l.id_usuario = u.id_usuario
ORDER BY 
    l.id_usuario, l.fecha_hora_login;

-- =====================================================
-- CONSULTAS DE NEGOCIO USANDO LAS VISTAS
-- =====================================================

-- Consulta 1: ¿Cuáles son los 5 colaboradores con mejor desempeño en fidelización y cuál es su cargo?
SELECT nombre_completo, cargo, total_puntos_fidelizacion_acumulados, estado_fidelizacion
FROM v_DesempenoColaboradores
ORDER BY total_puntos_fidelizacion_acumulados DESC
LIMIT 5;

-- Consulta 2: ¿Qué perfiles tienen la menor participación en actividades de fidelización y requieren un plan de incentivos?
SELECT nombre_perfil, descripcion_perfil, cantidad_usuarios_con_este_perfil, 
       total_actividades_participadas_por_perfil, promedio_puntos_por_usuario_en_este_perfil,
       porcentaje_participacion_total
FROM v_actividadesPorPerfil
ORDER BY total_actividades_participadas_por_perfil ASC, porcentaje_participacion_total ASC
LIMIT 5;

-- Consulta 3: ¿Qué usuarios no han iniciado sesión en los últimos 30 días y cuál fue su último cargo?
SELECT nombre_completo, cargo, dias_desde_ultimo_login, total_puntos_fidelizacion_acumulados
FROM v_DesempenoColaboradores
WHERE dias_desde_ultimo_login > 30 OR dias_desde_ultimo_login IS NULL
ORDER BY dias_desde_ultimo_login DESC;

-- Consulta 4: Obtener un reporte mensual de la cantidad de logins exitosos vs. fallidos
SELECT DATE_FORMAT(fecha_hora_login, '%Y-%m') AS mes, estado_login, COUNT(*) AS cantidad_logins
FROM v_historialLoginDetallado
GROUP BY mes, estado_login
ORDER BY mes, estado_login;