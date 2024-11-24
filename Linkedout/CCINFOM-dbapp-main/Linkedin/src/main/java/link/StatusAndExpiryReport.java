package link;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/StatusAndExpiryReport")
public class StatusAndExpiryReport extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("text/html");

        String timeDimension = request.getParameter("time_dimension");
        String query = generateQuery(timeDimension);

        try (Connection conn = DatabaseConnection.initializeDatabase();  // Use the DatabaseConnection class
             PreparedStatement stmt = conn.prepareStatement(query)) {

            ResultSet rs = stmt.executeQuery();
            Map<String, StringBuilder> reportData = new HashMap<>();
            reportData.put("Active", new StringBuilder());
            reportData.put("Expired", new StringBuilder());
            reportData.put("Closed", new StringBuilder());

            while (rs.next()) {
                String status = rs.getString("status");
                String details = String.format(
                    "Job ID: %d | Position: %s | Company: %s | Posting Date: %s | Expiry/Closed Date: %s<br>",
                    rs.getInt("job_ID"),
                    rs.getString("position_name"),
                    rs.getString("company_name"),
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
        String dateGrouping;
        switch (timeDimension.toLowerCase()) {
            case "year":
                dateGrouping = "YEAR(posting_date)";
                break;
            case "month":
                dateGrouping = "YEAR(posting_date), MONTH(posting_date)";
                break;
            case "day":
                dateGrouping = "DATE(posting_date)";
                break;
            case "month_year":
                dateGrouping = "YEAR(posting_date), MONTH(posting_date)";
                break;
            default:
                dateGrouping = "DATE(posting_date)";
        }

        return String.format(
            "SELECT jp.job_ID, jp.posting_date, " +
            "CASE " +
            "    WHEN jp.status IN ('Expired', 'Closed') THEN jp.expiry_date " +
            "    ELSE NULL " +
            "END AS expiry_or_closed_date, " +
            "jp.status, " +
            "rjp.position_name, " +
            "c.company_name " +
            "FROM job_postings jp " +
            "JOIN REF_job_position rjp ON jp.position_id = rjp.position_id " +
            "JOIN companies c ON jp.company_id = c.company_id " +
            "ORDER BY FIELD(jp.status, 'Active', 'Expired', 'Closed'), " +
            "CASE WHEN jp.status = 'Active' THEN jp.posting_date ELSE jp.expiry_date END"
        );
    }
}
