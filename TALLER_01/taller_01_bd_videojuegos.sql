-- Base de Datos de Videojuegos
-- Tema: BD de una Plataforma de Videojuegos tipo STEAM

-- =0=0=0=0=0=0=0=0=0=0= DDL =0=0=0=0=0=0=0=0=0=0=
CREATE DATABASE IF NOT EXISTS videojuegos_db;
USE videojuegos_db;

-- Tabla de Géneros
CREATE TABLE generos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL UNIQUE,
    descripcion TEXT
);

-- Tabla de Plataformas
CREATE TABLE plataformas (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL UNIQUE,
    fabricante VARCHAR(50) NOT NULL,
    fecha_lanzamiento DATE
);

-- Tabla de Desarrolladores
CREATE TABLE desarrolladores (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL UNIQUE,
    pais VARCHAR(50),
    sitio_web VARCHAR(255) NOT NULL UNIQUE,
    fecha_fundacion DATE
);

-- Tabla de Editores
CREATE TABLE editores (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL UNIQUE,
    pais VARCHAR(50),
    sitio_web VARCHAR(255) NOT NULL UNIQUE,
    fecha_fundacion DATE
);

-- Tabla de Usuarios
CREATE TABLE usuarios (
    id INT AUTO_INCREMENT PRIMARY KEY,
    usuario VARCHAR(20) NOT NULL UNIQUE,
    email VARCHAR(100) NOT NULL UNIQUE,
    contrasena VARCHAR(64) NOT NULL,
    fecha_nacimiento DATE,
    fecha_registro DATETIME DEFAULT CURRENT_TIMESTAMP,
    pais VARCHAR(50),
    es_admin BOOLEAN DEFAULT FALSE,
    es_baneado BOOLEAN DEFAULT FALSE,
    ultima_conexion DATETIME,
    estado_cuenta ENUM('activo', 'suspendido') DEFAULT 'activo',
    estado_actividad ENUM('activo', 'inactivo') DEFAULT 'activo'
);

-- Tabla de Videojuegos
CREATE TABLE videojuegos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    titulo VARCHAR(200) NOT NULL,
    descripcion TEXT,
    fecha_lanzamiento DATE,
    fecha_publicacion DATETIME,
    precio DECIMAL(10, 2) NOT NULL,
    clasificacion_edad VARCHAR(10),
    desarrollador_id INT NOT NULL,
    editor_id INT NOT NULL,
    FOREIGN KEY (desarrollador_id) REFERENCES desarrolladores(id),
    FOREIGN KEY (editor_id) REFERENCES editores(id)
);

-- Tabla de Logros
CREATE TABLE logros (
    id INT AUTO_INCREMENT PRIMARY KEY,
    videojuego_id INT NOT NULL,
    nombre VARCHAR(100) NOT NULL,
    descripcion TEXT,
    puntos INT DEFAULT 0,
    es_secreto BOOLEAN DEFAULT FALSE,
    FOREIGN KEY (videojuego_id) REFERENCES videojuegos(id) ON DELETE CASCADE
);

-- Tabla de Biblioteca (relación muchos a muchos)
CREATE TABLE biblioteca (
    usuario_id INT,
    videojuego_id INT,
    fecha_adquisicion DATETIME DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (usuario_id, videojuego_id),
    FOREIGN KEY (usuario_id) REFERENCES usuarios(id) ON DELETE CASCADE,
    FOREIGN KEY (videojuego_id) REFERENCES videojuegos(id) ON DELETE CASCADE
);

-- Tabla de Amistades (relación muchos a muchos con estado)
CREATE TABLE amistades (
    usuario_id INT,
    amigo_id INT,
    estado ENUM('pendiente', 'aceptada', 'rechazada', 'bloqueada') DEFAULT 'pendiente',
    fecha_solicitud DATETIME DEFAULT CURRENT_TIMESTAMP,
    fecha_aceptacion DATETIME,
    PRIMARY KEY (usuario_id, amigo_id),
    FOREIGN KEY (usuario_id) REFERENCES usuarios(id) ON DELETE CASCADE,
    FOREIGN KEY (amigo_id) REFERENCES usuarios(id) ON DELETE CASCADE
);

