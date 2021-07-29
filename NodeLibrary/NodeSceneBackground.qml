import QtQuick 2.0

Rectangle {
    id: backgroundRoot
    anchors.fill: parent

    property int xOrigin
    property int yOrigin
    property color linesColor: "#000"
    property real scaleFactor: 1

    onScaleFactorChanged: {
        var wholeBackgroundRect = Qt.rect(x, y, width, height);
        gridDrawer.clear();
        gridDrawer.markDirty(wholeBackgroundRect);
    }

    Canvas {
        id: gridDrawer
        anchors.fill: parent

        onPaint: {
            var ctx = getContext("2d");
            drawGrid(ctx, 15, 1);
            drawGrid(ctx, 150, 2);
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
                var xLine = stepScaled * row ;
                ctx.moveTo(0, xLine);
                ctx.lineTo(width, xLine);
            }

            // Draw the vertical lines.
            var amountColumns = (width / stepScaled) + 1;
            for (var col = 0; col < amountColumns; ++col) {
                var yLine = stepScaled * col ;
                ctx.moveTo(yLine, 0);
                ctx.lineTo(yLine, height);
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
    }
}
