import java.awt.Graphics;
import javax.swing.JFrame;
import javax.swing.JPanel;

public class HelloWorldApplet extends JPanel {
    @Override
    public void paintComponent(Graphics g) {
        super.paintComponent(g);
        g.drawString("Hello World", 100, 100); // Draw "Hello World" at coordinates (100, 100)
    }

    public static void main(String[] args) {
        JFrame frame = new JFrame("HelloWorldApplet");
        frame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
        frame.setSize(300, 200);
        frame.add(new HelloWorldApplet());
        frame.setVisible(true);
    }
}