-- Tabla intermedia para Usuarios y Logros (relación muchos a muchos)
CREATE TABLE usuarios_logros (
    usuario_id INT,
    logro_id INT,
    fecha_obtencion DATETIME DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (usuario_id, logro_id),
    FOREIGN KEY (usuario_id) REFERENCES usuarios(id) ON DELETE CASCADE,
    FOREIGN KEY (logro_id) REFERENCES logros(id) ON DELETE CASCADE
);

-- Tabla intermedia para Videojuegos y Géneros (relación muchos a muchos)
CREATE TABLE videojuegos_generos (
    videojuego_id INT,
    genero_id INT,
    PRIMARY KEY (videojuego_id, genero_id),
    FOREIGN KEY (videojuego_id) REFERENCES videojuegos(id) ON DELETE CASCADE,
    FOREIGN KEY (genero_id) REFERENCES generos(id) ON DELETE CASCADE
);

-- Tabla intermedia para Videojuegos y Plataformas (relación muchos a muchos)
CREATE TABLE videojuegos_plataformas (
    videojuego_id INT,
    plataforma_id INT,
    fecha_lanzamiento_plataforma DATE,
    PRIMARY KEY (videojuego_id, plataforma_id),
    FOREIGN KEY (videojuego_id) REFERENCES videojuegos(id) ON DELETE CASCADE,
    FOREIGN KEY (plataforma_id) REFERENCES plataformas(id) ON DELETE CASCADE
);

-- Tabla de Reseñas
CREATE TABLE reviews (
    id INT AUTO_INCREMENT PRIMARY KEY,
    usuario_id INT NOT NULL,
    videojuego_id INT NOT NULL,
    puntuacion INT CHECK (puntuacion BETWEEN 1 AND 10),
    comentario TEXT,
    fecha_resena DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (usuario_id) REFERENCES usuarios(id) ON DELETE CASCADE,
    FOREIGN KEY (videojuego_id) REFERENCES videojuegos(id) ON DELETE CASCADE,
    UNIQUE KEY unique_user_game (usuario_id, videojuego_id)
);

-- =0=0=0=0=0=0=0=0=0=0= DML =0=0=0=0=0=0=0=0=0=0=

-- Insertar Géneros principales
INSERT INTO generos (nombre, descripcion) VALUES 
('Acción', 'Juegos que requieren reflejos rápidos y habilidades de combate'),
('Aventura', 'Juegos centrados en exploración y narrativa'),
('RPG', 'Juegos de rol donde desarrollas personajes y tomas decisiones'),
('Estrategia', 'Juegos que requieren planificación táctica y gestión de recursos'),
('Simulación', 'Juegos que simulan actividades del mundo real'),
('Deportes', 'Simulaciones de deportes y competencias atléticas'),
('Carreras', 'Juegos de competencias automovilísticas'),
('Indie', 'Juegos desarrollados independientemente'),
('Multijugador Masivo', 'MMO y juegos en línea con muchos jugadores'),
('Puzzle', 'Juegos que requieren resolución de problemas lógicos'),
('Plataformas', 'Juegos de salto y navegación por niveles'),
('Horror', 'Juegos diseñados para asustar y crear tensión'),
('Shooter', 'Juegos de disparos en primera o tercera persona'),
('Mundo Abierto', 'Juegos con grandes mundos explorables libremente');

-- Insertar Plataformas de videojuegos
INSERT INTO plataformas (nombre, fabricante, fecha_lanzamiento) VALUES 
('PC (Steam)', 'Valve Corporation', '2003-09-12'),
('PlayStation 5', 'Sony Interactive Entertainment', '2020-11-12'),
('Xbox Series X/S', 'Microsoft', '2020-11-10'),
('Nintendo Switch', 'Nintendo', '2017-03-03'),
('PlayStation 4', 'Sony Interactive Entertainment', '2013-11-15'),
('Xbox One', 'Microsoft', '2013-11-22'),
('Epic Games Store', 'Epic Games', '2018-12-06'),
('GOG', 'CD Projekt', '2008-09-09');

