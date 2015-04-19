import QtQuick 2.0
import QtQuick.Controls 1.1
import QtQuick.Layouts 1.1
import QtQuick.Controls.Styles 1.3

Item {
    id: root
    property color foregroundColor: "black"
    property color backgroundColor: "grey"

    property int decimals: 0
    property double minimumValue: 0.0
    property double maximumValue: 100.0
    property double value: 0.0

    Row {
        id: row1
        spacing: 4

        Item {
            id: progressbar

            property int minimum: 0
            property int maximum: 100
            property int value: maximum * (root.value - root.minimumValue) / (root.maximumValue - root.minimumValue)
            property color color: "#77B753"

            width: 150; height: root.height
            clip: true

            Rectangle {
                id: border
                anchors.fill: parent
                anchors.bottomMargin: 1
                anchors.rightMargin: 1
                color: backgroundColor
                border.width: 1
                border.color: parent.color
            }

            Rectangle {
                id: highlight
                property int widthDest: ( ( progressbar.width * ( parent.value- parent.minimum ) ) / ( parent.maximum - parent.minimum ) - 4 )
                width: highlight.widthDest

                Behavior on width {
                    SmoothedAnimation {
                        velocity: 1200
                    }
                }

                anchors {
                    left: parent.left
                    top: parent.top
                    bottom: parent.bottom
                    margins: 2
                }
                color: parent.color
            }
        }

        Label {
            color: foregroundColor
            font.bold: true
            text: value.toFixed(decimals)
            anchors.verticalCenter: parent.verticalCenter
        }
    }
}
