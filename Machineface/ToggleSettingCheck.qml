import QtQuick 2.0
import QtQuick.Controls 1.2
import QtQuick.Layouts 1.1
import "."

RowLayout {
    property string groupName: "group"
    property string valueName: "value"
    property string text: qsTr("Group Value")

    CheckBox {
        checked: applicationCore.settings.initialized && applicationCore.settings.values[parent.groupName][parent.valueName]
        onClicked: {
            applicationCore.settings.setValue(parent.groupName + "." + valueName, !applicationCore.settings.values[parent.groupName][parent.valueName])
        }
    }

    Label {
        text: parent.text
        color: MyStyle.foregroundColor
    }
}
