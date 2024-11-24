<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="link.JobApplication" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Job Application Report</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            margin: 0;
            background-color: #f4f4f9;
        }
        .report-container {
            width: 800px;
            padding: 20px;
            background: white;
            border-radius: 8px;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
        }
        .report-container h1 {
            text-align: center;
            margin-bottom: 20px;
        }
        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
        }
        table, th, td {
            border: 1px solid #ddd;
            padding: 8px;
        }
        th {
            background-color: #f2f2f2;
            text-align: left;
        }
        tr:hover {
            background-color: #f1f1f1;
        }
    </style>
</head>
<body>
    <div class="report-container">
        <h1>Job Application Report</h1>
        <table>
            <thead>
                <tr>
                    <th>Job ID</th>
                    <th>Position Name</th>
                    <th>Status</th>
                    <th>Posting Date</th>
                    <th>Expiry Date</th>
                </tr>
            </thead>
            <tbody>
                <% 
                    // Retrieve the job applications from the request attribute
                    List<JobApplication> jobApplications = (List<JobApplication>) request.getAttribute("jobApplications");
                    if (jobApplications != null && !jobApplications.isEmpty()) {
                       <%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="link.JobApplication" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Job Application Report</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            margin: 0;
            background-color: #f4f4f9;
        }
        .report-container {
            width: 800px;
            padding: 20px;
            background: white;
            border-radius: 8px;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
        }
        .report-container h1 {
            text-align: center;
            margin-bottom: 20px;
        }
        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
        }
        table, th, td {
            border: 1px solid #ddd;
            padding: 8px;
        }
        th {
            background-color: #f2f2f2;
            text-align: left;
        }
        tr:hover {
            background-color: #f1f1f1;
        }
    </style>
</head>
<body>
    <div class="report-container">
        <h1>Job Application Report</h1>
        <table>
            <thead>
                <tr>
                    <th>Job ID</th>
                    <th>Position Name</th>
                    <th>Status</th>
                    <th>Posting Date</th>
                    <th>Expiry Date</th>
                </tr>
            </thead>
            <tbody>
                <% 
                    // Retrieve the job applications from the request attribute
                    List<JobApplication> jobApplications = (List<JobApplication>) request.getAttribute("jobApplications");
                    if (jobApplications != null && !jobApplications.isEmpty()) {   for (JobApplication job : jobApplications) {
                        %>
                        <tr>
                            <td><%= job.getJobId() %></td>
                            <td><%= job.getPositionName() %></td>
                            <td><%= job.getStatus() %></td>
                            <td><%= job.getPostingDate() %></td>
                            <td><%= job.getExpiryDate() %></td>
                        </tr>
                        <% 
                                }
                            } else {
                        %>
                        <tr>
                            <td colspan="5" style="text-align: center;">No job applications found.</td>
                        </tr>
                        <% } %>
                    </tbody>
                </table>
            </div>
        </body>
        </html>
                       