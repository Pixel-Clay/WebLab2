package com.lab;

import jakarta.servlet.http.HttpSession;
import java.util.ArrayList;
import java.util.List;

public class HistoryService {
    private static final String HISTORY_ATTRIBUTE = "history";

    public static void writeHistory(HttpSession session, PointResult result) {
        if (session == null) {
            return;
        }
        
        List<PointResult> history = readHistory(session);
        history.add(result);
        session.setAttribute(HISTORY_ATTRIBUTE, history);
    }

    public static List<PointResult> readHistory(HttpSession session) {
        if (session == null) {
            return new ArrayList<>();
        }
        
        Object historyObj = session.getAttribute(HISTORY_ATTRIBUTE);
        if (historyObj instanceof List) {
            return (List<PointResult>) historyObj;
        }
        return new ArrayList<>();
    }

    public static void resetHistory(HttpSession session) {
        if (session != null) {
            session.setAttribute(HISTORY_ATTRIBUTE, new ArrayList<PointResult>());
        }
    }
}

