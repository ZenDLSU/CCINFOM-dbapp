package usermanagement;

import java.util.*;
import java.sql.*;

public class user_accounts {
    public int user_id;
    public String first_name;
    public String last_name;
    public int age;
    public String contact_num;
    public String email;
    public String home_address;
    public String birthday;
    public String primary_language;
    public String password;
    public int years_of_experience;
    public String highest_education;

    public user_accounts() {}

    public int signup() {
        try {
            Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/linkedout", "root", "pass1234!");
            PreparedStatement pstmt = conn.prepareStatement("SELECT MAX(account_ID) + 1 AS newID FROM user_accounts");
            ResultSet rst = pstmt.executeQuery();
            
            if (rst.next()) {
                user_id = rst.getInt("newID");
            }
            
            pstmt = conn.prepareStatement("INSERT INTO user_accounts (account_ID, first_name, last_name, age, contact_num, email, home_address, birthday, primary_language, password, years_of_experience, highest_education) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)");
            pstmt.setInt(1, user_id);
            pstmt.setString(2, first_name);
            pstmt.setString(3, last_name);
            pstmt.setInt(4, age);
            pstmt.setString(5, contact_num);
            pstmt.setString(6, email);
            pstmt.setString(7, home_address);
            pstmt.setString(8, birthday);
            pstmt.setString(9, primary_language);
            pstmt.setString(10, password);
            pstmt.setInt(11, years_of_experience);
            pstmt.setString(12, highest_education);
            pstmt.executeUpdate();
            
            pstmt.close();
            conn.close();
            return 1;
        } catch (Exception e) {
            System.out.println(e.getMessage());
            return 0;
        }
    }

    public static void main(String args[]) {
        user_accounts A = new user_accounts();
        A.first_name = "John";
        A.last_name = "Doe";
        A.age = 25;
        A.contact_num = "1234567890";
        A.email = "john.doe@example.com";
        A.home_address = "123 Elm Street";
        A.birthday = "1998-06-15";
        A.primary_language = "English";
        A.password = "securePassword123";
        A.years_of_experience = 3;
        A.highest_education = "Bachelor";
        A.signup();
    }
}
