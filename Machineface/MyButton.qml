import QtQuick 2.0
import QtQuick.Controls 1.2
import QtQuick.Layouts 1.1
import QtQuick.Window 2.0
import QtQuick.Controls.Styles 1.3
import "."

Button {
    id: button
    property int pixelSize: 14
    property color textColor: MyStyle.foregroundColor
    property string pressed_color: "lightgreen"
    width: MyStyle.buttonSize
    height: MyStyle.buttonSize

    style: ButtonStyle {
        background: Rectangle {
            implicitWidth: parent.width
            implicitHeight: parent.height
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
                color: button.textColor
                font.bold: control.iconSource === "" ? false : true
                font.pixelSize: button.pixelSize
                wrapMode: Text.WordWrap
            }
        }
    }
}
