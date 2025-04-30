import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.parsers.DocumentBuilder;
import org.w3c.dom.Document;
import org.xml.sax.InputSource;

public class validateXML {
    public static void main(String[] args) {
        try {
            DocumentBuilderFactory factory = DocumentBuilderFactory.newInstance();
            factory.setValidating(true);  

            DocumentBuilder builder = factory.newDocumentBuilder();

            Document document = builder.parse(new InputSource("questions.xml"));

            System.out.println("XML is valid!");
        } catch (Exception e) {
            System.err.println("XML Validation failed: " + e.getMessage());
        }
    }
}

