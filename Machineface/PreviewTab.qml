import QtQuick 2.0
import QtQuick.Controls 1.2
import QtQuick.Layouts 1.1
import QtQuick.Window 2.0
import Machinekit.Controls 1.0
import Machinekit.PathView 1.0

Tab {
    title: qsTr("Preview")

    property bool zoomButtons: !(Qt.platform.os == "android")

    Rectangle {
        anchors.fill: parent
        anchors.margins: Screen.pixelDensity
        color: "transparent"
        border.width: 1
        border.color: systemPalette.shadow

        SystemPalette { id: systemPalette }

        RowLayout {
            anchors.fill: parent
            spacing: 0

            PathView3D {
                id: pathView
                Layout.fillHeight: true
                Layout.fillWidth: true
                visible: true

                onViewModeChanged: {
                    cameraZoom = 0.95
                    cameraOffset = Qt.vector3d(0,0,0)
                    cameraPitch = 60
                    cameraHeading = -135
                }
            }

            Item {
                Layout.fillHeight: true
                Layout.preferredWidth: 70
                visible: pathView.visible
                Rectangle {
                    width: parent.width
                    height: parent.height
                    color: "black"
                }

                ColumnLayout {
                    id: viewModeLayout
                    anchors.fill: parent
                    anchors.leftMargin: Screen.pixelDensity / 2
                    anchors.margins: Screen.pixelDensity
                    spacing: Screen.pixelDensity

                    MyButton {
                        visible: zommButtons
                        Layout.fillWidth: true
                        Layout.preferredHeight: width
                        action: ZoomOutAction { view: pathView }
                        showIcon: false
                    }
                    MyButton {
                        visible: zommButtons
                        Layout.fillWidth: true
                        Layout.preferredHeight: width
                        action: ZoomInAction { view: pathView }
                        showIcon: false
                    }
                    MyButton {
                        visible: zommButtons
                        Layout.fillWidth: true
                        Layout.preferredHeight: width
                        action: ZoomOriginalAction { view: pathView }
                        showIcon: false
                    }
                    MyButton {
                        Layout.fillWidth: true
                        Layout.preferredHeight: width
                        action: ViewModeAction { view: pathView; viewMode: "Top"}
                        showIcon: false
                    }
//                    MyButton {
//                        Layout.fillWidth: true
//                        Layout.preferredHeight: width
//                        action: ViewModeAction { view: pathView; viewMode: "RotatedTop"}
//                        showIcon: false
//                    }
                    MyButton {
                        Layout.fillWidth: true
                        Layout.preferredHeight: width
                        action: ViewModeAction { view: pathView; viewMode: "Front"}
                        showIcon: false
                    }
                    MyButton {
                        Layout.fillWidth: true
                        Layout.preferredHeight: width
                        action: ViewModeAction { view: pathView; viewMode: "Side"}
                        showIcon: false
                    }
                    MyButton {
                        Layout.fillWidth: true
                        Layout.preferredHeight: width
                        action: ViewModeAction { view: pathView; viewMode: "Perspective"}
                        showIcon: false
                        text: "3D"
                    }
                    Item {
                        Layout.fillHeight: true
                    }
                }
            }
        }
    }
}
