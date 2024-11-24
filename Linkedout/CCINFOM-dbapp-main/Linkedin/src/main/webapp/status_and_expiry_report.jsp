<%-- 
    Document   : status_expiry_report
    Created on : Nov 24, 2024, 3:16:58 AM
    Author     : julia
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Status Report</title>
        <style>
            body {
                font-family: Arial, sans-serif;
                background-color: #f0f0f0;
                margin: 0;
                padding: 20px;
            }
            .container {
                max-width: 1000px;
                margin: 0 auto;
                background-color: #fff;
                padding: 20px;
                border-radius: 10px;
                box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
            }
            h1 {
                color: #333;
                margin-bottom: 20px;
            }
            .summary-table {
                width: 100%;
                border-collapse: collapse;
                margin-bottom: 20px;
            }
            .summary-table, th, td {
                border: 1px solid #ccc;
            }
            th, td {
                padding: 10px;
                text-align: left;
            }
            th {
                background-color: #f2f2f2;
            }
            .scrollable-table {
                max-height: 400px;
                overflow-y: auto;
                margin-top: 20px;
            }
            .back-button {
                display: block;
                width: 100%;
                padding: 10px;
                margin-top: 20px;
                background-color: #ccc;
                color: black;
                text-decoration: none;
                border: none;
                border-radius: 5px;
                cursor: pointer;
                text-align: center;
            }
            .back-button:hover {
                background-color: #bbb;
            }
        </style>
    </head>
    <body>
        <div class="container">
            <h1>Status Report</h1>
            <table class="summary-table">
                <thead>
                    <tr>
                        <th>Category</th>
                        <th>Total Count</th>
                    </tr>
                </thead>
                <tbody>
                    <% 
                        try {
                            Class.forName("com.mysql.cj.jdbc.Driver");
                            Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/group3s15?useSSL=false&serverTimezone=UTC", "root", "123456789"); 
                            
                            PreparedStatement pstmt = conn.prepareStatement("SELECT COUNT(*) AS total_accounts FROM user_accounts");
                            ResultSet rs = pstmt.executeQuery();
                            if (rs.next()) {
                    %>
                    <tr>
                        <td>Total Accounts</td>
                        <td><%= rs.getInt("total_accounts") %></td>
                    </tr>
                    <% 
                            }
                            rs.close();
                            pstmt.close();
                            
                            pstmt = conn.prepareStatement("SELECT COUNT(*) AS total_job_listings FROM job_postings");
                            rs = pstmt.executeQuery();
                            if (rs.next()) {
                    %>
                    <tr>
                        <td>Total Job Listings</td>
                        <td><%= rs.getInt("total_job_listings") %></td>
                    </tr>
                    <% 
                            }
                            rs.close();
                            pstmt.close();
                            
                            pstmt = conn.prepareStatement("SELECT COUNT(*) AS total_companies FROM companies");
                            rs = pstmt.executeQuery();
                            if (rs.next()) {
                    %>
                    <tr>
                        <td>Total Companies</td>
                        <td><%= rs.getInt("total_companies") %></td>
                    </tr>
                    <% 
                            }
                            rs.close();
                            pstmt.close();
                            
                            pstmt = conn.prepareStatement("SELECT COUNT(*) AS total_branches FROM branches");
                            rs = pstmt.executeQuery();
                            if (rs.next()) {
                    %>
                    <tr>
                        <td>Total Branches</td>
                        <td><%= rs.getInt("total_branches") %></td>
                    </tr>
                    <% 
                            }
                            rs.close();
                            pstmt.close();
                            
                            conn.close();
                        } catch (Exception e) {
                            e.printStackTrace();
                        }
                    %>
                </tbody>
            </table>
            <h2>Job Listings</h2>
            <div class="scrollable-table">
                <table class="summary-table">
                    <thead>
                        <tr>
                            <th>Posting ID</th>
                            <th>Position ID</th>
                            <th>Company ID</th>
                            <th>Branch ID</th>
                            <th>Posting Date</th>
                            <th>Expiry Date</th>
                            <th>Status</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% 
                            try {
                                Class.forName("com.mysql.cj.jdbc.Driver");
                                Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/group3s15?useSSL=false&serverTimezone=UTC", "root", "123456789"); 
                                PreparedStatement pstmt = conn.prepareStatement("SELECT posting_ID, position_ID, company_ID, branch_ID, posting_date, expiry_date, status FROM job_postings");
                                ResultSet rs = pstmt.executeQuery();
                                
                                while (rs.next()) {
                        %>
                        <tr>
                            <td><%= rs.getInt("posting_ID") %></td>
                            <td><%= rs.getInt("position_ID") %></td>
                            <td><%= rs.getInt("company_ID") %></td>
                            <td><%= rs.getInt("branch_ID") %></td>
                            <td><%= rs.getDate("posting_date") %></td>
                            <td><%= rs.getDate("expiry_date") %></td>
                            <td><%= rs.getString("status") %></td>
                        </tr>
                        <% 
                                }
                                rs.close();
                                pstmt.close();
                                conn.close();
                            } catch (Exception e) {
                                e.printStackTrace();
                            }
                        %>
                    </tbody>
                </table>
            </div>
            <a href="generate_reports.jsp" class="back-button">Back to Reports</a>
        </div>
    </body>
</html>
