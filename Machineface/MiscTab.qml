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

    ApplicationItem {
        id: app
        property bool _ready: status.synced
        property int axes: _ready ? status.config.axes : 4
        property var axisNames: ["X", "Y", "Z", "A", "B", "C", "U", "V", "W"]

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
                id: touchoff
                spacing: 10

                Repeater {
                    model: app.axes
                    MyButton {
                        text: "Touchoff " + app.axisNames[index]
                        action: TouchOffAction {
                            touchOffDialog: TouchOffDialog {
                                axis: index
                                height: window.height * 0.2
                            }
                        }
                    }
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
}
