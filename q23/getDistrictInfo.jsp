<%@ page import="java.sql.*" %>
<%
    String district = request.getParameter("district");
    Connection conn = null;
    PreparedStatement stmt = null;
    ResultSet rs = null;

    try {
        Class.forName("com.mysql.jdbc.Driver");
        conn = DriverManager.getConnection("jdbc:mysql://172.16.4.234:3306/test", "be22104", "bChaVGIP");

        String query = "SELECT information FROM district_info_1104 d INNER JOIN districts_1104 di ON d.district_id = di.id WHERE di.district_name=?";
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
