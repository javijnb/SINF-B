# PRÁCTICA 4 MySQL

Entramos en MySQL:

> sudo mysql -u usuarioROOT -p

> Password: SINFmolamogollon1!

## NOTAS

La mayoría de la información pertinente a cada apartado se encuentra comentada en el fichero `p4.sql`

## VISTAS

Un cambio efectuado en una vista tendrá efecto sobre las tablas (o vistas) de las que dependa.

Para poder ver todas las vistas actuales en la BD podemos introducir el siguiente comando:

> SHOW FULL TABLES WHERE table_type = 'VIEW';

#### Operaciones sobre vistas:

¿Cuándo una vista no es operable (INSERT o DELETE)? Cuando una vista contiene:

1. Aggregate functions such as MIN, MAX, SUM, AVG, and COUNT.
2. DISTINCT
3. GROUP BY clause.
4. HAVING clause.
5. UNION or UNION ALL clause.
6. Left join or outer join.
7. Subquery in the SELECT clause or in the WHERE clause that refers to the table appeared in the FROM clause.
8. Reference to non-updatable view in the FROM clause.
9. Reference only to literal values.
10. Multiple references to any column of the base table.

Sin embargo para ser updatable, no suele haber restricciones, siempre y cuando se operen sobre vistas que no estén ligadas a tablas (operaciones directas sobre tablas nativas o atributos de un join que sean de una tabla nativa).

Ver: https://dev.mysql.com/doc/refman/8.0/en/view-updatability.html

## GESTIÓN DE PERMISOS DE USUARIOS

Llamar al fichero `permisos.sql` para cargar dos nuevos usuarios que puedan operar sobre las vistas del fichero `p4.sql`.

## ÍNDICES

Los índices se usan para encontrar filas con un valor de columna esperado de forma rápida. Sin un indice, MySQL debe empezar por la primera fila y leer todas las entradas de la tabla para ver sus coincidencias, de la otra manera el gestor puede determinar la posición a buscar rápidamente sin tener que inspeccionar todas las tuplas.

