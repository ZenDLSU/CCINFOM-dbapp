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

    //check if a job is available
    public boolean isJobAvailable(int job_ID) {
    Connection conn = null;
    PreparedStatement pstmt = null;
    ResultSet rst = null;
    boolean isAvailable = false;

    try {
        conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/group3s15?useSSL=false&serverTimezone=UTC", "root", "123456789");
        String query = "SELECT status FROM job_postings WHERE job_ID = ? AND status = 'Active'";
        pstmt = conn.prepareStatement(query);
        pstmt.setInt(1, job_ID);
        rst = pstmt.executeQuery();

        isAvailable = rst.next(); //job is vacant if any record matches
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

    //retrieveapplicant information
    public void displayApplicantInfo(String applicant_email) {
    Connection conn = null;
    PreparedStatement pstmt = null;
    ResultSet rst = null;

    try {
        conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/group3s15?useSSL=false&serverTimezone=UTC", "root", "123456789");
        String query = "SELECT first_name, last_name FROM user_accounts WHERE email = ?";
        pstmt = conn.prepareStatement(query);
        pstmt.setString(1, applicant_email);
        rst = pstmt.executeQuery();

        if (rst.next()) {
            String firstName = rst.getString("first_name");
            String lastName = rst.getString("last_name");
            System.out.printf("Applicant Name: %s %s, Email: %s%n", firstName, lastName, applicant_email);
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

}