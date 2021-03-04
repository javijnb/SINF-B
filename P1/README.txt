INVOCACIÓN:
    > sudo mysql -h maquina -u usuario -p bd
    Por defecto no hay que indicar maquina por ser localhost y solo usamos el parametro -p si queremos cargar otra BD

    
LIMPIAR PANTALLA:
    > system clear;
    
SALIR DE MYSQL: >\q   ó   > exit
    
    
MOSTRAR USUARIOS: > SELECT User, Host FROM mysql.user;

    
AÑADIR USUARIO:
    > CREATE USER 'usuario1'@'localhost' IDENTIFIED BY 'SINFmolamogollon1!';
    
    Hay unas políticas de contraseñas que establecen cómo ha de fuerte han de ser
    Para visualizarlas:
    > SHOW VARIABLES LIKE 'validate_password%';
    
    
MODIFICAR USUARIOS:
    > ALTER USER 'usuario1'@'localhost' ATTRIBUTE '{"prueba": null}';
    
    Observar los cambios:
    > SELECT * FROM INFORMATION_SCHEMA.USER_ATTRIBUTES
        > WHERE USER='usuario1' AND HOST='localhost';
    
    
ELIMINAR USUARIO: > DROP USER 'usuario1'@'localhost';

CAMBIAR ENTRE USUARIOS: > SYSTEM mysql -u usuarioROOT -p
    
    
EJERCICIO 3 y 5 - AÑADIR UN USUARIO CON ACCESO DESDE CUALQUIER MÁQUINA SOBRE UNA BD CONCRETA:
    > CREATE USER 'usuarioROOT'@'localhost' IDENTIFIED BY 'SINFmolamogollon1!';
    > GRANT ALL PRIVILEGES ON *.* TO 'usuarioROOT'@'localhost';
    > FLUSH PRIVILEGES;

        
VER PERMISOS: > SHOW GRANTS FOR 'usuario1'@'localhost';
    

CREAR DATABASE: > CREATE DATABASE nombre;
MODIFICAR DATABASE: > ALTER DATABASE nombre READ_ONLY = 1; (si queremos que solo sea para lectura)
ELIMINAR DATABASE: > DROP DATABASE nombre;
USAR DATABASE: > USE nombre;

CREAR TABLA ALUMNOS:
    > CREATE TABLE Alumnos(
    -> id INT AUTO_INCREMENT,
    -> nombre VARCHAR(100),
    -> apellido VARCHAR(100),
    -> email VARCHAR(100),
    -> password VARCHAR(255),
    -> is_admin TINYINT(1),
    -> curso INT, 
    -> PRIMARY KEY(id)
    -> );
    
CREAR TABLA PROFESORES:
    > CREATE TABLE Profesores(
    -> id INT AUTO_INCREMENT,
    -> nombre VARCHAR(100),
    -> apellido VARCHAR(100),
    -> email VARCHAR(100),
    -> password VARCHAR(255),
    -> is_admin TINYINT(1),
    -> asignatura_impartida VARCHAR(100),
    -> departamento VARCHAR(100),
    -> PRIMARY KEY(id)
    -> );

ELIMINAR TABLA: > DROP TABLE nombre;
MOSTRAR TABLAS DE UNA DATABASE: > SHOW TABLES;
INTRODUCIR DATOS:
    > INSERT INTO Alumnos(nombre, apellido, email, password, is_admin, curso)
    -> values('Javi', 'Núñez', 'javijnb@gmail.com', 'contraseñalimpia', 1, 4);
    
INTRODUCIR DATOS EN UNA SOLA ORDEN:
    > INSERT INTO Alumnos(nombre, apellido, email, password, is_admin, curso)
    -> values('Diego', 'Prieto', 'diegopc@gmail.com', 'pwd', 0, 4),
    -> ('Pedro', 'Otero', 'correopedro@outlook.com', 'pwd2', 0, 4);

    
OBTENER INFORMACION DE UNA TABLA: > SELECT * FROM Alumnos;
OBTENER INFORMACION POR CAMPOS:   > SELECT nombre, apellido FROM Alumnos;
OBTENER INFORMACION POR VALORES:  > SELECT * FROM Alumnos WHERE curso=4;     SELECT * FROM Alumnos WHERE curso=4 AND is_admin=0;
ELIMINAR ENTRADAS DE LA TABLA:    > DELETE FROM Alumnos WHERE id=3;
ACTUALIZAR ENTRADAS DE LA TABLA:  > UPDATE Alumnos SET email='javimola99@outlook.com' WHERE id=1;
AÑADIR UN CAMPO A LA TABLA:       > ALTER TABLE Alumnos ADD edad VARCHAR(3);
CAMBIAR EL TIPO DE UN CAMPO:      > ALTER TABLE Alumnos MODIFY COLUMN edad INT(3);
ORDENAR ENTRADAS POR VALORES:     > SELECT * FROM Alumnos ORDER BY nombre ASC;
CONCATENAR CAMPOS Y FILTRAR:      > SELECT CONCAT(nombre, ' ', apellido) AS 'nuevocampo', edad FROM Alumnos;
OBTENER LOS VALORES DE UN CAMPO SIN REPETICIONES: > SELECT DISTINCT edad FROM Alumnos;
OBTENER UN RANGO DE VALORES:      > SELECT * FROM Alumnos WHERE edad BETWEEN 20 AND 25;
OBTENER UN CONJUNTO DE VALORES:   > SELECT * FROM Alumnos WHERE nombre IN('Javi', 'Diego');
OBTENER VALORES QUE EMPIECEN POR: > SELECT * FROM Alumnos WHERE nombre LIKE 'J%';

