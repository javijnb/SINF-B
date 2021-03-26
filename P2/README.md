# PRACTICA 2 MySQL

Entramos en MySQL:

> sudo mysql -u usuarioROOT -p
> Password: SINFmolamogollon1!

Los ejercicios 1-8 están resueltos en el script `ejercicios.sql`.
Invocar dicho script desde mysql, primero escogiendo una base de datos sobre la que trabajar:
> use practicas;

Cargamos el script, que limpia la terminal y las tablas generadas cada vez que se invoca:
> \\. ejercicios.sql

***EJERCICIO 10***

El fichero `DLL.sql` se emplea para modelar el esquema de las bases de datos.
Los ficheros `gran.sql` y `peq.sql`tienen el código que genera el esquema e inserta datos en una base de datos grande y pequeña, respectivamente.
Las consultas del ejercicio 10 están ubicadas en dichos ficheros. Para ejecutarlos:
> \\. peq.sql

> \\. gran.sql

En la consulta 4, con el LEFT JOIN nos aseguramos que si un docente no está en un departamento, que aparezca igualmente (esto se debe buscar en función de si lo contempla el modelo)
El comando `SELECT DISTINCT(atributo)` permite eliminar tuplas que tengan duplicado dicho atributo. Lo correcto sería usar un UNION pero bueno ;)
El comando `UNION ALL` consiste en fusionar dos tablas que compartan sus atributos y obtener otra relación con todas las tuplas posibles y el mismo número de atributos de las tablas originales.