-- Insertar Estudios de desarrollo
INSERT INTO desarrolladores (nombre, pais, sitio_web, fecha_fundacion) VALUES 
('Naughty Dog', 'Estados Unidos', 'www.naughtydog.com', '1984-01-01'),
('CD Projekt RED', 'Polonia', 'www.cdprojektred.com', '1994-01-01'),
('Rockstar Games', 'Estados Unidos', 'www.rockstargames.com', '1998-12-01'),
('Valve Corporation', 'Estados Unidos', 'www.valvesoftware.com', '1996-08-24'),
('Nintendo EPD', 'Japón', 'www.nintendo.com', '2015-09-16'),
('FromSoftware', 'Japón', 'www.fromsoftware.jp', '1986-11-01'),
('Bethesda Game Studios', 'Estados Unidos', 'bethesdagamestudios.com', '2001-01-01'),
('Insomniac Games', 'Estados Unidos', 'www.insomniacgames.com', '1994-02-28'),
('Santa Monica Studio', 'Estados Unidos', 'sms.playstation.com', '1999-01-01'),
('Epic Games', 'Estados Unidos', 'www.epicgames.com', '1991-01-01'),
('Riot Games', 'Estados Unidos', 'www.riotgames.com', '2006-09-01'),
('Mojang Studios', 'Suecia', 'www.minecraft.net', '2009-05-17'),
('Supercell', 'Finlandia', 'supercell.com', '2010-06-14'),
('Bungie', 'Estados Unidos', 'www.bungie.net', '1991-05-01'),
('Ubisoft Montreal', 'Canadá', 'montreal.ubisoft.com', '1997-04-01');

-- Insertar Compañías editoras
INSERT INTO editores (nombre, pais, sitio_web, fecha_fundacion) VALUES 
('Sony Interactive Entertainment', 'Estados Unidos', 'www.playstation.com', '1993-11-16'),
('Microsoft Studios', 'Estados Unidos', 'www.xbox.com', '2000-01-01'),
('Nintendo', 'Japón', 'www.nintendo.com', '1889-09-23'),
('Electronic Arts', 'Estados Unidos', 'www.ea.com', '1982-05-27'),
('Activision Blizzard', 'Estados Unidos', 'www.activisionblizzard.com', '2008-07-09'),
('Ubisoft', 'Francia', 'www.ubisoft.com', '1986-03-28'),
('Take-Two Interactive', 'Estados Unidos', 'www.take2games.com', '1993-09-30'),
('CD Projekt', 'Polonia', 'www.cdprojekt.com', '1994-05-01'),
('Valve Corporation', 'Estados Unidos', 'www.valvesoftware.com', '1996-08-24'),
('Epic Games', 'Estados Unidos', 'www.epicgames.com', '1991-01-01'),
('Bethesda Softworks', 'Estados Unidos', 'bethesda.net', '1986-06-28'),
('Square Enix', 'Japón', 'www.square-enix.com', '2003-04-01'),
('Bandai Namco', 'Japón', 'www.bandainamcoent.com', '2006-03-31'),
('Capcom', 'Japón', 'www.capcom.com', '1979-05-30'),
('2K Games', 'Estados Unidos', 'www.2k.com', '2005-01-25');

