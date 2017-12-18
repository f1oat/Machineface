import QtQuick 2.0
import QtQuick.Controls.Styles 1.2
import QtQuick.Controls 1.2
import QtQuick.Window 2.0

ButtonStyle {
    property double darkness: 0.0
    property color baseColor: "red"
    property color textColor: systemPalette.text

    id: root

    SystemPalette {
        id: systemPalette
    }

    background: Rectangle {
        implicitWidth: 100
        implicitHeight: 25
        border.width: 3
        border.color: button.checked ? pressed_color : "grey"
        radius: 4
        color: control.pressed ? "grey" : MyStyle.backgroundColor
    }

    label: Item {
        opacity: control.enabled ? 1.0 : 0.4
        Image {
            anchors.centerIn: parent
            width: parent.width * 0.6
            height: width
            source: control.iconSource
            smooth: true
            sourceSize: Qt.size(width, height)
        }
        Label {
            anchors.fill: parent
            anchors.margins: parent.width * 0.06
            horizontalAlignment: control.iconSource == "" ? "AlignHCenter" : "AlignRight"
            verticalAlignment: control.iconSource == "" ? "AlignVCenter" : "AlignBottom"
            text: control.text
            color: root.textColor
            font.bold: control.iconSource == "" ? false : true
        }
    }
}
