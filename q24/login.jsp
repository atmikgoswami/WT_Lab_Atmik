<%@ page import="java.sql.*" %>
<%
    String username = request.getParameter("login_name");
    String password = request.getParameter("password");

    Connection conn = null;
    PreparedStatement stmt = null;
    ResultSet rs = null;

    try {
        Class.forName("com.mysql.jdbc.Driver");
        conn = DriverManager.getConnection("jdbc:mysql://172.16.4.234:3306/test", "be22104", "bChaVGIP");

        String query = "SELECT * FROM accounts_1104 WHERE login_name=?";
        stmt = conn.prepareStatement(query);
        stmt.setString(1, username);
        rs = stmt.executeQuery();

        if (!rs.next()) {
            out.print("Login name not valid");
        } else {
            String dbPassword = rs.getString("password");
            if (dbPassword.equals(password)) {
                out.print("success"); 
            } else {
                out.print("Incorrect password");
            }
        }
    } catch (Exception e) {
        out.print("Error: " + e.getMessage());
    } finally {
        if (rs != null) try { rs.close(); } catch (Exception ignored) {}
        if (stmt != null) try { stmt.close(); } catch (Exception ignored) {}
        if (conn != null) try { conn.close(); } catch (Exception ignored) {}
    }
%>
