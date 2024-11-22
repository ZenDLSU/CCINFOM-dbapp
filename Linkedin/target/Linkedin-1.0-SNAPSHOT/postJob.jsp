<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.*,link.*,java.time.LocalDate,java.time.format.DateTimeFormatter" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Job Posting</title>
    </head>
    <body>
        <jsp:useBean id="B" class="link.Job_Record_Management" scope="request" />
        
        <%
    
            String company_ID = request.getParameter("company_ID");
            String branch_ID = request.getParameter("branch_ID");
            String position_name = request.getParameter("position_name");
            int positionID = Integer.parseInt(position_name);
            String education = request.getParameter("education");

            // Set the parameters for the Job_Record_Management bean
            B.company_ID = Integer.parseInt(company_ID);  
            B.branch_ID = Integer.parseInt(branch_ID);    
            B.position_ID = positionID;             
            if (education == null || education.isEmpty()) {
                B.education = null;
            } else {
                B.education = education;
            }
            
            int result = B.post_job(); //returns an integer for success/failure
        %>

        <h1>Job Posted Successfully</h1>
        <% if (result == 0) { %>
            <h2>Error: Failed to post job. Please try again.</h2>
        <% } else { %>
            <h2>Job has been successfully posted!</h2>
        <% } %>

    </body>
</html>