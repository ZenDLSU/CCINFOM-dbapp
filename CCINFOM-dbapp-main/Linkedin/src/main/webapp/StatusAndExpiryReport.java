package link;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class StatusAndExpiryReport extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("text/html");

        String timeDimension = request.getParameter("time_dimension");
        String query = generateQuery(timeDimension);

        try (Connection conn = DatabaseConnection.initializeDatabase();
             PreparedStatement stmt = conn.prepareStatement(query)) {

            ResultSet rs = stmt.executeQuery();
            Map<String, StringBuilder> reportData = new HashMap<>();
            reportData.put("Active", new StringBuilder());
            reportData.put("Expired", new StringBuilder());
            reportData.put("Closed", new StringBuilder());

            while (rs.next()) {
                String status = rs.getString("status");
                String details = String.format(
                    "Job ID: %d | Posting Date: %s | Expiry/Closed Date: %s<br>",
                    rs.getInt("job_ID"),
                    rs.getString("posting_date"),
                    rs.getString("expiry_or_closed_date")
                );
                reportData.get(status).append(details);
            }

            StringBuilder responseContent = new StringBuilder("<h1>Job Posting Status Report</h1>");
            responseContent.append("<h2>Time Dimension: ").append(timeDimension).append("</h2>");

            for (Map.Entry<String, StringBuilder> entry : reportData.entrySet()) {
                responseContent.append("<h3>").append(entry.getKey()).append(" Posts</h3>");
                if (entry.getValue().length() > 0) {
                    responseContent.append(entry.getValue());
                } else {
                    responseContent.append("No data available.<br>");
                }
            }

            response.getWriter().write(responseContent.toString());

        } catch (Exception e) {
            response.getWriter().write("<h2>Error generating report:</h2><pre>" + e.getMessage() + "</pre>");
        }
    }

    private String generateQuery(String timeDimension) {
        String dateColumn;
        switch (timeDimension.toLowerCase()) {
            case "year":
                dateColumn = "YEAR(posting_date)";
                break;
            case "month":
                dateColumn = "YEAR(posting_date), MONTH(posting_date)";
                break;
            case "day":
                dateColumn = "DATE(posting_date)";
                break;
            case "month_year":
                dateColumn = "YEAR(posting_date), MONTH(posting_date)";
                break;
            default:
                dateColumn = "DATE(posting_date)";
        }

        return "SELECT job_ID, posting_date, " +
               "CASE " +
               "WHEN status = 'Active' THEN NULL ELSE expiry_date END AS expiry_or_closed_date, " +
               "status " +
               "FROM job_postings " +
               "ORDER BY status DESC, " +
               "CASE WHEN status = 'Active' THEN posting_date ELSE expiry_date END";
    }
}
