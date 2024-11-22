package webapp;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class JobApplicationAcceptance {

    private static final String DB_URL = "jdbc:mysql://localhost:3306/group3s15?useSSL=false&serverTimezone=UTC";
    private static final String DB_USER = "root"; // Change to your database username
    private static final String DB_PASSWORD = "123456789"; // Change to your database password

    // Method to accept a job application
    public boolean acceptJobApplication(int jobId, String applicantEmail) {
        Connection conn = null;
        PreparedStatement pstmtUpdateJob = null;
        PreparedStatement pstmtUpdateUser  = null;
        boolean success = false;

        try {
            // Establish database connection
            conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);
            conn.setAutoCommit(false); // Start transaction

            // Update job record to mark it as filled
            String updateJobQuery = "UPDATE jobs SET is_available = ? WHERE job_ID = ?";
            pstmtUpdateJob = conn.prepareStatement(updateJobQuery);
            pstmtUpdateJob.setBoolean(1, false); // Mark job as filled
            pstmtUpdateJob.setInt(2, jobId);
            int rowsUpdatedJob = pstmtUpdateJob.executeUpdate();

            // Update user account record to add the job to employment history
            String updateUserQuery = "INSERT INTO employment_history (email, job_ID) VALUES (?, ?)";
            pstmtUpdateUser  = conn.prepareStatement(updateUserQuery);
            pstmtUpdateUser .setString(1, applicantEmail);
            pstmtUpdateUser .setInt(2, jobId);
            int rowsInsertedUser  = pstmtUpdateUser .executeUpdate();

            // Check if both updates were successful
            if (rowsUpdatedJob > 0 && rowsInsertedUser  > 0) {
                conn.commit(); // Commit transaction
                success = true;
                System.out.println("Job application accepted successfully.");
            } else {
                conn.rollback(); // Rollback transaction if any update failed
                System.out.println("Failed to accept job application. Transaction rolled back.");
            }
        } catch (Exception e) {
            try {
                if (conn != null) conn.rollback(); // Rollback in case of exception
            } catch (Exception rollbackEx) {
                rollbackEx.printStackTrace();
            }
            e.printStackTrace();
        } finally {
            // Close resources
            try {
                if (pstmtUpdateJob != null) pstmtUpdateJob.close();
                if (pstmtUpdateUser  != null) pstmtUpdateUser .close();
                if (conn != null) conn.close();
            } catch (Exception closeEx) {
                closeEx.printStackTrace();
            }
        }
        return success;
    }

    // Main method to demonstrate functionality
    public static void main(String[] args) {
        JobApplicationAcceptance jobAppAcceptance = new JobApplicationAcceptance();
        int jobId = 1; // Example job ID
        String applicantEmail = "applicant@example.com"; // Example applicant email

        // Accept the job application
        jobAppAcceptance.acceptJobApplication(jobId, applicantEmail);
    }
}