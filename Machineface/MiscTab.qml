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
    property HalPin pin_vise_lock
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
                spacing: 10

                MyGroupBox {
                    title: "Spindle"
                    ExclusiveGroup { id: spindle_group }

                    Row {
                        id: spindle
                        spacing: 10

                        MyButton {
                            action: StopSpindleAction { }
                            text: "Spindle\nStop"
                            exclusiveGroup: spindle_group
                            onClicked: checked = true
                        }

                        MyButton {
                            action: SpindleCwAction { }
                            text: "Spindle\nCW"
                            exclusiveGroup: spindle_group
                            onClicked: checked = true
                        }
                    }
                }

                MyGroupBox {
                    title: "Coolant"

                    Row {
                        id: coolant
                        spacing: 10

                        MyButton {
                            action: MistAction { }
                        }

                        MyButton {
                            action: FloodAction { }
                        }

                    }
                }

                Item {
                    Layout.fillWidth: true
                }
            }

            MyGroupBox {
                id: touchoff
                title: "Manual touch off"
                Row {
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
            }

            MyGroupBox {
                id: locks
                title: "Locks"

                Row {

                    spacing: 10

                    MyButton {
                        text: "Vise Lock"
                        checked: pin_vise_locked_led.value
                        onClicked: {
                            pin_vise_lock.value = !pin_vise_locked_led.value
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
            }

            MdiCommandAction {
                id: myAction
                enableHistory: false
            }
        }
    }
}
