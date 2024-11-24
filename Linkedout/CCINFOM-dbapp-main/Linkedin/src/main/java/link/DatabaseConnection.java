package link;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DatabaseConnection {
    

    public static Connection initializeDatabase() throws SQLException {

        String url = "jdbc:mysql://localhost:3306/your_database_name";
        String username = "your_username";
        String password = "your_password";
        
        try {
    
            Class.forName("com.mysql.cj.jdbc.Driver");  // Ensure you have the MySQL JDBC driver
            return DriverManager.getConnection(url, username, password);
        } catch (ClassNotFoundException e) {

            throw new SQLException("MySQL JDBC driver not found.", e);
        }
    }
}
