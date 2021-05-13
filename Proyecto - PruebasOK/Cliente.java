import java.io.BufferedReader;
import java.io.IOException;
import java.sql.*;
import java.io.InputStreamReader;
import java.io.BufferedReader;

public class Cliente {

    private Connection connection = null;

    public static void main(String[] args) throws IOException{

        Cliente cliente = new Cliente();
        conexion.connectToDatabase(); 
        conexion.consulta();
    }

    public void connectToDatabase(){

        try{
            try {
                Class.forName("com.mysql.jdbc.Driver");
            } catch (ClassNotFoundException ex) {
                System.out.println("Error al registrar el driver de MySQL: " + ex);
            }

            //Connection connection = null;
            // Database connect
            // Conectamos con la base de datos
        
            connection = DriverManager.getConnection("jdbc:mysql://localhost:3306","diego", "1effc6373");

            boolean valid = connection.isValid(50000);
            if(valid == true){
                System.out.println("Conexion establecida correctamente\n");
            }else{
                System.out.println("Conexion no establecida\n");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return;
    }

    public void consulta() throws IOException{

        try{

            PreparedStatement stmtcreate = connection.prepareStatement("DROP DATABASE misPeliculas;");
            stmtcreate.executeUpdate();

            stmtcreate = connection.prepareStatement("CREATE DATABASE misPeliculas;");
            stmtcreate.executeUpdate();

            stmtcreate = connection.prepareStatement("USE misPeliculas;");
            stmtcreate.executeUpdate();

            stmtcreate = connection.prepareStatement("CREATE TABLE Actores (ID_actor INT AUTO_INCREMENT NOT NULL,nombre VARCHAR (30) NOT NULL,PRIMARY KEY (ID_actor),IMDb INT UNIQUE,edad INT NOT NULL,CONSTRAINT check_edad CHECK (edad > -1 AND edad < 121));");            
            stmtcreate.executeUpdate();

            stmtcreate = connection.prepareStatement("INSERT INTO Actores(nombre,IMDb,edad) VALUES('Leonardo DiCaprio','0000138','130'),('Jason Statham','0005458','54'),('Paul Walker','0908094','32'),('Vin Diesel','0004874','46'),('Emma Watson','0914612','-1');");
            stmtcreate.executeUpdate();

            BufferedReader buffer = new BufferedReader(new InputStreamReader(System.in));

                String nombre,IMDb,edad;

                System.out.println("Introduce los parametros a anadir:\n");
                System.out.println("Nombre: ");
                    nombre= buffer.readLine();
                System.out.println("\nIMDb: ");
                    IMDb = buffer.readLine();
                System.out.println("\nEdad: ");
                    edad = buffer.readLine();
                System.out.println("\n");

            PreparedStatement stmtINSERT = connection.prepareStatement("INSERT INTO Actores (nombre,IMDb,edad) VALUES('"+nombre.trim()+"','"+IMDb.trim()+"','"+edad.trim()+"');");
            stmtINSERT.executeUpdate();

            Statement stmtSELECT = connection.createStatement();
            ResultSet rs = stmtSELECT.executeQuery("SELECT * FROM Actores;");
            System.out.println("");
            while (rs.next()){
                System.out.println (rs.getString("nombre")+"        "+rs.getString("IMDb")+"        "+rs.getString("edad"));
            }

            //PreparedStatement stmtselect = connection.prepareStatement("INSERT INTO misPeliculas(nombre) VALUES('300');");
            /*ResultSet rs = stmt.executeQuery();
          
            while (rs.next()){
              System.out.println (rs.getString("country"));
            }*/
          
          } catch (SQLException sqle) { 
            System.out.println("Error en la ejecución:" 
              + sqle.getErrorCode() + " " + sqle.getMessage());    
          }

        return;
    }
} 
