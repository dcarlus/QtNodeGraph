import QtQuick 2.0
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import "../../../NodeLibrary"

Item {
    id: widgetRoot
    Layout.fillWidth: true
    Layout.fillHeight: true

    property alias inputPortColor: inputPort.color

    property alias widgetContainer: widgetContainer
    property alias widget: widgetLoader.widget
    property alias widgetSource: widgetLoader.widgetSource
    property alias widgetModel: widgetLoader.widgetModel
    property alias parentLayout: widgetLoader.parentLayout

    GridLayout {
        columns: 2
        anchors.fill: parent

        Port {
            id: inputPort
        }

        Item {
            id: widgetContainer
            Layout.fillHeight: true
            Layout.fillWidth: true
        }
    }

    DynamicWidgetLoader {
        id: widgetLoader
    }
}
