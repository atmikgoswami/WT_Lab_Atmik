package WT_Lab_Atmik.q18;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.Random;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class StockPriceServlet extends HttpServlet {
    private Random random = new Random();

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("text/event-stream");
        response.setCharacterEncoding("UTF-8");

        PrintWriter out = response.getWriter();

        Thread aaplThread = new Thread(new StockPriceUpdater("AAPL", 150, 10, out, 5000));
        Thread googThread = new Thread(new StockPriceUpdater("GOOG", 2700, 50, out, 3000));

        aaplThread.start();
        googThread.start();

        try {
            aaplThread.join();
            googThread.join();
        } catch (InterruptedException e) {
            e.printStackTrace();
        }

        out.close();
    }

    private class StockPriceUpdater implements Runnable {
        private String stockSymbol;
        private double basePrice;
        private double priceVariance;
        private PrintWriter out;
        private int timeout;

        public StockPriceUpdater(String stockSymbol, double basePrice, double priceVariance, PrintWriter out, int timeout) {
            this.stockSymbol = stockSymbol;
            this.basePrice = basePrice;
            this.priceVariance = priceVariance;
            this.out = out;
            this.timeout = timeout;
        }

        @Override
        public void run() {
            try {
                while (true) {
                    double price = basePrice + random.nextDouble() * priceVariance;

                    synchronized (out) {  
                        out.write("event: " + stockSymbol + "\n");
                        out.write("data: " + String.format("%.2f", price) + "\n\n");
                        out.flush();
                    }

                    Thread.sleep(timeout);
                }
            } catch (InterruptedException e) {
                Thread.currentThread().interrupt();
            }
        }
    }
}