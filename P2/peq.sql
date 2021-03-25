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
LEFT JOIN departamento ON docente.nombre_dpto=departamento.nombre_dpto
-- Con el LEFT JOIN nos aseguramos que si un docente no está en un departamento, que aparezca igualmente (esto se debe buscar en función de si lo contempla el modelo)

-- 5. Encontrar los nombres de las materias del dpto de Telemática que tengan 3 créditos


-- 6. Encontrar todos los ID y nombre de materias que está cursando un alumno con un ID concreto (ID 1234 p.e)


-- 7. Listar el nombre de todos los docentes y alumnos alfabéticamente


-- 8. Apartado anterior pero mostrando además los créditos cursados por los alumnos apoyándose en la agregación materias cursadas por el alumno


-- 9. Apartado anterior pero mostrando su ID y sin mostrar alumnos que no cursen ninguna materia


-- 10. Buscar los nombres de todos los alumnos que hayan cursado alguna asignatura impartida por el dpto de Telemática (sin duplicados)


-- 11. Mostrar todos los IDs de los profesores que nunca impartieron (ni impartirán) una asignatura


-- 12. Apartado anterior pero mostrando sus nombres y no sus IDs


-- 13. Encontrar los grupos con mayor y menor número de alumnos (sin contar los vacíos)


-- 14. Para cada materia, encontrar todos los grupos que estén al máximo de alumnos, mostrando dicho número y con una consulta anidada


-- 15. Apartado anterior pero mostrando los resultados ordenados de mayor a menos número de alumnos


-- 16. Mostrar los 10 grupos con más alumnos matriculados junto al nombre de la asignatura