-- Insertar Catálogo de videojuegos
INSERT INTO videojuegos (titulo, descripcion, fecha_lanzamiento, fecha_publicacion, precio, clasificacion_edad, desarrollador_id, editor_id) VALUES 
('The Last of Us Part II', 'Aventura post-apocalíptica sobre Ellie en busca de venganza en un mundo devastado por hongos infectados.', '2020-06-19', '2020-06-19 00:00:00', 59.99, 'M', 1, 1),
('Cyberpunk 2077', 'RPG futurista en Night City, donde juegas como V, un mercenario en busca de un implante que garantiza la inmortalidad.', '2020-12-10', '2020-12-10 00:00:00', 29.99, 'M', 2, 8),
('Grand Theft Auto V', 'Juego de mundo abierto ambientado en Los Santos, sigue las historias de tres criminales.', '2013-09-17', '2013-09-17 00:00:00', 29.99, 'M', 3, 7),
('Half-Life: Alyx', 'Aventura de realidad virtual que sirve como precuela de Half-Life 2.', '2020-03-23', '2020-03-23 00:00:00', 59.99, 'T', 4, 9),
('The Legend of Zelda: Breath of the Wild', 'Aventura de mundo abierto donde Link despierta en Hyrule devastado por Calamity Ganon.', '2017-03-03', '2017-03-03 00:00:00', 59.99, 'E10+', 5, 3),
('Elden Ring', 'RPG de acción en mundo abierto creado en colaboración con George R.R. Martin.', '2022-02-25', '2022-02-25 00:00:00', 59.99, 'M', 6, 11),
('The Elder Scrolls V: Skyrim', 'RPG épico de fantasía donde juegas como el Dragonborn en la provincia de Skyrim.', '2011-11-11', '2011-11-11 00:00:00', 39.99, 'M', 7, 11),
('Spider-Man: Miles Morales', 'Aventura de superhéroes siguiendo a Miles Morales como el nuevo Spider-Man de Nueva York.', '2020-11-12', '2020-11-12 00:00:00', 49.99, 'T', 8, 1),
('God of War', 'Reinvención de la saga, Kratos y su hijo Atreus viajan por los reinos nórdicos.', '2018-04-20', '2018-04-20 00:00:00', 39.99, 'M', 9, 1),
('Fortnite', 'Battle royale gratuito donde 100 jugadores luchan hasta que solo quede uno.', '2017-07-25', '2017-07-25 00:00:00', 0.00, 'T', 10, 10),
('League of Legends', 'MOBA competitivo donde dos equipos de cinco campeones luchan por destruir el Nexus enemigo.', '2009-10-27', '2009-10-27 00:00:00', 0.00, 'T', 11, 11),
('Minecraft', 'Juego sandbox de construcción y supervivencia en mundos proceduralmente generados.', '2011-11-18', '2011-11-18 00:00:00', 26.95, 'E10+', 12, 2),
('Clash of Clans', 'Estrategia mobile donde construyes tu aldea y luchas contra otros jugadores.', '2012-08-02', '2012-08-02 00:00:00', 0.00, 'T', 13, 13),
('Destiny 2', 'Shooter online cooperativo donde juegas como un Guardián protegiendo la humanidad.', '2017-09-06', '2017-09-06 00:00:00', 0.00, 'T', 14, 14),
('Assassins Creed Valhalla', 'RPG de acción ambientado en la era vikinga, siguiendo la historia de Eivor.', '2020-11-10', '2020-11-10 00:00:00', 59.99, 'M', 15, 6);

-- Relacionar videojuegos con géneros (muchos a muchos)
INSERT INTO videojuegos_generos (videojuego_id, genero_id) VALUES 
-- The Last of Us Part II (Acción, Aventura, Horror)
(1, 1), (1, 2), (1, 12),
-- Cyberpunk 2077 (RPG, Acción, Mundo Abierto)
(2, 3), (2, 1), (2, 14),
-- GTA V (Acción, Mundo Abierto)
(3, 1), (3, 14),
-- Half-Life: Alyx (Acción, Aventura, Shooter)
(4, 1), (4, 2), (4, 13),
-- Zelda BOTW (Aventura, Mundo Abierto)
(5, 2), (5, 14),
-- Elden Ring (RPG, Acción)
(6, 3), (6, 1),
-- Skyrim (RPG, Aventura, Mundo Abierto)
(7, 3), (7, 2), (7, 14),
-- Spider-Man Miles Morales (Acción, Aventura)
(8, 1), (8, 2),
-- God of War (Acción, Aventura)
(9, 1), (9, 2),
-- Fortnite (Shooter, Multijugador Masivo)
(10, 13), (10, 9),
-- League of Legends (Estrategia, Multijugador Masivo)
(11, 4), (11, 9),
-- Minecraft (Simulación, Indie, Mundo Abierto)
(12, 5), (12, 8), (12, 14),
-- Clash of Clans (Estrategia)
(13, 4),
-- Destiny 2 (Shooter, Multijugador Masivo)
(14, 13), (14, 9),
-- AC Valhalla (RPG, Acción, Mundo Abierto)
(15, 3), (15, 1), (15, 14);

