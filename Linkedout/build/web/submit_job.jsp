<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Job Posted</title>
</head>
<body>
    <h1>Job Posting Confirmation</h1>
    <%
        Integer companyId = (Integer) session.getAttribute("company_ID");

        if (companyId == null) {
            out.println("<p>You are not logged in. Please log in as a company to post a job.</p>");
            out.println("<a href='login.jsp'>Login</a>");
        } else {
            String jobId = request.getParameter("job_id");
            String location = request.getParameter("location");
            String salary = request.getParameter("salary");
            String closingDate = request.getParameter("closing_date");

            if (jobId != null && location != null && salary != null && closingDate != null) {
                String dbURL = "jdbc:mysql://localhost:3306/linkedout";
                String dbUser = "root";
                String dbPassword = "pass1234!";
                Connection conn = null;
                PreparedStatement pstmt = null;

                try {
                    // Connect to database
                    Class.forName("com.mysql.cj.jdbc.Driver");
                    conn = DriverManager.getConnection(dbURL, dbUser, dbPassword);

                    // Insert job posting into active_jobs table
                    String sql = "INSERT INTO active_jobs (job_id, company_id, location, salary, posting_date, closing_date) " +
                                 "VALUES (?, ?, ?, ?, CURDATE(), ?)";
                    pstmt = conn.prepareStatement(sql);
                    pstmt.setInt(1, Integer.parseInt(jobId));
                    pstmt.setInt(2, companyId);
                    pstmt.setString(3, location);
                    pstmt.setDouble(4, Double.parseDouble(salary));
                    pstmt.setString(5, closingDate);

                    int rowsAffected = pstmt.executeUpdate();

                    if (rowsAffected > 0) {
                        out.println("<p>Job successfully posted!</p>");
                    } else {
                        out.println("<p>Failed to post job. Please try again.</p>");
                    }
                } catch (Exception e) {
                    out.println("<p>Error: " + e.getMessage() + "</p>");
                } finally {
                    if (pstmt != null) try { pstmt.close(); } catch (Exception ignore) {}
                    if (conn != null) try { conn.close(); } catch (Exception ignore) {}
                }
            } else {
                out.println("<p>Missing required information. Please fill in all fields.</p>");
            }
        }
    %>
    
    <br>
    <a href="companyhomepage.html">
        <button type="button">Return to Homepage</button>
    </a>
</body>
</html>
