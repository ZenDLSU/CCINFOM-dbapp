 
//Author     : zen




package link;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/StatusAndExpiryReport")
public class StatusAndExpiryReport extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try (Connection conn = DatabaseConnection.initializeDatabase()) {
            
            //summary data
            Map<String, Integer> summaryData = fetchSummaryData(conn);

            //job listings
            List<Map<String, Object>> jobListings = fetchJobListings(conn);

            //add data
            request.setAttribute("summaryData", summaryData);
            request.setAttribute("jobListings", jobListings);

            
            RequestDispatcher dispatcher = request.getRequestDispatcher("status_and_expiry.jsp");
            dispatcher.forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error fetching report data.");
        }
    }

    private Map<String, Integer> fetchSummaryData(Connection conn) throws Exception {
        Map<String, Integer> summaryData = new HashMap<>();
        String[] queries = {
            "SELECT COUNT(*) AS total FROM user_accounts",
            "SELECT COUNT(*) AS total FROM job_postings",
            "SELECT COUNT(*) AS total FROM companies",
            "SELECT COUNT(*) AS total FROM branches"
        };
        String[] keys = {"Total Accounts", "Total Job Listings", "Total Companies", "Total Branches"};

        for (int i = 0; i < queries.length; i++) {
            try (PreparedStatement stmt = conn.prepareStatement(queries[i]);
                 ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    summaryData.put(keys[i], rs.getInt("total"));
                }
            }
        }
        return summaryData;
    }

    private List<Map<String, Object>> fetchJobListings(Connection conn) throws Exception {
        List<Map<String, Object>> jobListings = new ArrayList<>();
        String query = "SELECT posting_ID, position_ID, company_ID, branch_ID, posting_date, expiry_date, status FROM job_postings";

        try (PreparedStatement stmt = conn.prepareStatement(query);
             ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                Map<String, Object> job = new HashMap<>();
                job.put("posting_ID", rs.getInt("posting_ID"));
                job.put("position_ID", rs.getInt("position_ID"));
                job.put("company_ID", rs.getInt("company_ID"));
                job.put("branch_ID", rs.getInt("branch_ID"));
                job.put("posting_date", rs.getDate("posting_date"));
                job.put("expiry_date", rs.getDate("expiry_date"));
                job.put("status", rs.getString("status"));
                jobListings.add(job);
            }
        }
        return jobListings;
    }
}
