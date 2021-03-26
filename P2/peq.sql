\. DLL.sql
\. UnivInsertPeq.sql


-- 1. Listar todos los docentes
SELECT * FROM docente;


-- 2. Encontrar el nombre de todos los docentes del departamento de Telemática
SELECT docente.nombre FROM docente WHERE docente.nombre_dpto="Ingeniería Telemática";


-- 3. Listar el nombre de todos los docentes del departamento de Ingeniería Telemática con salarios superior a 70000 euros
SELECT docente.nombre FROM docente WHERE docente.nombre_dpto="Ingeniería Telemática" AND docente.salario>70000;


-- 4. Listar para todos los docentes: ID, nombre, salario, departamento, edificio del departamento, y presupuesto del dpto
SELECT docente.ID, docente.nombre, docente.salario, docente.nombre_dpto, departamento.edificio, departamento.presupuesto FROM docente 
LEFT JOIN departamento ON docente.nombre_dpto=departamento.nombre_dpto;


-- 5. Encontrar los nombres de las materias del dpto de Telemática que tengan 3 créditos
SELECT materia.nombre, materia.creditos, materia.nombre_dpto FROM materia WHERE materia.nombre_dpto="Ingeniería Telemática" AND materia.creditos=3;


-- 6. Encontrar todos los ID y nombre de materias que está cursando un alumno con un ID concreto (ID 1234 p.e)
SELECT alumno_3ciclo.nombre, alumno_3ciclo.ID, materia.id_materia, materia.nombre FROM alumno_3ciclo
JOIN cursa   ON cursa.ID = alumno_3ciclo.ID
JOIN materia ON materia.id_materia = cursa.id_materia
WHERE alumno_3ciclo.ID="12345";


-- 7. Listar el nombre de todos los docentes y alumnos alfabéticamente
SELECT nombre FROM docente UNION ALL SELECT nombre FROM alumno_3ciclo ORDER BY nombre ASC;


-- 8. Apartado anterior pero mostrando además los créditos cursados por los alumnos apoyándose en la agregación materias cursadas por el alumno
SELECT alumno_3ciclo.nombre, SUM(materia.creditos) FROM alumno_3ciclo 
LEFT JOIN cursa ON cursa.ID = alumno_3ciclo.ID
INNER JOIN materia ON materia.id_materia = cursa.id_materia
GROUP BY cursa.ID
ORDER BY alumno_3ciclo.nombre ASC;
-- Eva Yáñez (que no cursa ninguna materia) no aparece porque listamos los alumnos de la relación CURSA y no los alumnos en general y luego por sus materias cursadas


-- 9. Apartado anterior pero mostrando su ID y sin mostrar alumnos que no cursen ninguna materia
SELECT alumno_3ciclo.tot_creditos, alumno_3ciclo.ID, SUM(materia.creditos) FROM alumno_3ciclo 
LEFT JOIN cursa ON cursa.ID = alumno_3ciclo.ID
INNER JOIN materia ON materia.id_materia = cursa.id_materia
GROUP BY cursa.ID
ORDER BY alumno_3ciclo.nombre ASC;


-- 10. Buscar los nombres de todos los alumnos que hayan cursado alguna asignatura impartida por el dpto de Telemática (sin duplicados)
SELECT DISTINCT(alumno_3ciclo.nombre) FROM alumno_3ciclo
INNER JOIN cursa ON cursa.ID = alumno_3ciclo.ID
INNER JOIN materia ON materia.id_materia = cursa.id_materia
WHERE materia.nombre_dpto="Ingeniería Telemática"
ORDER BY alumno_3ciclo.nombre;


-- 11. Mostrar todos los IDs de los profesores que nunca impartieron (ni impartirán) una asignatura
SELECT docente.ID, docente.nombre FROM docente
WHERE docente.ID NOT IN (SELECT imparte.ID FROM imparte)
ORDER BY docente.ID;


-- 12. Apartado anterior pero mostrando sus nombres y no sus IDs
SELECT docente.nombre FROM docente
WHERE docente.ID NOT IN (SELECT imparte.ID FROM imparte)
ORDER BY docente.ID;


-- 13. Encontrar los grupos con mayor y menor número de alumnos (sin contar los vacíos)
-- GRUPOS CON MENOR NUMERO DE ALUMNOS
-- SELECT "Grupo con menos alumnos";
SELECT cursa.id_materia, cursa.id_grupo, COUNT(*) AS contador FROM cursa
GROUP BY cursa.id_materia, cursa.id_grupo
ORDER BY contador ASC
LIMIT 1;

-- GRUPOS CON MAYOR NUMERO DE ALUMNOS
-- SELECT "Grupo con más alumnos";
SELECT cursa.id_materia, cursa.id_grupo, COUNT(*) AS contador FROM cursa
GROUP BY cursa.id_materia, cursa.id_grupo
ORDER BY contador DESC
LIMIT 1;


-- 14. Para cada materia, encontrar todos los grupos que estén al máximo de alumnos, mostrando dicho número y con una consulta anidada


-- 15. Apartado anterior pero mostrando los resultados ordenados de mayor a menos número de alumnos


-- 16. Mostrar los 10 grupos con más alumnos matriculados junto al nombre de la asignatura
SELECT grupo.id_materia, grupo.id_grupo, COUNT(cursa.ID) AS NumeroDeAlumnos FROM cursa, grupo
WHERE cursa.id_materia = grupo.id_materia
AND cursa.id_grupo = grupo.id_grupo
AND cursa.cuatrimestre = grupo.cuatrimestre
AND cursa.anho = grupo.anho
GROUP BY cursa.id_materia, cursa.id_grupo, cursa.cuatrimestre, cursa.anho
ORDER BY NumeroDeAlumnos DESC
LIMIT 10;
