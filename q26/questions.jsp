<%@ page import="java.sql.*, java.util.*" %>
<%@ page import="WT_Lab_Atmik.q25.XMLQuestionImporter" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Questions</title>
</head>
<body>
    <h2>Answer the Questions</h2>

    <form action="checkAnswers.jsp" method="POST">
        <%
            // Database connection details
            String dbUrl = "jdbc:mysql://localhost:3306/1104_local_db";
            String dbUsername = "root";
            String dbPassword = "root";
            Connection conn = null;
            Statement stmt = null;
            ResultSet rs = null;

            try {
                // Establish connection
                conn = DriverManager.getConnection(dbUrl, dbUsername, dbPassword);
                stmt = conn.createStatement();

                String query = "SELECT question_text, option_a, option_b, option_c, option_d FROM questions";
                rs = stmt.executeQuery(query);
                while (rs.next()) {
                    String questionText = rs.getString("question_text");
                    String optionA = rs.getString("option_a");
                    String optionB = rs.getString("option_b");
                    String optionC = rs.getString("option_c");
                    String optionD = rs.getString("option_d");
        %>
        <div>
            <p><strong><%= questionText %></strong></p>
            <label><input type="radio" name="question_<%= rs.getRow() %>" value="A"> <%= optionA %></label><br>
            <label><input type="radio" name="question_<%= rs.getRow() %>" value="B"> <%= optionB %></label><br>
            <label><input type="radio" name="question_<%= rs.getRow() %>" value="C"> <%= optionC %></label><br>
            <label><input type="radio" name="question_<%= rs.getRow() %>" value="D"> <%= optionD %></label><br>
            <br>
        </div>
        <%
                }
            } catch (SQLException e) {
                e.printStackTrace();
            } finally {
                // Close resources
                try {
                    if (rs != null) rs.close();
                    if (stmt != null) stmt.close();
                    if (conn != null) conn.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
        %>

        <input type="submit" value="Submit Answers">
    </form>
</body>
</html>
