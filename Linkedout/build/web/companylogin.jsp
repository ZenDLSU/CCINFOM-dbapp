<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.sql.*" %>
<%@page import="jakarta.servlet.http.*" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Company Login</title>
    </head>
    <body>
        <%
            String v_email = request.getParameter("email");
            String v_password = request.getParameter("password");

            if (v_email != null && v_password != null) {
                String dbURL = "jdbc:mysql://localhost:3306/linkedout";
                String dbUser = "root";
                String dbPassword = "pass1234!";
                
                try (Connection conn = DriverManager.getConnection(dbURL, dbUser, dbPassword)) {
                    String sql = "SELECT * FROM company_accounts WHERE email = ? AND password = ?";
                    try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
                        pstmt.setString(1, v_email);
                        pstmt.setString(2, v_password);

                        try (ResultSet rs = pstmt.executeQuery()) {
                            if (rs.next()) {
                                session.setAttribute("company_ID", rs.getInt("company_ID"));
                                session.setAttribute("company_name", rs.getString("company_name"));
                                session.setAttribute("email", v_email);
                                session.setMaxInactiveInterval(30 * 60); // 30-minute timeout
                                response.sendRedirect("companyhomepage.html"); // Redirect to the homepage
                                return;
                            } else {
                                out.println("<h3>Invalid email or password. Please try again.</h3>");
                            }
                        }
                    }
                } catch (Exception e) {
                    log("Login error: " + e.getMessage(), e);
                    out.println("<h3>An unexpected error occurred. Please try again later.</h3>");
                }
            } else {
                out.println("<h3>Please enter your email and password to login.</h3>");
            }
        %>
    </body>
</html>
