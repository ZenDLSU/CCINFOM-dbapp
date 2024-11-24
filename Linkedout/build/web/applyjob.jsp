<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.Date" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Apply for Job</title>
</head>
<body>
    <h1>Job Application Status</h1>
    <%
        String dbURL = "jdbc:mysql://localhost:3306/linkedout";
        String dbUser = "root";
        String dbPassword = "pass1234!";
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        Integer userId = (Integer) session.getAttribute("user_id");
        String jobId = request.getParameter("job_opening_id");

        if (userId == null) {
            out.println("<p>You are not logged in. Please log in to apply for jobs.</p>");
            out.println("<a href='login.jsp'>Login</a>");
        } else if (jobId == null || jobId.trim().isEmpty()) {
            out.println("<p>No job was selected. Please select a job to apply for.</p>");
            out.println("<a href='select_job.jsp'>Go Back</a>");
        } else {
            try {
                Class.forName("com.mysql.cj.jdbc.Driver");
                conn = DriverManager.getConnection(dbURL, dbUser, dbPassword);

                String userCheckQuery = "SELECT COUNT(*) FROM user_accounts WHERE account_ID = ?";
                pstmt = conn.prepareStatement(userCheckQuery);
                pstmt.setInt(1, userId);
                rs = pstmt.executeQuery();
                rs.next();
                int userExists = rs.getInt(1);

                if (userExists == 0) {
                    out.println("<p>User does not exist. Please contact support.</p>");
                } else {
                    String jobInfoQuery = "SELECT aj.job_id, aj.company_id FROM active_jobs aj WHERE aj.job_opening_id = ?";
                    pstmt = conn.prepareStatement(jobInfoQuery);
                    pstmt.setInt(1, Integer.parseInt(jobId));
                    rs = pstmt.executeQuery();

                    if (rs.next()) {
                        int jobIdFromDb = rs.getInt("job_id");
                        int companyId = rs.getInt("company_id");

                        String checkApplicationQuery = "SELECT COUNT(*) FROM user_job_applications WHERE account_ID = ? AND job_id = ? AND company_ID = ?";
                        pstmt = conn.prepareStatement(checkApplicationQuery);
                        pstmt.setInt(1, userId);
                        pstmt.setInt(2, jobIdFromDb);
                        pstmt.setInt(3, companyId);
                        ResultSet checkRs = pstmt.executeQuery();
                        checkRs.next();
                        int existingApplication = checkRs.getInt(1);
                        checkRs.close();

                        if (existingApplication > 0) {
                            out.println("<p>You have already applied for this job.</p>");
                        } else {
                            String insertQuery = "INSERT INTO user_job_applications (account_ID, job_id, company_ID, application_date, application_status) VALUES (?, ?, ?, ?, ?)";
                            pstmt = conn.prepareStatement(insertQuery);
                            pstmt.setInt(1, userId);
                            pstmt.setInt(2, jobIdFromDb);
                            pstmt.setInt(3, companyId);
                            pstmt.setDate(4, new java.sql.Date(new Date().getTime()));
                            pstmt.setString(5, "Pending");
                            int rowsInserted = pstmt.executeUpdate();

                            if (rowsInserted > 0) {
                                out.println("<p>Your application has been submitted successfully!</p>");
                            } else {
                                out.println("<p>There was an error submitting your application. Please try again.</p>");
                            }
                        }
                    } else {
                        out.println("<p>Invalid job selected. Please try again.</p>");
                    }
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
    <br>
    <a href="userhomepage.html">Go Back to User homepage</a>
</body>
</html>
