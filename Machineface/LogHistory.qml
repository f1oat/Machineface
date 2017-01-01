import QtQuick 2.0
import QtQuick.Controls 1.2
import QtQuick.Layouts 1.1
import QtQuick.Controls.Styles 1.2
import QtQuick.Dialogs 1.1

import Machinekit.Application 1.0

TableView {
    id: logTableView
    frameVisible: true
    alternatingRowColors: true
    backgroundVisible: true
    Layout.fillWidth: true
    Layout.fillHeight: true
    model: null
    headerVisible: false
    rowDelegate: Rectangle {
        height: 20
        width: parent.width
        color: styleData.alternate ? "#202020" : "black"
    }


    TableViewColumn{ role: "type"  ; title: "Type" ;  width: 32; delegate: typeDelegate;}
    TableViewColumn{ role: "text"  ; title: "Text" ; delegate: textDelegate }

    Component {
        id: typeDelegate

        Image {
            id: typeImage
            //width: parent.width * 0.13
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
    }

    Component {
        id: textDelegate

        Label {
            text: model.text
            color: "white"
            font.pixelSize: 14
        }
    }

    MouseArea {
        anchors.fill: parent
        anchors.rightMargin: 30 // to avoid scrollbar
        onDoubleClicked: { messageDialog.open() }
    }

    MessageDialog {
        id: messageDialog
        //title: "May I have your attention please"
        text: "Clear log?"
        icon: StandardIcon.Question
        standardButtons: StandardButton.Yes | StandardButton.No
        onYes: {
            model.clear()
            close()
        }
        onNo: {
            close()
        }
    }

    Timer {
        id: delay
        interval: 100; running: false; repeat: false
        onTriggered: logTableView.positionViewAtRow(logTableView.rowCount-1, TableView.Contain)
    }

    onRowCountChanged: {
        delay.start()
    }
}
