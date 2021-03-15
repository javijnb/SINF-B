 CREATE TABLE Directores(
    -> id INT AUTO_INCREMENT,
    -> nombre VARCHAR(100),
    -> PRIMARY KEY(id)
    -> );
    
  CREATE TABLE Peliculas(
    -> id INT AUTO_INCREMENT,
    -> titulo VARCHAR(100),
    -> PRIMARY KEY(id),
    -> FOREIGN KEY (id) REFERENCES Directores(id)
    -> );
    
  INSERT INTO Directores(nombre) VALUES('Steven Spierlberg'),('Peter Jackson'),('Martin Scorsese'),('Ridley Scott'),('Quentin Tarantino');
  
  INSERT INTO Peliculas(titulo) values('ET'),('El Señor de los Anillos'),('Infiltrados'),('Gladiator'),('Pulp Fiction');
  
  -> SELECT Directores.nombre, Peliculas.titulo FROM Peliculas INNER JOIN Directores ON Peliculas.id=Directores.id ORDER BY Directores.nombre;
  
    +-------------------+--------------------------+
    | nombre            | titulo                   |
    +-------------------+--------------------------+
    | Martin Scorsese   | Infiltrados              |
    | Peter Jackson     | El Señor de los Anillos  |
    | Quentin Tarantino | Pulp Fiction             |
    | Ridley Scott      | Gladiator                |
    | Steven Spierlberg | ET                       |
    +-------------------+--------------------------+
