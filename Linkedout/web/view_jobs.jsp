<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>View and Delete Job Postings</title>
</head>
<body>
    <h1>View and Delete Job Postings</h1>
    <form action="delete_job.jsp" method="POST">
        <label for="job_id">Select Job to Delete:</label>
        <select name="job_id" id="job_id" required>
            <%
                Integer companyId = (Integer) session.getAttribute("company_ID");
                if (companyId == null) {
                    out.println("<p>You are not logged in. Please log in as a company to delete a job.</p>");
                    out.println("<a href='login.jsp'>Login</a>");
                } else {
                    String dbURL = "jdbc:mysql://localhost:3306/linkedout";
                    String dbUser = "root";
                    String dbPassword = "pass1234!";
                    Connection conn = null;
                    PreparedStatement pstmt = null;
                    ResultSet rs = null;

                    try {
                        Class.forName("com.mysql.cj.jdbc.Driver");
                        conn = DriverManager.getConnection(dbURL, dbUser, dbPassword);

                        // SQL query updated to fetch the job_title from REF_job_titles table
                        String sql = "SELECT aj.job_opening_id, jt.job_title " +
                                     "FROM active_jobs aj " +
                                     "JOIN REF_job_titles jt ON aj.job_id = jt.job_id " +
                                     "WHERE aj.company_id = ?";
                        pstmt = conn.prepareStatement(sql);
                        pstmt.setInt(1, companyId);
                        rs = pstmt.executeQuery();

                        while (rs.next()) {
                            int jobOpeningId = rs.getInt("job_opening_id");
                            String jobTitle = rs.getString("job_title");
                            // Displaying the job title in the option
                            out.println("<option value='" + jobOpeningId + "'>" + jobTitle + "</option>");
                        }
                    } catch (Exception e) {
                        out.println("<p>Error: " + e.getMessage() + "</p>");
                    } finally {
                        if (rs != null) try { rs.close(); } catch (Exception ignore) {}
                        if (pstmt != null) try { pstmt.close(); } catch (Exception ignore) {}
                        if (conn != null) try { conn.close(); } catch (Exception ignore) {}
                    }
                }
            %>
        </select><br><br>
        <button type="submit">Delete Job</button>
    </form>
</body>
</html>
