<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Job Postings Report</title>
    <style>
        table {
            width: 100%;
            border-collapse: collapse;
        }
        table, th, td {
            border: 1px solid black;
        }
        th, td {
            padding: 8px;
            text-align: left;
        }
        th {
            background-color: #f2f2f2;
        }
    </style>
</head>
<body>

<h2>Job Postings and Applicants Report</h2>

<table>
    <thead>
        <tr>
            <th>Job Opening ID</th>
            <th>Job ID</th>
            <th>Company ID</th>
            <th>Location</th>
            <th>Salary</th>
            <th>Number of Applicants</th>
        </tr>
    </thead>
    <tbody>
        <%
            // Database connection parameters
            String dbURL = "jdbc:mysql://localhost:3306/linkedout"; // Update your database name here
            String dbUser = "root"; // Your DB username
            String dbPassword = "pass1234!"; // Your DB password

            Connection conn = null;
            PreparedStatement pstmt = null;
            ResultSet rs = null;

            try {
                // Establish connection
                conn = DriverManager.getConnection(dbURL, dbUser, dbPassword);

                // Updated SQL query
                String sql = "SELECT aj.job_opening_id, aj.job_id, aj.company_id, aj.location, aj.salary, " +
                             "COUNT(uja.application_id) AS num_applicants " +
                             "FROM active_jobs aj " +
                             "LEFT JOIN user_job_applications uja ON aj.job_id = uja.job_id " +
                             "GROUP BY aj.job_opening_id, aj.job_id, aj.company_id, aj.location, aj.salary";

                // Prepare and execute query
                pstmt = conn.prepareStatement(sql);
                rs = pstmt.executeQuery();

                // Loop through the result set and display job postings and number of applicants
                while (rs.next()) {
                    int jobOpeningId = rs.getInt("job_opening_id");
                    int jobId = rs.getInt("job_id");
                    int companyId = rs.getInt("company_id");
                    String location = rs.getString("location");
                    double salary = rs.getDouble("salary");
                    int numApplicants = rs.getInt("num_applicants");
        %>
                <tr>
                    <td><%= jobOpeningId %></td>
                    <td><%= jobId %></td>
                    <td><%= companyId %></td>
                    <td><%= location %></td>
                    <td><%= String.format("$%.2f", salary) %></td>
                    <td><%= numApplicants %></td>
                </tr>
        <%
                }
            } catch (SQLException e) {
                out.println("<tr><td colspan='6' style='color: red;'>Error: " + e.getMessage() + "</td></tr>");
                e.printStackTrace();
            } finally {
                try {
                    if (rs != null) rs.close();
                    if (pstmt != null) pstmt.close();
                    if (conn != null) conn.close();
                } catch (SQLException e) {
                    out.println("<tr><td colspan='6' style='color: red;'>Error closing resources: " + e.getMessage() + "</td></tr>");
                }
            }
        %>
    </tbody>
</table>
 <a href="reports.html"> index </a>
</body>
</html>
