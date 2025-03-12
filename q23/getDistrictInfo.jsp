<%@ page import="java.sql.*" %>
<%
    String district = request.getParameter("district");
    Connection conn = null;
    PreparedStatement stmt = null;
    ResultSet rs = null;

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/1104_local_db", "root", "root");

        String query = "SELECT information FROM district_info d INNER JOIN districts di ON d.district_id = di.id WHERE di.district_name=?";
        stmt = conn.prepareStatement(query);
        stmt.setString(1, district);
        rs = stmt.executeQuery();

        if (rs.next()) {
            out.print("<p>" + rs.getString("information") + "</p>");
        } else {
            out.print("<p>No information available for this district.</p>");
        }
    } catch (Exception e) {
        out.print("<p>Error fetching data</p>");
    } finally {
        if (rs != null) try { rs.close(); } catch (Exception ignored) {}
        if (stmt != null) try { stmt.close(); } catch (Exception ignored) {}
        if (conn != null) try { conn.close(); } catch (Exception ignored) {}
    }
%>
