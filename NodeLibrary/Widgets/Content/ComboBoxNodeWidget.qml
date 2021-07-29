import QtQuick 2.0;
import QtQuick.Controls 2.15;

ComboBox {
    id: comboBoxWidget
    anchors.left: parent.left
    anchors.right: parent.right

    background: Rectangle {
        color: "#ccc"
        radius: 2
    }

    indicator: Canvas {
        id: canvas
        x: comboBoxWidget.width - width - comboBoxWidget.rightPadding
        y: comboBoxWidget.topPadding + (comboBoxWidget.availableHeight - height) / 2
        width: 12
        height: 8
        contextType: "2d"

        Connections {
            target: comboBoxWidget
            function onPressedChanged() { canvas.requestPaint(); }
        }

        onPaint: {
            context.reset();
            context.moveTo(0, 0);
            context.lineTo(width, 0);
            context.lineTo(width / 2, height);
            context.closePath();
            context.fillStyle = comboBoxWidget.pressed ? "#aaa" : "#444";
            context.fill();
        }
    }
}
