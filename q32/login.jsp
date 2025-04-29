<%@ page import="java.sql.*, java.security.*, java.math.*" %>
<%
    String login = request.getParameter("login");
    String password = request.getParameter("password");

    // Hash the entered password using SHA-256
    String hashedPassword = "";
    try {
        MessageDigest md = MessageDigest.getInstance("SHA-256");
        byte[] messageDigest = md.digest(password.getBytes());
        BigInteger no = new BigInteger(1, messageDigest);
        hashedPassword = String.format("%064x", no);
    } catch (NoSuchAlgorithmException e) {
        out.println("Hashing error: " + e.getMessage());
        return;
    }

    String url = "jdbc:mysql://localhost:3306/1104_local_db";
    String user = "root";
    String pass = "root";

    try {
        Class.forName("com.mysql.jdbc.Driver");
        Connection conn = DriverManager.getConnection(url, user, pass);
        PreparedStatement ps = conn.prepareStatement("SELECT * FROM users WHERE login=? AND password=?");
        ps.setString(1, login);
        ps.setString(2, hashedPassword);

        ResultSet rs = ps.executeQuery();
        if (rs.next()) {
            out.println("Login successful. Welcome, " + rs.getString("name"));
        } else {
            out.println("Invalid login credentials.");
        }

        conn.close();
    } catch (Exception e) {
        e.printStackTrace();
        out.println("Error: " + e.getMessage());
    }
%>
