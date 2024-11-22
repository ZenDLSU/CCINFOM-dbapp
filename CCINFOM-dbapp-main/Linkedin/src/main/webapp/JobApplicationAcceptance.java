package webapp;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class JobApplicationAcceptance {

    private static final String DB_URL = "jdbc:mysql://localhost:3306/group3s15?useSSL=false&serverTimezone=UTC";
    private static final String DB_USER = "root"; 
    private static final String DB_PASSWORD = "123456789"; 

    // Method to accept a job application
    public boolean acceptJobApplication(int jobId, String applicantEmail) {
        Connection conn = null;
        PreparedStatement pstmtUpdateJob = null;
        PreparedStatement pstmtUpdateUser  = null;
        boolean success = false;

        try {

            conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);
            conn.setAutoCommit(false); 

            //update job record to mark it as filled
            String updateJobQuery = "UPDATE jobs SET is_available = ? WHERE job_ID = ?";
            pstmtUpdateJob = conn.prepareStatement(updateJobQuery);
            pstmtUpdateJob.setBoolean(1, false); // Mark job as filled
            pstmtUpdateJob.setInt(2, jobId);
            int rowsUpdatedJob = pstmtUpdateJob.executeUpdate();

            //update user account record to add the job to employment history
            String updateUserQuery = "INSERT INTO employment_history (email, job_ID) VALUES (?, ?)";
            pstmtUpdateUser  = conn.prepareStatement(updateUserQuery);
            pstmtUpdateUser .setString(1, applicantEmail);
            pstmtUpdateUser .setInt(2, jobId);
            int rowsInsertedUser  = pstmtUpdateUser .executeUpdate();

            //check if both updates are successful
            if (rowsUpdatedJob > 0 && rowsInsertedUser  > 0) {
                conn.commit(); // Commit transaction
                success = true;
                System.out.println("Job application accepted successfully.");
            } else {
                conn.rollback(); //rollback transaction if any update failed
                System.out.println("Failed to accept job application. Transaction rolled back.");
            }
        } catch (Exception e) {
            try {
                if (conn != null) conn.rollback(); //rollback in case of exception
            } catch (Exception rollbackEx) {
                rollbackEx.printStackTrace();
            }
            e.printStackTrace();
        } finally {
           
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


    public static void main(String[] args) {
        JobApplicationAcceptance jobAppAcceptance = new JobApplicationAcceptance();
        int jobId = 1; 
        String applicantEmail = "applicant@example.com"; 


        jobAppAcceptance.acceptJobApplication(jobId, applicantEmail);
    }
}