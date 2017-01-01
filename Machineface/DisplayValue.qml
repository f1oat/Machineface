import QtQuick 2.0
import QtQuick.Controls 1.1
import QtQuick.Layouts 1.1
import QtQuick.Controls.Styles 1.3
import "."

Item {
    id: indicator
    property string name: "name"
    property string value: "0.0"

    Row {
        spacing: 4
        Label {
            color: MyStyle.foregroundColor
            text: name
        }
        Label {
            color: MyStyle.foregroundColor
            text: value
        }
    }
}
