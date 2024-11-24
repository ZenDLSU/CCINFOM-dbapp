<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Active Job Openings</title>
</head>
<body>
    <h1>Select an Active Job</h1>
    <form action="applyjob.jsp" method="post">
        <label for="job">Choose a job:</label>
        <select id="job" name="job_opening_id" required>
            <option value="" disabled selected>Select a job</option>
            <%
                String dbURL = "jdbc:mysql://localhost:3306/linkedout";
                String dbUser = "root";
                String dbPassword = "pass1234!";
                
                Connection conn = null;
                PreparedStatement pstmt = null;
                ResultSet rs = null;

                try {
                    Class.forName("com.mysql.cj.jdbc.Driver");
                    conn = DriverManager.getConnection(dbURL, dbUser, dbPassword);

                    String sql = "SELECT aj.job_opening_id, jt.job_title, jt.job_id, ca.company_name, aj.location, aj.salary " +
                                 "FROM active_jobs aj " +
                                 "JOIN REF_job_titles jt ON aj.job_id = jt.job_id " +
                                 "JOIN company_accounts ca ON aj.company_id = ca.company_ID " +
                                 "WHERE aj.is_filled = FALSE AND aj.closing_date >= CURDATE()";
                    pstmt = conn.prepareStatement(sql);
                    rs = pstmt.executeQuery();

                    while (rs.next()) {
                        int jobOpeningId = rs.getInt("job_opening_id");
                        String jobTitle = rs.getString("job_title");
                        String companyName = rs.getString("company_name");
                        String location = rs.getString("location");
                        double salary = rs.getDouble("salary");

                        out.println("<option value='" + jobOpeningId + "'>" +
                                    jobTitle + " at " + companyName + " (" + location + ", PHP " + salary + ")" +
                                    "</option>");
                    }
                } catch (Exception e) {
                    out.println("<p>Error: " + e.getMessage() + "</p>");
                } finally {
                    if (rs != null) try { rs.close(); } catch (Exception ignore) {}
                    if (pstmt != null) try { pstmt.close(); } catch (Exception ignore) {}
                    if (conn != null) try { conn.close(); } catch (Exception ignore) {}
                }
            %>
        </select>
        <br><br>
        <button type="submit">Apply for Job</button>
    </form>

    <br>

    <!-- Button to view detailed job information -->
    <form action="view_job_details.jsp" method="get">
        <input type="hidden" id="selected_job" name="job_opening_id">
        <button type="submit" onclick="return setSelectedJob()">View Job Details</button>
    </form>

    <script>
        // JavaScript to copy selected job value to the hidden input
        function setSelectedJob() {
            const selectedJob = document.getElementById('job').value;
            if (!selectedJob) {
                alert('Please select a job first!');
                return false;
            }
            document.getElementById('selected_job').value = selectedJob;
            return true;
        }
    </script>
</body>
</html>
