/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package linkedin;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class Job_Record_Management {

    public int job_ID;
    public int company_ID;
    public int branch_ID; // Nullable field
    public int position_ID; // Refers to Job_Position_Reference
    public String education; // Nullable field

    public int post_job() {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rst = null;

        try {
            
            Class.forName("com.mysql.cj.jdbc.Driver");
            String user = "root";
            String password = "123456789";
            String url = "jdbc:mysql://localhost:3306/group3s15?useSSL=false&serverTimezone=UTC";
            conn = DriverManager.getConnection(url, user, password);
            System.out.println("Connection Successful");

            //validate position_ID
            pstmt = conn.prepareStatement("SELECT COUNT(*) AS count FROM job_position_reference WHERE position_ID = ?");
            pstmt.setInt(1, position_ID);
            rst = pstmt.executeQuery();
            if (rst.next() && rst.getInt("count") == 0) {
                System.out.println("Error: Invalid position_ID.");
                return 0; // Exit early if position_ID is invalid
            }

            //create next job_ID
            pstmt = conn.prepareStatement("SELECT COALESCE(MAX(job_ID), 0) + 1 AS newID FROM job_record_management");
            rst = pstmt.executeQuery();
            if (rst.next()) {
                job_ID = rst.getInt("newID");
            }

            //insert job record
            pstmt = conn.prepareStatement("INSERT INTO job_record_management (job_ID, company_ID, branch_ID, position_ID, education) VALUES (?, ?, ?, ?, ?)");
            pstmt.setInt(1, job_ID);
            pstmt.setInt(2, company_ID);

            //handle nullable branch_ID
            if (branch_ID == -1) {
                pstmt.setNull(3, java.sql.Types.INTEGER);
            } else {
                pstmt.setInt(3, branch_ID);
            }

            pstmt.setInt(4, position_ID);

            //handle nullable education field
            if (education == null) {
                pstmt.setNull(5, java.sql.Types.VARCHAR);
            } else {
                pstmt.setString(5, education);
            }

            
            pstmt.executeUpdate();
            System.out.println("Job posted successfully with ID: " + job_ID);

        } catch (Exception e) {
            System.out.println("Error: " + e.getMessage());
            return 0; //failure
        } finally {
            try {
                if (rst != null) rst.close();
                if (pstmt != null) pstmt.close();
                if (conn != null) conn.close();
            } catch (Exception ex) {
                System.out.println("Error closing resources: " + ex.getMessage());
            }
        }
        return 1; //success
    }

    //example
    public static void main(String args[]) {
        Job_Record_Management job = new Job_Record_Management();
        job.company_ID = 1001; 
        job.branch_ID = 1999; /
        job.position_ID = 1;  
        job.education = "Bachelor's in Computer Science"; 
        int result = job.post_job();
        if (result == 1) {
            System.out.println("Job posted successfully.");
        } else {
            System.out.println("Failed to post the job.");
        }
    }
}
