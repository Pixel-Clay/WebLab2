package com.lab;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

public class ControllerServlet extends HttpServlet {
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        
        String action = request.getParameter("action");
        
        if (action == null || action.trim().isEmpty()) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("Missing action parameter");
            return;
        }
        
        HttpSession session = request.getSession(true);
        
        switch (action) {
            case "check":
                handleAreaCheck(request, response, session);
                break;
            case "reset":
                handleReset(request, response, session);
                break;
            default:
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                response.getWriter().write("Unknown action: " + action);
                break;
        }
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        if ("index".equals(action)) {
            request.getRequestDispatcher("/index.jsp").forward(request, response);
        } else {
            response.setStatus(HttpServletResponse.SC_METHOD_NOT_ALLOWED);
            response.getWriter().write("GET method not allowed. Use POST with action parameter.");
        }
    }
    
    private void handleAreaCheck(HttpServletRequest request, HttpServletResponse response, HttpSession session)
            throws ServletException, IOException {
        // Extract and validate parameters
        String rParam = request.getParameter("r");
        String xParam = request.getParameter("x");
        String yParam = request.getParameter("y");

        if (rParam == null || xParam == null || yParam == null) {
            sendErrorPage(request, response);
            return;
        }

        double r, x, y;
        try {
            r = Double.parseDouble(rParam);
            x = Double.parseDouble(xParam);
            y = Double.parseDouble(yParam);
        } catch (NumberFormatException e) {
            sendErrorPage(request, response);
            return;
        }

        // Validate parameter ranges
        if (Double.isNaN(r) || Double.isNaN(x) || Double.isNaN(y) ||
                Double.isInfinite(r) || Double.isInfinite(x) || Double.isInfinite(y)) {
            sendErrorPage(request, response);
            return;
        }

        request.setAttribute("r", r);
        request.setAttribute("x", x);
        request.setAttribute("y", y);

        request.getRequestDispatcher("/areaCheck").forward(request, response);
    }
    
    private void handleReset(HttpServletRequest request, HttpServletResponse response, HttpSession session)
            throws IOException {
        HistoryService.resetHistory(session);
        response.setStatus(HttpServletResponse.SC_OK);
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        response.getWriter().write("{\"success\":true}");
    }

    void sendErrorPage(ServletRequest request, ServletResponse response) throws ServletException, IOException {
        RequestDispatcher dispatcher = getServletContext().getRequestDispatcher("/products/index.jsp");
        dispatcher.forward(request, response);
    }
}

