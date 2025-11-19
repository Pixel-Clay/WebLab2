package com.lab;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.util.Random;

public class RandomBackgroundServlet extends HttpServlet {
    private static final Random random = new Random();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Generate random number between 1 and 5 (inclusive)
        int randomBg = random.nextInt(5) + 1;
        String imagePath = "/static/backgrounds/" + randomBg + ".jpg";
        
        // Get the image as a resource stream
        InputStream imageStream = getServletContext().getResourceAsStream(imagePath);
        
        if (imageStream == null) {
            response.setStatus(HttpServletResponse.SC_NOT_FOUND);
            response.getWriter().write("Background image not found");
            return;
        }
        
        // Set response headers for image
        response.setContentType("image/jpeg");
        response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
        response.setHeader("Pragma", "no-cache");
        response.setDateHeader("Expires", 0);
        
        // Copy image data to response
        try (OutputStream out = response.getOutputStream()) {
            byte[] buffer = new byte[4096];
            int bytesRead;
            while ((bytesRead = imageStream.read(buffer)) != -1) {
                out.write(buffer, 0, bytesRead);
            }
        } finally {
            imageStream.close();
        }
    }
}


