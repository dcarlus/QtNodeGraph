import QtQuick 2.0
import QtQuick.Controls 2.15

Item {
    id: nodeSceneRoot
    anchors.fill: parent

    // Scene interactions.
    MouseArea {
        id: sceneMouseArea
        anchors.fill: parent

        property real mouseOffset: 0.

        onWheel: (wheel) => {
            if ((wheel.angleDelta.y > 0) && (nodeContainerTransform.xScale < 2.)) {
                nodeContainerTransform.xScale += 0.1;
            }
            else if ((wheel.angleDelta.y < 0) && (nodeContainerTransform.xScale > 0.25)) {
                 nodeContainerTransform.xScale -= 0.1;
            }

            nodeContainerTransform.yScale = nodeContainerTransform.xScale;
        }

        onPressed: {
            nodeContainer.selection();
            nodeContainer.selectedNode = null;
        }
    }

    // Scene content.
    Item {
        id: nodeContainer
        anchors.fill: parent

        property Node selectedNode

        function selection() {
            if (selectedNode != null) {
                selectedNode.selected = false;

                // Decrease the Z value of all the sibling nodes.
                var amountNodes = children.length;

                for (var nodeIndex = 0; nodeIndex < amountNodes; ++nodeIndex) {
                    var node = children[nodeIndex];

                    if (node !== this) {
                        node.z -= 1;
                    }
                }
            }
        }

        transform: Scale {
            id: nodeContainerTransform
        }

        Node {
            id: stepNode
            caption: "A step to do something"
            captionColor: Qt.rgba(0.4, 0.7, 0.1)

            x: 200
            y: 50
        }

        Node {
            id: actionNode
            caption: "Action to be linked to a button"
            captionColor: Qt.rgba(0.8, 0.2, 0.1)

            x: 30
            y: 300
        }

        Node {
            id: userInputNode
            caption: "A value that the user enter"
            captionColor: Qt.rgba(0.2, 0.5, 0.9)

            x: 150
            y: 150
        }
    }
}
