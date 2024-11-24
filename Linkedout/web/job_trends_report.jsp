<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Company Job Postings Report</title>
</head>
<body>
    <h1>Job Postings Report</h1>

    <form method="get" action="">
        <label for="company_id">Choose a Company:</label>
        <select name="company_id" id="company_id">
            <%
                String dbURL = "jdbc:mysql://localhost:3306/linkedout";
                String dbUser = "root";
                String dbPassword = "pass1234!";
                Connection conn = null;
                PreparedStatement pstmt = null;
                ResultSet rs = null;
                String selectedCompanyId = request.getParameter("company_id");

                try {
                    Class.forName("com.mysql.cj.jdbc.Driver");
                    conn = DriverManager.getConnection(dbURL, dbUser, dbPassword);
                    String sql = "SELECT company_ID, company_name FROM company_accounts";
                    pstmt = conn.prepareStatement(sql);
                    rs = pstmt.executeQuery();

                    while (rs.next()) {
                        int companyId = rs.getInt("company_ID");
                        String companyName = rs.getString("company_name");
                        String selected = selectedCompanyId != null && companyId == Integer.parseInt(selectedCompanyId) ? "selected" : "";
                        out.println("<option value='" + companyId + "' " + selected + ">" + companyName + "</option>");
                    }
                } catch (Exception e) {
                    out.println("<p>Error fetching companies: " + e.getMessage() + "</p>");
                } finally {
                    try {
                        if (rs != null) rs.close();
                        if (pstmt != null) pstmt.close();
                        if (conn != null) conn.close();
                    } catch (SQLException e) {
                        e.printStackTrace();
                    }
                }
            %>
        </select>

        <label for="month">Month:</label>
        <select name="month" id="month">
            <option value="">Select Month</option>
            <option value="1" <%= request.getParameter("month") != null && request.getParameter("month").equals("1") ? "selected" : "" %>>January</option>
            <option value="2" <%= request.getParameter("month") != null && request.getParameter("month").equals("2") ? "selected" : "" %>>February</option>
            <option value="3" <%= request.getParameter("month") != null && request.getParameter("month").equals("3") ? "selected" : "" %>>March</option>
            <option value="4" <%= request.getParameter("month") != null && request.getParameter("month").equals("4") ? "selected" : "" %>>April</option>
            <option value="5" <%= request.getParameter("month") != null && request.getParameter("month").equals("5") ? "selected" : "" %>>May</option>
            <option value="6" <%= request.getParameter("month") != null && request.getParameter("month").equals("6") ? "selected" : "" %>>June</option>
            <option value="7" <%= request.getParameter("month") != null && request.getParameter("month").equals("7") ? "selected" : "" %>>July</option>
            <option value="8" <%= request.getParameter("month") != null && request.getParameter("month").equals("8") ? "selected" : "" %>>August</option>
            <option value="9" <%= request.getParameter("month") != null && request.getParameter("month").equals("9") ? "selected" : "" %>>September</option>
            <option value="10" <%= request.getParameter("month") != null && request.getParameter("month").equals("10") ? "selected" : "" %>>October</option>
            <option value="11" <%= request.getParameter("month") != null && request.getParameter("month").equals("11") ? "selected" : "" %>>November</option>
            <option value="12" <%= request.getParameter("month") != null && request.getParameter("month").equals("12") ? "selected" : "" %>>December</option>
        </select>

        <label for="year">Year:</label>
        <select name="year" id="year">
            <option value="">Select Year</option>
            <%
                int currentYear = java.util.Calendar.getInstance().get(java.util.Calendar.YEAR);
                String selectedYear = request.getParameter("year");
                for (int year = currentYear - 5; year <= currentYear + 5; year++) {
                    String selected = (selectedYear != null && year == Integer.parseInt(selectedYear)) ? "selected" : "";
                    out.println("<option value='" + year + "' " + selected + ">" + year + "</option>");
                }
            %>
        </select>

        <input type="submit" value="Generate Report">
    </form>

    <%
        String companyId = request.getParameter("company_id");
        String month = request.getParameter("month");
        String year = request.getParameter("year");

        if (companyId != null) {
            try {
                conn = DriverManager.getConnection(dbURL, dbUser, dbPassword);
                String reportQuery = "SELECT job_opening_id, job_title, posting_date, closing_date, is_filled " +
                                     "FROM active_jobs JOIN REF_job_titles ON active_jobs.job_id = REF_job_titles.job_id " +
                                     "WHERE company_id = ?";

                if (month != null && !month.isEmpty() && year != null && !year.isEmpty()) {
                    reportQuery += " AND MONTH(posting_date) = ? AND YEAR(posting_date) = ?";
                }

                reportQuery += " ORDER BY posting_date";

                pstmt = conn.prepareStatement(reportQuery);
                pstmt.setInt(1, Integer.parseInt(companyId));

                if (month != null && !month.isEmpty() && year != null && !year.isEmpty()) {
                    pstmt.setInt(2, Integer.parseInt(month));
                    pstmt.setInt(3, Integer.parseInt(year));
                }

                rs = pstmt.executeQuery();

                out.println("<table border='1'>");
                out.println("<tr><th>Job ID</th><th>Job Title</th><th>Posting Date</th><th>Closing Date</th><th>Filled Status</th></tr>");
                while (rs.next()) {
                    int jobOpeningId = rs.getInt("job_opening_id");
                    String jobTitle = rs.getString("job_title");
                    Date postingDate = rs.getDate("posting_date");
                    Date closingDate = rs.getDate("closing_date");
                    boolean isFilled = rs.getBoolean("is_filled");

                    out.println("<tr>");
                    out.println("<td>" + jobOpeningId + "</td>");
                    out.println("<td>" + jobTitle + "</td>");
                    out.println("<td>" + postingDate + "</td>");
                    out.println("<td>" + closingDate + "</td>");
                    out.println("<td>" + (isFilled ? "Filled" : "Open") + "</td>");
                    out.println("</tr>");
                }
                out.println("</table>");
            } catch (Exception e) {
                out.println("<p>Error fetching job postings: " + e.getMessage() + "</p>");
            } finally {
                try {
                    if (rs != null) rs.close();
                    if (pstmt != null) pstmt.close();
                    if (conn != null) conn.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
        }
    %>
</body>
</html>
