import QtQuick 2.0

Rectangle {
    id: portRoot

    width: 12
    height: width
    radius: width

    border.width: 1
    border.color: color.darker(2)

    MouseArea {
        id: portMouseArea
        anchors.fill: parent
    }
}
