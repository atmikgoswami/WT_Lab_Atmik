<%@ page import="java.sql.*, java.util.*" %>
<%
    String dbUrl = "jdbc:mysql://localhost:3306/1104_local_db";
    String dbUsername = "root";
    String dbPassword = "root";

    Connection conn = null;
    PreparedStatement stmt = null;
    ResultSet rs = null;

    double totalPrice = 0.0;
    Map<String, String> selectedComponents = new HashMap<>();
    selectedComponents.put("HDD", request.getParameter("hdd"));
    selectedComponents.put("Motherboard", request.getParameter("motherboard"));
    selectedComponents.put("Processor", request.getParameter("processor"));
    selectedComponents.put("RAM", request.getParameter("ram"));
    selectedComponents.put("Monitor", request.getParameter("monitor"));
    selectedComponents.put("CD/DVD R/W", request.getParameter("cd_dvd"));

    try {
        conn = DriverManager.getConnection(dbUrl, dbUsername, dbPassword);

        for (Map.Entry<String, String> entry : selectedComponents.entrySet()) {
            if (entry.getValue() != null && !entry.getValue().isEmpty()) {
                String sql = "SELECT price FROM computer_components WHERE component_type = ? AND model = ?";
                stmt = conn.prepareStatement(sql);
                stmt.setString(1, entry.getKey());
                stmt.setString(2, entry.getValue());
                rs = stmt.executeQuery();

                if (rs.next()) {
                    totalPrice += rs.getDouble("price");
                }
            }
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
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>System Price</title>
</head>
<body>
    <h2>Selected Configuration</h2>
    <ul>
        <%
            for (Map.Entry<String, String> entry : selectedComponents.entrySet()) {
                if (entry.getValue() != null && !entry.getValue().isEmpty()) {
        %>
        <li><strong><%= entry.getKey() %>:</strong> <%= entry.getValue() %></li>
        <%
                }
            }
        %>
    </ul>
    
    <h2>Total Price: ₹<%= totalPrice %></h2>

    <br>
    <a href="index.html">Go Back</a>
</body>
</html>
