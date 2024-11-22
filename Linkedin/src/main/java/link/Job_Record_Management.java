/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */

package link;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class Job_Record_Management {

    public int job_ID;      
    public int company_ID;  
    public int branch_ID;    
    public String position_name;
    public String education; 
    public int position_ID;

    public int post_job() {
        try {
            // Database connection setup
            Connection conn;
            Class.forName("com.mysql.cj.jdbc.Driver");
            String user = "root";
            String password = "123456789";
            String url = "jdbc:mysql://localhost:3306/group3s15?useSSL=false&serverTimezone=UTC";
            conn = DriverManager.getConnection(url, user, password);
            System.out.println("Connection Successful");

            // Generate the next job_ID
            PreparedStatement pstmt = conn.prepareStatement("SELECT COALESCE(MAX(job_ID), 0) + 1 AS newID FROM job_record_management;");
            ResultSet rst = pstmt.executeQuery();
            while (rst.next()) {
                job_ID = rst.getInt("newID");
            }

            // Insert job record
            pstmt = conn.prepareStatement("INSERT INTO job_record_management (job_ID, company_ID, branch_ID, position_ID) VALUES (?, ?, ?, ?)");
            pstmt.setInt(1, job_ID);
            pstmt.setInt(2, company_ID);
            if (branch_ID == -1) {
                pstmt.setNull(3, java.sql.Types.INTEGER);
            } else {
                pstmt.setInt(3, branch_ID);
            }
            pstmt.setInt(4, position_ID);
            

            // Execute the query
            pstmt.executeUpdate();
            System.out.println("Job posted successfully with ID: " + job_ID);

            // Close resources
            pstmt.close();
            conn.close();
        } catch (Exception e) {
            System.out.println("Error: " + e.getMessage());
            return 0;
        }
        return 1;
    }

    public static void main(String args[]) {
        
        //try
        Job_Record_Management job = new Job_Record_Management();
        job.company_ID = 1001; 
        job.branch_ID = 1999; // Assuming branch ID exists
        job.position_name = "Vtuber";
        job.education = "Bachelor's in Computer Science";
        job.post_job();
    }
}