-- Relacionar videojuegos con plataformas (muchos a muchos)
INSERT INTO videojuegos_plataformas (videojuego_id, plataforma_id, fecha_lanzamiento_plataforma) VALUES 
-- The Last of Us Part II (PlayStation exclusivo)
(1, 5, '2020-06-19'), (1, 2, '2022-03-29'),
-- Cyberpunk 2077 (Multiplataforma)
(2, 1, '2020-12-10'), (2, 5, '2020-12-10'), (2, 6, '2020-12-10'), (2, 2, '2020-12-10'), (2, 3, '2020-12-10'),
-- GTA V (Multiplataforma)
(3, 1, '2015-04-14'), (3, 5, '2014-11-18'), (3, 6, '2014-11-18'), (3, 2, '2022-03-15'),
-- Half-Life: Alyx (PC exclusivo Steam)
(4, 1, '2020-03-23'),
-- Zelda BOTW (Nintendo exclusivo)
(5, 4, '2017-03-03'),
-- Elden Ring (Multiplataforma)
(6, 1, '2022-02-25'), (6, 5, '2022-02-25'), (6, 6, '2022-02-25'), (6, 2, '2022-02-25'), (6, 3, '2022-02-25'),
-- Skyrim (Multiplataforma)
(7, 1, '2011-11-11'), (7, 5, '2016-10-28'), (7, 6, '2016-10-28'), (7, 4, '2017-11-17'), (7, 2, '2021-11-11'),
-- Spider-Man Miles Morales (PlayStation exclusivo)
(8, 5, '2020-11-12'), (8, 2, '2020-11-12'), (8, 1, '2022-11-18'),
-- God of War (PlayStation exclusivo luego PC)
(9, 5, '2018-04-20'), (9, 1, '2022-01-14'),
-- Fortnite (Multiplataforma)
(10, 1, '2017-07-25'), (10, 5, '2018-06-12'), (10, 6, '2018-06-12'), (10, 4, '2018-06-12'), (10, 2, '2018-06-12'), (10, 3, '2018-06-12'),
-- League of Legends (PC exclusivo)
(11, 1, '2009-10-27'),
-- Minecraft (Multiplataforma)
(12, 1, '2011-11-18'), (12, 5, '2014-09-04'), (12, 6, '2014-09-05'), (12, 4, '2017-05-11'), (12, 2, '2018-12-07'), (12, 3, '2018-12-07'),
-- Clash of Clans (Mobile - simularemos como plataforma PC)
(13, 1, '2013-10-07'),
-- Destiny 2 (Multiplataforma)
(14, 1, '2017-10-24'), (14, 5, '2017-09-06'), (14, 6, '2017-09-06'), (14, 2, '2019-10-01'), (14, 3, '2019-10-01'),
-- AC Valhalla (Multiplataforma)
(15, 1, '2020-11-10'), (15, 5, '2020-11-10'), (15, 6, '2020-11-10'), (15, 2, '2020-11-10'), (15, 3, '2020-11-10');

