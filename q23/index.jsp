<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>State and District Selection</title>
    <script>
        function getDistricts() {
            let state = document.getElementById("state").value;
            let districtDropdown = document.getElementById("district");
            let infoDiv = document.getElementById("info");

            // Clear previous districts and info
            districtDropdown.innerHTML = "<option value=''>Select District</option>";
            infoDiv.innerHTML = "";

            if (state === "") return; // No action if no state selected

            let xhr = new XMLHttpRequest();
            xhr.onreadystatechange = function () {
                if (xhr.readyState == 4 && xhr.status == 200) {
                    districtDropdown.innerHTML = "<option value=''>Select District</option>" + xhr.responseText;
                }
            };
            xhr.open("GET", "getDistricts.jsp?state=" + state, true);
            xhr.send();
        }

        function getDistrictInfo() {
            let district = document.getElementById("district").value;
            let infoDiv = document.getElementById("info");

            // Clear previous info when changing district
            infoDiv.innerHTML = "";

            if (district === "") return; // No action if no district selected

            let xhr = new XMLHttpRequest();
            xhr.onreadystatechange = function () {
                if (xhr.readyState == 4 && xhr.status == 200) {
                    infoDiv.innerHTML = xhr.responseText;
                }
            };
            xhr.open("GET", "getDistrictInfo.jsp?district=" + district, true);
            xhr.send();
        }
    </script>
</head>
<body>
    <h2>Select a State and District</h2>

    <label for="state">State:</label>
    <select id="state" onchange="getDistricts()">
        <option value="">Select State</option>
        <%
            Connection conn = null;
            PreparedStatement stmt = null;
            ResultSet rs = null;

            try {
                Class.forName("com.mysql.cj.jdbc.Driver");
                conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/1104_local_db", "root", "root");

                String query = "SELECT state_name FROM states";
                stmt = conn.prepareStatement(query);
                rs = stmt.executeQuery();

                while (rs.next()) {
                    String stateName = rs.getString("state_name");
                    out.print("<option value='" + stateName + "'>" + stateName + "</option>");
                }
            } catch (Exception e) {
                out.print("<option>Error Loading States</option>");
            } finally {
                if (rs != null) try { rs.close(); } catch (Exception ignored) {}
                if (stmt != null) try { stmt.close(); } catch (Exception ignored) {}
                if (conn != null) try { conn.close(); } catch (Exception ignored) {}
            }
        %>
    </select>

    <label for="district">District:</label>
    <select id="district" onchange="getDistrictInfo()">
        <option value="">Select District</option>
    </select>

    <h3>District Information:</h3>
    <div id="info"></div>
</body>
</html>
