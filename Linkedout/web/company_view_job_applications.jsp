<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>View Job Applications</title>
</head>
<body>
    <h1>Job Applications for Your Posted Jobs</h1>

    <%
        // Check if the company is logged in
        Integer companyId = (Integer) session.getAttribute("company_ID");

        if (companyId == null) {
            out.println("<p>You are not logged in. Please log in as a company to view applications.</p>");
            out.println("<a href='login.jsp'>Login</a>");
        } else {
            // Query to get job applications for this company
            String dbURL = "jdbc:mysql://localhost:3306/linkedout";
            String dbUser = "root";
            String dbPassword = "pass1234!";
            Connection conn = null;
            PreparedStatement pstmt = null;
            ResultSet rs = null;

            try {
                // Connect to the database
                Class.forName("com.mysql.cj.jdbc.Driver");
                conn = DriverManager.getConnection(dbURL, dbUser, dbPassword);

                // Query to fetch applications for jobs posted by the company
                String sql = "SELECT ja.application_id, ja.account_ID, ja.job_id, ja.application_date, ja.application_status, " +
                             "u.first_name, u.last_name, j.job_title, ja.company_ID " +
                             "FROM user_job_applications ja " +
                             "JOIN user_accounts u ON ja.account_ID = u.account_ID " +
                             "JOIN REF_job_titles j ON ja.job_id = j.job_id " +
                             "WHERE ja.company_ID = ? AND ja.application_status = 'Pending'";

                pstmt = conn.prepareStatement(sql);
                pstmt.setInt(1, companyId);
                rs = pstmt.executeQuery();

                // Display applications in a table
                out.println("<table border='1'>");
                out.println("<tr><th>Applicant Name</th><th>Job Title</th><th>Application Date</th><th>Action</th></tr>");

                while (rs.next()) {
                    String applicantName = rs.getString("first_name") + " " + rs.getString("last_name");
                    String jobTitle = rs.getString("job_title");
                    String applicationDate = rs.getDate("application_date").toString();
                    Long applicationId = rs.getLong("application_id");

                    out.println("<tr>");
                    out.println("<td>" + applicantName + "</td>");
                    out.println("<td>" + jobTitle + "</td>");
                    out.println("<td>" + applicationDate + "</td>");
                    out.println("<td>" +
                                "<form action='accept_application.jsp' method='POST' style='display:inline;'>" +
                                "<input type='hidden' name='application_id' value='" + applicationId + "'>" +
                                "<input type='submit' value='Accept Application'>" +
                                "</form>" +
                                "<form action='reject_application.jsp' method='POST' style='display:inline;'>" +
                                "<input type='hidden' name='application_id' value='" + applicationId + "'>" +
                                "<input type='submit' value='Reject Application'>" +
                                "</form>" +
                                "</td>");
                    out.println("</tr>");
                }
                out.println("</table>");
            } catch (Exception e) {
                out.println("<p>Error: " + e.getMessage() + "</p>");
            } finally {
                if (rs != null) try { rs.close(); } catch (Exception ignore) {}
                if (pstmt != null) try { pstmt.close(); } catch (Exception ignore) {}
                if (conn != null) try { conn.close(); } catch (Exception ignore) {}
            }
        }
    %>

</body>
</html>
