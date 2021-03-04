 create table if not exists Profesores2 (id int not null auto_increment, 
DNI varchar (50), Nombre varchar(50), Apellidos varchar(50), 
Departamento varchar(50), primary key(id));
create table if not exists Alumnos (id int not null auto_increment, DNI 
varchar (50), Nombre varchar(50), Apellidos varchar(50), nota int 
unsigned, primary key(id));
show tables;
describe Profesores2;
insert into Profesores2 (DNI, Nombre, Apellidos, Departamento) values 
('12345678A', 'Jorge', 'Garcia Duque', 'Telematica');
insert into Profesores2 (DNI, Nombre, Apellidos, Departamento) values 
('12345678A', 'Jorge', 'Garcia Duque', 'Telematica');
select * from Profesores2;
