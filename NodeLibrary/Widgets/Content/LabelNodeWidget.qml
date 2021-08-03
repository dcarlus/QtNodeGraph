import QtQuick 2.0
import QtQuick.Controls 2.15;

Container {
    id: labelContainerWidget
    anchors.left: parent.left
    anchors.right: parent.right

    property alias model: label.text

    contentItem: Label {
        id: label
        anchors.fill: parent
        color: Qt.rgba(1,1,1,1)

        // WARNING: Temporary until creation of an enumeration for the port
        // position.
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        elide: Text.ElideRight
    }
}
