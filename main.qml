import QtQuick
import QtQuick.Window
import "NodeLibrary"

Window {
    title: qsTr("QtNodeGraph test application")
    visible: true

    width: 640
    height: 480

    onWindowStateChanged: nodeScene.centerOnContent();
    onWidthChanged: nodeScene.centerOnContent();
    onHeightChanged: nodeScene.centerOnContent();

    NodeScene {
        id: nodeScene
    }
}
