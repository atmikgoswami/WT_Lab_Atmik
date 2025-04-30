<%@ page import="java.sql.*" %>
<%
    String username = request.getParameter("login_name");
    String password = request.getParameter("password");
    String fullName = request.getParameter("full_name");
    String email = request.getParameter("email");

    Connection conn = null;
    PreparedStatement checkStmt = null;
    PreparedStatement insertStmt = null;
    ResultSet rs = null;

    try {
        Class.forName("com.mysql.jdbc.Driver");
        conn = DriverManager.getConnection("jdbc:mysql://172.16.4.234:3306/test", "be22104", "bChaVGIP");

        String checkQuery = "SELECT login_name, email FROM accounts_1104 WHERE login_name=? OR email=?";
        checkStmt = conn.prepareStatement(checkQuery);
        checkStmt.setString(1, username);
        checkStmt.setString(2, email);
        rs = checkStmt.executeQuery();

        boolean usernameExists = false;
        boolean emailExists = false;

        while (rs.next()) {
            if (rs.getString("login_name").equals(username)) {
                usernameExists = true;
            }
            if (rs.getString("email").equals(email)) {
                emailExists = true;
            }
        }

        if (usernameExists) {
            out.print("<p style='color:red;'>Username already taken!</p>");
        } else if (emailExists) {
            out.print("<p style='color:red;'>Email already registered!</p>");
        } else {
            String insertQuery = "INSERT INTO accounts_1104 (login_name, password, full_name, email) VALUES (?, ?, ?, ?)";
            insertStmt = conn.prepareStatement(insertQuery);
            insertStmt.setString(1, username);
            insertStmt.setString(2, password);
            insertStmt.setString(3, fullName);
            insertStmt.setString(4, email);
            insertStmt.executeUpdate();

            out.print("<p style='color:green;'>Account created successfully!</p>");
        }
    } catch (SQLIntegrityConstraintViolationException e) {
        if (e.getMessage().contains("accounts.login_name")) {
            out.print("<p style='color:red;'>Error: Username already exists!</p>");
        } else if (e.getMessage().contains("accounts.email")) {
            out.print("<p style='color:red;'>Error: Email already exists!</p>");
        } else {
            out.print("<p style='color:red;'>Error: Duplicate entry!</p>");
        }
    } catch (Exception e) {
        out.print("<p style='color:red;'>Error: " + e.getMessage() + "</p>");
    } finally {
        if (rs != null) try { rs.close(); } catch (Exception ignored) {}
        if (checkStmt != null) try { checkStmt.close(); } catch (Exception ignored) {}
        if (insertStmt != null) try { insertStmt.close(); } catch (Exception ignored) {}
        if (conn != null) try { conn.close(); } catch (Exception ignored) {}
    }
%>
