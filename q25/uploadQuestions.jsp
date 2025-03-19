<%@ page import="java.io.*, javax.servlet.*, javax.servlet.http.*, org.w3c.dom.*, javax.xml.parsers.*, java.sql.*" %>
<%@ page import="WT_Lab_Atmik.q25.XMLQuestionImporter" %>

<%
    // Check if the request method is POST (file upload)
    if ("POST".equalsIgnoreCase(request.getMethod())) {
        Part filePart = request.getPart("file"); 
        String fileName = filePart.getSubmittedFileName();

        // Directory to store the uploaded file
        String uploadDir = application.getRealPath("/") + "uploads/";

        File uploadDirFile = new File(uploadDir);
        if (!uploadDirFile.exists()) {
            uploadDirFile.mkdirs();
        }

        // Define the full path for the uploaded file
        String filePath = uploadDir + fileName;

        try (InputStream fileContent = filePart.getInputStream();
             OutputStream outStream = new FileOutputStream(filePath)) {

            byte[] buffer = new byte[4096];
            int bytesRead;
            while ((bytesRead = fileContent.read(buffer)) != -1) {
                outStream.write(buffer, 0, bytesRead);
            }
            try {
                XMLQuestionImporter importer = new XMLQuestionImporter(filePath);
                importer.insert();  // Insert questions into the database
                out.println("<h3>Questions have been successfully inserted into the database.</h3>");
            } catch (Exception e) {
                e.printStackTrace();
                out.println("<h3>Error inserting questions into the database: " + e.getMessage() + "</h3>");
            }

        } catch (IOException e) {
            e.printStackTrace();
            out.println("<h3>Error uploading the file.</h3>");
        }
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Upload Questions XML</title>
</head>
<body>
    <h2>Upload Questions XML File</h2>
    <form action="uploadQuestions.jsp" method="POST" enctype="multipart/form-data">
        <label for="file">Choose XML File:</label>
        <input type="file" name="file" id="file" accept=".xml" required>
        <br><br>
        <input type="submit" value="Upload">
    </form>
</body>
</html>
