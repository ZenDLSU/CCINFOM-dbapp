package link;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/JobApplicationManagement")
public class JobApplicationManagement extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        List<Job> availableJobs = getAvailableJobs();
        request.setAttribute("availableJobs", availableJobs);
        RequestDispatcher dispatcher = request.getRequestDispatcher("JobApplicationManagement.html");
        dispatcher.forward(request, response);
    }

    private List<Job> getAvailableJobs() {
        List<Job> jobs = new ArrayList<>();
        try (Connection conn = DatabaseConnection.initializeDatabase();
             PreparedStatement ps = conn.prepareStatement("SELECT * FROM job_postings WHERE status = 'Available' ORDER BY years_of_experience")) {
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                jobs.add(new Job(rs.getInt("job_ID"), rs.getString("position_name"), rs.getInt("years_of_experience"), rs.getString("education")));
            }
        } catch (Exception e) {
            e.printStackTrace(); // Log any exceptions
        }
        return jobs;
    }
}

