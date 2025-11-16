package com.lab;

import com.fasterxml.jackson.annotation.JsonProperty;
import java.io.Serializable;

public class PointResult implements Serializable {
    private static final long serialVersionUID = 1L;
    private boolean success;
    private double r;
    private double x;
    private double y;
    private String time;
    private String took;

    public PointResult() {
    }

    public PointResult(boolean success, double r, double x, double y) {
        this.success = success;
        this.r = r;
        this.x = x;
        this.y = y;
    }

    @JsonProperty("success")
    public boolean isSuccess() {
        return success;
    }

    public void setSuccess(boolean success) {
        this.success = success;
    }

    @JsonProperty("r")
    public double getR() {
        return r;
    }

    public void setR(double r) {
        this.r = r;
    }

    @JsonProperty("x")
    public double getX() {
        return x;
    }

    public void setX(double x) {
        this.x = x;
    }

    @JsonProperty("y")
    public double getY() {
        return y;
    }

    public void setY(double y) {
        this.y = y;
    }

    @JsonProperty("time")
    public String getTime() {
        return time;
    }

    public void setTime(String time) {
        this.time = time;
    }

    @JsonProperty("took")
    public String getTook() {
        return took;
    }

    public void setTook(String took) {
        this.took = took;
    }
}



