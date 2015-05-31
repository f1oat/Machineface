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
    color: "transparent" //MyStyle.backgroundColor

    Image {
        id: background
        anchors.fill: parent
        fillMode: Image.Stretch
        source: "images/black-parchment-paper-texture.jpg"
    }

    visible: true
    title: applicationCore.applicationName + (d.machineName == "" ? "" : " - " + d.machineName)

    QtObject {
        id: d
        property string machineName: applicationCore.status.config.name
    }

    ApplicationCore {
        id: applicationCore
        notifications: applicationNotifications
        applicationName: "Machineface"
    }

    PathViewCore {
        id: pathViewCore
    }

    ApplicationFileDialog {
        id: applicationFileDialog
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
        width: window.width
        id: container

        ApplicationToolBar {
            id: toolBar
            width: window.width
            height: 70
        }

        StatusPanel {
            id: statusPanel
            foregroundColor: MyStyle.foregroundColor
            backgroundColor: MyStyle.backgroundColor
            background: "transparent"
        }

        TabView {
            id: mainTab
            Layout.preferredWidth: window.width
            Layout.preferredHeight: 600
            currentIndex: 0
            frameVisible: true
            transformOrigin: Item.Center

            style: TabViewStyle {
                           frameOverlap: 1
                           tab: Rectangle {
                               color: styleData.selected ? "grey" : MyStyle.backgroundColor
                               border.color:  MyStyle.foregroundColor
                               implicitWidth: Math.max(text.width + 4, 80)
                               implicitHeight: 40
                               radius: 2
                               Text {
                                   id: text
                                   anchors.centerIn: parent
                                   text: styleData.title
                                   color: MyStyle.foregroundColor
                               }
                           }
                           frame: Rectangle { color: "transparent" /*MyStyle.backgroundColor*/ }
                       }

            JogControlTab {}
            MiscTab {
                pin_safety_disable: statusPanel._pin_safety_disable
                pin_tool_number: statusPanel._pin_tool_number
                pin_vise_locked_led: statusPanel._pin_vise_locked_led
            }
            MdiTab {}
            GCodeTab {}
            PreviewTab {}
            VideoTab {}
            //ExtrasTab {}
            SettingsTab {}
        }

        ApplicationProgressBar {
            id: applicationProgressBar
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            width: parent.width
            anchors.margins: Screen.pixelDensity
        }
    }

    ApplicationNotifications {
        id: applicationNotifications
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.top: parent.top
        anchors.margins: Screen.pixelDensity * 3
        messageWidth: parent.width * 0.25
    }
}
