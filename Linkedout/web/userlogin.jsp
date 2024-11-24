<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import= "java.util.*, java.sql.*"%>
<%@page import= "java.sql.*"%>
<%@page import="jakarta.servlet.http.*"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
    </head>
    <body>
        <%
            Class.forName("com.mysql.cj.jdbc.Driver");
            String v_email = request.getParameter("email");
            String v_password = request.getParameter("password");
            
            String dbURL = "jdbc:mysql://localhost:3306/linkedout";
            String dbUser = "root";
            String dbPassword = "pass1234!";
            
            Connection conn = null;
            PreparedStatement pstmt = null;
            ResultSet rs = null;
            
            try {
                // Establish database connection
                Class.forName("com.mysql.cj.jdbc.Driver");
                conn = DriverManager.getConnection(dbURL, dbUser, dbPassword);

                // Validate user credentials
                String sql = "SELECT * FROM user_accounts WHERE email = ? AND password = ?";
                pstmt = conn.prepareStatement(sql);
                pstmt.setString(1, v_email);
                pstmt.setString(2, v_password);
                rs = pstmt.executeQuery();

                if (rs.next()) {
                    session.setAttribute("user_id", rs.getInt("account_ID"));
                    session.setAttribute("first_name", rs.getString("first_name"));
                    session.setAttribute("last_name", rs.getString("last_name"));
                    session.setAttribute("email", v_email);

                    out.println("<h3>Login Successful!</h3>");
                    out.println("<p>Welcome, " + rs.getString("first_name") + " " + rs.getString("last_name") + "!</p>");
                    out.println("<a href='userhomepage.html'>Go to Dashboard</a>");
                } else {
                    out.println("<h3>Invalid email or password. Please try again.</h3>");
                }
            } catch (Exception e) {
                out.println("<h3>Error: " + e.getMessage() + "</h3>");
            } finally {
                if (rs != null) rs.close();
                if (pstmt != null) pstmt.close();
                if (conn != null) conn.close();
            }
        %>
    </body>
</html>
