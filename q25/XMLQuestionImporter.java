package WT_Lab_Atmik.q25;

import org.w3c.dom.*;
import javax.xml.parsers.*;
import java.io.*;
import java.sql.*;

public class XMLQuestionImporter {

    private String xmlFileName;
    @SuppressWarnings("unused")
    private Connection connection;

    public XMLQuestionImporter(String xmlFileName) {
        this.xmlFileName = xmlFileName;
    }

    private Connection getConnection() throws SQLException {
        try {
            String dbUrl = "jdbc:mysql://172.16.4.234:3306/test";
            String username = "be22104";
            String password = "bChaVGIP";
            return DriverManager.getConnection(dbUrl, username, password);
        } catch (SQLException e) {
            throw new SQLException("Error connecting to the database", e);
        }
    }

    public void insert() throws Exception {
        Connection connection = getConnection();
        PreparedStatement stmt = null;

        try {

            File xmlFile = new File(this.xmlFileName);
            DocumentBuilderFactory factory = DocumentBuilderFactory.newInstance();
            DocumentBuilder builder = factory.newDocumentBuilder();
            Document document = builder.parse(xmlFile);
            document.getDocumentElement().normalize();

            NodeList questionsList = document.getElementsByTagName("question");
            for (int i = 0; i < questionsList.getLength(); i++) {
                Node questionNode = questionsList.item(i);
                if (questionNode.getNodeType() == Node.ELEMENT_NODE) {
                    Element questionElement = (Element) questionNode;

                    String questionText = questionElement.getElementsByTagName("text").item(0).getTextContent();
                    String optionA = questionElement.getElementsByTagName("optionA").item(0).getTextContent();
                    String optionB = questionElement.getElementsByTagName("optionB").item(0).getTextContent();
                    String optionC = questionElement.getElementsByTagName("optionC").item(0).getTextContent();
                    String optionD = questionElement.getElementsByTagName("optionD").item(0).getTextContent();
                    String answer = questionElement.getElementsByTagName("answer").item(0).getTextContent();

                    String query = "INSERT INTO questions_1104 (question_text, option_a, option_b, option_c, option_d, answer) VALUES (?, ?, ?, ?, ?, ?)";
                    stmt = connection.prepareStatement(query);
                    stmt.setString(1, questionText);
                    stmt.setString(2, optionA);
                    stmt.setString(3, optionB);
                    stmt.setString(4, optionC);
                    stmt.setString(5, optionD);
                    stmt.setString(6, answer);

                    stmt.executeUpdate();
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            throw new Exception("Error inserting questions into the database", e);
        } finally {
            if (stmt != null) {
                stmt.close();
            }
            if (connection != null) {
                connection.close();
            }
        }
    }

    public static void main(String[] args) {
        try {
            XMLQuestionImporter importer = new XMLQuestionImporter("questions.xml");
            importer.insert();
            System.out.println("Questions have been inserted into the database successfully.");
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
