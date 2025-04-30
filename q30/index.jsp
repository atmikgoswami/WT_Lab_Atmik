<%@ page import="java.sql.*, java.util.*, javax.sql.*" %>
<%@ page contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Select Computer Components</title>
</head>
<body>
    <h2>Select Computer Components</h2>
    <%
        String url = "jdbc:mysql://172.16.4.234:3306/test"; 
        String user = "be22104"; 
        String password = "bChaVGIP"; 

        String query = "SELECT * FROM computer_components_1104";

        Map<String, List<String>> components = new HashMap<>();
        components.put("HDD", new ArrayList<>());
        components.put("Motherboard", new ArrayList<>());
        components.put("Processor", new ArrayList<>());
        components.put("RAM", new ArrayList<>());
        components.put("Monitor", new ArrayList<>());
        components.put("CD/DVD", new ArrayList<>());

        Connection conn = null;
        Statement stmt = null;
        ResultSet rs = null;

        try {
            Class.forName("com.mysql.jdbc.Driver");
            conn = DriverManager.getConnection(url, user, password);
            stmt = conn.createStatement();
            rs = stmt.executeQuery(query);

            while (rs.next()) {
                String componentType = rs.getString("component_type");
                String model = rs.getString("manufacturer") + " - " + rs.getString("model");

                if (componentType.equals("CD/DVD R/W")) {
                    componentType = "CD/DVD"; 
                }

                if (components.containsKey(componentType)) {
                    components.get(componentType).add(model);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try {
                if (rs != null) rs.close();
                if (stmt != null) stmt.close();
                if (conn != null) conn.close();
            } catch (SQLException se) {
                se.printStackTrace();
            }
        }
    %>

    <form action="calculatePrice.jsp" method="POST">
        <label for="hdd">HDD:</label>
        <select name="hdd" id="hdd">
            <option value="">Select HDD</option>
            <% for (String hdd : components.get("HDD")) { %>
                <option value="<%= hdd %>"><%= hdd %></option>
            <% } %>
        </select>
        <br><br>

        <label for="motherboard">Motherboard:</label>
        <select name="motherboard" id="motherboard">
            <option value="">Select Motherboard</option>
            <% for (String motherboard : components.get("Motherboard")) { %>
                <option value="<%= motherboard %>"><%= motherboard %></option>
            <% } %>
        </select>
        <br><br>

        <label for="processor">Processor:</label>
        <select name="processor" id="processor">
            <option value="">Select Processor</option>
            <% for (String processor : components.get("Processor")) { %>
                <option value="<%= processor %>"><%= processor %></option>
            <% } %>
        </select>
        <br><br>

        <label for="ram">RAM:</label>
        <select name="ram" id="ram">
            <option value="">Select RAM</option>
            <% for (String ram : components.get("RAM")) { %>
                <option value="<%= ram %>"><%= ram %></option>
            <% } %>
        </select>
        <br><br>

        <label for="monitor">Monitor:</label>
        <select name="monitor" id="monitor">
            <option value="">Select Monitor</option>
            <% for (String monitor : components.get("Monitor")) { %>
                <option value="<%= monitor %>"><%= monitor %></option>
            <% } %>
        </select>
        <br><br>

        <label for="cd_dvd">CD/DVD R/W:</label>
        <select name="cd_dvd" id="cd_dvd">
            <option value="">Select CD/DVD R/W</option>
            <% for (String cd_dvd : components.get("CD/DVD")) { %>
                <option value="<%= cd_dvd %>"><%= cd_dvd %></option>
            <% } %>
        </select>
        <br><br>

        <input type="submit" value="Calculate Price">
    </form>
</body>
</html>
