import QtQuick 2.0
import QtQuick.Controls 1.2
import QtQuick.Layouts 1.1
import QtQuick.Window 2.0
import Machinekit.Application.Controls 1.0

Tab {
    title: qsTr("MDI")
    ColumnLayout {
        anchors.fill: parent
        anchors.margins: Screen.pixelDensity * 1

        RowLayout {
            MdiHistoryTable {
                id: history
                Layout.fillHeight: true
                Layout.fillWidth: true
                onCommandSelected: {
                    mdiCommandEdit.text = command
                }
                onCommandTriggered: {
                    mdiCommandEdit.text = command
                    mdiCommandEdit.action.trigger()
                }
                Component.onCompleted: {
                    positionViewAtRow(rowCount-1, ListView.End)
                }
            }

            CNC_Keypad {
                width: 300
                Layout.fillHeight: true
                onKeyPressed: {
                    if (k != "Back") {
                        mdiCommandEdit.text += k
                    }
                    else {
                        mdiCommandEdit.text = mdiCommandEdit.text.slice(0, -1)
                    }
                }
            }
        }

        RowLayout {
            id: mdiCommandEdit
            property alias text: mdiTextField.text
            property alias action: mdiCommandAction
            property alias core: mdiCommandAction.core
            property alias status: mdiCommandAction.status
            property alias command: mdiCommandAction.command
            property alias mdiHistory: mdiCommandAction.mdiHistory
            property int mdiHistoryPos: -1

            Layout.fillWidth: true
            Layout.fillHeight: false

            TextField {

                id: mdiTextField
                Layout.fillWidth: true
                Layout.fillHeight: true

                onAccepted: {
                    if (text != "") {
                        mdiCommandAction.trigger()
                    }
                }

                Keys.onUpPressed: {
                    if (mdiHistory.model.length > 0) {
                        if (mdiHistoryPos == -1) {
                            mdiHistoryPos = mdiHistory.model.length
                        }

                        mdiHistoryPos -= 1

                        if (mdiHistoryPos == -1) {
                            mdiHistoryPos = 0
                        }

                        mdiTextField.text = mdiHistory.model[mdiHistoryPos].command
                    }
                }

                Keys.onDownPressed: {
                    if (mdiHistory.model.length > 0) {
                        mdiHistoryPos += 1

                        if (mdiHistoryPos === mdiHistory.model.length) {
                            mdiHistoryPos -= 1
                        }

                        mdiTextField.text = mdiHistory.model[mdiHistoryPos].command
                    }
                }
            }

            Button {
                Layout.fillHeight: true
                Layout.fillWidth: false
                action: mdiCommandAction
            }

            MdiCommandAction {
                id: mdiCommandAction
                mdiCommand: mdiTextField.text
                onTriggered: {
                    mdiTextField.text = ''
                    //mdiHistoryPos = -1
                    history.positionViewAtRow(history.rowCount-1, ListView.End)
                }
            }
        }
    }
}
