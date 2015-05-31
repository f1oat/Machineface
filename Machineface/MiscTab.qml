import QtQuick 2.0
import QtQuick.Controls 1.2
import QtQuick.Layouts 1.1
import QtQuick.Window 2.0
import QtQuick.Dialogs 1.2
import Machinekit.Application 1.0
import Machinekit.Application.Controls 1.0
import Machinekit.Controls 1.0
import Machinekit.HalRemote 1.0
import Machinekit.HalRemote.Controls 1.0
import Machinekit.Service 1.0

Tab {
    id: tab
    title: qsTr("Misc")
    property HalPin pin_tool_number
    property HalPin pin_vise_locked_led
    property HalPin pin_safety_disable

    ApplicationItem {
        id: app
        property bool _ready: status.synced
        property int axes: _ready ? status.config.axes : 4
        property var axisNames: ["X", "Y", "Z", "A", "B", "C", "U", "V", "W"]

        MyTouchOffDialog {
            id: myTouchOffDialog
        }

        Column {
            anchors.fill: parent
            anchors.margins: 10
            spacing: 10

            Row {
                id: spindleMist
                spacing: 10

                MyButton {
                    action: StopSpindleAction { }
                }

                MyButton {
                    action: SpindleCwAction { }
                }

                MyButton {
                    action: MistAction { }
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
                        onClicked: {
                            myTouchOffDialog.axis = index
                            myTouchOffDialog.open()
                        }
                    }
                }
            }

            Row {
                id: locks
                spacing: 10

                MyButton {
                    text: "Vise Lock"
                    checked: pin_vise_locked_led.value
                    onClicked: {
                        myAction.mdiCommand = checked ? "M103": "M104"
                        myAction.trigger()
                    }
                }

                MyButton {
                    id: _safety_button
                    text: "No Safety"
                    pressed_color: "red"
                    checked: pin_safety_disable.value
                    onClicked: {
                        pin_safety_disable.value = !pin_safety_disable.value
                    }
                }
            }

            Grid {
                rows: 2
                spacing: 10
                Repeater {
                    model: ["4", "2", "0", "3", "1"]
                    MyButton {
                        text: modelData == 0 ? "Tool Unload" : "Tool #" + modelData
                        onClicked: {
                            myAction.mdiCommand = "T" + modelData + " M6"
                            myAction.trigger()
                        }
                        checked: pin_tool_number.value == modelData
                    }
                }
            }

            MdiCommandAction {
                id: myAction
                enableHistory: false
            }
        }
    }
}
