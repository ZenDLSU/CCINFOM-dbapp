package link;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.RequestDispatcher;


@WebServlet("/JobDetailsServlet")


public class JobDetailsServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int jobId = Integer.parseInt(request.getParameter("job_ID"));
        Job jobDetails = getJobDetails(jobId);
        if (jobDetails != null) {
            request.setAttribute("jobDetails", jobDetails);
            RequestDispatcher dispatcher = request.getRequestDispatcher("JobDetails.html");
            dispatcher.forward(request, response);
        } else {
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "Job not found");
        }
    }

    private Job getJobDetails(int jobId) {
        Job jobDetails = null;
        try (Connection conn = DatabaseConnection.initializeDatabase(); 
             PreparedStatement ps = conn.prepareStatement("SELECT job_ID, position_name, years_of_experience, education, company_name, branch_details FROM job_postings WHERE job_ID = ?")) {
            ps.setInt(1, jobId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                jobDetails = new Job(rs.getInt("job_ID"), rs.getString("position_name"), rs.getInt("years_of_experience"), rs.getString("education"), rs.getString("company_name"), rs.getString("branch_details"));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return jobDetails;
    }
}
