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
            
            // Extract and validate parameters
            String rParam = request.getParameter("r");
            String xParam = request.getParameter("x");
            String yParam = request.getParameter("y");

            if (rParam == null || xParam == null || yParam == null) {
                sendErrorPage(response, "Missing required parameters: r, x, y");
                return;
            }

            double r, x, y;
            try {
                r = Double.parseDouble(rParam);
                x = Double.parseDouble(xParam);
                y = Double.parseDouble(yParam);
            } catch (NumberFormatException e) {
                sendErrorPage(response, "Invalid parameter format: parameters must be numbers");
                return;
            }

            // Validate parameter ranges
            if (Double.isNaN(r) || Double.isNaN(x) || Double.isNaN(y) ||
                Double.isInfinite(r) || Double.isInfinite(x) || Double.isInfinite(y)) {
                sendErrorPage(response, "Invalid parameter values");
                return;
            }

            // Measure execution time
            long before = System.nanoTime();
            Instant currentInstant = Instant.now();

            // Check point
            PointResult result = PointChecker.handlePointCheck(x, y, r);
            
            // Set timestamp and execution time
            result.setTime(currentInstant.toString());
            long after = System.nanoTime();
            result.setTook((after - before) / 1000000 + "ms");

            // Get session and save to history
            HttpSession session = request.getSession(true);
            HistoryService.writeHistory(session, result);

            // Generate and send HTML response
            sendResultPage(response, result, x, y, r, request.getContextPath());

        } catch (Exception e) {
            sendErrorPage(response, "Internal server error: " + e.getMessage());
            e.printStackTrace(); // In production, use proper logging
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
    
    private void sendResultPage(HttpServletResponse response, PointResult result, double x, double y, double r, String contextPath) throws IOException {
        PrintWriter out = response.getWriter();
        boolean success = result.isSuccess();
        String cardClass = success ? "card-success" : "card-failure";
        String resultClass = success ? "result-success" : "result-failure";
        String resultText = success ? "✅ Point is within the area" : "❌ Point is outside the area";
        String resultStatus = success ? "Success" : "Failure";
        String time = result.getTime() != null ? escapeHtml(result.getTime()) : "N/A";
        String took = result.getTook() != null ? escapeHtml(result.getTook()) : "N/A";
        
        out.println("<!DOCTYPE html>");
        out.println("<html>");
        out.println("<head>");
        out.println("<meta charset=\"UTF-8\">");
        out.println("<link href=\"data:image/x-icon;base64,AAABAAEAEBAQAAEABAAoAQAAFgAAACgAAAAQAAAAIAAAAAEABAAAAAAAgAAAAAAAAAAAAAAAEAAAAAAAAAD9/f0AAAAAAAICAgD///8ANCvaAMPDwwAbGxsABgYGACYmJgD+/v4AAQEBAE9PTwAKCgoAaGhoABUVFQAAAAAAERETMzMzERERERMzMzEREREREzMzMRERERERMzMRERERERMxExERERM0MzM7M0ERFkMzMTM0AzETPjETMRODEbpTMRMxExMxEbExEzEToxERMRETMRETEREzMzMzMzMxETMxzTMzMzERMztZMyMzMREzN6MRETMxERMRyhERExHwBwAA8A8AAPAPAAD4HwAAgAcAAAABAACAAAAAAAEAAAAAAADAAQAAgAEAAIAAAACAAAAAgAAAAIAgAADE8QAA\" rel=\"icon\" type=\"image/x-icon\">");
        out.println("<link rel=\"preconnect\" href=\"https://fonts.googleapis.com\">");
        out.println("<link rel=\"preconnect\" href=\"https://fonts.gstatic.com\" crossorigin>");
        out.println("<link href=\"https://fonts.googleapis.com/css2?family=Dela+Gothic+One&family=Roboto:ital,wght@0,100..900;1,100..900&display=swap\" rel=\"stylesheet\">");
        out.println("<script src=\"" + contextPath + "/static/randombg.js\" defer></script>");
        out.println("<style>");
        out.println("body { font-family: 'Roboto', sans-serif; margin: 0; padding: 20px; background-size: auto; background-position: center; transition: background-image 0.5s ease-in-out; background-repeat: repeat; }");
        out.println("h1 { font-family: Dela Gothic One, monospace; font-style: normal; font-weight: 400; text-align: center; }");
        out.println("h1::before, h1::after { content: \"🌟\"; }");
        out.println(".header { width: stretch; border-radius: 24px; margin: 4px; margin-bottom: 20px; box-shadow: 0 8px 32px 0 rgba(31, 38, 135, 0.18); backdrop-filter: blur(12px) saturate(160%); -webkit-backdrop-filter: blur(12px) saturate(160%); border: 1px solid rgba(255, 255, 255, 0.3); background: linear-gradient(to right, rgba(172, 255, 47, 0.65), rgba(0, 128, 0, 0.65), rgba(172, 255, 47, 0.65)); background-size: 500% 100%; animation: gradient-animation 10s ease infinite alternate; animation-iteration-count: infinite; animation-timing-function: linear; }");
        out.println(".card { background: rgba(255, 255, 255, 0.18); border: 1px solid rgba(255, 255, 255, 0.3); border-radius: 16px; padding: 20px; margin: 20px auto; max-width: 800px; box-shadow: 0 8px 32px 0 rgba(31, 38, 135, 0.18); backdrop-filter: blur(12px) saturate(160%); -webkit-backdrop-filter: blur(12px) saturate(160%); }");
        out.println(".card-success { background: rgba(144, 238, 144, 0.4); border: 1px solid rgba(0, 128, 0, 0.3); border-radius: 12px; padding: 20px; margin: 20px auto; max-width: 800px; box-shadow: 0 4px 24px 0 rgba(31, 38, 135, 0.10); backdrop-filter: blur(8px) saturate(140%); -webkit-backdrop-filter: blur(8px) saturate(140%); }");
        out.println(".card-failure { background: rgba(240, 128, 128, 0.4); border: 1px solid rgba(255, 0, 0, 0.3); border-radius: 12px; padding: 20px; margin: 20px auto; max-width: 800px; box-shadow: 0 4px 24px 0 rgba(31, 38, 135, 0.10); backdrop-filter: blur(8px) saturate(140%); -webkit-backdrop-filter: blur(8px) saturate(140%); }");
        out.println("table { width: 100%; border-collapse: collapse; margin: 20px 0; }");
        out.println("table th, table td { padding: 12px; text-align: left; border-bottom: 1px solid rgba(255, 255, 255, 0.3); }");
        out.println("table th { background: rgba(255, 255, 255, 0.2); font-weight: bold; }");
        out.println(".result-display { text-align: center; font-size: 24px; font-weight: bold; margin: 20px 0; }");
        out.println(".result-success { color: green; }");
        out.println(".result-failure { color: red; }");
        out.println(".link-button { display: inline-block; padding: 15px 30px; margin: 20px auto; text-align: center; text-decoration: none; font-family: Dela Gothic One, monospace; font-size: large; border-radius: 8px; background-color: rgba(172, 255, 47, 0.5); border: 1px solid rgba(0, 128, 0, 0.3); color: black; box-shadow: 0 4px 24px 0 rgba(31, 38, 135, 0.10); backdrop-filter: blur(8px) saturate(140%); -webkit-backdrop-filter: blur(8px) saturate(140%); transition: all 0.25s; }");
        out.println(".link-button:hover { background-color: rgba(0, 0, 0, 0.5); border: 1px solid rgba(118, 124, 118, 0.3); color: white; box-shadow: 0 4px 24px 0 rgba(0, 0, 0, 0.228); transform: scale(1.01); }");
        out.println(".link-container { text-align: center; margin-top: 30px; }");
        out.println("@keyframes gradient-animation { 0% { background-position: 0% 50%; } 100% { background-position: 100% 50%; } }");
        out.println("</style>");
        out.println("<title>Area Check Result</title>");
        out.println("</head>");
        out.println("<body>");
        out.println("<div class=\"header\">");
        out.println("<h1>Турыгин Никита Денисович P3231 467783</h1>");
        out.println("</div>");
        out.println("<div class=\"card\">");
        out.println("<h2>Received Parameters</h2>");
        out.println("<table>");
        out.println("<tr><th>Parameter</th><th>Value</th></tr>");
        out.println("<tr><td>X</td><td>" + x + "</td></tr>");
        out.println("<tr><td>Y</td><td>" + y + "</td></tr>");
        out.println("<tr><td>R</td><td>" + r + "</td></tr>");
        out.println("</table>");
        out.println("</div>");
        out.println("<div class=\"" + cardClass + "\">");
        out.println("<h2>Check Result</h2>");
        out.println("<div class=\"result-display " + resultClass + "\">" + escapeHtml(resultText) + "</div>");
        out.println("<table>");
        out.println("<tr><th>Property</th><th>Value</th></tr>");
        out.println("<tr><td>Result</td><td>" + escapeHtml(resultStatus) + "</td></tr>");
        out.println("<tr><td>Coordinates</td><td>(" + x + ", " + y + ")</td></tr>");
        out.println("<tr><td>Radius</td><td>" + r + "</td></tr>");
        out.println("<tr><td>Timestamp</td><td>" + time + "</td></tr>");
        out.println("<tr><td>Execution Time</td><td>" + took + "</td></tr>");
        out.println("</table>");
        out.println("</div>");
        out.println("<div class=\"link-container\">");
        out.println("<a href=\"" + contextPath + "/index.jsp\" class=\"link-button\">Create New Request</a>");
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

