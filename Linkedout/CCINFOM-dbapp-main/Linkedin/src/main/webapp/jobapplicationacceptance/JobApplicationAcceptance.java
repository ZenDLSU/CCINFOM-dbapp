import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/JobApplicationAcceptance")
public class JobApplicationAcceptance extends HttpServlet {
	private static final long serialVersionUID = 1L;

	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		HttpSession session = request.getSession();
		String action = request.getParameter("action");
		if (action != null && action.equals("acceptJob")) {
			int jobId = Integer.parseInt(request.getParameter("jobId"));
			try {
				updateJobStatus(jobId, session);
				response.sendRedirect("JobApplicationAcceptanceConfirmation.html");
			} catch (SQLException e) {
				e.printStackTrace();
				response.sendRedirect("error.html");
			}
		} else {
			List<JobApplication> jobApplications = new ArrayList<>();
			try {
				jobApplications = getJobApplications(session);
			} catch (SQLException e) {
				e.printStackTrace();
				response.sendRedirect("error.html");
			}
			request.setAttribute("jobApplications", jobApplications);
			request.getRequestDispatcher("JobApplicationAcceptance.html").forward(request, response);
		}
	}

	private List<JobApplication> getJobApplications(HttpSession session) throws SQLException {
		List<JobApplication> jobApplications = new ArrayList<>();
		String userId = (String) session.getAttribute("userId");
		try (Connection connection = DriverManager.getConnection("jdbc:mysql://localhost:3306/your_database", "username",
				"password");
				PreparedStatement statement = connection
						.prepareStatement("SELECT job_id, job_title, status FROM job_applications WHERE user_id = ?")) {
			statement.setString(1 , userId);
			ResultSet resultSet = statement.executeQuery();
			while (resultSet.next()) {
				int jobId = resultSet.getInt("job_id");
				String jobTitle = resultSet.getString("job_title");
				String status = resultSet.getString("status");
				jobApplications.add(new JobApplication(jobId, jobTitle, status));
			}
		}
		return jobApplications;
	}

	private void updateJobStatus(int jobId, HttpSession session) throws SQLException {
		String userId = (String) session.getAttribute("userId");
		try (Connection connection = DriverManager.getConnection("jdbc:mysql://localhost:3306/your_database", "username",
				"password");
				PreparedStatement statement = connection
						.prepareStatement("UPDATE user_accounts SET job_id = ? WHERE user_id = ?")) {
			statement.setInt(1, jobId);
			statement.setString(2, userId);
			statement.executeUpdate();
		}
	}
}