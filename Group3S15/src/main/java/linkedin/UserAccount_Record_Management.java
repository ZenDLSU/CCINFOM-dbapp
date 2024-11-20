/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package linkedin;
import java.time.LocalDate;
import java.sql.*;
import java.util.*;
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
    public LocalDate birthday;
    public String education;
    public int years_of_experience;
    public String employment_history;
    public String primary_language;
    public String secondary_language;
    public int job_ID; 
    public int company_ID;
    
    public int register_account(){
        try{
            Connection conn;
            String user = "root";
            String password = "123456789";
            String url = "jdbc:mysql://localhost:3306/group3s15";
            conn = DriverManager.getConnection(url, user, password);
            System.out.println("Connection Successful");
            PreparedStatement pstmt = conn.prepareStatement("SELECT COALESCE(MAX(account_ID), 0) + 1 AS newID FROM useraccount_record_management;");
            ResultSet rst = pstmt.executeQuery();
            while(rst.next()){
                account_ID = rst.getInt("newID");
            }
            pstmt = conn.prepareStatement("INSERT INTO useraccount_record_management (account_ID, first_name, last_name, contact_no, email, home_address, birthday, education, years_of_experience, primary_language, secondary_language, job_ID, company_ID) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)");
            pstmt.setInt(1,account_ID);
            pstmt.setString(2,first_name);
            pstmt.setString(3,last_name);
            pstmt.setNull(4, java.sql.Types.VARCHAR);
            pstmt.setString(5,email);
            pstmt.setNull(6, java.sql.Types.LONGVARCHAR);
            pstmt.setNull(7, java.sql.Types.DATE);
            pstmt.setNull(8, java.sql.Types.LONGVARCHAR);
            pstmt.setNull(9, java.sql.Types.LONGVARCHAR);
            pstmt.setString(10,primary_language);
            pstmt.setNull(11, java.sql.Types.LONGVARCHAR);
            pstmt.setNull(12, java.sql.Types.DECIMAL);
            pstmt.setNull(13, java.sql.Types.DECIMAL);
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
    
    public static void main(String args[]){
        UserAccount_Record_Management a = new UserAccount_Record_Management();
        a.first_name = "julian";
        a.last_name = "briones";
        a.email ="julian_briones@dlsu.edu.ph";
        a.primary_language = "English";
        a.register_account();
        
    }
}
