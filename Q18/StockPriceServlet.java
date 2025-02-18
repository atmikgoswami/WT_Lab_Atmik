package WT_Lab.Q18;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.Random;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/WT_Lab/Q17/stocks")
public class StockPriceServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private Random random = new Random();

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        response.setContentType("text/event-stream");
        response.setCharacterEncoding("UTF-8");
        
        PrintWriter out = response.getWriter();

        while (true) {
            try {
                // Generate random stock prices
                double aaplPrice = 150 + random.nextDouble() * 10;
                double googPrice = 2700 + random.nextDouble() * 50;

                // Send SSE formatted data
                out.write("data: {\"AAPL\": " + String.format("%.2f", aaplPrice) + ", \"GOOG\": " + String.format("%.2f", googPrice) + "}\n\n");
                out.flush(); // Ensure data is sent immediately
                
                Thread.sleep(3000); // Update every 3 seconds
            } catch (InterruptedException e) {
                break;
            }
        }
        
        out.close();
    }
}
