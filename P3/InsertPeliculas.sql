DECLARE llamadas_contar_directores INT;
SET @llamadas_contar_directores = 0;
DECLARE cadena VARCHAR(100);
SET @cadena = "Cadena de prueba";

SYSTEM clear;

DROP TABLE IF EXISTS Directores;
DROP TABLE IF EXISTS ActoresPeliculas;
DROP TABLE IF EXISTS Actores;
DROP TABLE IF EXISTS Peliculas;


DROP PROCEDURE IF EXISTS listar_directores_peliculas;
DROP PROCEDURE IF EXISTS contar_directores;
DROP PROCEDURE IF EXISTS consultaPorNacionalidad;
DROP PROCEDURE IF EXISTS peliculasPorNacionalidad;
DROP PROCEDURE IF EXISTS ponerEnMayusculas;
DROP PROCEDURE IF EXISTS contar_directores2;
DROP PROCEDURE IF EXISTS extraer_imbds;

CREATE TABLE Peliculas(
    id_pelicula INT, 
	titulo VARCHAR(100) NOT NULL,
    id_director INT NOT NULL,
    nacionalidad VARCHAR(100),
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

show tables;

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
    
INSERT INTO Peliculas(id_pelicula, titulo, id_director, nacionalidad) VALUES
	(0172495, 'Gladiator', 631, 'Inglaterra'),
    (0371746, 'Iron Man', 939, 'USA'),
    (6320628, 'SpiderMan', 939, 'USA'),
    (4154796, 'Los vengadores: Endgame', 939, 'USA'),
    (816692,  'Interstellar', 4240, 'USA'),
    (76759,   'Star Wars: A new hope', 184, 'Canadá'),
    (3659388, 'The Martian', 631, 'USA');
    
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






-- EJERCICIO 1
DELIMITER //
CREATE PROCEDURE listar_directores_peliculas()
BEGIN
    SELECT Peliculas.titulo, Directores.nombre FROM Peliculas JOIN Directores ON Peliculas.id_director=Directores.id_director
    ORDER BY Peliculas.titulo;
END //
DELIMITER ;

CALL listar_directores_peliculas();




-- EJERCICIO 2
DELIMITER //
CREATE PROCEDURE contar_directores()
BEGIN

    DECLARE contador INT;

    CREATE TABLE IF NOT EXISTS cuentaDirectores(
        id_tabla INT NOT NULL AUTO_INCREMENT,
        instante TIMESTAMP,
        contaje INT,
        PRIMARY KEY(id_tabla)
    );

    SELECT COUNT(Directores.nombre) INTO @contador FROM Directores;

    INSERT INTO cuentaDirectores(contaje, instante) VALUES
    (@contador, CURRENT_TIMESTAMP());

    SELECT * FROM cuentaDirectores;

    SET @llamadas_contar_directores = @llamadas_contar_directores + 1;

END //
DELIMITER ;

-- CALL contar_directores();
-- SELECT @llamadas_contar_directores;




-- EJERCICIO 4
DELIMITER // 
CREATE PROCEDURE consultaPorNacionalidad(IN nacionalidadIN VARCHAR(100))
BEGIN
    
    SELECT * FROM Peliculas  WHERE Peliculas.nacionalidad  = nacionalidadIN;
    SELECT * FROM Directores WHERE Directores.nacionalidad = nacionalidadIN;
    SELECT * FROM Actores    WHERE Actores.nacionalidad    = nacionalidadIN;

END //
DELIMITER ;

CALL consultaPorNacionalidad("Inglaterra");



-- EJERCICIO 5
DELIMITER //
CREATE PROCEDURE peliculasPorNacionalidad(IN nacionalidadIN VARCHAR (100), OUT peliculasOUT INT)
BEGIN  
    SELECT COUNT(Peliculas.nacionalidad) INTO peliculasOUT FROM Peliculas WHERE Peliculas.nacionalidad=nacionalidadIN;

END //
DELIMITER ;

CALL peliculasPorNacionalidad("USA", @NumeroDePeliculas);
SELECT @NumeroDePeliculas;




-- EJERCICIO 6
DELIMITER //
CREATE PROCEDURE ponerEnMayusculas(INOUT cadena VARCHAR(100))
BEGIN
    SET cadena = UCASE(@cadena);
END //
DELIMITER ; 

CALL ponerEnMayusculas(@cadena);
SELECT @cadena;




-- EJERCICIO 7 : Version modificada del ejercicio 2/3
DELIMITER //
CREATE PROCEDURE contar_directores2()
BEGIN

    DECLARE contador2 INT;
    DECLARE tuplas INT;

    SELECT COUNT(Directores.nombre) INTO @contador2 FROM Directores;

    SELECT COUNT(*) INTO @tuplas FROM cuentaDirectores;
    SELECT @tuplas;
    IF @tuplas >= 10 THEN
        -- SELECT "Dentro del IF";
        DELETE FROM cuentaDirectores
        ORDER BY cuentaDirectores.instante ASC 
        LIMIT 1;
    END IF;

    INSERT INTO cuentaDirectores(contaje, instante) VALUES
    (@contador2, CURRENT_TIMESTAMP());

    SELECT * FROM cuentaDirectores;

    SET @llamadas_contar_directores = @llamadas_contar_directores + 1;

END //
DELIMITER ;

CALL contar_directores2();




-- EJERCICIO 8:
-- PRIMERO SOLO SE HARÁ CON PELICULAS
DELIMITER //
CREATE PROCEDURE extraer_imbds(IN nacionalidadIN VARCHAR(100))
BEGIN

    CREATE TABLE IF NOT EXISTS tablaAuxiliar(
        id_tabla INT NOT NULL AUTO_INCREMENT,
        id_imbd INT,
        nombre VARCHAR(100),
        PRIMARY KEY(id_tabla)
    );

    -- SELECT * FROM Peliculas  WHERE Peliculas.nacionalidad  = nacionalidadIN;
    INSERT INTO tablaAuxiliar(id_imbd, nombre) VALUES
        (765, "Nombre de prueba"); 
    SELECT * FROM tablaAuxiliar;
    ALTER TABLE tablaAuxiliar RENAME @nacionalidadIN;
    

END //
DELIMITER ;

CALL extraer_imbds("USA");






































/*
SELECT * FROM Actores;
SELECT * FROM Directores;
SELECT 'Cartelera';
SELECT * FROM Peliculas; 

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



EJERCICIO 8
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
*/