RELACIONES - FOREIGN KEY:
    > CREATE TABLE Profesores(
    -> id INT AUTO_INCREMENT,
    -> IDProfesor INT,
    -> nombre VARCHAR(100),
    -> apellidos VARCHAR(100),
    -> curso_impartido INT,
    -> PRIMARY KEY(id),
    -> FOREIGN KEY(curso_impartido) REFERENCES Alumnos(curso)
    -> );
    IMPORTANTE: Si usamos como foreign key el campo de otra tabla que no es primarykey, como es este caso, tenemos que crear un índice para ese campo:
    > CREATE INDEX IndiceCursos ON Alumnos(curso);
    
    OBTENER INFORMACION RELACIONADA ENTRE TABLAS - INNER JOIN:
    > SELECT
    -> Profesores.IDProfesor,
    -> Alumnos.nombre,
    -> Alumnos.apellidos,
    -> Profesores.nombre,
    -> Profesores.apellidos
    -> FROM Alumnos
    -> INNER JOIN Profesores
    -> ON Alumnos.curso = Profesores.curso
    -> ORDER BY Profesores.IDProfesor;
    Obtiene los campos nombre y apellidos de ambas tablas, busca las equivalencias entre las relaciones que indiquemos (en este caso los match de cursos) y luego la respuesta la ordena por codigo de profesor
    
ALUMNOS:
+----+--------+------------+------------------------+-------------------+----------+-------+------+
| id | nombre | apellido   | email                  | password          | is_admin | curso | edad |
+----+--------+------------+------------------------+-------------------+----------+-------+------+
|  1 | Javi   | Núñez      | javimola99@outlook.com | contraseñalimpia  |        1 |     4 | NULL |
|  2 | Diego  | Prieto     | diegopc@gmail.com      | pwd               |        0 |     4 | NULL |
|  4 | Axel   | Valladares | correoaxel@gmail.com   | contrasenachula   |        1 |     3 | NULL |
|  5 | Juan   | Jota       | javijnb@gmail.com      | contraseñasucia   |        0 |     1 | NULL |
+----+--------+------------+------------------------+-------------------+----------+-------+------+

    
PROFESORES:
+----+------------+--------+-----------+-----------------+
| id | IDProfesor | nombre | apellidos | curso_impartido |
+----+------------+--------+-----------+-----------------+
|  1 |       3463 | Juan   | Santos    |               4 |
|  2 |       1234 | Andres | Suarez    |               3 |
|  4 |       1111 | Jorge  | Duque     |               3 |
|  5 |       4345 | Ubaldo | Palomares |               1 |
+----+------------+--------+-----------+-----------------+


RESULTADO DEL ULTIMO SELECT:
+------------+--------+------------+--------+-----------+
| IDProfesor | nombre | apellido   | nombre | apellidos |
+------------+--------+------------+--------+-----------+
|       1111 | Axel   | Valladares | Jorge  | Duque     |
|       1234 | Axel   | Valladares | Andres | Suarez    |
|       3463 | Javi   | Núñez      | Juan   | Santos    |
|       3463 | Diego  | Prieto     | Juan   | Santos    |
|       4345 | Juan   | Jota       | Ubaldo | Palomares |
+------------+--------+------------+--------+-----------+



----------------------------------------------------------------------
TRAS INVOCAR EL SCRIPT PRUEBA.SQL:
Query OK, 0 rows affected (0.04 sec)

Query OK, 0 rows affected, 1 warning (0.00 sec)

+---------------------+
| Tables_in_practicas |
+---------------------+
| Alumnos             |
| Profesores          |
| Profesores2         |
+---------------------+
3 rows in set (0.01 sec)

+--------------+-------------+------+-----+---------+----------------+
| Field        | Type        | Null | Key | Default | Extra          |
+--------------+-------------+------+-----+---------+----------------+
| id           | int         | NO   | PRI | NULL    | auto_increment |
| DNI          | varchar(50) | YES  |     | NULL    |                |
| Nombre       | varchar(50) | YES  |     | NULL    |                |
| Apellidos    | varchar(50) | YES  |     | NULL    |                |
| Departamento | varchar(50) | YES  |     | NULL    |                |
+--------------+-------------+------+-----+---------+----------------+
5 rows in set (0.00 sec)

Query OK, 1 row affected (0.00 sec)

Query OK, 1 row affected (0.01 sec)

+----+-----------+--------+--------------+--------------+
| id | DNI       | Nombre | Apellidos    | Departamento |
+----+-----------+--------+--------------+--------------+
|  1 | 12345678A | Jorge  | Garcia Duque | Telematica   |
|  2 | 12345678A | Jorge  | Garcia Duque | Telematica   |
+----+-----------+--------+--------------+--------------+
2 rows in set (0.00 sec)

                                


