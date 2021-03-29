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
DROP PROCEDURE IF EXISTS introducir_pelicula;

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
-- Crea una relación con todas las Peliculas, Actores y Directores con esa nacionalidad
-- Primero solo buscará en Peliculas y las inserta, y luego igual con Actores y Directores
DELIMITER //
CREATE PROCEDURE extraer_imbds(IN nacionalidadIN VARCHAR(100))
BEGIN

    -- Variable que va a contener el valor del puntero cada vez que encuentre una tupla válida
    DECLARE AuxPeliculas INT;
    DECLARE AuxActores INT;
    DECLARE AuxDirectores INT;

    -- Cursor para iterar en la query de peliculas que tienen la nacionalidad = input
    DECLARE finished BOOLEAN DEFAULT false;
    DECLARE cursorPeliculas CURSOR FOR SELECT Peliculas.id_pelicula FROM Peliculas WHERE Peliculas.nacionalidad = nacionalidadIN;
    DECLARE cursorActores   CURSOR FOR SELECT Actores.id_actor      FROM Actores   WHERE Actores.nacionalidad   = nacionalidadIN;
    DECLARE cursorDirectores CURSOR FOR SELECT Directores.id_director FROM Directores WHERE Directores.nacionalidad = nacionalidadIN;

    -- Creamos los comandos de forma dinámica en función de la nacionalidad introducida (las instrucciones por defecto son atómicas)
    SET @comandoDropTable   = CONCAT("DROP TABLE IF EXISTS ", nacionalidadIN, ";");
    SET @comandoCreateTable = CONCAT("CREATE TABLE ", nacionalidadIN, " (IMBD INT);");

    -- Inicializamos
    SET AuxPeliculas = 0;
    SET AuxActores   = 0;
    SET AuxDirectores = 0;

    -- Eliminamos si existía ya una tabla con ese nombre (nacionalidad introducida) y luego la creamos
    PREPARE stmt_dropTable FROM @comandoDropTable;
    EXECUTE stmt_dropTable;

    PREPARE stmt_createTable FROM @comandoCreateTable;
    EXECUTE stmt_createTable;

    -- Comenzamos a iterar Peliculas
    OPEN cursorPeliculas;
    BEGIN   
        -- Cada vez que entramos tenemos que ponerlo a false
        DECLARE finished BOOLEAN DEFAULT false;
        DECLARE CONTINUE HANDLER FOR NOT FOUND SET finished = true;

        -- Bucle de Peliculas
        buclePeliculas: LOOP

            -- Cada vez que encuentre el cursor una tupla válida, la metemos en la variable
            FETCH cursorPeliculas INTO AuxPeliculas;
            IF finished THEN 
                LEAVE buclePeliculas;
            ELSE
                -- Si quedan más por buscar, preparamos el comando para añadir dicho valor a la tabla
                SET @addValue = CONCAT("INSERT ", nacionalidadIN, " VALUES(", AuxPeliculas,");");
                PREPARE stmt_addValuePeliculas FROM @addValue;
                EXECUTE stmt_addValuePeliculas;
            END IF;
        END LOOP buclePeliculas;
    END;
    CLOSE cursorPeliculas;

    -- Comenzamos a iterar Actores
    OPEN cursorActores;
    BEGIN   
        DECLARE finished BOOLEAN DEFAULT false;
        DECLARE CONTINUE HANDLER FOR NOT FOUND SET finished = true;

        bucleActores: LOOP

            FETCH cursorActores INTO AuxActores;
            IF finished THEN 
                LEAVE bucleActores;
            ELSE
                SET @addValue = CONCAT("INSERT ", nacionalidadIN, " VALUES(", AuxActores,");");
                PREPARE stmt_addValueActores FROM @addValue;
                EXECUTE stmt_addValueActores;
            END IF;
        END LOOP bucleActores;

    END;
    CLOSE cursorActores;

    -- Comenzamos a iterar Directores
    OPEN cursorDirectores;
    BEGIN   
        DECLARE finished BOOLEAN DEFAULT false;
        DECLARE CONTINUE HANDLER FOR NOT FOUND SET finished = true;

        bucleDirectores: LOOP

            FETCH cursorDirectores INTO AuxDirectores;
            IF finished THEN 
                LEAVE bucleDirectores;
            ELSE
                SET @addValue = CONCAT("INSERT ", nacionalidadIN, " VALUES(", AuxDirectores,");");
                PREPARE stmt_addValueDirectores FROM @addValue;
                EXECUTE stmt_addValueDirectores;
            END IF;
        END LOOP bucleDirectores;
        
    END;
    CLOSE cursorDirectores;


END //
DELIMITER ;

CALL extraer_imbds("USA");
SELECT * FROM USA;


-- EJERCICIO 9 y 10
DELIMITER //
CREATE PROCEDURE introducir_pelicula(IN id_peliculaIN INT, IN tituloIN VARCHAR(100), IN id_directorIN INT, IN nacionalidadIN VARCHAR(100))
BEGIN

    START TRANSACTION;
        INSERT Peliculas VALUE(id_peliculaIN, tituloIN, id_directorIN, nacionalidadIN);
    COMMIT;

END //
DELIMITER ;

-- CALL introducir_pelicula(77777, "Star Wars: The empire strikes back", 184, "USA");
-- SELECT * FROM Peliculas;

-- EJERCICIO 11
DELIMITER //
DROP TRIGGER IF EXISTS disparadorEliminarDirectores//
CREATE TRIGGER disparadorEliminarDirectores BEFORE DELETE ON Directores FOR EACH ROW
BEGIN
    -- Variables para poder efectuar los chequeos y la eliminación del elemento de la tabla de su nacionalidad
    DECLARE nacionalidadAux VARCHAR(100);
    DECLARE id_directorAux INT;

    -- Conseguimos la nacionalidad para saber buscar en la tabla
    SELECT Directores.nacionalidad INTO nacionalidadAux FROM Directores WHERE Directores.id_director = old.id_director;
    -- Conseguimos el IMBD del elemento para saber cual eliminar
    SELECT Directores.id_director INTO id_directorAux FROM Directores WHERE Directores.id_director = old.id_director;

    IF(nacionalidadAux="USA") THEN
        DELETE FROM USA WHERE USA.IMBD = id_directorAux;
    END IF;

END //
DELIMITER ;

DELIMITER //
DROP TRIGGER IF EXISTS disparadorInsertarDirectores//
CREATE TRIGGER disparadorInsertarDirectores BEFORE INSERT ON Directores FOR EACH ROW
BEGIN
    DECLARE nacionalidadAux VARCHAR(100);
    DECLARE id_directorAux INT;

    SELECT Directores.nacionalidad INTO nacionalidadAux FROM Directores WHERE Directores.id_director = new.id_director;
    SELECT Directores.id_director  INTO id_directorAux  FROM Directores WHERE Directores.id_director = new.id_director;

    IF(nacionalidadAux="USA") THEN
        INSERT USA VALUE(id_directorAux);
    END IF;

END //
DELIMITER ;


INSERT INTO Peliculas(id_pelicula, titulo, id_director, nacionalidad) VALUES(33333, "Titulo de prueba", 200, "España");
INSERT INTO Directores(id_director, edad, nombre, nacionalidad) VALUE(200, 66, "James Cameron", "USA");
SELECT * FROM Directores;
SELECT * FROM USA;
-- DELETE FROM Directores WHERE id_director=200;
-- SELECT * FROM USA ;

