<%@ page import="java.sql.*" %>
<%
    String state = request.getParameter("state");
    Connection conn = null;
    PreparedStatement stmt = null;
    ResultSet rs = null;

    try {
        Class.forName("com.mysql.jdbc.Driver");
        conn = DriverManager.getConnection("jdbc:mysql://172.16.4.234:3306/test", "be22104", "bChaVGIP");

        String query = "SELECT d.district_name FROM districts_1104 d INNER JOIN states_1104 s ON d.state_id = s.id WHERE s.state_name=?";
        stmt = conn.prepareStatement(query);
        stmt.setString(1, state);
        rs = stmt.executeQuery();

        out.print("<option value=''>Select District</option>");
        while (rs.next()) {
            out.print("<option value='" + rs.getString("district_name") + "'>" + rs.getString("district_name") + "</option>");
        }
    } catch (Exception e) {
        out.print("<option>Error Loading Districts</option>");
    } finally {
        if (rs != null) try { rs.close(); } catch (Exception ignored) {}
        if (stmt != null) try { stmt.close(); } catch (Exception ignored) {}
        if (conn != null) try { conn.close(); } catch (Exception ignored) {}
    }
%>
