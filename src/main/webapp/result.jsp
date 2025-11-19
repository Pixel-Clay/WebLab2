<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.lab.PointResult" %>
<%!
    private String escapeHtml(String text) {
        if (text == null) return "";
        return text.replace("&", "&amp;")
                   .replace("<", "&lt;")
                   .replace(">", "&gt;")
                   .replace("\"", "&quot;")
                   .replace("'", "&#39;");
    }
%>
<%
    PointResult result = (PointResult) request.getAttribute("result");
    Double x = (Double) request.getAttribute("x");
    Double y = (Double) request.getAttribute("y");
    Double r = (Double) request.getAttribute("r");
    String contextPath = (String) request.getAttribute("contextPath");
    if (contextPath == null) {
        contextPath = request.getContextPath();
    }
    
    boolean success = result != null && result.success();
    String cardClass = success ? "card-success" : "card-failure";
    String resultClass = success ? "result-success" : "result-failure";
    String resultText = success ? "✅ Point is within the area" : "❌ Point is outside the area";
    String resultStatus = success ? "Success" : "Failure";
    String time = (result != null && result.time() != null) ? result.time() : "N/A";
    String took = (result != null && result.took() != null) ? result.took() : "N/A";
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <link href="data:image/x-icon;base64,AAABAAEAEBAQAAEABAAoAQAAFgAAACgAAAAQAAAAIAAAAAEABAAAAAAAgAAAAAAAAAAAAAAAEAAAAAAAAAD9/f0AAAAAAAICAgD///8ANCvaAMPDwwAbGxsABgYGACYmJgD+/v4AAQEBAE9PTwAKCgoAaGhoABUVFQAAAAAAERETMzMzERERERMzMzEREREREzMzMRERERERMzMRERERERMxExERERM0MzM7M0ERFkMzMTM0AzETPjETMRODEbpTMRMxExMxEbExEzEToxERMRETMRETEREzMzMzMzMxETMxzTMzMzERMztZMyMzMREzN6MRETMxERMRyhERExHwBwAA8A8AAPAPAAD4HwAAgAcAAAABAACAAAAAAAEAAAAAAADAAQAAgAEAAIAAAACAAAAAgAAAAIAgAADE8QAA" rel="icon" type="image/x-icon">
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Dela+Gothic+One&family=Roboto:ital,wght@0,100..900;1,100..900&display=swap" rel="stylesheet">
    <style>
        body { font-family: 'Roboto', sans-serif; margin: 0; padding: 20px; background-image: url('<%= contextPath %>/api/random-background'); background-size: auto; background-position: center; transition: background-image 0.5s ease-in-out; background-repeat: repeat; }
        h1 { font-family: Dela Gothic One, monospace; font-style: normal; font-weight: 400; text-align: center; }
        h1::before, h1::after { content: "🌟"; }
        .header { width: stretch; border-radius: 24px; margin: 4px; margin-bottom: 20px; box-shadow: 0 8px 32px 0 rgba(31, 38, 135, 0.18); backdrop-filter: blur(12px) saturate(160%); -webkit-backdrop-filter: blur(12px) saturate(160%); border: 1px solid rgba(255, 255, 255, 0.3); background: linear-gradient(to right, rgba(172, 255, 47, 0.65), rgba(0, 128, 0, 0.65), rgba(172, 255, 47, 0.65)); background-size: 500% 100%; animation: gradient-animation 10s ease infinite alternate; animation-iteration-count: infinite; animation-timing-function: linear; }
        .card { background: rgba(255, 255, 255, 0.18); border: 1px solid rgba(255, 255, 255, 0.3); border-radius: 16px; padding: 20px; margin: 20px auto; max-width: 800px; box-shadow: 0 8px 32px 0 rgba(31, 38, 135, 0.18); backdrop-filter: blur(12px) saturate(160%); -webkit-backdrop-filter: blur(12px) saturate(160%); }
        .card-success { background: rgba(144, 238, 144, 0.4); border: 1px solid rgba(0, 128, 0, 0.3); border-radius: 12px; padding: 20px; margin: 20px auto; max-width: 800px; box-shadow: 0 4px 24px 0 rgba(31, 38, 135, 0.10); backdrop-filter: blur(8px) saturate(140%); -webkit-backdrop-filter: blur(8px) saturate(140%); }
        .card-failure { background: rgba(240, 128, 128, 0.4); border: 1px solid rgba(255, 0, 0, 0.3); border-radius: 12px; padding: 20px; margin: 20px auto; max-width: 800px; box-shadow: 0 4px 24px 0 rgba(31, 38, 135, 0.10); backdrop-filter: blur(8px) saturate(140%); -webkit-backdrop-filter: blur(8px) saturate(140%); }
        table { width: 100%; border-collapse: collapse; margin: 20px 0; }
        table th, table td { padding: 12px; text-align: left; border-bottom: 1px solid rgba(255, 255, 255, 0.3); }
        table th { background: rgba(255, 255, 255, 0.2); font-weight: bold; }
        .result-display { text-align: center; font-size: 24px; font-weight: bold; margin: 20px 0; }
        .result-success { color: green; }
        .result-failure { color: red; }
        .link-button { display: inline-block; padding: 15px 30px; margin: 20px auto; text-align: center; text-decoration: none; font-family: Dela Gothic One, monospace; font-size: large; border-radius: 8px; background-color: rgba(172, 255, 47, 0.5); border: 1px solid rgba(0, 128, 0, 0.3); color: black; box-shadow: 0 4px 24px 0 rgba(31, 38, 135, 0.10); backdrop-filter: blur(8px) saturate(140%); -webkit-backdrop-filter: blur(8px) saturate(140%); transition: all 0.25s; }
        .link-button:hover { background-color: rgba(0, 0, 0, 0.5); border: 1px solid rgba(118, 124, 118, 0.3); color: white; box-shadow: 0 4px 24px 0 rgba(0, 0, 0, 0.228); transform: scale(1.01); }
        .link-container { text-align: center; margin-top: 30px; }
        @keyframes gradient-animation { 0% { background-position: 0% 50%; } 100% { background-position: 100% 50%; } }
    </style>
    <title>Area Check Result</title>
</head>
<body>
    <div class="header">
        <h1>Турыгин Никита Денисович P3231 467783</h1>
    </div>
    <div class="card">
        <h2>Received Parameters</h2>
        <table>
            <tr><th>Parameter</th><th>Value</th></tr>
            <tr><td>X</td><td><%= x != null ? x : "N/A" %></td></tr>
            <tr><td>Y</td><td><%= y != null ? y : "N/A" %></td></tr>
            <tr><td>R</td><td><%= r != null ? r : "N/A" %></td></tr>
        </table>
    </div>
    <div class="<%= cardClass %>">
        <h2>Check Result</h2>
        <div class="result-display <%= resultClass %>"><%= escapeHtml(resultText) %></div>
        <table>
            <tr><th>Property</th><th>Value</th></tr>
            <tr><td>Result</td><td><%= escapeHtml(resultStatus) %></td></tr>
            <tr><td>Coordinates</td><td>(<%= x != null ? x : "N/A" %>, <%= y != null ? y : "N/A" %>)</td></tr>
            <tr><td>Radius</td><td><%= r != null ? r : "N/A" %></td></tr>
            <tr><td>Timestamp</td><td><%= escapeHtml(time) %></td></tr>
            <tr><td>Execution Time</td><td><%= escapeHtml(took) %></td></tr>
        </table>
    </div>
    <div class="link-container">
        <a href="<%= contextPath %>/index.jsp" class="link-button">Create New Request</a>
    </div>
</body>
</html>