-- Insertar Usuarios de la plataforma
INSERT INTO usuarios (usuario, email, contrasena, fecha_nacimiento, pais, ultima_conexion, estado_cuenta, estado_actividad) VALUES 
('GamerPro23', 'carlos.martinez@email.com', SHA2('password123', 256), '1995-03-15', 'España', '2024-10-03 20:30:00', 'activo', 'activo'),
('NoobSlayer', 'ana.rodriguez@gmail.com', SHA2('securepass456', 256), '1992-07-22', 'México', '2024-10-03 19:45:00', 'activo', 'activo'),
('RetroGamer', 'miguel.santos@hotmail.com', SHA2('retro1987', 256), '1987-12-03', 'Argentina', '2024-10-02 22:15:00', 'activo', 'inactivo'),
('PixelQueen', 'sofia.herrera@yahoo.com', SHA2('pixel2024', 256), '1999-05-18', 'Colombia', '2024-10-03 21:00:00', 'activo', 'activo'),
('FPSMaster', 'david.lopez@outlook.com', SHA2('fps_master', 256), '1990-09-10', 'Chile', '2024-10-03 18:30:00', 'activo', 'activo');

-- Insertar datos en Biblioteca (usuarios que poseen juegos)
INSERT INTO biblioteca (usuario_id, videojuego_id, fecha_adquisicion) VALUES 
(1, 1, '2020-06-20 15:30:00'), 
(1, 2, '2020-12-11 10:15:00'), 
(1, 6, '2022-02-26 09:00:00'), 
(1, 7, '2019-05-10 20:00:00'),
(2, 10, '2018-03-15 14:20:00'), 
(2, 14, '2017-09-07 16:45:00'), 
(2, 4, '2020-03-24 11:30:00'),
(3, 7, '2011-11-12 00:30:00'), 
(3, 12, '2012-01-05 13:15:00'), 
(3, 3, '2013-09-18 18:20:00'),
(4, 5, '2017-03-04 12:00:00'), 
(4, 6, '2022-02-25 15:45:00'), 
(4, 9, '2018-04-21 19:30:00'),
(5, 10, '2017-08-01 10:00:00'), 
(5, 14, '2017-09-06 16:00:00'), 
(5, 4, '2020-03-23 14:30:00');

-- Insertar Reseñas de usuarios
INSERT INTO reviews (usuario_id, videojuego_id, puntuacion, comentario, fecha_resena) VALUES 
(1, 1, 9, 'Una obra maestra narrativa. Los gráficos son impresionantes y la historia te mantiene pegado a la pantalla.', '2020-06-25 21:30:00'),
(1, 2, 7, 'Buen juego en general, pero tuvo muchos bugs al lanzamiento. Night City es increíble.', '2021-03-15 19:45:00'),
(2, 10, 10, 'El mejor battle royale del mercado. Cada partida es diferente y las actualizaciones constantes mantienen el juego fresco.', '2018-09-20 16:20:00'),
(3, 7, 10, 'Un clásico atemporal. He jugado más de 500 horas y sigo descubriendo cosas nuevas.', '2012-01-15 14:30:00'),
(4, 5, 10, 'Revolucionó la fórmula de Zelda. La libertad de exploración es incomparable.', '2017-03-10 20:15:00'),
(5, 14, 8, 'Excelente shooter cooperativo. Los raids son desafiantes y satisfactorios.', '2017-09-20 22:00:00'),
(1, 6, 8, 'Desafiante como siempre, pero justo. La colaboración con George R.R. Martin se nota.', '2022-03-10 20:30:00'),
(4, 9, 9, 'Reinvención magistral de la saga. La relación padre-hijo está muy bien desarrollada.', '2018-05-01 16:45:00');

