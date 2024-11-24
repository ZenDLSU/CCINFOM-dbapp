<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Branch Created</title>
</head>
<body>
    <h1>Branch Creation Confirmation</h1>
    
    <%
        // Get company ID and branch address from the form
        String address = request.getParameter("address");
        String companyId = request.getParameter("company_id");

        if (address != null && companyId != null) {
            String dbURL = "jdbc:mysql://localhost:3306/linkedout";
            String dbUser = "root";
            String dbPassword = "pass1234!";
            Connection conn = null;
            PreparedStatement pstmt = null;

            try {
                // Connect to the database
                Class.forName("com.mysql.cj.jdbc.Driver");
                conn = DriverManager.getConnection(dbURL, dbUser, dbPassword);

                // Insert the new branch into the company_branches table
                String sql = "INSERT INTO company_branches (address, company_ID) VALUES (?, ?)";
                pstmt = conn.prepareStatement(sql);
                pstmt.setString(1, address);
                pstmt.setInt(2, Integer.parseInt(companyId));

                int rowsAffected = pstmt.executeUpdate();

                if (rowsAffected > 0) {
                    out.println("<p>Branch successfully created!</p>");
                } else {
                    out.println("<p>Failed to create the branch. Please try again.</p>");
                }
            } catch (Exception e) {
                out.println("<p>Error: " + e.getMessage() + "</p>");
            } finally {
                if (pstmt != null) try { pstmt.close(); } catch (Exception ignore) {}
                if (conn != null) try { conn.close(); } catch (Exception ignore) {}
            }
        } else {
            out.println("<p>Missing required information. Please fill in the address.</p>");
        }
    %>

    <br>
    <a href="companyhomepage.html">
        <button type="button">Return to Homepage</button>
    </a>
</body>
</html>
     