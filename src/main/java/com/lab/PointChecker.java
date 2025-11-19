package com.lab;

public class PointChecker {
    
    public static PointResult handlePointCheck(double x, double y, double r) {
        // Rectangle check: quadrant II
        boolean inRectangle = 0 <= x && x <= r/2 && 0 >= y && y >= -r;
        
        // Quarter circle check: quadrant I
        boolean inQuarterCircle = (x >= 0 && x <= r) &&
                                  (y >= 0 && y <= r) &&
                                  (Math.sqrt(x * x + y * y) <= r);
        
        // Triangle check: quadrant IV
        boolean inTriangle = x <= 0 && x >= -r/2 && 
                             y >= 0 && y <= r && 
                             y <= (-2 * x);
                        
        boolean success = inRectangle || inQuarterCircle || inTriangle;
        
        return new PointResult(success, r, x, y);
    }
}



