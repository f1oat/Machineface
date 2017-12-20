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
import QtQuick.Controls 1.1
import QtQuick.Layouts 1.1
import QtQuick.Window 2.0
import Machinekit.Application 1.0
import Machinekit.Application.Controls 1.0
import Machinekit.Controls 1.0
import Machinekit.HalRemote 1.0
import Machinekit.HalRemote.Controls 1.0
import Machinekit.Service 1.0
import Machinekit.PathView 1.0
import QtQuick.Controls.Styles 1.3
import "."

ServiceWindow {
    id: window
    color: MyStyle.backgroundColor

    visible: true
    title: applicationCore.applicationName + (d.machineName == "" ? "" : " - " + d.machineName)

    ListModel { id: logModel }

    QtObject {
        id: d
        property string machineName: applicationCore.status.config.name
    }

    ApplicationCore {
        id: applicationCore
        notifications: notificationLine
        applicationName: "Machineface"
    }

    PathViewCore {
        id: pathViewCore
    }

    ApplicationRemoteFileDialog {
        id: applicationFileDialog
        width: window.width
        height: window.height
        fileDialog: fileDialog
    }

    ApplicationFileDialog {
        id: fileDialog
    }

    Service {
        id: halrcompService
        type: "halrcomp"
    }

    Service {
        id: halrcmdService
        type: "halrcmd"
    }

    HalRemoteComponent {
        id: halRemoteComponent
        halrcmdUri: halrcmdService.uri
        halrcompUri: halrcompService.uri
        ready: (halrcmdService.ready && halrcompService.ready) || connected
        name: "control"
        containerItem: container
        create: false
        onErrorStringChanged: console.log(errorString)
    }

    ColumnLayout {
        anchors.fill: parent
        id: container

        ApplicationToolBar {
            id: toolBar
            Layout.fillWidth: true
            Layout.fillHeight: true
            //height: 70
            Layout.preferredHeight:25
        }

        Rectangle {
            Layout.fillWidth: true
            height: 20
            color: "black"
            border.color: "white"
            border.width: 1
            Label {
                id: notificationLine
                anchors.margins: 2
                anchors.left: parent.left
                anchors.top: parent.top
                text: "idle"
                color: "orange"
                font.pixelSize: 14
                font.bold: true
                visible: false

                property bool display: applicationCore.status.running
                property variant filter: ["motion stopped by enable input"]

                Timer {
                    id: blinker
                    interval: 250; running: display; repeat: true
                    onTriggered: notificationLine.visible = !notificationLine.visible
                }

                function addNotification (type, str)
                {
                    var f = filter.indexOf(str)
                    if (f >= 0) return

                    str = str.replace(".000000", "")
                    switch (type) {
                    case ApplicationError.OperatorText:
                        text = str
                        break
                    default:
                        mainTab.currentIndex = 6
                        break
                    }

                    logModel.append({"type": type, "text": str})
                }

                onDisplayChanged: {
                    if (!display) {
                        text = ""
                        notificationLine.visible = false
                    }
                }

                onTextChanged: {
                    if (text != "") {
                        notificationLine.visible = true
                        blinker.start()
                    }
                }
            }
        }

        StatusPanel {
            id: statusPanel
            Layout.fillWidth: true
            foregroundColor: MyStyle.foregroundColor
            backgroundColor: MyStyle.backgroundColor
            background: "transparent"
        }

        TabView {
            id: mainTab
            Layout.fillWidth: true
            //Layout.preferredHeight: 580
            Layout.fillHeight: true
            currentIndex: 0
            frameVisible: true
            transformOrigin: Item.Center

            style: TabViewStyle {
                           frameOverlap: 1
                           tab: Rectangle {
                               color: styleData.selected ? "grey" : MyStyle.backgroundColor
                               border.color:  MyStyle.foregroundColor
                               implicitWidth: Math.max(text.width + 4, 80)
                               implicitHeight: 70
                               radius: 2
                               Text {
                                   id: text
                                   anchors.centerIn: parent
                                   text: styleData.title
                                   color: MyStyle.foregroundColor
                                   font.pixelSize: 14
                                   font.bold: true
                               }
                           }
                           frame: Rectangle { color: "transparent" /*MyStyle.backgroundColor*/ }
                       }

            JogControlTab {active: true}
            MiscTab {
                active: true
                pin_safety_disable: statusPanel._pin_safety_disable
                pin_vise_lock: statusPanel._pin_vise_lock
                pin_vise_locked_led: statusPanel._pin_vise_locked_led
            }
            ToolsTab {
                 active: true
                 pin_vise_locked_led: statusPanel._pin_vise_locked_led
                 tool_number: statusPanel.tool_number
                 Component.onCompleted: {
                     console.log("connect2")
                     toolBar.abort.connect(abort)
                 }
            }
            MdiTab {active: true}
            GCodeTab {active: true}
            PreviewTab {active: true}
            //VideoTab {}
            //ExtrasTab {}
            //SettingsTab {}
            Tab {
                id: logTab
                title: qsTr("Log")
                active: true
                ColumnLayout {
                    anchors.fill: parent
                    anchors.margins: Screen.pixelDensity * 1

                    LogHistory {
                        id: logHistory
                        model: logModel
                    }
                }
            }
        }
    }
}
