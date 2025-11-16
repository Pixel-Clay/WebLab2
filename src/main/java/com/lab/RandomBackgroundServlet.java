package com.lab;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.Random;

public class RandomBackgroundServlet extends HttpServlet {
    private static final Random random = new Random();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int randomBg = random.nextInt(4) + 1;
        String contextPath = request.getContextPath();
        String bgPath = contextPath + "/static/backgrounds/" + randomBg + ".jpg";
        
        response.setContentType("text/plain");
        response.setCharacterEncoding("UTF-8");
        response.getWriter().write(bgPath);
    }
}


