<%@ page import="java.sql.*, java.security.*, java.math.*" %>
<%
    String login = request.getParameter("login");
    String password = request.getParameter("password1");
    String email = request.getParameter("email");
    String name = request.getParameter("name");
    String contact = request.getParameter("contact");

    // Hash password using SHA-256
    String hashedPassword = "";
    try {
        MessageDigest md = MessageDigest.getInstance("SHA-256");
        byte[] messageDigest = md.digest(password.getBytes());
        BigInteger no = new BigInteger(1, messageDigest);
        hashedPassword = String.format("%064x", no); // 64-char hex string
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
        PreparedStatement ps = conn.prepareStatement("INSERT INTO users (login, password, email, name, contact) VALUES (?, ?, ?, ?, ?)");
        ps.setString(1, login);
        ps.setString(2, hashedPassword);
        ps.setString(3, email);
        ps.setString(4, name);
        ps.setString(5, contact);

        int rows = ps.executeUpdate();
        if (rows > 0) {
            out.println("Account created successfully.");
        } else {
            out.println("Account creation failed.");
        }

        conn.close();
    } catch (Exception e) {
        e.printStackTrace();
        out.println("Error: " + e.getMessage());
    }
%>
