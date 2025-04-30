package WT_Lab_Atmik.q19;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.*;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class StudentSearchServlet extends HttpServlet {

    static {
        try {
            Class.forName("com.mysql.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            throw new RuntimeException("MySQL Driver not found!", e);
        }
    }

    private static final String DB_URL = "jdbc:mysql://172.16.4.234:3306/test";
    private static final String DB_USER = "be22104"; 
    private static final String DB_PASSWORD = "bChaVGIP"; 

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String searchString = request.getParameter("searchString");

        response.setContentType("text/html");
        PrintWriter out = response.getWriter();

        out.println("<html><head><title>Student Search</title></head><body>");
        out.println("<h2>Search Results</h2>");

        if (searchString != null && !searchString.trim().isEmpty()) {
            try (Connection connection = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD)) {
                System.out.println("Connected to Database Successfully!");

                String query = "SELECT s.name, s.roll_no, d.dept_name FROM students_1104 s " +
                               "JOIN departments_1104 d ON s.dept_id = d.dept_id WHERE s.name LIKE ?";
                
                try (PreparedStatement stmt = connection.prepareStatement(query)) {
                    stmt.setString(1, "%" + searchString + "%");

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
                            out.println("<tr><td colspan='3'>No students found.</td></tr>");
                        }

                        out.println("</table>");
                    }
                }
            } catch (SQLException e) {
                e.printStackTrace();
                out.println("<p>Error connecting to database: " + e.getMessage() + "</p>");
            }
        } else {
            out.println("<p>Please enter a search string.</p>");
        }

        out.println("<hr>");
        out.println("<form action='studentSearch' method='get'>");
        out.println("<label for='searchString'>Enter student name to search:</label>");
        out.println("<input type='text' id='searchString' name='searchString'>");
        out.println("<input type='submit' value='Search'>");
        out.println("</form>");
        out.println("</body></html>");
    }
}
