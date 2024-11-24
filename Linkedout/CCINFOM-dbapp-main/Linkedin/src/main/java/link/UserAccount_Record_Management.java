/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package link;
import java.time.LocalDate;
import java.sql.*;
import java.sql.Date;
import java.util.*;
import java.time.format.DateTimeFormatter;


/**
 *
 * @author julia
 */
public class UserAccount_Record_Management {
    public int account_ID;
    public String first_name;
    public String last_name;
    public String contact_no;
    public String email;
    public String home_address;
    public String birthday;
    public String education;
    public int years_of_experience;
    public String employment_history;
    public String primary_language;
    public String secondary_language;
    public int job_ID; 
    public int company_ID;
    public String userpassword;
    
    public int register_account(){
        try{
            Connection conn;
            Class.forName("com.mysql.cj.jdbc.Driver");
            String user = "root";
            String password = "123456789";
            String url = "jdbc:mysql://localhost:3306/group3s15?useSSL=false&serverTimezone=UTC";
            conn = DriverManager.getConnection(url, user, password);
            System.out.println("Connection Successful");
            PreparedStatement pstmt = conn.prepareStatement("SELECT COALESCE(MAX(account_ID), 0) + 1 AS newID FROM user_accounts;");
            ResultSet rst = pstmt.executeQuery();
            while(rst.next()){
                account_ID = rst.getInt("newID");
            }
            pstmt = conn.prepareStatement("INSERT INTO user_accounts (account_ID, first_name, last_name, contact_no, email, home_address, birthday, education, years_of_experience, primary_language, job_ID, company_ID, user_password) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)");
            pstmt.setInt(1, account_ID);
            pstmt.setString(2, first_name);
            pstmt.setString(3, last_name);
            pstmt.setString(13,userpassword);
            if (contact_no == null) {
                pstmt.setNull(4, java.sql.Types.VARCHAR);
            } else {
                pstmt.setString(4, contact_no);
            }
            pstmt.setString(5, email);
            if (home_address == null) {
                pstmt.setNull(6, java.sql.Types.VARCHAR);
            } else {
                pstmt.setString(6, home_address);
            }
            Date sqlDate = Date.valueOf(birthday);
            System.out.print(birthday);
            if (birthday == null){
                pstmt.setNull(7, java.sql.Types.DATE);
            } else {
                pstmt.setDate(7, sqlDate);
            }
            if (education == null) {
                pstmt.setNull(8, java.sql.Types.VARCHAR);
            } else {
                pstmt.setString(8, education);
            }
            if (years_of_experience == -1) {
                pstmt.setNull(9, java.sql.Types.INTEGER);
            } else {
                pstmt.setInt(9, years_of_experience);
            }
            pstmt.setString(10, primary_language);
            if (job_ID == -1) {
                pstmt.setNull(11, java.sql.Types.INTEGER); 
            } else {
                pstmt.setInt(11, job_ID); 
            }
            if (company_ID == -1) {
                pstmt.setNull(12, java.sql.Types.INTEGER);
            } else {
                pstmt.setInt(12, company_ID);
            }
            // and etc depending on how many fields there are
            pstmt.executeUpdate();
            pstmt.close();
            conn.close();
        } catch (Exception e) {
            System.out.println(e.getMessage());
            return 0;
        }
        return 1;
    }

    public static void main(String args[]) {
     
    }
}
