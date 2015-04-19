import QtQuick 2.0
import QtQuick.Controls 1.2
import QtQuick.Layouts 1.1
import QtQuick.Window 2.0
import Machinekit.Application 1.0
import Machinekit.Application.Controls 1.0
import "."

Tab {
    id: tab
    title: qsTr("Misc")

    Column {
        anchors.fill: parent
        anchors.margins: 10
        spacing: 10

        Row {
            id: spindleMist
            spacing: 10

            MyButton {
                action: SpindleCcwAction { }
            }

            MyButton {
                action: StopSpindleAction { }
            }

            MyButton {
                action: SpindleCwAction { }
            }

            MyButton {
                action: MistAction { }
            }

            MyButton {
                action: FloodAction { }
            }

            Item {
                Layout.fillWidth: true
            }
        }

        Row {
            id: locks
            spacing: 10

            MyButton {
                text: "Vice Lock"
            }
        }

        Grid {
            rows: 2
            spacing: 10
            Repeater {
                model: ["4", "3", "2", "1"]
                MyButton {
                    text: "Tool #" + modelData
                }
            }
        }
    }
}
