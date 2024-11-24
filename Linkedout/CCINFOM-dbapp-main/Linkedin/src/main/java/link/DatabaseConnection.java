package link;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DatabaseConnection {
    
    // Static method to initialize and return a database connection
    public static Connection initializeDatabase() throws SQLException {
        // Database connection credentials
        String url = "jdbc:mysql://localhost:3306/your_database_name";
        String username = "your_username";
        String password = "your_password";
        
        try {
            // Load the JDBC driver (MySQL in this case)
            Class.forName("com.mysql.cj.jdbc.Driver");  // Ensure you have the MySQL JDBC driver
            return DriverManager.getConnection(url, username, password);
        } catch (ClassNotFoundException e) {
            // Handle the error if the MySQL JDBC driver is not found
            throw new SQLException("MySQL JDBC driver not found.", e);
        }
    }
}
