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

    style: ButtonStyle {
        background: Rectangle {
            implicitWidth: MyStyle.buttonSize
            implicitHeight: MyStyle.buttonSize
            border.width: 3
            border.color: button.checked ? pressed_color : "grey"
            radius: 4
            color: control.pressed ? "grey" : MyStyle.backgroundColor
        }

        label: Item {
            anchors.fill: parent
            Text {
                anchors.verticalCenter: parent.verticalCenter
                anchors.horizontalCenter: parent.horizontalCenter
                text: control.text
                font.bold: true
                font.pixelSize: button.pixelSize
                color: enabled ? button.textColor : "grey"
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                wrapMode: Text.WordWrap
            }
        }
    }
}
