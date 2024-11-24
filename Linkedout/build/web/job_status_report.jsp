<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*, java.util.Date" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Job Listings Status Report</title>
    <style>
        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
        }
        table, th, td {
            border: 1px solid black;
        }
        th, td {
            padding: 8px;
            text-align: left;
        }
        th {
            background-color: #f2f2f2;
        }
    </style>
</head>
<body>
    <h1>Job Listings Status Report</h1>
    <p>This report monitors the status and expiration of job listings, and allows filtering by posting and closing dates.</p>

    <!-- Filter Form -->
    <form method="get" action="">
        <label for="filterMonth">Select Month:</label>
        <select name="filterMonth" id="filterMonth">
            <option value="">-- All Months --</option>
            <option value="01" <%= request.getParameter("filterMonth") != null && request.getParameter("filterMonth").equals("01") ? "selected" : "" %>>January</option>
            <option value="02" <%= request.getParameter("filterMonth") != null && request.getParameter("filterMonth").equals("02") ? "selected" : "" %>>February</option>
            <option value="03" <%= request.getParameter("filterMonth") != null && request.getParameter("filterMonth").equals("03") ? "selected" : "" %>>March</option>
            <option value="04" <%= request.getParameter("filterMonth") != null && request.getParameter("filterMonth").equals("04") ? "selected" : "" %>>April</option>
            <option value="05" <%= request.getParameter("filterMonth") != null && request.getParameter("filterMonth").equals("05") ? "selected" : "" %>>May</option>
            <option value="06" <%= request.getParameter("filterMonth") != null && request.getParameter("filterMonth").equals("06") ? "selected" : "" %>>June</option>
            <option value="07" <%= request.getParameter("filterMonth") != null && request.getParameter("filterMonth").equals("07") ? "selected" : "" %>>July</option>
            <option value="08" <%= request.getParameter("filterMonth") != null && request.getParameter("filterMonth").equals("08") ? "selected" : "" %>>August</option>
            <option value="09" <%= request.getParameter("filterMonth") != null && request.getParameter("filterMonth").equals("09") ? "selected" : "" %>>September</option>
            <option value="10" <%= request.getParameter("filterMonth") != null && request.getParameter("filterMonth").equals("10") ? "selected" : "" %>>October</option>
            <option value="11" <%= request.getParameter("filterMonth") != null && request.getParameter("filterMonth").equals("11") ? "selected" : "" %>>November</option>
            <option value="12" <%= request.getParameter("filterMonth") != null && request.getParameter("filterMonth").equals("12") ? "selected" : "" %>>December</option>
        </select>

        <label for="filterYear">Select Year:</label>
        <select name="filterYear" id="filterYear">
            <option value="">-- All Years --</option>
            <option value="<%= new java.util.GregorianCalendar().get(java.util.Calendar.YEAR) %>" 
                <%= request.getParameter("filterYear") != null && request.getParameter("filterYear").equals(String.valueOf(new java.util.GregorianCalendar().get(java.util.Calendar.YEAR))) ? "selected" : "" %>>Current Year</option>
            <!-- Add any other specific year options here as necessary -->
            <option value="2023" <%= request.getParameter("filterYear") != null && request.getParameter("filterYear").equals("2023") ? "selected" : "" %>>2023</option>
            <option value="2022" <%= request.getParameter("filterYear") != null && request.getParameter("filterYear").equals("2022") ? "selected" : "" %>>2022</option>
        </select>

        <button type="submit">Filter</button>
    </form>

    <%
        String filterMonth = request.getParameter("filterMonth");
        String filterYear = request.getParameter("filterYear");

        String dbURL = "jdbc:mysql://localhost:3306/linkedout";
        String dbUser = "root";
        String dbPassword = "pass1234!";
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DriverManager.getConnection(dbURL, dbUser, dbPassword);

            // Build the dynamic SQL query based on filters
            String sql = "SELECT jt.job_title, ca.company_name, aj.posting_date, aj.closing_date, aj.is_filled, " +
                         "IF(aj.closing_date < CURDATE(), 'Expired', 'Active') AS expiration_status " +
                         "FROM active_jobs aj " +
                         "JOIN REF_job_titles jt ON aj.job_id = jt.job_id " +
                         "JOIN company_accounts ca ON aj.company_id = ca.company_ID ";

            // Add filtering conditions if applicable
            if (filterMonth != null && !filterMonth.isEmpty()) {
                sql += "WHERE MONTH(aj.posting_date) = ? ";
            }
            if (filterYear != null && !filterYear.isEmpty()) {
                if (filterMonth != null && !filterMonth.isEmpty()) {
                    sql += "AND YEAR(aj.posting_date) = ? ";
                } else {
                    sql += "WHERE YEAR(aj.posting_date) = ? ";
                }
            }

            sql += "ORDER BY aj.posting_date";

            pstmt = conn.prepareStatement(sql);

            // Set the parameters based on filters
            int paramIndex = 1;
            if (filterMonth != null && !filterMonth.isEmpty()) {
                pstmt.setString(paramIndex++, filterMonth);
            }
            if (filterYear != null && !filterYear.isEmpty()) {
                pstmt.setString(paramIndex, filterYear);
            }

            rs = pstmt.executeQuery();
        %>

        <h2>Job Listings Status and Expiration</h2>
        <table>
            <tr>
                <th>Job Title</th>
                <th>Company Name</th>
                <th>Posting Date</th>
                <th>Closing Date</th>
                <th>Status</th>
                <th>Expiration Status</th>
            </tr>
            <%
                while (rs != null && rs.next()) {
                    String jobTitle = rs.getString("job_title");
                    String companyName = rs.getString("company_name");
                    Date postingDate = rs.getDate("posting_date");
                    Date closingDate = rs.getDate("closing_date");
                    boolean isFilled = rs.getBoolean("is_filled");
                    String expirationStatus = rs.getString("expiration_status");
                    String status = isFilled ? "Filled" : "Not Filled";
            %>
            <tr>
                <td><%= jobTitle %></td>
                <td><%= companyName %></td>
                <td><%= postingDate %></td>
                <td><%= closingDate %></td>
                <td><%= status %></td>
                <td><%= expirationStatus %></td>
            </tr>
            <%
                }
            %>
        </table>

        <%
        } catch (Exception e) {
            out.println("<p>Error: " + e.getMessage() + "</p>");
        } finally {
            if (rs != null) try { rs.close(); } catch (Exception ignore) {}
            if (pstmt != null) try { pstmt.close(); } catch (Exception ignore) {}
            if (conn != null) try { conn.close(); } catch (Exception ignore) {}
        }
    %>

    <a href="index.html">Go back to Home</a>
</body>
</html>
