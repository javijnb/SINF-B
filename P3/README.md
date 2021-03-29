# PRACTICA 3 MySQL

Todos los ejericios de la práctica 3 están en el fichero `InsertPeliculas.sql`

Todas las declaraciones de variables dentro de un procedure (o del propio script SQL) deben estar situadas al principio de todo el código, si no da error

***CURSORES***

Todas las declaraciones de cursores han de estar ubicadas después de las de las variables y asociadas a un SELECT

Toda la explicación del funcionamiento del código de cursores está comentada en el ejericio 8 en el fichero

***TRANSACCIONES***

Para indicar a MySQL que gestionaremos nosotros manualmente las transacciones indicamos por terminal:

> SET autocommit = 0;

Las transacciones permiten ejecutar ejecutar por completo un conjunto de instrucciones o en caso de error, que no surtan efecto y se vuelva al estado anterior a la llamada de la transacción. `START TRANSACTION` para iniciarla, `COMMIT` para confirmar la ejecución de la directivas de la transacción y tengan resultado y `ROLLBACK` para cancelar su efecto y volver al estado inicial, previo a la invocación de la transacción. En este ejercicio ( EJ 9) vamos a hacer una transacción de instrucciones DML y además de probar su correcto funcionamiento, probar a matar el proceso de mysql desde otra terminal mientras se ejecuta la transacción para reiniciar el gestor de BD y comprobar que no ha tenido efecto dicha transacción incompleta
El ejercicio 9 está incluido en el 10

Para llamar al procedimiento almacenado de la transacción:

> CALL introducir_pelicula(77777, "Star Wars: The empire strikes back", 184, "USA");

> SELECT * FROM Peliculas;

Esta operación permite introducir directores incluso que no estén listados - debería corregirlo :( 

***DISPARADORES*** 

Procedimientos almacenados que se ejecutan antes o después de un evento de inserción, modificación o eliminación de un elemento. Sobrecarga el SGBD.
Obviamente solo podemos ver sus efectos y no verlo en acción ni invocarlos de forma directa.
Funcionamiento del ejericio 11: disparadores que se activan antes de introducir o eliminar un elemento de las relaciones Peliculas / Directores / Actores. Estos disparadores se encargan de tener actualizadas las tablas de la nacionalidad correspondiente al elemento que alteramos. De esta manera si alguien elimina un actor de USA se elimina su ID de la tabla, y si alguien mete uno nuevo, que este entre en la tabla de su nacionalidad correspondiente. Para comprobar su correcto funcionamiento:

> INSERT INTO Peliculas VALUES(77777, "Star Wars: The empire strikes back", 184, "USA");

> SELECT * FROM USA;

En los disparadores se juegan con las palabras reservadas `.old` y `.new`

- Inserción: sólo se puede acceder al campo `.new`, el campo `.old` contiene NULL

- Modificación: se pueden acceder a ambos campos e incluso compararlos

- Borrado: únicamente se puede acceder al valor `.old` ya que el campo `.new` después de que la operación suceda
