SYSTEM clear;

DROP TABLE IF EXISTS Directores;
DROP TABLE IF EXISTS ActoresPeliculas;
DROP TABLE IF EXISTS Actores;
DROP TABLE IF EXISTS Peliculas;


CREATE TABLE Peliculas(
    id_pelicula INT, 
	titulo VARCHAR(100) NOT NULL,
    id_director INT NOT NULL,
    /*id_actor INT,*/
    PRIMARY KEY(id_pelicula),
    UNIQUE (id_pelicula, titulo)
);

CREATE INDEX IndiceDirectores ON Peliculas(id_director);

CREATE TABLE Directores(
	id_director INT UNIQUE,
    edad INT CHECK (edad>0 AND edad<=120),
	nombre VARCHAR(100) NOT NULL,
    PRIMARY KEY(id_director),
	FOREIGN KEY(id_director) REFERENCES Peliculas(id_director)
);

CREATE TABLE Actores(
	id_actor INT UNIQUE,
    edad INT CHECK (edad>0 AND edad<=120),
	nombre VARCHAR(100) NOT NULL,
    PRIMARY KEY(id_actor)
);

CREATE TABLE ActoresPeliculas(
	id_actor INT, 
    id_pelicula INT,
    PRIMARY KEY(id_actor, id_pelicula),
    FOREIGN KEY(id_actor) REFERENCES Actores(id_actor),
    FOREIGN KEY(id_pelicula) REFERENCES Peliculas(id_pelicula)
);

show tables;

INSERT INTO Actores (nombre, id_actor, edad) VALUES
	('Russell Crowe', 128, 56),
    ('Robert Downey Jr', 375, 55),
    ('Tom Holland', 618, 24),
    ('Gwyneth Paltrow', 569, 48),
    ('Matthew McConaughey', 190, 52),
    ('Matt Damon', 354, 51),
    ('Mark Hamill', 434, 70),
    ('Carrie Fisher', 402, 60),
    ('Harrison Ford', 148, 79),
    ('Hayden Christensen', 789, 40);
    
INSERT INTO Peliculas(id_pelicula, titulo, id_director) VALUES
	(0172495, 'Gladiator', 631),
    (0371746, 'Iron Man', 939),
    (6320628, 'SpiderMan', 939),
    (4154796, 'Los vengadores: Endgame', 939),
    (816692,  'Interstellar', 4240),
    (76759,   'Star Wars: A new hope', 184),
    (3659388, 'The Martian', 631);
    
INSERT INTO Directores(nombre, id_director, edad) VALUES
	('Ridley Scott', 631, 83),
    ('Marvel - Hermanos Russo', 939, 85),
    ('Christopher Nolan', 4240, 50),
    ('George Lucas', 184, 75);
    
INSERT INTO ActoresPeliculas(id_actor, id_pelicula) VALUES
	(128,0172495),(375,0371746),(375,4154796),
    (618,6320628),(618,4154796),(569,0371746),
    (569,4154796),(190,816692),(354,816692),
    (434,76759),(402,76759),(148,76759),(354,3659388);

/*
SELECT * FROM Actores;
SELECT * FROM Directores;
*/
SELECT 'Cartelera';
SELECT * FROM Peliculas; 

/*
SELECT 'Directores junto a sus peliculas';

SELECT Peliculas.id_director, Directores.nombre, Peliculas.titulo  
FROM Peliculas INNER JOIN Directores 
ON Peliculas.id_director = Directores.id_director 
ORDER BY Directores.id_director;

SELECT 'Reparto de las películas (por nombre)';

SELECT Peliculas.titulo, Actores.nombre, ActoresPeliculas.id_actor, ActoresPeliculas.id_pelicula
FROM Actores 
INNER JOIN ActoresPeliculas ON Actores.id_actor=ActoresPeliculas.id_actor
INNER JOIN Peliculas ON Peliculas.id_pelicula=ActoresPeliculas.id_pelicula
ORDER BY Peliculas.titulo;

SELECT 'Reparto de las películas (por actores)';

SELECT Actores.nombre, Peliculas.titulo, ActoresPeliculas.id_actor, ActoresPeliculas.id_pelicula
FROM Actores 
INNER JOIN ActoresPeliculas ON Actores.id_actor=ActoresPeliculas.id_actor
INNER JOIN Peliculas ON Peliculas.id_pelicula=ActoresPeliculas.id_pelicula
ORDER BY Actores.nombre;
*/


/* EJERCICIO 8 */
SELECT 'Todos los actores';
SELECT * FROM Actores;

SELECT 'Todos los actores de STAR WARS';
SELECT Actores.nombre, Peliculas.titulo
FROM Actores
JOIN ActoresPeliculas ON Actores.id_actor=ActoresPeliculas.id_actor
JOIN Peliculas        ON Peliculas.id_pelicula=ActoresPeliculas.id_pelicula
WHERE Peliculas.titulo='Star Wars: A new hope'
ORDER BY Actores.nombre;

SELECT 'Actores de más de 50 años';
SELECT * FROM Actores WHERE edad>50 ORDER BY Actores.edad;

SELECT 'Numero de peliculas de cada director';
SELECT Directores.nombre, COUNT(Peliculas.titulo) AS NumeroDePelis FROM Peliculas
JOIN Directores ON Directores.id_director = Peliculas.id_director
GROUP BY Directores.nombre
ORDER BY Directores.nombre;

SELECT 'Actores que no actuan';
SELECT * FROM Actores WHERE id_actor NOT IN (
	SELECT ActoresPeliculas.id_actor FROM ActoresPeliculas);

SELECT 'Todos los directores de las películas de un actor dado';
SELECT DISTINCT Actores.nombre, Directores.nombre, Directores.id_director
FROM Actores 
INNER JOIN ActoresPeliculas ON Actores.id_actor=ActoresPeliculas.id_actor
INNER JOIN Peliculas ON Peliculas.id_pelicula=ActoresPeliculas.id_pelicula
INNER JOIN Directores ON Peliculas.id_director=Directores.id_director
WHERE Actores.nombre='Matt Damon'
ORDER BY Directores.nombre;






