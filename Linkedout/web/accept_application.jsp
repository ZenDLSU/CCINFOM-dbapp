<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Accept Application</title>
</head>
<body>
    <h1>Accepting Application</h1>

    <%
        String applicationId = request.getParameter("application_id");
        Integer companyId = (Integer) session.getAttribute("company_ID");

        if (applicationId != null && companyId != null) {
            String dbURL = "jdbc:mysql://localhost:3306/linkedout";
            String dbUser = "root";
            String dbPassword = "pass1234!";
            Connection conn = null;
            PreparedStatement pstmt = null;
            ResultSet rs = null;

            try {
                Class.forName("com.mysql.cj.jdbc.Driver");
                conn = DriverManager.getConnection(dbURL, dbUser, dbPassword);

                // Update the application status to 'Accepted'
                String updateApplicationStatus = "UPDATE user_job_applications SET application_status = 'Accepted' WHERE application_id = ?";
                pstmt = conn.prepareStatement(updateApplicationStatus);
                pstmt.setLong(1, Long.parseLong(applicationId));
                pstmt.executeUpdate();

                // Retrieve the account_ID of the user from the application
                String getUserAccountId = "SELECT account_ID FROM user_job_applications WHERE application_id = ?";
                pstmt = conn.prepareStatement(getUserAccountId);
                pstmt.setLong(1, Long.parseLong(applicationId));
                rs = pstmt.executeQuery();

                long userAccountId = 0;
                if (rs.next()) {
                    userAccountId = rs.getLong("account_ID");
                }

                // Insert the user into the company_employees table
                String insertIntoCompanyEmployees = "INSERT INTO company_employees (account_ID, company_ID) VALUES (?, ?)";
                pstmt = conn.prepareStatement(insertIntoCompanyEmployees);
                pstmt.setLong(1, userAccountId);
                pstmt.setInt(2, companyId); // Use the companyId from the session
                pstmt.executeUpdate();

                // Update the is_filled column to TRUE for the job that was accepted
                String updateJobStatus = "UPDATE active_jobs SET is_filled = TRUE WHERE job_id = (SELECT job_id FROM user_job_applications WHERE application_id = ?)";
                pstmt = conn.prepareStatement(updateJobStatus);
                pstmt.setLong(1, Long.parseLong(applicationId));
                pstmt.executeUpdate();

                out.println("<p>Application accepted.</p>");
                out.println("<a href='companyhomepage.html'>Back to Company Home Page</a>");
            } catch (ClassNotFoundException | SQLException e) {
                out.println("<p>Error: " + e.getMessage() + "</p>");
                e.printStackTrace();
            } finally {
                try {
                    if (rs != null) rs.close();
                    if (pstmt != null) pstmt.close();
                    if (conn != null) conn.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
        } else {
            out.println("<p>Application ID or Company ID is missing.</p>");
        }
    %>

</body>
</html>
