<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>User Logout</title>
</head>
<body>
    <%
        // Ensure the session is available
        if (session != null) {
            // Retrieve the session attributes to check if the user is logged in
            Integer userId = (Integer) session.getAttribute("user_id");  // Use "user_id" here, not "account_ID"

            if (userId != null) {
                // If it's a user, log out the user
                session.invalidate(); // Invalidate the session
                out.println("<h2>You have successfully logged out as a user.</h2>");
            } else {
                // If no user is logged in, display a message
                out.println("<h2>No active session found for user.</h2>");
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
