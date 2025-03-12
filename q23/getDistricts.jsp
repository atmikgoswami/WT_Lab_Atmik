<%@ page import="java.sql.*" %>
<%
    String state = request.getParameter("state");
    Connection conn = null;
    PreparedStatement stmt = null;
    ResultSet rs = null;

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/1104_local_db", "root", "root");

        String query = "SELECT d.district_name FROM districts d INNER JOIN states s ON d.state_id = s.id WHERE s.state_name=?";
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
