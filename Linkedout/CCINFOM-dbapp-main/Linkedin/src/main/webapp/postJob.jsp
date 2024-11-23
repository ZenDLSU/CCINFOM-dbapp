<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.*,link.*,java.time.LocalDate,java.time.format.DateTimeFormatter" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Post a Job</title>
    </head>
    <body>
        <jsp:useBean id="B" class="link.Job_Record_Management" scope="request" />
        <%
            try {
                // Retrieve and parse form parameters
                String company_ID = request.getParameter("company_ID");
                String branch_ID = request.getParameter("branch_ID");
                String position_ID = request.getParameter("position_ID");

                // Set parameters in the jobs management bean
                B.company_ID = Integer.parseInt(company_ID);
                B.branch_ID = (branch_ID == null || branch_ID.isEmpty()) ? -1 : Integer.parseInt(branch_ID);
                B.position_ID = Integer.parseInt(position_ID);

                // Call post_job method
                int result = B.post_job();
                if (result == 0) {
        %>
                    <h2>Error: Job posting failed. Please contact support if the problem persists.</h2>
        <%
                } else {
        %>
                    <h2>Job successfully posted with ID: <%= result %></h2>
        <%
                }
            } catch (Exception e) {
        %>
                <h2>Error: Invalid input provided. Please check your data and try again.</h2>
                <pre><%= e.getMessage() %></pre>
        <%
            }
        %>
        <a href="job_posting_index.html">Post Another Job</a>
        <a href="homepage.html">Return to Home</a>
    </body>
</html>
