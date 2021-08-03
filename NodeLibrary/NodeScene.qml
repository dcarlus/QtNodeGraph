import QtQuick 2.0
import QtQuick.Controls 2.15
import QtQuick.Shapes 1.1

Item {
    id: sceneRoot
    anchors.fill: parent

    Component.onCompleted: centerOnContent();

    function centerOnContent() {
        nodesContainer.computeBoundingBox();

        var sceneWidth = width;
        var sceneHeight = height;
        var sceneCenter = Qt.point(width / 2, height / 2);

        var contentTopLeft = nodesContainer.bboxTopLeft;
        var contentBottomRight = nodesContainer.bboxBottomRight;
        var contentWidth = contentBottomRight.x - contentTopLeft.x;
        var contentHeight = contentBottomRight.y - contentTopLeft.y;

        var dX = sceneCenter.x - contentWidth;
        var dY = sceneCenter.y - contentHeight;

        nodesContainer.x = dX;
        nodesContainer.y = dY;
    }

    Rectangle {
        id: sceneBackground
        anchors.fill: parent

        gradient: Gradient {
            GradientStop { position: 0; color: "#566267" }
            GradientStop { position: 0.5; color: "#4a515a" }
            GradientStop { position: 1.; color: "#3f4349" }
        }
    }

    // Scene interactions.
    MouseArea {
        id: sceneMouseArea
        anchors.fill: parent

        drag.target: nodesContainer
        drag.axis: Drag.XAndYAxis

        acceptedButtons: Qt.AllButtons

        // Position of the mouse on press.
        property point clickPosition: Qt.point(0, 0)
        property point previousDelta: Qt.point(0, 0)

        // Press a mouse button.
        onPressed: mouse => {
            nodesContainer.selection();
            nodesContainer.selectedNode = null;

            if (mouse.button === Qt.MiddleButton) {
                nodesContainer.enabled = false;
                cursorShape = Qt.SizeAllCursor;
                clickPosition = Qt.point(mouse.x, mouse.y);
            }
        }

        // Release the mouse button.
        onReleased: mouse => {
            if (mouse.button === Qt.MiddleButton) {
                nodesContainer.enabled = true;
                cursorShape = Qt.ArrowCursor;
                clickPosition = Qt.point(0, 0);
                previousDelta = Qt.point(0, 0);
            }
        }

        // Moving the mouse while it is pressed.
        onPositionChanged: mouse => {
            if (mouse.button === Qt.MiddleButton) {
                var dx = mouse.x - clickPosition.x;
                var dy = mouse.y - clickPosition.y;

                var xIncrPos = dx - previousDelta.x;
                var yIncrPos = dy - previousDelta.y;

                nodesContainer.pan(dx, dy);
            }
        }

        // Scrolling.
        onWheel: (wheel) => {
            if ((wheel.angleDelta.y > 0) && (nodeContainerTransform.xScale < 2.)) {
                nodeContainerTransform.xScale += 0.1;
            }
            else if ((wheel.angleDelta.y < 0) && (nodeContainerTransform.xScale > 0.25)) {
                 nodeContainerTransform.xScale -= 0.1;
            }

            nodeContainerTransform.yScale = nodeContainerTransform.xScale;
        }
    }

    // Scene content.
    Item {
        id: nodesContainer
        x: parent.x
        y: parent.y
        width: parent.width
        height: parent.height

        property var bboxTopLeft: Qt.point(0,0)
        property var bboxBottomRight: Qt.point(0,0)
        property Node selectedNode

        Component.onCompleted: computeBoundingBox();

        ///
        /// @brief  Process the selection of node.
        ///
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

        ///
        /// @brief  Compute the bounding box of the node container.
        ///
        function computeBoundingBox() {
            bboxTopLeft = Qt.point(Number.MAX_SAFE_INTEGER, Number.MAX_SAFE_INTEGER);
            bboxBottomRight = Qt.point(0, 0);

            var amountNodes = children.length;

            for (var nodeIndex = 0; nodeIndex < amountNodes; ++nodeIndex) {
                var node = children[nodeIndex];

                var mappedTopLeft = mapToItem(sceneRoot, node.x, node.y);
                var mappedBottomRight = mapToItem(sceneRoot, node.x + node.width, node.y + node.height);

                // Node corner positions.
                var nodeTopLeftX = mappedTopLeft.x;
                var nodeTopLeftY = mappedTopLeft.y;
                var nodeBottomRightX = mappedBottomRight.x;
                var nodeBottomRightY = mappedBottomRight.y;

                var bboxTopLeftX = (nodeTopLeftX < bboxTopLeft.x) ? nodeTopLeftX : bboxTopLeft.x;
                var bboxTopLeftY = (nodeTopLeftY < bboxTopLeft.y) ? nodeTopLeftY : bboxTopLeft.y;
                var bboxBottomRightX = (nodeTopLeftX > bboxBottomRight.x) ? nodeTopLeftX : bboxBottomRight.x;
                var bboxBottomRightY = (nodeTopLeftY > bboxBottomRight.y) ? nodeTopLeftY : bboxBottomRight.y;

                bboxTopLeft = Qt.point(bboxTopLeftX, bboxTopLeftY);
                bboxBottomRight = Qt.point(bboxBottomRightX, bboxBottomRightY);
            }
        }

        function pan(panX, panY) {
            x += panX
            y += panY
        }

        transform: Scale {
            id: nodeContainerTransform
        }

        Node {
            id: stepNode
            caption: "A node to do something"
            captionColor: Qt.rgba(0.4, 0.7, 0.1)

            x: 200
            y: 50
        }

        Node {
            id: actionNode
            caption: "Node to be linked to another one"
            captionColor: Qt.rgba(0.8, 0.2, 0.1)

            x: 30
            y: 300
        }

        Node {
            id: userInputNode
            caption: "Another node with an elided title to show it works"
            captionColor: Qt.rgba(0.2, 0.5, 0.9)

            x: 150
            y: 150
        }
    }

    Item {
        id: connectionsContainer
        anchors.fill: parent
    }
}
