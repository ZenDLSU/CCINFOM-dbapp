<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Company Logout</title>
</head>
<body>
    <%

        // Ensure the session is available
        if (session != null) {
            // Retrieve the session attributes to check if the company is logged in
            Integer companyId = (Integer) session.getAttribute("company_ID");

            if (companyId != null) {
                // If it's a company, log out the company
                session.invalidate(); // Invalidate the session
                out.println("<h2>You have successfully logged out as a company.</h2>");
            } else {
                // If no company is logged in, display a message
                out.println("<h2>No active session found for company.</h2>");
            }
        } else {
            // No session exists
            out.println("<h2>No active session found.</h2>");
        }
    %>
    <br>
    <a href="index.html">Back to Homepage</a> <!-- Redirect to homepage -->
</body>
</html>
