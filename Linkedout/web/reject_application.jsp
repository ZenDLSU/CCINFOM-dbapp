<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Reject Application</title>
</head>
<body>
    <h1>Rejecting Application</h1>

    <%
        String applicationId = request.getParameter("application_id");

        if (applicationId != null) {
            String dbURL = "jdbc:mysql://localhost:3306/linkedout";
            String dbUser = "root";
            String dbPassword = "pass1234!";
            Connection conn = null;
            PreparedStatement pstmt = null;

            try {
                // Connect to the database
                Class.forName("com.mysql.cj.jdbc.Driver");
                conn = DriverManager.getConnection(dbURL, dbUser, dbPassword);

                // Update the application status to 'Rejected'
                String updateApplicationStatus = "UPDATE user_job_applications SET application_status = 'Rejected' WHERE application_id = ?";
                pstmt = conn.prepareStatement(updateApplicationStatus);
                pstmt.setLong(1, Long.parseLong(applicationId));
                pstmt.executeUpdate();

                out.println("<p>Application rejected.</p>");
                out.println("<a href='companyhomepage.html'>Back to Company Home Page</a>");
            } catch (Exception e) {
                out.println("<p>Error: " + e.getMessage() + "</p>");
            } finally {
                if (pstmt != null) try { pstmt.close(); } catch (Exception ignore) {}
                if (conn != null) try { conn.close(); } catch (Exception ignore) {}
            }
        } else {
            out.println("<p>Application ID is missing.</p>");
        }
    %>

</body>
</html>