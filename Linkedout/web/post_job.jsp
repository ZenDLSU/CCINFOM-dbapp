<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Post Job Offering</title>
</head>
<body>
    <h1>Post a Job Offering</h1>
    <%
        Integer companyId = (Integer) session.getAttribute("company_ID");

        if (companyId == null) {
            out.println("<p>You are not logged in. Please log in as a company to post a job.</p>");
            out.println("<a href='login.jsp'>Login</a>");
        } else {
            // Fetch company main address and branch addresses
            String dbURL = "jdbc:mysql://localhost:3306/linkedout";
            String dbUser = "root";
            String dbPassword = "pass1234!";
            
            Connection conn = null;
            PreparedStatement pstmt = null;
            ResultSet rs = null;
            String mainAddress = null;
            
            try {
                // Connect to database
                Class.forName("com.mysql.cj.jdbc.Driver");
                conn = DriverManager.getConnection(dbURL, dbUser, dbPassword);

                // Get the company's main address
                String sqlMainAddress = "SELECT main_address FROM company_accounts WHERE company_ID = ?";
                pstmt = conn.prepareStatement(sqlMainAddress);
                pstmt.setInt(1, companyId);
                rs = pstmt.executeQuery();
                if (rs.next()) {
                    mainAddress = rs.getString("main_address");
                }

                // Get the company's branch addresses
                String sqlBranches = "SELECT address FROM company_branches WHERE company_ID = ?";
                pstmt = conn.prepareStatement(sqlBranches);
                pstmt.setInt(1, companyId);
                rs = pstmt.executeQuery();

                // Prepare the list of addresses (main address + branch addresses)
                List<String> addresses = new ArrayList<>();
                addresses.add(mainAddress); // Always include the main address

                while (rs.next()) {
                    addresses.add(rs.getString("address"));
                }

                // Generate the options for the location select element
                out.println("<form action='submit_job.jsp' method='POST'>");
                out.println("<label for='job_id'>Job Type:</label>");
                out.println("<select name='job_id' id='job_id' required>");
                
                // Fetch job titles from REF_job_titles table
                String sqlJobTitles = "SELECT job_id, job_title FROM REF_job_titles";
                pstmt = conn.prepareStatement(sqlJobTitles);
                rs = pstmt.executeQuery();
                while (rs.next()) {
                    out.println("<option value='" + rs.getInt("job_id") + "'>" + rs.getString("job_title") + "</option>");
                }
                out.println("</select><br><br>");

                // Location select with all addresses (main and branches)
                out.println("<label for='location'>Location:</label>");
                out.println("<select name='location' id='location' required>");
                for (String address : addresses) {
                    out.println("<option value='" + address + "'>" + address + "</option>");
                }
                out.println("</select><br><br>");

                out.println("<label for='salary'>Salary:</label>");
                out.println("<input type='number' name='salary' id='salary' step='0.01' required><br><br>");

                out.println("<label for='closing_date'>Closing Date:</label>");
                out.println("<input type='date' name='closing_date' id='closing_date' required><br><br>");

                out.println("<button type='submit'>Post Job</button>");
                out.println("</form>");
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
