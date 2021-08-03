import QtQuick 2.0
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtQml.Models 2.15
import QtQuick.Shapes 1.15

import "Widgets"
import "Widgets/Base"

Item {
    id: nodeRoot

    width: 200
    height: nodeCaptionBackground.height + nodeContentLayout.implicitHeight + (nodeContentLayout.anchors.margins * 2)

    property string caption
    property color captionColor
    property string iconSource
    property bool selected: false

    QtObject {
        // Private properties
        id: internal

        property color selectedBorderColor: Qt.rgba(0.5, 0.5, 0.5, 1)
        property color selectedColor: Qt.rgba(0.35, 0.35, 0.35, 1)

        property color unselectedBorderColor: nodeCaptionBackground.color.darker(1.1)
        property color unselectedColor: Qt.rgba(0.3, 0.3, 0.3, 1)
    }

    onSelectedChanged: {
        if (selected) {
            parent.selection();
            parent.selectedNode = this;
            z = 1;

            nodeShape.border.color = internal.selectedBorderColor;
            nodeShape.color = internal.selectedColor;
        }
        else {
            nodeShape.border.color = internal.unselectedBorderColor;
            nodeShape.color = internal.unselectedColor;
        }
    }

    // Node itself.
    Rectangle {
        id: nodeShape
        anchors.fill: parent

        radius: 3
        border.width: 1
        border.color: internal.unselectedBorderColor

        gradient: Gradient {
            GradientStop { position: 1.0; color: nodeRoot.captionColor.darker(2.2); }
            GradientStop { position: 0.5; color: selected ? internal.selectedColor : internal.unselectedColor; }
        }

        // Node caption.
        Rectangle
        {
            id: nodeCaptionBackground
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.margins: nodeShape.border.width

            color: nodeRoot.captionColor
            radius: 2
            height: 30

            Text {
                id: nodeCaption
                anchors.fill: parent

                text: nodeRoot.caption
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                color: Qt.rgba(1,1,1,1)

                font.bold: true
                elide: Text.ElideMiddle
            }
        }

        // User interactions.
        MouseArea {
            id: nodeMouseArea
            anchors.fill: parent
            hoverEnabled: true

            acceptedButtons: Qt.LeftButton | Qt.RightButton
            drag.target: nodeRoot
            drag.axis: Drag.XAndYAxis

            onPressed: {
                if (containsMouse) {
                    selected = true;
                }
                else {
                    selected = false;
                }
            }

            onReleased: {
                nodeRoot.parent.computeBoundingBox();
            }
        }

        GridLayout {
            id: nodeContentLayout

            columns: 1
            rows: 4
            rowSpacing: 6

            anchors.top: nodeCaptionBackground.bottom
            anchors.bottom: nodeShape.bottom
            anchors.left: nodeShape.left
            anchors.right: nodeShape.right

            anchors.margins: 5

            InputNodeWidget {
                id: testLabelInputWidget

                parentLayout: nodeContentLayout

                inputPortColor: "#85ae21";

                widgetSource: '../Content/LabelNodeWidget.qml'
                widgetModel: "BSDF"
            }

            NoPortNodeWidget {
                id: renderEngineSelectWidget

                parentLayout: nodeContentLayout

                widgetSource: '../Content/ComboBoxNodeWidget.qml'
                widgetModel: ListModel {
                    id: renderEngineModel
                    ListElement { text: "EEVEE" }
                    ListElement { text: "Cycles" }
                    ListElement { text: "All" }
                }
            }

            InputNodeWidget {
                id: testInputWidget

                parentLayout: nodeContentLayout

                inputPortColor: "#5578aa";

                widgetSource: '../Content/ComboBoxNodeWidget.qml'
                widgetModel: ListModel {
                    id: pokemonModel
                    ListElement { text: "Pikachu" }
                    ListElement { text: "Squirtle" }
                    ListElement { text: "Chikorita" }
                    ListElement { text: "Eevee" }
                }
            }

            InputOutputNodeWidget {
                id: testInputOutputWidget

                parentLayout: nodeContentLayout

                inputPortColor: "#cd78a1";
                outputPortColor: "#5578aa";

                widgetSource: '../Content/ComboBoxNodeWidget.qml'
                widgetModel: ListModel {
                    id: dogModel
                    ListElement { text: "Shiba Inu" }
                    ListElement { text: "Maltezer" }
                    ListElement { text: "Poodle" }
                    ListElement { text: "Bulldog" }
                    ListElement { text: "Yorkshire" }
                }
            }

            OutputNodeWidget {
                id: testOutputWidget

                parentLayout: nodeContentLayout

                widgetSource: '../Content/ComboBoxNodeWidget.qml'
                widgetModel: ListModel {
                    id: gamingModel
                    ListElement { text: "PlayStation" }
                    ListElement { text: "XBox" }
                    ListElement { text: "Switch" }
                    ListElement { text: "MegaDrive" }
                    ListElement { text: "GameBoy" }
                }
            }
        }
    }
}
