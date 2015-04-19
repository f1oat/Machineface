import QtQuick 2.0
import QtQuick.Controls 1.2
import QtQuick.Layouts 1.1
import QtQuick.Window 2.0
import Machinekit.Application 1.0
import Machinekit.Application.Controls 1.0
import QtQuick.Controls.Styles 1.3
import "."

Button {
    id: button

    style: ButtonStyle {
        background: Rectangle {
            implicitWidth: 100
            implicitHeight: MyStyle.buttonSize
            border.width: 3
            border.color: button.checked ? "lightgreen" : "grey"
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
                color: MyStyle.foregroundColor
            }
        }
    }
}