-- Insertar Sistema de logros
INSERT INTO logros (videojuego_id, nombre, descripcion, puntos, es_secreto) VALUES 
-- The Last of Us Part II (videojuego_id = 1)
(1, 'Sobreviviente', 'Completa el juego en cualquier dificultad', 50, FALSE),
(1, 'Coleccionista', 'Encuentra todos los objetos coleccionables', 75, FALSE),
(1, 'Venganza Cumplida', 'Completa la historia principal', 100, TRUE),
-- Cyberpunk 2077 (videojuego_id = 2)
(2, 'Leyenda de Night City', 'Alcanza el nivel 50', 80, FALSE),
(2, 'Keanu Reeves', 'Completa todas las misiones de Johnny Silverhand', 60, FALSE),
(2, 'Netrunner', 'Hackea 100 dispositivos', 40, FALSE),
-- GTA V (videojuego_id = 3)
(3, 'Golpe Perfecto', 'Completa un atraco sin alertar a la policía', 70, FALSE),
(3, 'Multimillonario', 'Acumula $100,000,000 en el modo online', 90, FALSE),
-- Half-Life: Alyx (videojuego_id = 4)
(4, 'Maestro de la Gravedad', 'Usa los guantes de gravedad 1000 veces', 50, FALSE),
(4, 'Resistance Fighter', 'Completa el juego en VR', 100, FALSE),
-- Zelda BOTW (videojuego_id = 5)
(5, 'Héroe de Hyrule', 'Derrota a Calamity Ganon', 100, FALSE),
(5, 'Explorador Completo', 'Activa todas las torres Sheikah', 60, FALSE),
(5, 'Maestro Chef', 'Cocina 50 platos diferentes', 30, FALSE),
-- Elden Ring (videojuego_id = 6)
(6, 'Señor del Anillo', 'Obtén el final del Señor del Anillo Ancestral', 100, TRUE),
(6, 'Demi-dios Derrotado', 'Derrota a Margit, el Vil Augurio', 50, FALSE),
(6, 'Jinete Legendario', 'Obtén a Torrent', 25, FALSE),
-- Skyrim (videojuego_id = 7)
(7, 'Dragonborn', 'Aprende tu primer grito de dragón', 40, FALSE),
(7, 'Master Criminal', 'Obtén una recompensa de 1000 monedas en los 9 territorios', 80, FALSE),
-- Spider-Man Miles Morales (videojuego_id = 8)
(8, 'Nuevo Spider-Man', 'Completa la historia principal', 100, FALSE),
(8, 'Venom Blast', 'Usa 50 ataques de veneno', 30, FALSE),
-- God of War (videojuego_id = 9)
(9, 'Padre e Hijo', 'Completa el viaje principal', 100, TRUE),
(9, 'Valkyria Slayer', 'Derrota a las 8 Valkyrias', 90, FALSE),
-- Fortnite (videojuego_id = 10)
(10, 'Victory Royale', 'Gana tu primera partida', 50, FALSE),
(10, '100 Eliminations', 'Consigue 100 eliminaciones', 60, FALSE),
-- League of Legends (videojuego_id = 11)
(11, 'First Blood', 'Consigue la primera muerte de la partida', 20, FALSE),
(11, 'Pentakill', 'Elimina a los 5 enemigos en menos de 10 segundos', 100, FALSE),
-- Minecraft (videojuego_id = 12)
(12, 'Taking Inventory', 'Abre tu inventario', 10, FALSE),
(12, 'The End?', 'Entra al End', 80, FALSE),
(12, 'Diamonds!', 'Adquiere diamantes con tu pico de hierro', 50, FALSE),
-- Destiny 2 (videojuego_id = 14)
(14, 'Guardian', 'Completa la campaña principal', 60, FALSE),
(14, 'Raid Master', 'Completa un raid', 100, FALSE);

-- Insertar Usuarios_Logros (logros obtenidos por usuarios)
INSERT INTO usuarios_logros (usuario_id, logro_id, fecha_obtencion) VALUES 
-- GamerPro23 (usuario 1) - jugador dedicado
(1, 1, '2020-06-28 23:45:00'), (1, 2, '2020-07-15 19:30:00'), (1, 3, '2020-06-30 22:15:00'),
(1, 4, '2021-02-20 20:00:00'), (1, 17, '2022-03-10 18:30:00'), (1, 18, '2022-03-15 21:45:00'),
-- NoobSlayer (usuario 2) - fan de shooters
(2, 23, '2018-04-01 16:20:00'), (2, 24, '2018-08-15 19:45:00'), (2, 11, '2020-03-30 17:30:00'),
(2, 29, '2017-10-15 20:15:00'),
-- RetroGamer (usuario 3) - coleccionista veterano
(3, 16, '2011-12-25 14:30:00'), (3, 17, '2012-03-10 16:45:00'), (3, 27, '2012-02-14 10:20:00'),
(3, 28, '2013-05-20 22:30:00'), (3, 9, '2013-10-30 15:45:00'),
-- PixelQueen (usuario 4) - aventurera
(4, 12, '2017-03-20 19:15:00'), (4, 13, '2017-04-05 21:30:00'), (4, 14, '2017-05-10 18:45:00'),
(4, 18, '2022-03-05 20:00:00'), (4, 19, '2022-03-25 16:30:00'), (4, 21, '2018-05-01 17:15:00'),
-- FPSMaster (usuario 5) - especialista en FPS
(5, 23, '2017-08-15 14:20:00'), (5, 24, '2018-01-20 19:30:00'), (5, 11, '2020-04-10 16:45:00'),
(5, 29, '2017-09-15 21:00:00'), (5, 30, '2018-06-20 18:15:00');

