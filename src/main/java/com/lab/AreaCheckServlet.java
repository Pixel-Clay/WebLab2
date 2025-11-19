package com.lab;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.io.PrintWriter;
import java.time.Instant;

public class AreaCheckServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            // Set character encoding
            request.setCharacterEncoding("UTF-8");
            response.setCharacterEncoding("UTF-8");
            response.setContentType("text/html;charset=UTF-8");
            
            // Extract parameters
            double r = (Double) request.getAttribute("r");
            double x = (Double) request.getAttribute("x");
            double y = (Double) request.getAttribute("y");

            // Measure execution time
            long before = System.nanoTime();
            Instant currentInstant = Instant.now();

            // Check point
            PointResult result = PointChecker.handlePointCheck(x, y, r);
            
            // Set timestamp and execution time
            // Remaking result because records are read only
            PointResult timestampedResult = new PointResult(result.success(), result.r(), result.x(), result.y(), currentInstant.toString(), (System.nanoTime() - before) / 1000000 + "ms");

            // Get session and save to history
            HttpSession session = request.getSession(true);
            HistoryService.writeHistory(session, timestampedResult);

            // Set request attributes for JSP
            request.setAttribute("result", timestampedResult);
            request.setAttribute("x", x);
            request.setAttribute("y", y);
            request.setAttribute("r", r);
            request.setAttribute("contextPath", request.getContextPath());

            // Forward to result JSP
            request.getRequestDispatcher("/result.jsp").forward(request, response);

        } catch (Exception e) {
            sendErrorPage(response, "Internal server error: " + e.getMessage());
            e.printStackTrace();
        }
    }
    
    private void sendErrorPage(HttpServletResponse response, String error) throws IOException {
        response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();
        out.println("<!DOCTYPE html>");
        out.println("<html>");
        out.println("<head>");
        out.println("<meta charset=\"UTF-8\">");
        out.println("<title>Error</title>");
        out.println("<style>");
        out.println("body { font-family: Arial, sans-serif; padding: 20px; text-align: center; }");
        out.println(".error-container { max-width: 600px; margin: 50px auto; padding: 20px; border: 2px solid #ff0000; border-radius: 8px; background-color: #ffe6e6; }");
        out.println("a { display: inline-block; margin-top: 20px; padding: 10px 20px; background-color: #4CAF50; color: white; text-decoration: none; border-radius: 4px; }");
        out.println("a:hover { background-color: #45a049; }");
        out.println("</style>");
        out.println("</head>");
        out.println("<body>");
        out.println("<div class=\"error-container\">");
        out.println("<h1>Error</h1>");
        out.println("<p>" + escapeHtml(error) + "</p>");
        out.println("<a href=\"" + response.encodeURL("/index.jsp") + "\">Return to Home</a>");
        out.println("</div>");
        out.println("</body>");
        out.println("</html>");
    }
    
    private String escapeHtml(String text) {
        if (text == null) {
            return "";
        }
        return text.replace("&", "&amp;")
                   .replace("<", "&lt;")
                   .replace(">", "&gt;")
                   .replace("\"", "&quot;")
                   .replace("'", "&#39;");
    }
}

