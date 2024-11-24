<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Delete Job Posting</title>
</head>
<body>
    <h1>Delete Job Posting</h1>
    <%
        String jobId = request.getParameter("job_id");
        if (jobId != null) {
            String dbURL = "jdbc:mysql://localhost:3306/linkedout";
            String dbUser = "root";
            String dbPassword = "pass1234!";
            Connection conn = null;
            PreparedStatement pstmt = null;

            try {
                Class.forName("com.mysql.cj.jdbc.Driver");
                conn = DriverManager.getConnection(dbURL, dbUser, dbPassword);

                String deleteJob = "DELETE FROM active_jobs WHERE job_opening_id = ?";
                pstmt = conn.prepareStatement(deleteJob);
                pstmt.setInt(1, Integer.parseInt(jobId));
                int rowsAffected = pstmt.executeUpdate();

                if (rowsAffected > 0) {
                    out.println("<p>Job posting deleted successfully.</p>");
                } else {
                    out.println("<p>Error: Job posting not found.</p>");
                }
            } catch (Exception e) {
                out.println("<p>Error: " + e.getMessage() + "</p>");
            } finally {
                if (pstmt != null) try { pstmt.close(); } catch (Exception ignore) {}
                if (conn != null) try { conn.close(); } catch (Exception ignore) {}
            }
        } else {
            out.println("<p>Error: No job selected for deletion.</p>");
        }
    %>
    <a href="companyhomepage.html">Back to Company Home Page</a>
</body>
</html>
