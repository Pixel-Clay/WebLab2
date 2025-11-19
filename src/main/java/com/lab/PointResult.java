package com.lab;

import com.fasterxml.jackson.annotation.JsonProperty;
import java.io.Serializable;

public record PointResult(
        @JsonProperty("success") boolean success,
        @JsonProperty("r") double r,
        @JsonProperty("x") double x,
        @JsonProperty("y") double y,
        @JsonProperty("time") String time,
        @JsonProperty("took") String took
) implements Serializable {
    private static final long serialVersionUID = 1L;


    // Additional constructor for the 4-parameter version
    public PointResult(boolean success, double r, double x, double y) {
        this(success, r, x, y, null, null);
    }
}