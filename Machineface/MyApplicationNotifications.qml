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
import Machinekit.Application 1.0
import QtQuick.Window 2.0

ListView {
    property int messageWidth: 200

    id: root
    implicitWidth: 0
    implicitHeight: 200
    verticalLayoutDirection: ListView.BottomToTop
    model: notificationModel
    delegate: notificationDelegate
    property variant filter: ["motion stopped by enable input"]

    function addNotification (type, text)
    {
        var f = filter.indexOf(text)
        if (f < 0) notificationModel.append({"type": type, "text": text})
    }

    SystemPalette {
        id: systemPalette
    }

    Component {
        id: notificationDelegate
        Rectangle {

            //height: width * 0.4
            anchors.right: parent.right
            width: root.messageWidth
            height: textLabel.height
            //radius: Screen.logicalPixelDensity * 2
            color: systemPalette.light
            border.color: systemPalette.mid
            border.width: 2

            Label {
                id: textLabel
                anchors.left: typeImage.right
                anchors.right: parent.right
                anchors.margins: Screen.logicalPixelDensity * 5
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                wrapMode: Text.WordWrap
                text: model.text
                font.pixelSize: 14
                font.bold: true
            }

            Image {
                id: typeImage
                anchors.left: parent.left
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                width: parent.width * 0.13
                anchors.margins: Screen.logicalPixelDensity * 5
                fillMode: Image.PreserveAspectFit
                source: {
                    switch (model.type) {
                    case ApplicationError.NmlError:
                    case ApplicationError.OperatorError:
                        return "qrc:Machinekit/Application/Controls/icons/dialog-error"
                    case ApplicationError.NmlDisplay:
                    case ApplicationError.OperatorDisplay:
                        return "qrc:Machinekit/Application/Controls/icons/dialog-warning"
                    case ApplicationError.NmlText:
                    case ApplicationError.OperatorText:
                        return "qrc:Machinekit/Application/Controls/icons/dialog-information"
                    default:
                        return ""
                    }
                }
                visible: source != ""
            }

            MouseArea {
                id: notificationMouseArea
                anchors.fill: parent
                onClicked: notificationModel.remove(model.index)
                hoverEnabled: true
            }

            opacity: (notificationMouseArea.containsMouse || (notificationModel.count === (model.index+1))) ? 1.0 : 0.6
        }
    }

    ListModel {
        id: notificationModel
    }
}