-- Insertar Amistades entre usuarios
INSERT INTO amistades (usuario_id, amigo_id, estado, fecha_solicitud, fecha_aceptacion) VALUES 
-- Amistades confirmadas
(1, 2, 'aceptada', '2020-07-01 10:30:00', '2020-07-01 14:20:00'),
(1, 4, 'aceptada', '2020-08-15 16:45:00', '2020-08-15 18:30:00'),
(2, 5, 'aceptada', '2018-09-10 20:15:00', '2018-09-10 21:00:00'),
(3, 4, 'aceptada', '2019-03-20 15:30:00', '2019-03-20 17:45:00'),
-- Solicitudes pendientes
(1, 3, 'pendiente', '2024-10-01 18:30:00', NULL),
(2, 4, 'pendiente', '2024-09-28 16:45:00', NULL),
-- Amistad bloqueada
(3, 5, 'bloqueada', '2022-08-10 19:30:00', NULL);

-- =0=0=0=0=0=0=0=0=0=0= CONSULTAS =0=0=0=0=0=0=0=0=0=0=

-- 1. Top 5 videojuegos mejor calificados
SELECT v.titulo, ROUND(AVG(r.puntuacion), 2) as promedio, COUNT(r.id) as total
FROM videojuegos v
LEFT JOIN reviews r ON v.id = r.videojuego_id
GROUP BY v.id, v.titulo
HAVING total > 0
ORDER BY promedio DESC, total DESC
LIMIT 5;

-- 2. Usuarios más activos (con más juegos en biblioteca)
SELECT u.usuario, COUNT(b.videojuego_id) as juegos_en_biblioteca, u.pais
FROM usuarios u
LEFT JOIN biblioteca b ON u.id = b.usuario_id
GROUP BY u.id, u.usuario, u.pais
ORDER BY juegos_en_biblioteca DESC
LIMIT 5;

-- 3. Videojuegos multiplataforma más populares
SELECT v.titulo, COUNT(vp.plataforma_id) as num_plataformas, COUNT(b.usuario_id) as propietarios
FROM videojuegos v
LEFT JOIN videojuegos_plataformas vp ON v.id = vp.videojuego_id
LEFT JOIN biblioteca b ON v.id = b.videojuego_id
GROUP BY v.id, v.titulo
HAVING num_plataformas >= 3
ORDER BY propietarios DESC, num_plataformas DESC;

-- 4. Usuarios con más logros desbloqueados
SELECT u.usuario, COUNT(ul.logro_id) as logros_obtenidos, u.pais
FROM usuarios u
LEFT JOIN usuarios_logros ul ON u.id = ul.usuario_id
GROUP BY u.id, u.usuario, u.pais
ORDER BY logros_obtenidos DESC
LIMIT 5;

-- 5. Análisis de amistades por estado y usuario
SELECT 
    a.estado,
    u1.usuario as solicitante,
    u2.usuario as destinatario,
    a.fecha_solicitud,
    a.fecha_aceptacion,
    COUNT(*) OVER (PARTITION BY a.estado) as total_por_estado
FROM amistades a
JOIN usuarios u1 ON a.usuario_id = u1.id
JOIN usuarios u2 ON a.amigo_id = u2.id
ORDER BY a.estado, a.fecha_solicitud DESC;