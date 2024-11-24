<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*, java.util.Date" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Employee Report</title>
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
    <h1>Employees Report</h1>
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
            String sql = "SELECT ua.first_name, ua.last_name, ua.email, ua.contact_num, ua.date_created, ce.date_hired, ca.company_name " +
                         "FROM company_employees ce " +
                         "JOIN user_accounts ua ON ce.account_ID = ua.account_ID " +
                         "JOIN company_accounts ca ON ce.company_ID = ca.company_ID ";

            // Add filtering conditions if applicable
            if (filterMonth != null && !filterMonth.isEmpty()) {
                sql += "WHERE MONTH(ce.date_hired) = ? ";
            }
            if (filterYear != null && !filterYear.isEmpty()) {
                if (filterMonth != null && !filterMonth.isEmpty()) {
                    sql += "AND YEAR(ce.date_hired) = ? ";
                } else {
                    sql += "WHERE YEAR(ce.date_hired) = ? ";
                }
            }

            sql += "ORDER BY YEAR(ce.date_hired), MONTH(ce.date_hired)";

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

        <h2>Employees Sorted by Hire Date</h2>
        <table>
            <tr>
                <th>First Name</th>
                <th>Last Name</th>
                <th>Email</th>
                <th>Contact Number</th>
                <th>Date Registered</th>
                <th>Hire Date</th>
                <th>Company Name</th>
            </tr>
            <%
                while (rs != null && rs.next()) {
                    String firstName = rs.getString("first_name");
                    String lastName = rs.getString("last_name");
                    String email = rs.getString("email");
                    long contactNum = rs.getLong("contact_num");
                    Date dateCreated = rs.getDate("date_created");
                    Date hireDate = rs.getDate("date_hired");
                    String companyName = rs.getString("company_name");
            %>
            <tr>
                <td><%= firstName %></td>
                <td><%= lastName %></td>
                <td><%= email %></td>
                <td><%= contactNum %></td>
                <td><%= dateCreated %></td>
                <td><%= hireDate %></td>
                <td><%= companyName %></td>
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
