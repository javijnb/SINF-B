USE practicas;

SYSTEM clear;

DROP TABLE IF EXISTS Directores;
DROP TABLE IF EXISTS ActoresPeliculas;
DROP TABLE IF EXISTS Actores;
DROP TABLE IF EXISTS Peliculas;

DROP VIEW VEjercicio6;
DROP VIEW VEjercicio7;
DROP VIEW VEjercicio8;

CREATE TABLE Peliculas(
    id_pelicula INT, 
	titulo VARCHAR(100) NOT NULL,
    id_director INT NOT NULL,
    nacionalidad VARCHAR(100) DEFAULT "USA",
    valoracion FLOAT(3,2),
    -- cartel BLOB,
    sello DATETIME DEFAULT NOW(),
    PRIMARY KEY(id_pelicula),
    UNIQUE (id_pelicula, titulo)
);

CREATE INDEX IndiceDirectores ON Peliculas(id_director);

CREATE TABLE Directores(
	id_director INT UNIQUE,
    edad INT CHECK (edad>0 AND edad<=120),
	nombre VARCHAR(100) NOT NULL,
    nacionalidad VARCHAR(100),
    PRIMARY KEY(id_director),
	FOREIGN KEY(id_director) REFERENCES Peliculas(id_director)
);

CREATE TABLE Actores(
	id_actor INT UNIQUE,
    edad INT CHECK (edad>0 AND edad<=120),
	nombre VARCHAR(100) NOT NULL,
    nacionalidad VARCHAR(100),
    PRIMARY KEY(id_actor)
);

CREATE TABLE ActoresPeliculas(
	id_actor INT, 
    id_pelicula INT,
    PRIMARY KEY(id_actor, id_pelicula),
    FOREIGN KEY(id_actor) REFERENCES Actores(id_actor),
    FOREIGN KEY(id_pelicula) REFERENCES Peliculas(id_pelicula)
);

INSERT INTO Actores (nombre, id_actor, edad, nacionalidad) VALUES
	('Russell Crowe', 128, 56, 'Nueva Zelanda'),
    ('Robert Downey Jr', 375, 55, 'USA'),
    ('Tom Holland', 618, 24, 'Inglaterra'),
    ('Gwyneth Paltrow', 569, 48, 'USA'),
    ('Matthew McConaughey', 190, 52, 'USA'),
    ('Matt Damon', 354, 51, 'USA'),
    ('Mark Hamill', 434, 70, 'USA'),
    ('Carrie Fisher', 402, 60, 'USA'),
    ('Harrison Ford', 148, 79, 'USA'),
    ('Hayden Christensen', 789, 40, 'Canadá');
    
INSERT INTO Peliculas(id_pelicula, titulo, id_director, nacionalidad, valoracion) VALUES
	(0172495, 'Gladiator', 631, 'Inglaterra', 5.01),
    (0371746, 'Iron Man', 939, 'USA', 9.99),
    (6320628, 'SpiderMan', 939, 'USA', 2.56),
    (4154796, 'Los vengadores: Endgame', 939, 'USA', 0.00),
    (816692,  'Interstellar', 4240, 'USA', 4.97),
    (76759,   'Star Wars: A new hope', 184, 'Canadá', 3.98),
    (3659388, 'The Martian', 631, 'USA', 3.05);
    
INSERT INTO Directores(nombre, id_director, edad, nacionalidad) VALUES
	('Ridley Scott', 631, 83, 'Inglaterra'),
    ('Marvel - Hermanos Russo', 939, 85, 'USA'),
    ('Christopher Nolan', 4240, 50, 'Inglaterra'),
    ('George Lucas', 184, 75, 'USA');
    
INSERT INTO ActoresPeliculas(id_actor, id_pelicula) VALUES
	(128,0172495),(375,0371746),(375,4154796),
    (618,6320628),(618,4154796),(569,0371746),
    (569,4154796),(190,816692),(354,816692),
    (434,76759),(402,76759),(148,76759),(354,3659388);

-- EJERCICIO 1: Definir un campo que sea una imagen
-- UPDATE Peliculas
-- SET cartel = LOAD_FILE('/home/javi/Escritorio/SINF_B/P4/imagen.png')
-- WHERE id_pelicula = 6320628;

-- EJERCICIO 2: Definir el campo valoración

-- EJERCICIO 3: Crear un valor por defecto
-- INSERT INTO Peliculas(id_pelicula, titulo, id_director, valoracion) VALUES (111, "Titulo de prueba", 1234, 8.78);
-- SELECT * FROM Peliculas (comprobar que al no haber introducido nacionalidad, que se haya puesto por defecto USA)

-- EJERCICIO 4: crear un campo timestamp que cada vez que cree una tupla se cree dicho valor por defecto con su momento de creacion
-- +-------------+-------------------------+-------------+--------------+------------+---------------------+
-- | id_pelicula | titulo                  | id_director | nacionalidad | valoracion | sello               |
-- +-------------+-------------------------+-------------+--------------+------------+---------------------+
-- |         111 | Titulo de prueba        |        1234 | USA          |       8.78 | 2021-04-16 12:26:26 |
-- |       76759 | Star Wars: A new hope   |         184 | Canadá       |       3.98 | 2021-04-16 12:26:17 |
-- +-------------+-------------------------+-------------+--------------+------------+---------------------+

-- EJERCICIO 5: OMITIDO, ya se ha hecho en prácticas anteriores

-- EJERCICIO 6: Crear una vista que permita ver título y nacionalidad de una película
CREATE VIEW VEjercicio6 AS SELECT Peliculas.titulo, Peliculas.nacionalidad FROM Peliculas;
SELECT * FROM VEjercicio6;
-- Consulta sobre la vista: ver sólo campo título
SELECT titulo FROM VEjercicio6;

-- EJERCICIO 7: Vista que contenga, titulo, nacionalidad, director y actores que participan en ella
CREATE VIEW VEjercicio7 AS
SELECT Peliculas.titulo, Peliculas.nacionalidad, Actores.id_actor, Directores.id_director FROM Peliculas
JOIN Directores ON Directores.id_director = Peliculas.id_director
JOIN ActoresPeliculas ON Peliculas.id_pelicula=ActoresPeliculas.id_pelicula
JOIN Actores        ON Actores.id_actor=ActoresPeliculas.id_actor;
SELECT * FROM VEjercicio7;

-- EJERCICIO 8: Vista que contenga todas las peliculas de USA (p.e):
CREATE VIEW VEjercicio8 AS
SELECT Peliculas.titulo FROM Peliculas WHERE Peliculas.nacionalidad='USA';
SELECT * FROM VEjercicio8;





