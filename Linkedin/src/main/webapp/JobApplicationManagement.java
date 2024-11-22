package link;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class JobApplicationManagement {

    public int application_ID;
    public int job_ID;
    public String applicant_name;
    public String applicant_email;
    public String application_date;

    // Method to check if a job is available
    public boolean isJobAvailable(int job_ID) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rst = null;
        boolean isAvailable = false;

        try {
            // Database connection setup
            conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/group3s15?useSSL=false&serverTimezone=UTC", "root", "123456789");
            String query = "SELECT is_available FROM jobs WHERE job_ID = ?";
            pstmt = conn.prepareStatement(query);
            pstmt.setInt(1, job_ID);
            rst = pstmt.executeQuery();

            if (rst.next()) {
                isAvailable = rst.getBoolean("is_available"); // Assuming there's a column for availability
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try {
                if (rst != null) rst.close();
                if (pstmt != null) pstmt.close();
                if (conn != null) conn.close();
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        return isAvailable;
    }

    // Method to retrieve applicant information
    public void displayApplicantInfo(String applicant_email) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rst = null;

        try {
            // Database connection setup
            conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/group3s15?useSSL=false&serverTimezone=UTC", "root", "123456789");
            String query = "SELECT * FROM users WHERE email = ?";
            pstmt = conn.prepareStatement(query);
            pstmt.setString(1, applicant_email);
            rst = pstmt.executeQuery();

            if (rst.next()) {
                // Assuming the users table has columns like name and other details
                String name = rst.getString("name");
                System.out.printf("Applicant Name: %s, Email: %s%n", name, applicant_email);
            } else {
                System.out.println("No applicant found with this email.");
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try {
                if (rst != null) rst.close();
                if (pstmt != null) pstmt.close();
                if (conn != null) conn.close();
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    }

    // Main method to demonstrate functionality
    public static void main(String[] args) {
        JobApplicationManagement jobAppManagement = new JobApplicationManagement();
        int job_ID = 1; // Example job ID to check
        String applicant_email = "applicant@example.com"; // Example applicant email

        // Check if the job is available
        if (jobAppManagement.isJobAvailable(job_ID)) {
            System.out.println("Job is available for application.");
            // Display applicant info
            jobAppManagement.displayApplicantInfo(applicant_email);
        } else {
            System.out.println("Job is not available.");
        }
    }
}