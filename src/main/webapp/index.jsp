<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.lab.HistoryService" %>
<%@ page import="com.lab.PointResult" %>
<%@ page import="com.fasterxml.jackson.databind.ObjectMapper" %>
<%@ page import="java.util.List" %>
<%
    // Convert history to JSON
    List<PointResult> history = HistoryService.readHistory(session);
    ObjectMapper objectMapper = new ObjectMapper();
    String historyJson = "[]";
    if (history != null && !history.isEmpty()) {
        historyJson = objectMapper.writeValueAsString(history);
    }
%>
    <!DOCTYPE html>
    <html>

    <head>
        <meta charset="UTF-8">
        <link
            href="data:image/x-icon;base64,AAABAAEAEBAQAAEABAAoAQAAFgAAACgAAAAQAAAAIAAAAAEABAAAAAAAgAAAAAAAAAAAAAAAEAAAAAAAAAD9/f0AAAAAAAICAgD///8ANCvaAMPDwwAbGxsABgYGACYmJgD+/v4AAQEBAE9PTwAKCgoAaGhoABUVFQAAAAAAERETMzMzERERERMzMzEREREREzMzMRERERERMzMRERERERMxExERERM0MzM7M0ERFkMzMTM0AzETPjETMRODEbpTMRMxExMxEbExEzEToxERMRETMRETEREzMzMzMzMxETMxzTMzMzERMztZMyMzMREzN6MRETMxERMRyhERExHwBwAA8A8AAPAPAAD4HwAAgAcAAAABAACAAAAAAAEAAAAAAADAAQAAgAEAAIAAAACAAAAAgAAAAIAgAADE8QAA"
            rel="icon" type="image/x-icon">
        <link rel="preconnect" href="https://fonts.googleapis.com">
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
        <link
            href="https://fonts.googleapis.com/css2?family=Dela+Gothic+One&family=Roboto:ital,wght@0,100..900;1,100..900&display=swap"
            rel="stylesheet">

        <link rel="stylesheet"
            href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@48,400,0,0&icon_names=delete" />

        <link rel="preload" href="static/sounds/funni.mp3">
        <script src="https://cdn.plot.ly/plotly-3.1.0.min.js" charset="utf-8"></script>
        <style>
            table {
                width: 100%;
                max-height: 100vh;
                height: 100%;
                table-layout: fixed;
            }

            body {
                font-family: 'Roboto', sans-serif;
                margin: 0;
                background-image: url('<%= request.getContextPath() %>/api/random-background');
                background-size: auto;
                background-position: center;
                transition: background-image 0.5s ease-in-out;
                background-repeat: repeat;
            }

            h1 {
                font-family: Dela Gothic One, monospace;
                font-style: normal;
                font-weight: 400;
                text-align: center;
            }

            h1::before,
            h1::after {
                content: "🌟";
            }

            input[type="number"] {
                width: 100%;
                box-sizing: border-box;
                height: 24px;
            }

            input[type="submit"] {
                width: 100%;
                box-sizing: border-box;
                cursor: pointer;
                height: 69px;
                font-family: Dela Gothic One;
                font-style: normal;
                font-weight: 400;
                font-size: large;
                text-align: center;
                transition: all 0.25s;
                border-radius: 8px;
                background-color: rgba(172, 255, 47, 0.5);
                border: 1px solid rgba(0, 128, 0, 0.3);
                box-shadow: 0 4px 24px 0 rgba(31, 38, 135, 0.10);
                backdrop-filter: blur(8px) saturate(140%);
                -webkit-backdrop-filter: blur(8px) saturate(140%);

            }

            input[type="submit"]:hover {
                background-color: rgba(0, 0, 0, 0.5);
                border: 1px solid rgba(118, 124, 118, 0.3);
                color: white;
                box-shadow: 0 4px 24px 0 rgba(0, 0, 0, 0.228);
                transform: scale(1.01);
            }

            input[type="submit"]:active {
                background-color: rgba(255, 255, 255, 0.3);
                border: 1px solid rgba(118, 124, 118, 0.3);
                color: black;
                transform: scale(0.98);
            }

            input[type="submit"]:disabled {
                background-color: rgba(0, 0, 0, 0);
                border: 1px solid rgba(211, 211, 211, 0.3);
                color: rgb(211, 211, 211);
                transform: scale(1);
                cursor: not-allowed
            }

            input[type="text"] {
                width: 100%;
                box-sizing: border-box;
                padding: 4px;
                border: 1px solid rgba(211, 211, 211, 0.3);
                background-color: rgba(255, 255, 255, 0.5);
                color: black;
                border-radius: 8px;
                height: 24px;
                transition: all 0.25s;
                box-shadow: 0 4px 24px 0 rgba(31, 38, 135, 0.10);
                backdrop-filter: blur(8px) saturate(140%);
                -webkit-backdrop-filter: blur(8px) saturate(140%);
            }

            input[type="text"]:hover {
                box-shadow: 0 4px 24px 0 rgba(0, 0, 0, 0.228);
                transform: scale(1.01);
            }

            input[type="text"]:invalid {
                background: rgba(240, 128, 128, 0.4);
                border: 1px solid rgba(255, 0, 0, 0.3);
            }

            button {
                width: 100%;
                box-sizing: border-box;
                cursor: pointer;
                height: 69px;
                font-family: Dela Gothic One;
                font-style: normal;
                font-weight: 400;
                font-size: large;
                text-align: center;
                transition: all 0.25s;
                border-radius: 8px;
                background-color: rgba(241, 115, 115, 0.5);
                border: 1px solid rgba(128, 0, 0, 0.3);
                box-shadow: 0 4px 24px 0 rgba(31, 38, 135, 0.10);
                backdrop-filter: blur(8px) saturate(140%);
                -webkit-backdrop-filter: blur(8px) saturate(140%);
            }

            button:hover {
                box-shadow: 0 4px 24px 0 rgba(255, 56, 56, 0.288);
                transform: scale(1.01);
            }

            td>label {
                display: block;
                text-align: center;
            }

            td>input[type="radio"] {
                display: block;
                margin-left: auto;
                margin-right: auto;
            }

            td>span {
                display: block;
                text-align: center;
            }


            input {
                padding: 3% !important;
            }

            .header {
                width: stretch;
                border-radius: 24px;
                margin: 4px;
                box-shadow: 0 8px 32px 0 rgba(31, 38, 135, 0.18);
                backdrop-filter: blur(12px) saturate(160%);
                -webkit-backdrop-filter: blur(12px) saturate(160%);
                border: 1px solid rgba(255, 255, 255, 0.3);
                background: linear-gradient(to right, rgba(172, 255, 47, 0.65), rgba(0, 128, 0, 0.65), rgba(172, 255, 47, 0.65));
                background-size: 500% 100%;
                animation: gradient-animation 10s ease infinite alternate;
                animation-iteration-count: infinite;
                /* Makes the animation loop forever */
                animation-timing-function: linear;
                /* Optional: Sets the speed curve of the animation */
            }

            .card {
                background: rgba(255, 255, 255, 0.18);
                border: 1px solid rgba(255, 255, 255, 0.3);
                border-radius: 16px;
                padding: 4px;
                margin-top: 4px;
                box-shadow: 0 8px 32px 0 rgba(31, 38, 135, 0.18);
                backdrop-filter: blur(12px) saturate(160%);
                -webkit-backdrop-filter: blur(12px) saturate(160%);
            }

            .card-light {
                background: rgba(255, 255, 255, 0.22);
                border: 1px solid rgba(255, 255, 255, 0.3);
                border-radius: 12px;
                padding: 4px;
                box-shadow: 0 4px 24px 0 rgba(31, 38, 135, 0.10);
                backdrop-filter: blur(8px) saturate(140%);
                -webkit-backdrop-filter: blur(8px) saturate(140%);
            }

            .card-success {
                background: rgba(144, 238, 144, 0.4);
                border: 1px solid rgba(0, 128, 0, 0.3);
                border-radius: 12px;
                padding: 8px;
                box-shadow: 0 4px 24px 0 rgba(31, 38, 135, 0.10);
                backdrop-filter: blur(8px) saturate(140%);
                -webkit-backdrop-filter: blur(8px) saturate(140%);
            }



            .card-failure {
                background: rgba(240, 128, 128, 0.4);
                border: 1px solid rgba(255, 0, 0, 0.3);
                border-radius: 12px;
                padding: 8px;
                box-shadow: 0 4px 24px 0 rgba(31, 38, 135, 0.10);
                backdrop-filter: blur(8px) saturate(140%);
                -webkit-backdrop-filter: blur(8px) saturate(140%);
            }

            .plot {
                border-radius: 8px;
                overflow: hidden;
            }

            @keyframes gradient-animation {
                0% {
                    background-position: 0% 50%;
                }

                100% {
                    background-position: 100% 50%;
                }
            }
        </style>
        <title>Labuba 2</title>
    </head>

    <body>
        <div class="header">
            <h1>Турыгин Никита Денисович P3231 467783</h1>
        </div>
        <table>
            <tr>
                <td style="width: 65%; vertical-align: top;">
                    <div class="card-light">
                        <div id="myPlot" class="plot"></div>
                    </div>
                </td>
                <td>
                    <div class="card" id="formCard">
                        <div class="card-light">
                            <form id="myForm">
                                <table>
                                    <tr>
                                        <td><label for="x">X:</label></td>
                                        <td>
                                            <input type="radio" name="x" value="-2" id="x1">
                                        </td>
                                        <td>
                                            <input type="radio" name="x" value="-1.5" id="x2">
                                        </td>
                                        <td>
                                            <input type="radio" name="x" value="-1" id="x3">
                                        </td>
                                        <td>
                                            <input type="radio" name="x" value="-0.5" id="x4">
                                        </td>
                                        <td>
                                            <input type="radio" name="x" value="0" id="x5">
                                        </td>
                                        <td>
                                            <input type="radio" name="x" value="0.5" id="x6">
                                        </td>
                                        <td>
                                            <input type="radio" name="x" value="1" id="x7">
                                        </td>
                                        <td>
                                            <input type="radio" name="x" value="1.5" id="x8">
                                        </td>
                                        <td>
                                            <input type="radio" name="x" value="2" id="x9">
                                        </td>
                                    </tr>
                                    <tr>
                                        <td></td>
                                        <td><label for="x1">-2</label></td>
                                        <td><label for="x2">-1.5</label></td>
                                        <td><label for="x3">-1</label></td>
                                        <td><label for="x4">-0.5</label></td>
                                        <td><label for="x5">0</label></td>
                                        <td><label for="x6">0.5</label></td>
                                        <td><label for="x7">1</label></td>
                                        <td><label for="x8">1.5</label></td>
                                        <td><label for="x9">2</label></td>
                                    </tr>
                                    <tr>
                                        <td><label for="y">Y:</label></td>
                                        <td colspan="9">
                                            <input type="text" id="r" name="y" placeholder="Введите Y от -5 до 5">
                                        </td>
                                    </tr>
                                    <tr>
                                        <td><label for="R">R:</label></td>
                                        <td>
                                            <input type="radio" name="r" value="1" id="r1">
                                        </td>
                                        <td>
                                            <input type="radio" name="r" value="2" id="r2">
                                        </td>
                                        <td>
                                            <input type="radio" name="r" value="3" id="r3">
                                        </td>
                                        <td>
                                            <input type="radio" name="r" value="4" id="r4">
                                        </td>
                                        <td>
                                            <input type="radio" name="r" value="5" id="r5">
                                        </td>
                                        <td colspan="4"></td>
                                    </tr>
                                    <tr>
                                        <td></td>
                                        <td><label for="r1">1</label></td>
                                        <td><label for="r2">2</label></td>
                                        <td><label for="r3">3</label></td>
                                        <td><label for="r4">4</label></td>
                                        <td><label for="r5">5</label></td>
                                        <td colspan="4"></td>
                                    </tr>
                                    <tr>

                                        <td colspan="8">
                                            <div>
                                                <input type="submit" disabled>
                                            </div>
                                        </td>
                                        <td colspan="2">
                                            <button type="button" class="reset" title="Clear history">
                                                <span class="material-symbols-outlined"
                                                    style="text-align: center; font-size: 100%;">
                                                    delete
                                                </span>
                                            </button>
                                        </td>
                                    </tr>
                                </table>
                            </form>
                        </div>
                    </div>
                </td>
            </tr>
        </table>
        <audio id="sound1" src="static/sounds/funni.mp3" autostart="0" autostart="false" preload="auto"></audio>
        <script>
            // graph plot
            function getPath(r) {
                // Rectangle in Quadrant II: 0 <= x <= r/2, 0 >= y >= -r
                const rect_data = {
                    x: [0, r / 2, r / 2, 0, 0],
                    y: [0, 0, -r, -r, 0],
                    fill: "toself",
                    fillcolor: 'rgba(172, 255, 47, 0.5)',
                    line: { color: 'rgba(0,0,0,0)' },
                    type: 'scatter',
                    name: 'rect'
                };

                // Quarter circle in Quadrant I: 0 <= x <= r, 0 <= y <= r, and sqrt(x^2 + y^2) <= r
                // Generate points along the quarter circle arc from (r,0) to (0,r)
                const theta = Array.from({ length: 100 }, (_, i) => (Math.PI / 2) * (i / 99));
                const circle_x = theta.map(angle => r * Math.cos(angle));
                const circle_y = theta.map(angle => r * Math.sin(angle));
                const circle_data = {
                    x: [0, ...circle_x, 0],
                    y: [0, ...circle_y, 0],
                    fill: "toself",
                    fillcolor: 'rgba(172, 255, 47, 0.5)',
                    line: { color: 'rgba(0,0,0,0)' },
                    type: 'scatter',
                    name: 'circle'
                };

                // Triangle in Quadrant IV: x in [-r/2, 0], y < 0, and y >= 2*x - r
                // The triangle is bounded by:
                // 1. The line y = 2*x - r from (0, -r) to (-r/2, -2r)
                // 2. The vertical line x = -r/2 from (-r/2, -2r) to (-r/2, 0)
                // 3. The horizontal line y = 0 from (-r/2, 0) to (0, 0)
                // 4. The vertical line x = 0 from (0, 0) to (0, -r)
                const triangle_x = [0, -r / 2, 0, 0];
                const triangle_y = [0, 0, r, 0];
                const triangle_data = {
                    x: triangle_x,
                    y: triangle_y,
                    fill: "toself",
                    fillcolor: 'rgba(172, 255, 47, 0.5)',
                    line: { color: 'rgba(0,0,0,0)' },
                    type: 'scatter',
                    name: 'triangle'
                };
                return [rect_data, circle_data, triangle_data]
            }

            // Store all history points for filtering by R
            var historyPoints = [];
            
            // History data from server (JSON)
            var historyData = <%
                out.print(historyJson);
            %>;

            // Default layout for empty graph (just axes)
            const emptyLayout = {
                margin: { l: 0, r: 0, t: 0, b: 0 },
                showlegend: false,
                plot_bgcolor: 'rgba(0, 0, 0, 0)',
                paper_bgcolor: 'rgba(255, 255, 255, 0.5)',
                xaxis: {
                    showline: true,
                    linecolor: 'black',
                    linewidth: 2,
                    mirror: true,
                    range: [-6, 6],
                    fixedrange: true
                },
                yaxis: {
                    showline: true,
                    linecolor: 'black',
                    linewidth: 2,
                    mirror: true,
                    scaleanchor: 'x',
                    scaleratio: 1,
                    range: [-6, 6],
                    fixedrange: true
                },
                shapes: [
                    { type: 'line', x0: -6, y0: 0, x1: 6, y1: 0, line: { color: 'black', width: 2 } },
                    { type: 'line', x0: 0, y0: -6, x1: 0, y1: 6, line: { color: 'black', width: 2 } }
                ]
            };

            var currentR = null; // Track current R value for graph updates
            var plotReady = false; // Track if plot is ready for updates

            // Convert pixel coordinates to plot data coordinates
            function pixelToPlotCoords(event, plotDiv) {
                const rect = plotDiv.getBoundingClientRect();
                const mouseX = event.clientX - rect.left;
                const mouseY = event.clientY - rect.top;

                // Get plot layout - try _fullLayout first (after plot is rendered), then layout
                const layout = plotDiv._fullLayout || plotDiv.layout;
                if (!layout) {
                    console.error('Plot layout not available');
                    return null;
                }

                // Get axis ranges
                const xAxis = layout.xaxis || {};
                const yAxis = layout.yaxis || {};
                const xRange = xAxis.range || [-6, 6];
                const yRange = yAxis.range || [-6, 6];

                // Get plot area dimensions
                // Plotly stores plot area info in _fullLayout._size or we calculate from margins
                let plotWidth, plotHeight, plotLeft, plotTop;

                if (layout._size) {
                    // Use Plotly's internal size calculations if available
                    plotLeft = layout._size.l || 0;
                    plotTop = layout._size.t || 0;
                    plotWidth = layout._size.w || (rect.width - plotLeft - (layout._size.r || 0));
                    plotHeight = layout._size.h || (rect.height - plotTop - (layout._size.b || 0));
                } else {
                    // Fallback: calculate from margins
                    const margin = layout.margin || {};
                    plotLeft = margin.l || 0;
                    plotTop = margin.t || 0;
                    const plotRight = margin.r || 0;
                    const plotBottom = margin.b || 0;
                    plotWidth = rect.width - plotLeft - plotRight;
                    plotHeight = rect.height - plotTop - plotBottom;
                }

                // Convert pixel coordinates to plot coordinates
                const plotX = xRange[0] + (mouseX - plotLeft) / plotWidth * (xRange[1] - xRange[0]);
                // Y-axis is inverted (screen Y increases downward, plot Y increases upward)
                const plotY = yRange[1] - (mouseY - plotTop) / plotHeight * (yRange[1] - yRange[0]);

                return { x: plotX, y: plotY };
            }

            function updateGraph(r) {
                currentR = r;
                const plotDiv = document.getElementById('myPlot');

                // Ensure plot div exists
                if (!plotDiv) {
                    console.error('Plot div not found');
                    return;
                }

                const newData = getPath(r);
                const newLayout = {
                    margin: { l: 0, r: 0, t: 0, b: 0 },
                    showlegend: false,
                    plot_bgcolor: 'rgba(0, 0, 0, 0)',
                    paper_bgcolor: 'rgba(255, 255, 255, 0.5)',
                    xaxis: {
                        showline: true,
                        linecolor: 'black',
                        linewidth: 2,
                        mirror: true,
                        fixedrange: true
                    },
                    yaxis: {
                        showline: true,
                        linecolor: 'black',
                        linewidth: 2,
                        mirror: true,
                        scaleanchor: 'x',
                        scaleratio: 1,
                        fixedrange: true
                    },
                    shapes: [
                        { type: 'line', x0: -r - 1, y0: 0, x1: r + 1, y1: 0, line: { color: 'black', width: 2 } },
                        { type: 'line', x0: 0, y0: -r - 1, x1: 0, y1: r + 1, line: { color: 'black', width: 2 } }
                    ]
                };

                // Show all history points on the graph
                // Always use newPlot to avoid state issues with react
                Plotly.newPlot('myPlot', [...newData, ...historyPoints], newLayout, { scrollZoom: false, doubleClick: false, displayModeBar: false, responsive: true })
                    .then(function () {
                        plotReady = true;
                    })
                    .catch(function (err) {
                        console.error('Error updating plot:', err);
                        plotReady = false;
                    });
            }

            // Initialize with empty graph (just axes)
            const plotDiv = document.getElementById('myPlot');
            if (plotDiv) {
                Plotly.newPlot('myPlot', [], emptyLayout, { scrollZoom: false, doubleClick: false, displayModeBar: false, responsive: true })
                    .then(function () {
                        plotReady = true;
                    });
            }
        </script>

        <script>
            // Get context path for API calls
            var contextPath = '${pageContext.request.contextPath}';
            // Fallback if contextPath is empty (deployed at root)
            if (!contextPath || contextPath === '') {
                contextPath = '';
            }
            console.log('Context path:', contextPath || '(root)');

            // history
            function clearPlotPoints() {
                // Clear all traces except shape traces (first 3)
                const plotDiv = document.getElementById('myPlot');
                if (plotDiv.data && plotDiv.data.length > 3) {
                    Plotly.deleteTraces('myPlot', Array.from({ length: plotDiv.data.length - 3 }, (_, i) => i + 3));
                }
            }

            function clearHistory() {
                // Clear existing history cards
                const formCard = document.getElementById('formCard');
                while (formCard.children.length > 1) {
                    formCard.removeChild(formCard.lastChild);
                }
                // Clear history points array
                historyPoints = [];
                // If R is selected, redraw graph with shape but no points
                if (currentR !== null) {
                    updateGraph(currentR);
                } else {
                    // Reset to empty graph
                    Plotly.react('myPlot', [], emptyLayout, { scrollZoom: true, displayModeBar: false, responsive: true });
                }
            }

            function loadHistoryFromSession() {
                // Load history from JSON data
                if (historyData && historyData.length > 0) {
                    historyData.forEach(function(result) {
                        // Append element to form card
                        appendElement(
                            result.success, 
                            result.r, 
                            result.x, 
                            result.y, 
                            result.time || '', 
                            result.took || '', 
                            "formCard"
                        );
                        
                        // Store point in history array for graph
                        historyPoints.push({
                            x: [result.x],
                            y: [result.y],
                            mode: 'markers',
                            type: 'scatter',
                            marker: { color: result.success ? 'green' : 'red', size: 10 },
                            name: 'point',
                            r: result.r
                        });
                    });
                }
                
                // After loading history, show points on graph
                    // Wait for plot to be ready
                    function checkAndUpdateGraph() {
                        if (plotReady) {
                            const rInput = document.querySelector('input[name="r"]:checked');
                            if (rInput) {
                                // If R is selected, show shape and all history points
                                const rValue = parseFloat(rInput.value);
                                updateGraph(rValue);
                            } else {
                                // If R is not selected, show all history points on empty graph
                                if (historyPoints.length > 0) {
                                    Plotly.newPlot('myPlot', historyPoints, emptyLayout, { scrollZoom: false, doubleClick: false, displayModeBar: false, responsive: true })
                                        .then(function () {
                                            plotReady = true;
                                        });
                                }
                            }
                        } else {
                            // Retry after a short delay if plot isn't ready yet
                            setTimeout(checkAndUpdateGraph, 50);
                        }
                    }
                checkAndUpdateGraph();
            }

            function appendElement(success, radius, x, y, time, took, containerToAppend) {
                var container = document.getElementById(containerToAppend);
                var element = document.createElement('div');
                element.className = success ? 'card card-success' : 'card card-failure';
                var icon = success ? '✅' : '❌';
                element.innerHTML = '<h2>' + icon + ' R = ' + radius + '</h2><p>(' + x + ', ' + y + ') ' + time + ' took ' + took + '</p>';
                container.insertBefore(element, container.children[1] || null);
            }

            function submitPointCheck(x, y, r) {
                // Create a form and submit it to allow proper page navigation
                const form = document.createElement('form');
                form.method = 'POST';
                form.action = contextPath + '/controller';

                const actionInput = document.createElement('input');
                actionInput.type = 'hidden';
                actionInput.name = 'action';
                actionInput.value = 'check';
                form.appendChild(actionInput);

                const xInput = document.createElement('input');
                xInput.type = 'hidden';
                xInput.name = 'x';
                xInput.value = x;
                form.appendChild(xInput);

                const yInput = document.createElement('input');
                yInput.type = 'hidden';
                yInput.name = 'y';
                yInput.value = y;
                form.appendChild(yInput);

                const rInput = document.createElement('input');
                rInput.type = 'hidden';
                rInput.name = 'r';
                rInput.value = r;
                form.appendChild(rInput);

                document.body.appendChild(form);
                form.submit();
            }

            document.getElementById('myForm').addEventListener('submit', function (event) {
                event.preventDefault();

                const form = event.target;
                const formData = new FormData(form);

                let formX = formData.get('x');
                let formY = formData.get('y');
                let formR = formData.get('r');

                if (!formX || !formY || !formR) {
                    alert('Please fill in all fields');
                    return;
                }

                submitPointCheck(formX, formY, formR);
            });

            document.getElementById('myForm').addEventListener('change', function (event) {
                const form = event.target.form;
                const formData = new FormData(form);

                const xSelected = formData.get('x') !== null;

                const yValue = formData.get('y');
                const yValid = !isNaN(yValue) && yValue.trim() !== '' && isFinite(yValue) && Number(yValue) >= -5 && Number(yValue) <= 5 && yValue.length <= 5;

                const rSelected = formData.get('r') !== null;

                // Update graph when R changes
                if (rSelected && event.target.name === 'r') {
                    const rValue = parseFloat(event.target.value);
                    updateGraph(rValue);
                }

                form.querySelector('input[type="text"]').setCustomValidity(yValid || yValue.trim() == '' ? "" : 'Русским языком написано -5 до 5, не больше и не меньше!');

                form.querySelector('input[type="submit"]').disabled = !(xSelected && yValid && rSelected);
            });

            window.addEventListener('DOMContentLoaded', function () {
                loadHistoryFromSession();

                // Add graph click handler after plot is created and submitPointCheck is defined
                const plotDiv = document.getElementById('myPlot');

                // Wait for plot to be ready before adding click handler
                function addClickHandler() {
                    if (plotReady && plotDiv) {
                        plotDiv.addEventListener('click', function (event) {
                            // Convert pixel coordinates to plot coordinates
                            const coords = pixelToPlotCoords(event, plotDiv);
                            if (!coords) {
                                return;
                            }

                            // Get selected R value
                            const rInput = document.querySelector('input[name="r"]:checked');
                            if (!rInput) {
                                alert('Point coordinates cannot be determined. Please select a radius (R) first.');
                                return;
                            }

                            const selectedR = rInput.value;

                            // Submit the point check
                            submitPointCheck(coords.x.toString(), coords.y.toString(), selectedR);
                        });
                    } else {
                        // Retry after a short delay if plot isn't ready yet
                        setTimeout(addClickHandler, 50);
                    }
                }
                addClickHandler();

                // Add reset button handler
                document.querySelector('button.reset').addEventListener('click', function () {
                    document.getElementById('sound1').play();

                    // Use URLSearchParams for proper form encoding
                    const params = new URLSearchParams();
                    params.append('action', 'reset');

                    fetch(contextPath + '/controller', {
                        method: 'POST',
                        headers: {
                            'Content-Type': 'application/x-www-form-urlencoded'
                        },
                        body: params.toString()
                    })
                        .then(response => {
                            console.log('Reset response status:', response.status);
                            if (!response.ok) {
                                return response.text().then(text => {
                                    throw new Error('Failed to reset history: ' + text);
                                });
                            }
                            return response.json();
                        })
                        .then(data => {
                            console.log('Reset successful:', data);
                            // Clear the UI
                            clearHistory();


                            // Reload the page to ensure everything is in sync
                            window.location.reload();
                        })
                        .catch(error => {
                            console.error('Error resetting history:', error);
                            alert('Error resetting history: ' + error.message);
                        });
                });
            });
        </script>

    </body>

    </html>