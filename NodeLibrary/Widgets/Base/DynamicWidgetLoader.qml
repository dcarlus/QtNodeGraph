import QtQuick 2.0
import QtQuick.Layouts 1.15

Item {
    // Dynamic widget loading.
    property var widget
    property string widgetSource
    property var widgetModel
    property Layout parentLayout

    QtObject {
        id: internal
        property Component component;
    }

    Component.onCompleted: createWidget()

    onWidgetChanged: {
        if (widget === null || widgetModel === null) {
            return;
        }

        widget.model = widgetModel;
    }

    function createWidget() {
        internal.component = Qt.createComponent(
            widgetSource,
            widgetContainer
        );

        if (internal.component.status === Component.Ready) {
            finishCreation();
        }
        else {
            internal.component.statusChanged.connect(finishCreation);
        }
    }

    function finishCreation() {
        if (internal.component.status === Component.Ready) {
            widget = internal.component.createObject(widgetContainer);

            if (widget === null) {
                // Error Handling
                console.log("Error creating object");
            }
            else {
                parentLayout.implicitHeight += widget.height;
            }
        }
        else if (component.status === Component.Error) {
            // Error Handling
            console.log("Error loading component:", internal.component.errorString());
        }
    }
}
