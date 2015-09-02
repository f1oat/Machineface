import QtQuick 2.0
import QtQuick.Controls 1.2
import QtQuick.Layouts 1.1
import QtQuick.Window 2.0
import QtQuick.Dialogs 1.2
import QtQuick.Controls.Styles 1.3
import Machinekit.Application 1.0
import Machinekit.Application.Controls 1.0
import Machinekit.Controls 1.0
import Machinekit.HalRemote 1.0
import Machinekit.HalRemote.Controls 1.0
import Machinekit.Service 1.0
import "."

Tab {
    id: tab
    title: qsTr("Tools")
    property int tool_number
    property bool _ready: status.synced && command.connected
    property HalPin pin_vise_locked_led
    signal abort

    ApplicationItem {
        id: app
        property bool _ready: status.synced && command.connected

        enabled: _ready
                 && (status.task.taskState === ApplicationStatus.TaskStateOn)
                 && !status.running

        Column {
            anchors.fill: parent
            anchors.margins: 10
            spacing: 10

            MyGroupBox {
                title: "Tool Change"

                Grid {
                    rows: 2
                    spacing: 10
                    Repeater {
                        model: ["4", "2", "0", "3", "1"]
                        MyButton {
                            text: modelData == 0 ? "Unload\nTool" : "Load\nTool #" + modelData
                            onClicked: {
                                myAction.mdiCommand = "T" + modelData + " M6 G43"
                                myAction.trigger()
                            }
                            checked: tool_number == modelData
                        }
                    }
                }
            }

            MyGroupBox {
                title: "Tool Length Measurement"
                enabled: pin_vise_locked_led.value

                Grid {
                    rows: 2
                    spacing: 10
                    Repeater {
                        id: selection
                        model: ["4", "2", "0", "3", "1"]
                        MyButton {
                            text: modelData == 0 ? "Measure\nSelected" : "Select\nTool #" + modelData
                            onClicked: {
                                if (modelData == 0) {
                                    var toolno
                                    var idx
                                    var selected_tools = [ 0, 0, 0, 0 ]
                                    for (idx=0; idx<5; idx++) {
                                        if (selection.itemAt(idx).checked) {
                                            toolno = selection.model[idx]
                                            selected_tools[toolno-1] = 1
                                            selection.itemAt(idx).checked = false
                                        }
                                    }
                                    myAction.mdiCommand = "o<measure-tools> call"
                                    if (tool_number >0) toolno = tool_number
                                    else tool_number = 1
                                    for (idx=0; idx<4; idx++) {
                                        if (selected_tools[toolno-1]) myAction.mdiCommand += " [" + toolno + "]"
                                        else myAction.mdiCommand += " [0]"
                                        toolno++
                                        if (toolno > 4) toolno = 1
                                    }
                                    myAction.trigger()
                                }
                                else {
                                    checked = !checked
                                }
                            }
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
