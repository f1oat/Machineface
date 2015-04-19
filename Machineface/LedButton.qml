import QtQuick 2.0
import QtQuick.Layouts 1.0
import QtQuick.Controls 1.2
import Machinekit.Controls 1.0
import Machinekit.Application.Controls 1.0

RowLayout {
    id: root
    property string name: "Button"
    property color onColor: "#24ff7d"

    Button {
        id: button1
        y: 2
        text: root.name
        anchors.left: parent.left
        anchors.leftMargin: 0
    }

    Led {
        id: ledRound1
        x: 0
        y: 0
        width: 30
        height: 30
        radius: 15
        shine: true
        value: false
        blink: false
        anchors.verticalCenter: parent.verticalCenter
        anchors.right: parent.right
        anchors.rightMargin: 0
        onColor: root.onColor
    }
}
