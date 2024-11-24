<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Job Details</title>
</head>
<body>
    <h1>Job Details</h1>
    <%
        String dbURL = "jdbc:mysql://localhost:3306/linkedout";
        String dbUser = "root";
        String dbPassword = "pass1234!";
        
        // Retrieve the job opening ID from the query parameter
        String jobOpeningId = request.getParameter("job_opening_id");
        
        // Check if the job opening ID is present
        if (jobOpeningId == null || jobOpeningId.trim().isEmpty()) {
            out.println("<p>Error: No job selected.</p>");
            out.println("<button onclick=\"window.history.back()\">Go Back</button>");
            return;
        }

        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DriverManager.getConnection(dbURL, dbUser, dbPassword);

            // Query to fetch job details along with the company address
            String sql = "SELECT jt.job_title, jt.job_description, cb.address AS company_address, aj.salary, aj.posting_date, aj.closing_date " +
                         "FROM REF_job_titles jt " +
                         "JOIN active_jobs aj ON jt.job_id = aj.job_id " +
                         "JOIN company_branches cb ON aj.company_id = cb.company_ID " +
                         "WHERE aj.job_opening_id = ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, Integer.parseInt(jobOpeningId));
            rs = pstmt.executeQuery();

            if (rs.next()) {
                String jobTitle = rs.getString("job_title");
                String jobDescription = rs.getString("job_description");
                String companyAddress = rs.getString("company_address");
                double salary = rs.getDouble("salary");
                Date postingDate = rs.getDate("posting_date");
                Date closingDate = rs.getDate("closing_date");

                out.println("<h2>" + jobTitle + "</h2>");
                out.println("<p><strong>Description:</strong> " + jobDescription + "</p>");
                out.println("<p><strong>Location:</strong> " + companyAddress + "</p>");
                out.println("<p><strong>Salary:</strong> PHP " + String.format("%.2f", salary) + "</p>");
                out.println("<p><strong>Posting Date:</strong> " + postingDate + "</p>");
                out.println("<p><strong>Closing Date:</strong> " + closingDate + "</p>");
            } else {
                out.println("<p>No job details found for the selected job.</p>");
            }
        } catch (Exception e) {
            out.println("<p>Error: " + e.getMessage() + "</p>");
        } finally {
            if (rs != null) try { rs.close(); } catch (Exception ignore) {}
            if (pstmt != null) try { pstmt.close(); } catch (Exception ignore) {}
            if (conn != null) try { conn.close(); } catch (Exception ignore) {}
        }
    %>
    <br>
    <button onclick="window.history.back()">Go Back</button>
</body>
</html>
