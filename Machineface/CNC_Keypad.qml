import QtQuick 2.0
import QtQuick.Controls 1.2
import QtQuick.Layouts 1.0
import "."

Rectangle {
    id: keypad
    width: 300
    height: 400

    property bool numeric: false

    property var layout1:
        ["7:0", "8:0", "9:0",
         "4:0", "5:0", "6:0",
         "1:0", "2:0", "3:0",
         "0:0", ".:0", "-:0"]

    property var layout2:
        ["X:1",    "Y:1", "Z:1", "A:1",
         "Q:2",    "R:2", "S:2", "F:2",
         "G:2",    "7:0", "8:0", "9:0",
         "M:2",    "4:0", "5:0", "6:0",
         "T:2",    "1:0", "2:0", "3:0",
         "Back:3", "0:0", ".:0", "-:0"]

    property var layout: numeric ? layout1 : layout2
    property variant keyColors: [ "white", "yellow", "green", "red" ]

    signal keyPressed(string k)

    color: MyStyle.backgroundColor

    GridLayout {
        id: grid1
        columns: numeric ? 3 : 4
        anchors.fill: parent

        Repeater {
            id: repeater1
            model: keypad.layout
            MyButton {
                property var g: modelData.split(":")
                text: g[0]
                textColor: keypad.keyColors[parseInt(g[1])]
                Layout.fillWidth: true
                Layout.fillHeight: true
                pixelSize: 20
                onClicked: {
                    keypad.keyPressed(text)
                    console.log(g)
                    console.log(textColor)
                    console.log(keypad.keyColors[1])
                }
            }
        }
    }
}

