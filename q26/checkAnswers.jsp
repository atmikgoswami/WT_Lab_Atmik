<%@ page import="java.sql.*, java.util.*" %>
<%
    // Check if there are any submitted answers
    boolean hasAnswers = false;
    Enumeration<String> parameterNames = request.getParameterNames();
    while (parameterNames.hasMoreElements()) {
        hasAnswers = true;
        break;
    }

    // Redirect to questions.jsp if accessed directly without form submission
    if (!hasAnswers) {
        response.sendRedirect("questions.jsp");
        return;
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Check Answers</title>
</head>
<body>
    <h2>Your Results</h2>

    <%
        // Database connection details
        String dbUrl = "jdbc:mysql://localhost:3306/1104_local_db";
        String dbUsername = "root";
        String dbPassword = "root";
        Connection conn = null;
        Statement stmt = null;
        ResultSet rs = null;

        int correctAnswersCount = 0;
        int totalQuestions = 0;

        try {
            // Establish connection to the database
            conn = DriverManager.getConnection(dbUrl, dbUsername, dbPassword);
            stmt = conn.createStatement();

            String query = "SELECT * FROM questions";
            rs = stmt.executeQuery(query);

            while (rs.next()) {
                String questionText = rs.getString("question_text");
                String correctAnswer = rs.getString("answer"); 
                String userAnswer = request.getParameter("question_" + rs.getRow());

                if (userAnswer != null && userAnswer.equals(correctAnswer)) {
                    correctAnswersCount++;
                }
                totalQuestions++; 
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            try {
                if (rs != null) rs.close();
                if (stmt != null) stmt.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }

        // Display the results to the user
        out.println("<h3>You answered " + correctAnswersCount + " out of " + totalQuestions + " questions correctly!</h3>");
        if (correctAnswersCount == totalQuestions) {
            out.println("<p>Congratulations! You answered all questions correctly.</p>");
        } else {
            out.println("<p>Keep practicing! You can improve your score.</p>");
        }
    %>

    <br>
    <a href="questions.jsp">Try Again</a>
</body>
</html>
