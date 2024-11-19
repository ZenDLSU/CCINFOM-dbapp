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
    public String contact_info;
    public String email;
    public String home_address;
    public LocalDate birthday;
    public String skills;
    public String education;
    public String employment_history;
    public String primary_language;
    public String secondary_language;
    public int job_ID; 
    public int company_ID;
    
    public int register_account(){
        try{
            Connection conn;
            String url = "jdbc:mysql://localhost:3306/group3s15";
            conn = DriverManager.getConnection(url);
            System.out.println("Connection Successful");
            PreparedStatement pstmt = conn.prepareStatement("SELECT MAX(account_ID) + 1 AS newID FROM useraccount_record_management;");
            ResultSet rst = pstmt.executeQuery();
            while(rst.next()){
                account_ID = rst.getInt("newID");
            }
            pstmt = conn.prepareStatement("INSERT INTO useraccount_record_management VALUE (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)");
            pstmt.setInt(1,account_ID);
            // and etc depending on how many fields there are
            pstmt.executeUpdate();
        } catch (Exception e) {
            System.out.println(e.getMessage());
            return 0;
        }
        return 1;
    }
}
