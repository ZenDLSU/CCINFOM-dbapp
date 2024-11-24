<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Your Job Applications</title>
    <style>
        table {
            width: 100%;
            border-collapse: collapse;
        }
        th, td {
            padding: 10px;
            border: 1px solid #ddd;
            text-align: left;
        }
        th {
            background-color: #f4f4f4;
        }
        a {
            text-decoration: none;
            color: white;
        }

    </style>
</head>
<body>
    <h1>Your Job Applications</h1>
    <%
        String dbURL = "jdbc:mysql://localhost:3306/linkedout";
        String dbUser = "root";
        String dbPassword = "pass1234!";
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        Integer userId = (Integer) session.getAttribute("user_id");

        if (userId != null) {
            try {
                Class.forName("com.mysql.cj.jdbc.Driver");
                conn = DriverManager.getConnection(dbURL, dbUser, dbPassword);

                String sql = "SELECT ja.application_id, jt.job_title, ca.company_name, ja.application_date, ja.application_status " +
                             "FROM user_job_applications ja " +
                             "JOIN REF_job_titles jt ON ja.job_id = jt.job_id " +
                             "JOIN company_accounts ca ON ja.company_ID = ca.company_ID " +
                             "WHERE ja.account_ID = ?";
                pstmt = conn.prepareStatement(sql);
                pstmt.setInt(1, userId);

                rs = pstmt.executeQuery();

                if (rs.isBeforeFirst()) {
    %>
                    <table>
                        <thead>
                            <tr>
                                <th>Application ID</th>
                                <th>Job Title</th>
                                <th>Company Name</th>
                                <th>Application Date</th>
                                <th>Status</th>
                            </tr>
                        </thead>
                        <tbody>
                            <%
                                while (rs.next()) {
                                    int applicationId = rs.getInt("application_id");
                                    String jobTitle = rs.getString("job_title");
                                    String companyName = rs.getString("company_name");
                                    Date applicationDate = rs.getDate("application_date");
                                    String applicationStatus = rs.getString("application_status");
                            %>
                            <tr>
                                <td><%= applicationId %></td>
                                <td><%= jobTitle %></td>
                                <td><%= companyName %></td>
                                <td><%= applicationDate %></td>
                                <td><%= applicationStatus %></td>
                            </tr>
                            <%
                                }
                            %>
                        </tbody>
                    </table>
    <%
                } else {
                    out.println("<p>No job applications found.</p>");
                }
            } catch (Exception e) {
                out.println("<p>Error: " + e.getMessage() + "</p>");
            } finally {
                if (rs != null) rs.close();
                if (pstmt != null) pstmt.close();
                if (conn != null) conn.close();
            }
        } else {
            out.println("<h3>You are not logged in. Please <a href='login.jsp'>log in</a>.</h3>");
        }
    %>
    <a href="userhomepage.html"><button>Back to Dashboard</button></a>
</body>
</html>
