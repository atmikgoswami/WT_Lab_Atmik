<%@ page import="java.sql.*" %>
<%
    String rollNo = request.getParameter("roll_no");
    String semesterId = request.getParameter("semester_id");
    String subjectId = request.getParameter("subject_id");

    String url = "jdbc:mysql://172.16.4.234:3306/test";
    String user = "be22104";
    String password = "bChaVGIP";

    Connection conn = null;
    PreparedStatement stmt = null;
    ResultSet rs = null;

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection(url, user, password);

        String query = "SELECT m.marks_obtained, s.subject_name FROM marks_1104 m JOIN subjects_1104 s ON m.subject_id = s.subject_id WHERE m.roll_no = ? AND m.semester_id = ? AND m.subject_id = ?";
        stmt = conn.prepareStatement(query);
        stmt.setString(1, rollNo);
        stmt.setInt(2, Integer.parseInt(semesterId));
        stmt.setInt(3, Integer.parseInt(subjectId));

        rs = stmt.executeQuery();

        if (rs.next()) {
            int marks = rs.getInt("marks_obtained");
            String subjectName = rs.getString("subject_name");
%>
            <h2>Marks Details</h2>
            <p>Roll No: <%= rollNo %></p>
            <p>Semester ID: <%= semesterId %></p>
            <p>Subject: <%= subjectName %></p>
            <p>Marks Obtained: <%= marks %></p>
<%
        } else {
%>
            <p>No records found for the given inputs.</p>
<%
        }
    } catch (Exception e) {
        out.println("Error: " + e.getMessage());
    } finally {
        if (rs != null) rs.close();
        if (stmt != null) stmt.close();
        if (conn != null) conn.close();
    }
%>
