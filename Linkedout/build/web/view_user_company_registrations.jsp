<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*, java.util.Date" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Registration Report</title>
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
        .report-summary {
            margin-top: 20px;
        }
    </style>
</head>
<body>
    <h1>Registration Report</h1>
    <p>This report gives a full view of all registered accounts in the system. You can track the total number of registrations by a specific timeframe (month and year).</p>

    <%
        String dbURL = "jdbc:mysql://localhost:3306/linkedout";
        String dbUser = "root";
        String dbPassword = "pass1234!";
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rsUserCount = null;
        ResultSet rsCompanyCount = null;
        ResultSet rsUserDetails = null;
        ResultSet rsCompanyDetails = null;
        String selectedMonth = request.getParameter("month");
        String selectedYear = request.getParameter("year");

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DriverManager.getConnection(dbURL, dbUser, dbPassword);

            // SQL queries to get registration counts based on the selected month and year
            String sqlUserCount = "SELECT COUNT(*) as user_count FROM user_accounts WHERE YEAR(date_created) = ? AND MONTH(date_created) = ?";
            String sqlCompanyCount = "SELECT COUNT(*) as company_count FROM company_accounts WHERE YEAR(date_created) = ? AND MONTH(date_created) = ?";
            
            // SQL to fetch user details for the selected month/year
            String sqlUserDetails = "SELECT first_name, last_name, email, contact_num, date_created FROM user_accounts WHERE YEAR(date_created) = ? AND MONTH(date_created) = ?";
            // SQL to fetch company details for the selected month/year
            String sqlCompanyDetails = "SELECT company_name, email, contact_number, main_address, date_created FROM company_accounts WHERE YEAR(date_created) = ? AND MONTH(date_created) = ?";

            if (selectedMonth != null && selectedYear != null) {
                pstmt = conn.prepareStatement(sqlUserCount);
                pstmt.setInt(1, Integer.parseInt(selectedYear));
                pstmt.setInt(2, Integer.parseInt(selectedMonth));
                rsUserCount = pstmt.executeQuery();

                pstmt = conn.prepareStatement(sqlCompanyCount);
                pstmt.setInt(1, Integer.parseInt(selectedYear));
                pstmt.setInt(2, Integer.parseInt(selectedMonth));
                rsCompanyCount = pstmt.executeQuery();

                pstmt = conn.prepareStatement(sqlUserDetails);
                pstmt.setInt(1, Integer.parseInt(selectedYear));
                pstmt.setInt(2, Integer.parseInt(selectedMonth));
                rsUserDetails = pstmt.executeQuery();

                pstmt = conn.prepareStatement(sqlCompanyDetails);
                pstmt.setInt(1, Integer.parseInt(selectedYear));
                pstmt.setInt(2, Integer.parseInt(selectedMonth));
                rsCompanyDetails = pstmt.executeQuery();
            }
        %>

        <h2>Filter by Month and Year</h2>
        <form action="" method="GET">
            <label for="month">Month:</label>
            <select id="month" name="month">
                <%
                    // Displaying months without year
                    String[] months = {"January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"};
                    for (int i = 1; i <= 12; i++) {
                        out.println("<option value='" + i + "' " + (i == Integer.parseInt(selectedMonth != null ? selectedMonth : "0") ? "selected" : "") + ">" + months[i-1] + "</option>");
                    }
                %>
            </select>

            <label for="year">Year:</label>
            <select id="year" name="year">
                <%
                    int currentYear = Calendar.getInstance().get(Calendar.YEAR);
                    for (int i = currentYear; i >= currentYear - 10; i--) {
                        out.println("<option value='" + i + "' " + (i == Integer.parseInt(selectedYear != null ? selectedYear : "0") ? "selected" : "") + ">" + i + "</option>");
                    }
                %>
            </select>
            <input type="submit" value="Filter">
        </form>

        <%
            if (rsUserCount != null && rsUserCount.next()) {
                int userCount = rsUserCount.getInt("user_count");
                int companyCount = 0;
                if (rsCompanyCount != null && rsCompanyCount.next()) {
                    companyCount = rsCompanyCount.getInt("company_count");
                }
        %>

        <h2>Registration Summary for <%= selectedMonth != null ? months[Integer.parseInt(selectedMonth) - 1] : "Select Month" %> <%= selectedYear != null ? selectedYear : "Select Year" %></h2>
        <div class="report-summary">
            <table>
                <tr>
                    <th>Category</th>
                    <th>Count</th>
                </tr>
                <tr>
                    <td>Total User Registrations</td>
                    <td><%= userCount %></td>
                </tr>
                <tr>
                    <td>Total Company Registrations</td>
                    <td><%= companyCount %></td>
                </tr>
            </table>
        </div>

        <h3>User Registrations</h3>
        <table>
            <tr>
                <th>First Name</th>
                <th>Last Name</th>
                <th>Email</th>
                <th>Contact Number</th>
                <th>Date Registered</th>
            </tr>
            <%
                while (rsUserDetails != null && rsUserDetails.next()) {
                    String firstName = rsUserDetails.getString("first_name");
                    String lastName = rsUserDetails.getString("last_name");
                    String email = rsUserDetails.getString("email");
                    long contactNum = rsUserDetails.getLong("contact_num");
                    Date dateCreated = rsUserDetails.getDate("date_created");
            %>
            <tr>
                <td><%= firstName %></td>
                <td><%= lastName %></td>
                <td><%= email %></td>
                <td><%= contactNum %></td>
                <td><%= dateCreated %></td>
            </tr>
            <%
                }
            %>
        </table>

        <h3>Company Registrations</h3>
        <table>
            <tr>
                <th>Company Name</th>
                <th>Email</th>
                <th>Contact Number</th>
                <th>Address</th>
                <th>Date Registered</th>
            </tr>
            <%
                while (rsCompanyDetails != null && rsCompanyDetails.next()) {
                    String companyName = rsCompanyDetails.getString("company_name");
                    String companyEmail = rsCompanyDetails.getString("email");
                    long companyContact = rsCompanyDetails.getLong("contact_number");
                    String companyAddress = rsCompanyDetails.getString("main_address");
                    Date companyDateCreated = rsCompanyDetails.getDate("date_created");
            %>
            <tr>
                <td><%= companyName %></td>
                <td><%= companyEmail %></td>
                <td><%= companyContact %></td>
                <td><%= companyAddress %></td>
                <td><%= companyDateCreated %></td>
            </tr>
            <%
                }
            %>
        </table>

        <%
            } else {
                out.println("<p>Please select a month and year to filter the data.</p>");
            }
        %>

    <%
        } catch (Exception e) {
            out.println("<p>Error: " + e.getMessage() + "</p>");
        } finally {
            if (rsUserCount != null) try { rsUserCount.close(); } catch (Exception ignore) {}
            if (rsCompanyCount != null) try { rsCompanyCount.close(); } catch (Exception ignore) {}
            if (rsUserDetails != null) try { rsUserDetails.close(); } catch (Exception ignore) {}
            if (rsCompanyDetails != null) try { rsCompanyDetails.close(); } catch (Exception ignore) {}
            if (pstmt != null) try { pstmt.close(); } catch (Exception ignore) {}
            if (conn != null) try { conn.close(); } catch (Exception ignore) {}
        }
    %>

    <a href="index.html">Go back to Home</a>
</body>
</html
