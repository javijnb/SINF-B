--EJERCICIO 11: Crear usuarios con suficientes permisos en las vistas creadas
CREATE USER 'usuario1'@'localhost' IDENTIFIED by 'usuario';
CREATE USER 'usuario2'@'localhost' IDENTIFIED BY 'usuario';

GRANT SELECT ON practicas.VEjercicio6 TO 'usuario1'@'localhost';
GRANT SELECT ON practicas.VEjercicio7 TO 'usuario1'@'localhost';
GRANT SELECT ON practicas.VEjercicio8 TO 'usuario1'@'localhost';

GRANT SELECT ON practicas.VEjercicio6 TO 'usuario2'@'localhost';
GRANT SELECT ON practicas.VEjercicio7 TO 'usuario2'@'localhost';
GRANT SELECT ON practicas.VEjercicio8 TO 'usuario2'@'localhost';

FLUSH PRIVILEGES;