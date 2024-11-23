@WebServlet("/JobDetailsServlet")
public class JobDetailsServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int jobId = Integer.parseInt(request.getParameter("job_ID"));
        Job jobDetails = getJobDetails(jobId);
        request.setAttribute("jobDetails", jobDetails);
        RequestDispatcher dispatcher = request.getRequestDispatcher("JobDetails.html");
        dispatcher.forward(request, response);
    }

    private Job getJobDetails(int jobId) {
        Job jobDetails = null;
        try (Connection conn = Database.getConnection();
             PreparedStatement ps = conn.prepareStatement("SELECT * FROM job_postings WHERE job_ID = ?")) {
            ps.setInt(1, jobId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                jobDetails = new Job(rs.getInt("job_ID"), rs.getString("position_name"), rs.getInt("years_of_experience"), rs.getString("education"), rs.getString("company_name"), rs.getString("branch_details"));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return jobDetails;
    }
}