import java.io.*;
import java.net.*;

class q3{
    public static void main(String args[]){
        String serverAddress = "172.16.4.226";
        int port = 8080;
        String fileName = "/first.html";

        try(
            Socket s = new Socket(serverAddress, port);
            PrintWriter out = new PrintWriter(s.getOutputStream(), true);
            BufferedReader in = new BufferedReader(new InputStreamReader(s.getInputStream()));
        ) {

            out.println("GET "+fileName+" HTTP/1.1");
            out.println("Host:"+serverAddress);
            out.println("");

            String line;
            while((line = in.readLine())!=null){
                System.out.println(line);
            }

        } catch (Exception e) {
            System.out.println(e.getMessage());
        }
    }
}