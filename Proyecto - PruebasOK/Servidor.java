import java.io.BufferedReader;
import java.io.IOException;
import java.sql.*;
import java.io.InputStreamReader;
import java.io.BufferedReader;
import java.text.SimpleDateFormat;
import java.util.Date;

public class Servidor {

    private Connection connection = null;

    public static BufferedReader br = new BufferedReader(new InputStreamReader(System.in));

    public static void main(String[] args) throws IOException{

        Servidor servidor = new Servidor();
        int menu = 0;
        int opcion = 0;

        servidor.connectToDatabase(); 

        System.out.println("Bienvenido al servicio de administracion de la BASE DE DATOS\n");

        do{
        System.out.println("Seleccione el modo a realizar: \n");
        System.out.println("1) Crear un cliente\n");
        System.out.println("2) Eliminar un cliente\n");
        System.out.println("3) Anadir evento\n");
        System.out.println("4) Definir gradas para cada evento\n");
        System.out.println("5) Salir\n");

            opcion = Integer.parseInt(br.readLine());

            switch(opcion){
                case 1:
                    servidor.crearCliente();
                    break;
                case 2:
                    servidor.eliminarCliente();
                    break;
                case 3:
                    servidor.evento();
                    break;
                case 4:
                    servidor.grada();
                    break;
                case 5:
                    System.out.println("Saliendo del gestor de administracion de la BASE DE DATOS...\n");
                    System.exit(0);
            }


        }while(menu == 0);

    }

    public void evento() throws NumberFormatException, IOException{

        System.out.println("Seleccionado sector de eventos:\n");

        Statement stmtSELECT = null;

        try{
            stmtSELECT = connection.createStatement();
        }catch(SQLException e) {
            e.printStackTrace();
        }

        String queryEspectaculos = "SELECT ID_espectaculo,nombre FROM Espectaculo;";
        
        try{
            ResultSet rs = stmtSELECT.executeQuery(queryEspectaculos);

            while (rs.next()){
                System.out.println ("ID del espectaculo: "+rs.getString("ID_espectaculo")+",  Nombre del Espectaculo: "+rs.getString("nombre")+"\n");
            }

        }catch(SQLException e) {
            e.printStackTrace();
        }

        System.out.println("Selecciona uno de los espectaculos por su ID: ");

        int ID_espectaculo = Integer.parseInt(br.readLine());

        /////////////////////////////////////////////////////////////////////////////

        String queryRecintos = "SELECT ID_recinto,nombre FROM Recinto;";
        
        try{
            ResultSet rs = stmtSELECT.executeQuery(queryRecintos);

            while (rs.next()){
                System.out.println ("ID del recinto: "+rs.getString("ID_recinto")+",  Nombre del Recinto: "+rs.getString("nombre")+"\n");
            }

        }catch(SQLException e) {
            e.printStackTrace();
        }

        System.out.println("Selecciona uno de los recintos por su ID: ");

        int ID_recinto = Integer.parseInt(br.readLine());

        ////////////////////////////////////////////////////////////////////////////

        String confirmacion = "";
        boolean entradas_bebe = false;
        boolean entradas_infantil = false;
        boolean entradas_parado = false;
        boolean entradas_jubilado = false;

        System.out.println("\nDesea permitir la compra/venta de entradas para bebes (Si,No): ");

        confirmacion = (br.readLine()).trim();

            if(confirmacion.equals("Si")){
                entradas_bebe = true;
            }else{
                entradas_bebe = false;
            }
        
        System.out.println("\nDesea permitir la compra/venta de entradas infantiles (Si,No): ");

        confirmacion = (br.readLine()).trim();

            if(confirmacion.equals("Si")){
                entradas_infantil = true;
            }else{
                entradas_infantil = false;
            }

        System.out.println("\nDesea permitir la compra/venta de entradas para parados (Si,No): ");

        confirmacion = (br.readLine()).trim();

            if(confirmacion.equals("Si")){
                entradas_parado = true;
            }else{
                entradas_parado = false;
            }
        
        System.out.println("\nDesea permitir la compra/venta de entradas para jubilados (Si,No): ");

        confirmacion = (br.readLine()).trim();

            if(confirmacion.equals("Si")){
                entradas_jubilado = true;
            }else{
                entradas_jubilado = false;
            }
        
        String pattern = "yyyy-MM-dd hh:mm:ss";
        boolean continuar = true;
        String fecha_inicio = "";
        
        do{
            System.out.println("\nIntroduce la fecha de inicio: ");

                fecha_inicio = br.readLine();

            SimpleDateFormat simpleDateFormat = new SimpleDateFormat(pattern);
            try{
                Date date= simpleDateFormat.parse(fecha_inicio);
                if(date.before(new Date())){
                    System.out.println("No puede introducir un evento en una fecha pasada\n");
                    continuar=false; 
                }
            }catch(Exception e){
                e.printStackTrace();
            }	

        }while(continuar == false);

        String fecha_fin = "";
        continuar = true;

        do{
            System.out.println("\nIntroduce la fecha de finalizacion: ");

                fecha_fin = br.readLine();

            SimpleDateFormat simpleDateFormat = new SimpleDateFormat(pattern);
            try{
                Date date= simpleDateFormat.parse(fecha_fin);
                if(date.before(new Date())){
                    System.out.println("No puede introducir un evento en una fecha pasada\n");
                    continuar=false; 
                }
            }catch(Exception e){
                e.printStackTrace();
            }	

        }while(continuar == false);

        System.out.println(ID_espectaculo+" "+ID_recinto);

        try{

            CallableStatement cstmt = connection.prepareCall("{CALL CrearEventos(?,?,?,?,?,?,?,?)}");

            cstmt.setInt(1,ID_espectaculo);
            cstmt.setInt(2,ID_recinto);   
            cstmt.setString(3,fecha_inicio);  
            cstmt.setString(4,fecha_fin);  
            cstmt.setBoolean(5,entradas_bebe);
            cstmt.setBoolean(6,entradas_infantil);
            cstmt.setBoolean(7,entradas_parado);
            cstmt.setBoolean(8,entradas_jubilado);

            cstmt.executeQuery();



        }catch(SQLException e){
            e.printStackTrace();
            System.out.println("Parametro introducido incorrecto\n");
        }

        return;
    }

