import QtQuick 2.0

Rectangle {
    id: backgroundRoot
    anchors.fill: parent

    property real xOrigin: 1
    property real yOrigin: 1
    property color linesColor: "#000"
    property real scaleFactor: 1

    onScaleFactorChanged: gridDrawer.redraw()

    Canvas {
        id: gridDrawer
        anchors.fill: parent
        renderStrategy : Canvas.Cooperative
        renderTarget: Canvas.FramebufferObject

        onPaint: {
            var ctx = getContext("2d");
            drawGrid(ctx, 20, 1);
            drawGrid(ctx, 200, 2);
        }

        /**
         * Draw a grid, each line separated by the amount of pixels.
         * @param ctx       Context of the canvas.
         * @param step      Spacing between lines.
         * @param lineWidth Line width.
         */
        function drawGrid(ctx, step, lineWidth) {
            var stepScaled = step * scaleFactor;

            ctx.lineWidth = lineWidth;
            ctx.strokeStyle = linesColor;

            ctx.beginPath();

            // Draw the horizontal lines.
            var amountRows = (height / stepScaled) + 1;
            for (var row = 0; row < amountRows; ++row) {
                var yLine = (stepScaled * row) ;
                ctx.moveTo(0, yLine);
                ctx.lineTo(width, yLine);
            }

            // Draw the vertical lines.
            var amountColumns = (width / stepScaled) + 1;
            for (var col = 0; col < amountColumns; ++col) {
                var xLine = (stepScaled * col) ;
                ctx.moveTo(xLine, 0);
                ctx.lineTo(xLine, height);
            }

            ctx.closePath();
            ctx.stroke();
        }

        /**
         * Clear the canvas content.
         */
        function clear() {
            var ctx = getContext("2d");
            ctx.reset();
        }

        /**
         * Redraw the whole canvas.
         */
        function redraw() {
            gridDrawer.clear();
            gridDrawer.requestPaint();
        }
    }
}
