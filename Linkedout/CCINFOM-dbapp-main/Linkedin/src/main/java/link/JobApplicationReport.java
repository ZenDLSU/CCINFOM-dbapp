package link;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/JobApplicationReport")
public class JobApplicationReport extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("text/html");

        List<JobApplications> jobApplications = new ArrayList<>(); // Use JobApplication if that's the correct class name

        // SQL query to fetch job postings
        String query = "SELECT jp.job_ID, rjp.position_name, jp.status, jp.posting_date, " +
                       "jp.expiry_date " +
                       "FROM job_postings jp " +
                       "JOIN REF_job_position rjp ON jp.position_id = rjp.position_id " +
                       "ORDER BY jp.posting_date DESC";

        try (Connection conn = DatabaseConnection.initializeDatabase();
             PreparedStatement stmt = conn.prepareStatement(query);
             ResultSet rs = stmt.executeQuery()) {

            // Fetch results and populate jobApplications list
            while (rs.next()) {
                jobApplications.add(new JobApplication( // Change to JobApplication if that's the correct name
                    rs.getInt("job_ID"),
                    rs.getString("position_name"),
                    rs.getString("status"),
                    rs.getDate("posting_date"),
                    rs.getDate("expiry_date")
                ));
            }

            // Set the job applications data in the request scope
            request.setAttribute("jobApplications", jobApplications);
            request.getRequestDispatcher("JobApplicationReport.jsp").forward(request, response);

        } catch (Exception e) {
            // Handle exceptions and display error message
            response.getWriter().write("<h2>Error generating report:</h2><pre>" + e.getMessage() + "</pre>");
        }
    }
}