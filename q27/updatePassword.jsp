<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ page import="java.io.*, java.sql.*, javax.servlet.*, javax.servlet.http.*" %>
<%@ page import="javax.servlet.annotation.MultipartConfig" %>
<%@ page session="true" %>

<%
    if ("POST".equalsIgnoreCase(request.getMethod())) {
        String loginname = request.getParameter("loginname");
        String oldPassword = request.getParameter("oldPassword");
        String newPassword = request.getParameter("newPassword");

        if (!loginname.isEmpty() && !oldPassword.isEmpty() && !newPassword.isEmpty()) {
            Connection conn = null;
            PreparedStatement stmt = null;
            ResultSet rs = null;

            try {
                String dbUrl = "jdbc:mysql://172.16.4.234:3306/test";
                String dbUsername = "be22104";
                String dbPassword = "bChaVGIP";
                conn = DriverManager.getConnection(dbUrl, dbUsername, dbPassword);

                String checkQuery = "SELECT * FROM accounts_1104 WHERE login_name = ? AND password = ?";
                stmt = conn.prepareStatement(checkQuery);
                stmt.setString(1, loginname);  
                stmt.setString(2, oldPassword); 

                rs = stmt.executeQuery();

                if (rs.next()) {
                    String updateQuery = "UPDATE accounts_1104 SET password = ? WHERE login_name = ?";
                    stmt = conn.prepareStatement(updateQuery);
                    stmt.setString(1, newPassword);  
                    stmt.setString(2, loginname);

                    int rowsAffected = stmt.executeUpdate();
                    if (rowsAffected > 0) {
                        out.println("Password updated successfully.");
                    } else {
                        out.println("Error updating password.");
                    }
                } else {
                    out.println("Old password does not match.");
                }

            } catch (SQLException e) {
                e.printStackTrace();
                out.println("Error occurred. Please try again later.");
            } finally {
                try {
                    if (rs != null) rs.close();
                    if (stmt != null) stmt.close();
                    if (conn != null) conn.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
        } else {
            out.println("Please provide valid input.");
        }
    }
%>
