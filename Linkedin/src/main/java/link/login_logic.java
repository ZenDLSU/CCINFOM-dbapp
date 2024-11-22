/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package link;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

/**
 *
 * @author julia
 */
public class login_logic {
    public String companyName;
    public String companyPassword;
    public String userName;
    public String userPassword;
    public int login(){
        try {
            String sql;
            PreparedStatement statement;
            Connection conn;
            Class.forName("com.mysql.cj.jdbc.Driver");
            String user = "root";
            String password = "123456789";
            String url = "jdbc:mysql://localhost:3306/group3s15?useSSL=false&serverTimezone=UTC";
            conn = DriverManager.getConnection(url, user, password);
            System.out.println("Connection Successful");
            sql = "SELECT * FROM Company_Record_Management WHERE company_name = ? AND company_password = ?";
                statement = conn.prepareStatement(sql);
                statement.setString(1, companyName);
                statement.setString(2, companyPassword);
            ResultSet resultSet = statement.executeQuery();
            if (resultSet.next()){
                resultSet.close();
                statement.close();
                conn.close();
                return 1;
            }
            System.out.println("Welcome, " + companyName + "!");
            sql = "SELECT * FROM UserAccount_Record_Management WHERE email = ? AND user_password = ?";
                statement = conn.prepareStatement(sql);
                statement.setString(1, userName);
                statement.setString(2, userPassword);
            resultSet = statement.executeQuery();
            if (resultSet.next()){
                resultSet.close();
                statement.close();
                conn.close();
                return 1;
            }
            System.out.println("Welcome, " + userName + "!");
                System.out.println("Invalid company name or password. Please try again.");
            resultSet.close();
            statement.close();
            conn.close();
        } catch (Exception e) {
            System.out.println(e.getMessage());
            return 0;
        }
        return 0;
    }
}
