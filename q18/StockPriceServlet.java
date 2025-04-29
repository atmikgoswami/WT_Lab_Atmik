package WT_Lab_Atmik.q18;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.Random;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/WT_Lab_Atmik/q18/stocks")
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
                double aaplPrice = 150 + random.nextDouble() * 10;
                double googPrice = 2700 + random.nextDouble() * 50;

                out.write("event: AAPL\n");
                out.write("data: " + String.format("%.2f", aaplPrice) + "\n\n");

                out.write("event: GOOG\n");
                out.write("data: " + String.format("%.2f", googPrice) + "\n\n");

                out.flush();
                Thread.sleep(3000);
            } catch (InterruptedException e) {
                break;
            }
        }

        out.close();
    }
}
