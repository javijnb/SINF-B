import java.sql.*;
import java.util.Scanner;

class ej1 {
    public static void main(String args[]) {

        String DB;   //practicas
        String user; //usuarioROOT
        String password; //SINFmolamogollon1!

        Connection con = null;
        Statement stmt = null;
        CallableStatement cstmt = null;

        try {

            Class.forName("com.mysql.jdbc.Driver");
            System.out.println("Bienvenido al programa de acceso a las bases de datos MYSQL de las prácticas de SINF\n");

            DB = leerTerminal(0);
            user = leerTerminal(1);
            password = leerTerminal(2);

            System.out.println("\nUsuario '"+user+"' conectándose a: <<jdbc:mysql://localhost:3306/"+DB+">>");

            
            con = DriverManager.getConnection("jdbc:mysql://localhost:3306/", user, password);
            stmt = con.createStatement();
            
            System.out.println("Conectado con éxito a la BBDD");

            String sqlorder = "CREATE DATABASE IF NOT EXISTS misPeliculas";
            int result = stmt.executeUpdate(sqlorder);
            System.out.println("Query OK, "+result+" row affected");

            sqlorder = "use misPeliculas";
            result = stmt.executeUpdate(sqlorder);
            System.out.println("Query OK, "+result+" row affected");

            String pepinardo = "source ./ejercicios.sql";
            boolean result2 = stmt.execute(pepinardo);
            System.out.println("EXITO JODER "+result2);

            String query = "SELECT * FROM Actores";
		    ResultSet rs = stmt.executeQuery(query);
            System.out.println("TABLA DE ACTORES");
            while(rs.next()){
                System.out.println(""+rs.getInt("id_actor")+"\t"+rs.getString("nombre")+"\t\t\t"+rs.getInt("edad"));				
            }
            rs.close();
            /*
            String sqlorder = "use practicas";
            int result = stmt.executeUpdate(sqlorder);
            System.out.println("Query OK, "+result+" row affected");

            sqlorder= "SHOW TABLES";
            result = stmt.executeUpdate(sqlorder);
            System.out.println("Tablas: "+result);

            String query = "SELECT * FROM Actores";
		    ResultSet rs = stmt.executeQuery(query);
            System.out.println("TABLA DE ACTORES");
            while(rs.next()){
                System.out.println(""+rs.getInt("id_actor")+"\t"+rs.getString("nombre")+"\t\t\t"+rs.getInt("edad"));				
            }
            rs.close();
            */

        } catch (SQLException e1){
            System.out.println("**************************");
            System.out.println("SQL Exception capturada");
            System.out.println(e1);
            System.out.println("**************************");

        } catch (Exception e3) {
            System.out.println(e3);
        }
    }

    public static String leerTerminal(int operacion){
		
		switch (operacion){
		
            //Introducir una Base de Datos
			case 0: {
				System.out.print("\nPor favor, introduzca la base de datos a la que se quiere conectar: \n\t->");
				Scanner entradaTerminal = new Scanner(System.in);
				return entradaTerminal.nextLine();
			}
			
            //Introducir usuario
			case 1: {
				System.out.print("\nPor favor, introduzca el nombre de usuario: \n\t-> ");
				Scanner entradaTerminal = new Scanner(System.in);
				return entradaTerminal.nextLine();
			}
			
            //Introducir contraseña
			case 2: {
				System.out.print("\nPor favor, introduzca la contraseña: \n\t-> ");
				Scanner entradaTerminal = new Scanner(System.in);
				return entradaTerminal.nextLine();
			}
			
			default: {
				return null;
			}
		}
	}
}