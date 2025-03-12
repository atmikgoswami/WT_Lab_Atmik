package WT_Lab_Atmik.q19;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.*;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/departmentSearch")
public class DepartmentSearchServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    // Load MySQL Driver Once
    static {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            throw new RuntimeException("MySQL Driver not found!", e);
        }
    }

    // Local Database Credentials
    private static final String DB_URL = "jdbc:mysql://localhost:3306/1104_local_db?serverTimezone=UTC&useSSL=false&allowPublicKeyRetrieval=true";
    private static final String DB_USER = "root"; // Change this to your local MySQL username
    private static final String DB_PASSWORD = "root"; // Change this to your local MySQL password

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String deptId = request.getParameter("deptId");

        response.setContentType("text/html");
        PrintWriter out = response.getWriter();

        out.println("<html><head><title>Department Search</title></head><body>");
        out.println("<h2>Department Students</h2>");

        if (deptId != null) {
            try (Connection connection = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD)) {
                System.out.println("✅ Connected to Database Successfully!");

                String query = "SELECT name, roll_no, d.dept_name FROM students s " +
                               "JOIN departments d ON s.dept_id = d.dept_id WHERE s.dept_id = ?";
                
                try (PreparedStatement stmt = connection.prepareStatement(query)) {
                    stmt.setInt(1, Integer.parseInt(deptId));

                    try (ResultSet resultSet = stmt.executeQuery()) {
                        out.println("<table border='1'><tr><th>Student Name</th><th>Roll Number</th><th>Department</th></tr>");

                        boolean hasResults = false;
                        while (resultSet.next()) {
                            hasResults = true;
                            String studentName = resultSet.getString("name");
                            String rollNo = resultSet.getString("roll_no");
                            String deptName = resultSet.getString("dept_name");

                            out.println("<tr><td>" + studentName + "</td><td>" + rollNo + "</td><td>" + deptName + "</td></tr>");
                        }

                        if (!hasResults) {
                            out.println("<tr><td colspan='3'>No students found in this department.</td></tr>");
                        }

                        out.println("</table>");
                    }
                }
            } catch (SQLException e) {
                e.printStackTrace();
                out.println("<p>Error connecting to database: " + e.getMessage() + "</p>");
            }
        }

        out.println("<hr>");
        out.println("<form action='departmentSearch' method='get'>");
        out.println("<label for='deptId'>Select Department:</label>");
        out.println("<select id='deptId' name='deptId'>");

        try (Connection connection = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD)) {
            System.out.println("✅ Database Connected Successfully!");
            Statement stmt = connection.createStatement();
            ResultSet resultSet = stmt.executeQuery("SELECT dept_id, dept_name FROM departments");

            while (resultSet.next()) {
                int deptIdFromDB = resultSet.getInt("dept_id");
                String deptName = resultSet.getString("dept_name");
                System.out.println("🔹 Found: " + deptIdFromDB + " - " + deptName);
                out.println("<option value='" + deptIdFromDB + "'>" + deptName + "</option>");
            }
        } catch (SQLException e) {
            e.printStackTrace();
            out.println("<p>Error fetching departments: " + e.getMessage() + "</p>");
        }

        out.println("</select>");
        out.println("<input type='submit' value='Search'>");
        out.println("</form>");
        out.println("</body></html>");
    }
}