    public void crearCliente() throws IOException{

        System.out.println("Seleccionado sector de creacion de cliente:\n");

        System.out.println("Introduce DNI del cliente: ");

            String DNI = br.readLine();

        System.out.println("\nIntroduce nombre del cliente: ");

            String nombre = br.readLine();

        System.out.println("\nIntroduce IBAN del cliente: ");

            String IBAN = br.readLine();

        String query = "INSERT INTO Cliente (DNI,nombre,IBAN) VALUES ('"+DNI+"','"+nombre+"','"+IBAN+"');";

        try {
            PreparedStatement stmt = connection.prepareStatement(query);
            stmt.executeUpdate();

            System.out.println("Cliente creado exitosamente\n");
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return;
    }

    public void eliminarCliente() throws IOException{

        System.out.println("Seleccionado sector de eliminacion de cliente:\n");

        System.out.println("Introduce DNI del cliente: ");

            String DNI = br.readLine();

        String queryElimina = "DELETE FROM Cliente WHERE DNI='"+DNI+"';";

        try {
            
            Statement stmtSELECT = connection.createStatement();
            ResultSet rs = stmtSELECT.executeQuery("SELECT * FROM Cliente WHERE DNI='"+DNI+"';");
        
            while (!rs.next()){
                System.out.println("No existe un cliente con ese DNI\n");
                return;
            }

            PreparedStatement stmt = connection.prepareStatement(queryElimina);
            stmt.executeUpdate();

            System.out.println("Cliente eliminado exitosamente\n");

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return;
    }

    public void grada() throws IOException{

        System.out.println("Seleccionado sector de gradas:\n");

        Statement stmtSELECT = null;

        try{
            stmtSELECT = connection.createStatement();
        }catch(SQLException e) {
            e.printStackTrace();
        }

        String queryDatos = "SELECT CelebradoEn.ID_CelebradoEn, Espectaculo.nombre AS nombre_espectaculo, Recinto.nombre AS nombre_recinto, CelebradoEn.fecha_inicio FROM CelebradoEn LEFT JOIN Espectaculo ON CelebradoEn.ID_espectaculo = Espectaculo.ID_espectaculo  LEFT JOIN Recinto ON CelebradoEn.ID_recinto = Recinto.ID_recinto WHERE CelebradoEn.estado='Abierto' ORDER BY Espectaculo.ID_Espectaculo;";
        
        try{
            ResultSet rs = stmtSELECT.executeQuery(queryDatos);

            while (rs.next()){
                System.out.println ("ID de evento: "+rs.getString("ID_CelebradoEn")+", Nombre del Espectaculo: "+rs.getString("nombre_espectaculo")+", Nombre de recinto: "+rs.getString("nombre_recinto")+"\n");
            }

        }catch(SQLException e) {
            e.printStackTrace();
        }

        System.out.println("Selecciona evento por ID de evento: ");

        int ID_CelebradoEn = Integer.parseInt(br.readLine());

        ///////////////////////////////////////////////////////////////////

        String queryGradas = "SELECT Grada.ID_grada, Grada.nombre, Recinto.ID_recinto FROM Grada INNER JOIN Recinto ON Grada.ID_recinto=Recinto.ID_recinto INNER JOIN CelebradoEn ON Recinto.ID_recinto=CelebradoEn.ID_recinto WHERE CelebradoEn.ID_CelebradoEn='"+ID_CelebradoEn+"';";

        try{
            ResultSet rs = stmtSELECT.executeQuery(queryGradas);

            while (rs.next()){
                System.out.println ("ID de grada: "+rs.getString("ID_grada")+", Nombre de la grada: "+rs.getString("nombre")+", ID del recinto: "+rs.getString("ID_recinto")+"\n");
            }

        }catch(SQLException e) {
            e.printStackTrace();
        }

        System.out.println("Selecciona grada por ID de grada: ");

        int ID_grada = Integer.parseInt(br.readLine());

        ////////////////////////////////////////////////////////////////////

        System.out.println("Selecciona el precio para bebe: ");

        float precio_bebe = Float.parseFloat(br.readLine());

        System.out.println("\nSelecciona el precio para infantil: ");

        float precio_infantil = Float.parseFloat(br.readLine());

        System.out.println("\nSelecciona el precio para parado: ");

        float precio_parado = Float.parseFloat(br.readLine());

        System.out.println("\nSelecciona el precio para jubilado: ");

        float precio_jubilado = Float.parseFloat(br.readLine());

        System.out.println("\nSelecciona el precio para adulto: ");

        float precio_adulto = Float.parseFloat(br.readLine());


        try{

            CallableStatement cstmt = connection.prepareCall("{CALL InsertarPrecios(?,?,?,?,?,?,?)}");

            cstmt.setInt(1,ID_CelebradoEn);
            cstmt.setInt(2,ID_grada);   
            cstmt.setFloat(3,precio_bebe);  
            cstmt.setFloat(4,precio_infantil);  
            cstmt.setFloat(5,precio_parado);
            cstmt.setFloat(6,precio_jubilado);
            cstmt.setFloat(7,precio_adulto);

            cstmt.executeQuery();

            System.out.println("Cambios relaizados correctamente\n");

        }catch(SQLException e){
            e.printStackTrace();
            System.out.println("Parametro introducido incorrecto\n");
        }

        return;
    }

    public void connectToDatabase(){

        try{
            try {
                Class.forName("com.mysql.jdbc.Driver");
            } catch (ClassNotFoundException ex) {
                System.out.println("Error al registrar el driver de MySQL: " + ex);
            }
        
            connection = DriverManager.getConnection("jdbc:mysql://localhost:3306","diego", "1effc6373");

            boolean valid = connection.isValid(50000);
            if(valid == true){
                System.out.println("Conexion establecida correctamente\n");
            }else{
                System.out.println("Conexion no establecida\n");
            }

            PreparedStatement stmtcreate = connection.prepareStatement("USE practicas;");
            stmtcreate.executeUpdate();


        } catch (SQLException e) {
            e.printStackTrace();
        }

        return;
    }

    
} 
