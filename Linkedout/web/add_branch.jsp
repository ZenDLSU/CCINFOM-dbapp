<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Create Company Branch</title>
</head>
<body>
    <h1>Create a New Branch for Your Company</h1>

    <%
        // Check if the company is logged in
        Integer companyId = (Integer) session.getAttribute("company_ID");

        if (companyId == null) {
            out.println("<p>You are not logged in. Please log in as a company to create a branch.</p>");
            out.println("<a href='login.jsp'>Login</a>");
        } else {
    %>
    
    <form action="submit_branch.jsp" method="POST">
        <label for="address">Branch Address:</label>
        <input type="text" name="address" id="address" required><br><br>
        
        <input type="hidden" name="company_id" value="<%= companyId %>">
        
        <button type="submit">Create Branch</button>
    </form>

    <% 
        } 
    %>
    
</body>
</html>