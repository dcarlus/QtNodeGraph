import QtQuick 2.0
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

import "../../../NodeLibrary"
import "../Content"

// Widget without any connection to other nodes.
// How to use (example):
/*
    NoPortNodeWidget {
        id: renderEngineSelectWidget
        widgetSource: '../Content/ComboBoxNodeWidget.qml'
        parentLayout: myLayout

        property var model: ListModel {
            id: renderEngineModel
            ListElement { text: "EEVEE" }
            ListElement { text: "Cycles" }
            ListElement { text: "All" }
        }

        onWidgetChanged: {
            if (widget === null) {
                return;
            }

            widget.model = model;
        }
    }
*/
Item {
    id: widgetRoot
    Layout.fillWidth: true
    Layout.fillHeight: true

    property alias widgetContainer: widgetContainer
    property alias widget: widgetLoader.widget
    property alias widgetSource: widgetLoader.widgetSource
    property alias widgetModel: widgetLoader.widgetModel
    property alias parentLayout: widgetLoader.parentLayout

    GridLayout {
        columns: 1
        anchors.fill: parent

        Item {
            id: widgetContainer
            Layout.fillHeight: true
            Layout.fillWidth: true
            Layout.rightMargin: Layout.leftMargin
        }
    }

    DynamicWidgetLoader {
        id: widgetLoader
    }
}
