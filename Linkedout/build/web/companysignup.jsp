<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import= "java.util.*, java.sql.*, usermanagement.*"%>
<%@page import= "java.sql.*"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>User SignUp</title>
    </head>
    <body>
        <jsp:useBean id="A" class="usermanagement.company_accounts" scope="session" />
        <%
             Class.forName("com.mysql.cj.jdbc.Driver");
            String v_company_name = request.getParameter("company_name");
            String v_contact_number = request.getParameter("contact_number");
            String v_main_address = request.getParameter("main_address");
            String v_email = request.getParameter("email");
            String v_password = request.getParameter("password");
            A.company_name = v_company_name; 
            A.contact_number = v_contact_number;
            A.email = v_email; 
            A.main_address = v_main_address; 
            A.password = v_password;
            int status = A.companySignup();
            
            if(status == 1) {
        %>
        <form action="index.html">
            <h1> Company Signup Successful </h1>
            <input type="submit" value = "Go to User home page">
        </form>
        <% } else { %>
            <form action="index.html">
            <h1> Company Signup Failed </h1>
            <input type="submit" value = "Return to Menu">
        <% } %>
        </form>
    </body>
</html>
