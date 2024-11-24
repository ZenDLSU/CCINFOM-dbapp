/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package usermanagement;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.*;

/**
 *
 * @author richa
 */
public class company_accounts {
    
    public int company_ID;
    public String company_name;
    public String contact_number;
    public String email;
    public String main_address;
    public String password;
    
    public ArrayList<Integer> company_IDList = new ArrayList<>();
    public ArrayList<String> company_nameList = new ArrayList<>();
    public ArrayList<String> contact_numberList = new ArrayList<>();
    public ArrayList<String> emailList = new ArrayList<>();
    public ArrayList<String> main_addressList = new ArrayList<>();
    
    public int companySignup() {
        try {
            Connection conn;
            conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/linkedout", "root", "pass1234!");
            System.out.println("Connection Successful");
            
            PreparedStatement pstmt = conn.prepareStatement("SELECT MAX(company_ID) + 1 AS newID FROM company_accounts");
            ResultSet rst = pstmt.executeQuery();
            
            while(rst.next()) {
                company_ID = rst.getInt("newID");
            }
            
            pstmt = conn.prepareStatement("INSERT INTO company_accounts (company_ID, company_name, contact_number, email, main_address, password) VALUE(?, ?, ?, ?, ?, ?)");
            pstmt.setInt(1, company_ID);
            pstmt.setString(2, company_name);
            pstmt.setString(3, contact_number);
            pstmt.setString(4, email);
            pstmt.setString(5, main_address);
            pstmt.setString(6, password);
            
            pstmt.executeUpdate();
            
            pstmt.close();
            conn.close();
            System.out.println("Successful");
            return 1;
            
        } catch (Exception e) {
            System.out.println(e.getMessage());
            return 0;
        }
    }
    
    public static void main (String args[]) {
        company_accounts A = new company_accounts();
        A.company_name = "Tech Innovations Inc.";  // Dummy company name
        A.contact_number = "8001234567";           // Dummy contact number
        A.email = "contact@techinnovations.com";   // Dummy email
        A.main_address = "456 Innovation Way, Silicon Valley, CA";  // Dummy address
        A.password = "Password";  // Dummy address
        
        A.companySignup();
    }
}
