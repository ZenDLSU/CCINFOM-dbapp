<%-- 
    Document   : logingIn
    Created on : Nov 22, 2024, 11:35:34 AM
    Author     : julia
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
    </head>
    <body>
        <jsp:useBean id="A" class="link.login_logic" scope="request" />
        <%
            String userName= request.getParameter("username");
            String password= request.getParameter("password");
            String errorMessage = null;
            A.companyName = userName;
            A.companyPassword = password;
            A.userName = userName;
            A.userPassword = password;
            int redirect = A.login();
            if (redirect == 1){
                response.sendRedirect("homePage.html");
            } else {
                errorMessage = "Login failed. Please check your username and password.";
                response.sendRedirect("index.html");  
            }
            %>
        <h1>Hello World!</h1>
    </body>
</html>
