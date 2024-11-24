<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.*, java.sql.*, usermanagement.*"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>User SignUp</title>
    </head>
    <body>
        <jsp:useBean id="A" class="usermanagement.user_accounts" scope="session" />
        <%
            Class.forName("com.mysql.cj.jdbc.Driver");
            String v_first_name = request.getParameter("first_name");
            String v_last_name = request.getParameter("last_name");
            int v_age = Integer.parseInt(request.getParameter("age"));
            String v_contact_num = request.getParameter("contact_num");
            String v_email = request.getParameter("email");
            String v_home_address = request.getParameter("home_address");
            String v_birthday = request.getParameter("birthday");
            String v_primary_language = request.getParameter("primary_language");
            String v_password = request.getParameter("password");
            int v_years_of_experience = Integer.parseInt(request.getParameter("years_of_experience"));
            String v_highest_education = request.getParameter("highest_education");

            A.first_name = v_first_name;
            A.last_name = v_last_name;
            A.age = v_age;
            A.contact_num = v_contact_num;
            A.email = v_email;
            A.home_address = v_home_address;
            A.birthday = v_birthday;
            A.primary_language = v_primary_language;
            A.password = v_password;
            A.years_of_experience = v_years_of_experience;
            A.highest_education = v_highest_education;

            int status = A.signup();
            if (status == 1) {
        %>
        <form action="index.html">
            <h1>Signup Successful</h1>
            <input type="submit" value="Go to User Home Page">
        </form>
        <% } else { %>
        <form action="index.html">
            <h1>Signup Failed</h1>
            <input type="submit" value="Return to Menu">
        </form>
        <% } %>
    </body>
</html>
