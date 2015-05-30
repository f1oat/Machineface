/****************************************************************************
**
** Copyright (C) 2014 Alexander Rössler
** License: LGPL version 2.1
**
** This file is part of QtQuickVcp.
**
** All rights reserved. This program and the accompanying materials
** are made available under the terms of the GNU Lesser General Public License
** (LGPL) version 2.1 which accompanies this distribution, and is available at
** http://www.gnu.org/licenses/lgpl-2.1.html
**
** This library is distributed in the hope that it will be useful,
** but WITHOUT ANY WARRANTY; without even the implied warranty of
** MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
** Lesser General Public License for more details.
**
** Contributors:
** Alexander Rössler @ The Cool Tool GmbH <mail DOT aroessler AT gmail DOT com>
**
****************************************************************************/

import QtQuick 2.0
import QtQuick.Controls 1.2
import QtQuick.Layouts 1.1
import QtQuick.Dialogs 1.2
import QtQuick.Controls.Styles 1.3
import Machinekit.Application 1.0
import "."

Dialog {
    property alias core: object.core
    property alias status: object.status
    property alias command: object.command
    property int axis: 0
    property var axisNames: ["X", "Y", "Z", "A", "B", "C", "U", "V", "W"]
    property var _axisNames: ["x", "y", "z", "a", "b", "c", "u", "v", "w"]

    property bool _ready: status.synced && command.connected

    id: dialog
    title: qsTr("Touch Off")
    standardButtons: StandardButton.Ok | StandardButton.Cancel
    modality: Qt.ApplicationModal

    onVisibleChanged: {
        if (visible) {
            coordinateSpin.text = "0"
            coordinateSystemCombo.currentIndex = _ready ? status.motion.g5xIndex-1 : 0
        }
    }

    contentItem: Rectangle {
        color: MyStyle.backgroundColor
        implicitWidth: r.width
        implicitHeight: r.height
        id: coordinateSystemCombo
        property int currentIndex: 0

        Row {
            id: r
            spacing: 5
            Column {
                id: col
                spacing: 5

                TextField {
                    id: coordinateSpin

                    font.pixelSize: 25
                    font.bold: true

                    horizontalAlignment: TextInput.AlignRight

                    style: TextFieldStyle {
                        background: Rectangle {
                            implicitWidth: 250
                            implicitHeight: MyStyle.buttonSize
                            border.color: "gray"
                            color: MyStyle.backgroundColor
                            radius: 2
                        }
                        textColor: MyStyle.foregroundColor
                    }
                }

                CNC_Keypad {
                    id: keypad
                    numeric: true
                    width: coordinateSpin.width
                    height: width
                    layout:
                        ["7:0", "8:0", "9:0",
                         "4:0", "5:0", "6:0",
                         "1:0", "2:0", "3:0",
                         "0:0", ".:0", "-:0",
                         "Ok:2", "Cancel:1", "Back:3"]

                    onKeyPressed: {
                        switch (k) {
                        case "Ok":
                            if (_ready) {
                                if (status.task.taskMode !== ApplicationStatus.TaskModeMdi) {
                                    command.setTaskMode('execute', ApplicationCommand.TaskModeMdi)
                                }
                                var axisName = _axisNames[axis]
                                var position = status.motion.position[axisName] - status.motion.g92Offset[axisName] - status.io.toolOffset[axisName]
                                var newOffset = (position - coordinateSpin.text) / status.config.axis[axis].units
                                var mdi = "G10 L2 P" + (coordinateSystemCombo.currentIndex + 1) + " " + axisNames[axis] + newOffset.toFixed(6)
                                console.log(mdi)
                                command.executeMdi('execute', mdi)
                            }
                            dialog.close()
                            break;
                        case "Cancel":
                            dialog.close()
                            break;
                        case "Back":
                            coordinateSpin.text = coordinateSpin.text.slice(0, -1)
                            break;
                        default:
                            if (coordinateSpin.text == "0") coordinateSpin.text = ""
                            coordinateSpin.text += k
                            break;
                        }
                    }
                }
            }
            Grid {
                rows: 5
                spacing: 5
                ExclusiveGroup { id: xGroup }
                Repeater {
                    model:[
                        "G54",
                        "G55",
                        "G56",
                        "G57",
                        "G58",
                        "G59",
                        "G59.1",
                        "G59.2",
                        "G59.3"
                    ]
                    MyButton {
                        text: modelData
                        exclusiveGroup: xGroup
                        checked: index == coordinateSystemCombo.currentIndex
                        onClicked: {
                            checked = true
                            coordinateSystemCombo.currentIndex = index
                        }
                    }
                }
            }

        }
    }

    ApplicationObject {
        id: object
    }
}
