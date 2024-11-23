<%-- 
    Document   : submitAcc
    Created on : Nov 20, 2024, 9:00:53 PM
    Author     : julia
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.*,link.*,java.time.LocalDate,java.time.format.DateTimeFormatter" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Account Processing</title>
    </head>
    <body>
        <jsp:useBean id="B" class="link.UserAccount_Record_Management" scope="request" />
        <%
            String first_name = request.getParameter("first_name");
            String last_name = request.getParameter("last_name");
            String contact_no = request.getParameter("contact_no");
            String email = request.getParameter("email");
            String home_address = request.getParameter("home_address");
            String birthday = request.getParameter("birthday");
            String education = request.getParameter("education");
            String years_of_experience = request.getParameter("years_of_experience");
            String primary_language = request.getParameter("primary_language");
            String job_ID = request.getParameter("job_ID");
            String company_ID = request.getParameter("company_ID");
            String password = request.getParameter("password");
            B.first_name = String.valueOf(first_name);
            B.last_name = String.valueOf(last_name);
            B.email = String.valueOf(email);
            B.primary_language = String.valueOf(primary_language);
            B.userpassword = String.valueOf(password);
            B.birthday = String.valueOf(birthday);
            if (contact_no == null || contact_no.isEmpty()) {
                contact_no = null;
            }
            if (home_address == null || home_address.isEmpty()) {
                B.home_address = null;
            }
            if (education == null || education.isEmpty()) {
                B.education = null;
            }
            if (years_of_experience == null || years_of_experience.isEmpty()) {
                B.years_of_experience = -1;
            }
            if (job_ID == null || job_ID.isEmpty()) {
                B.job_ID = -1;
            }
            if (company_ID == null || company_ID.isEmpty()) {
                B.company_ID = -1;
            }
            B.register_account();
        %>
        <h1>Account Successfully Made</h1>
    </body>
</html>
