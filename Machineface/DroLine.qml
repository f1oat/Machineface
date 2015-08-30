import QtQuick 2.0
import QtQuick.Controls 1.2
import QtQuick.Layouts 1.0

Rectangle {
    property color foregroundColor: "white"
    property color backgroundColor: "black"
    property color homedColor: "green"
    property color unhomedColor: "red"
    property color digitsColor: homed ? homedColor : unhomedColor

    property int bigFontSize: 37
    property int smallFontSize: 16

    property double wc_value: -10.12345
    property double mc_value: 45.12345
    property double dtg_value: -3.75

    property string title: "X"
    property bool homed: true
    property string g5x: "G54"

    width: 300
    height: 61

    id: droLine

    color: backgroundColor

    function round(value, decimals) {
        return Number(Math.round(value+'e'+decimals)+'e-'+decimals).toFixed(decimals);
    }

    Label {
        id: dummySmall
        visible: false
        text: "-0000.000"
        font.pixelSize: smallFontSize
        font.bold: true
    }

    Label {
        id: dummyBig
        visible: false
        text: "-0000.000"
        font.pixelSize: bigFontSize
        font.bold: true
    }

    Rectangle {
        id: border
        color: backgroundColor
        border.width: 1
        border.color: foregroundColor
        anchors.fill: parent
    }

    ColumnLayout {
        id: column
        anchors.fill: parent

        RowLayout {
            id: rowLayout1
            anchors.left: parent.left
            anchors.leftMargin: 0
            anchors.right: parent.right
            anchors.rightMargin: 0
            anchors.top: parent.top
            anchors.topMargin: -4

            Label {
                id: axisName
                text: title
                font.pixelSize: bigFontSize
                anchors.left: parent.left
                anchors.leftMargin: 3
                color: droLine.digitsColor
                font.bold: true
                horizontalAlignment: Text.AlignRight
            }

            Label {
                id: g5x_label
                text: g5x
                font.pixelSize: smallFontSize
                anchors.left: axisName.right
                anchors.leftMargin: 0
                anchors.bottom: axisName.bottom
                anchors.bottomMargin: 0
                verticalAlignment: Text.AlignBottom
                color: droLine.digitsColor
                font.bold: true
                horizontalAlignment: Text.AlignLeft
            }

            Label {
                id: wc_dro
                Layout.preferredWidth: bigFontSize * 9
                text: round(wc_value, 3)
                font.pixelSize: bigFontSize
                anchors.right: parent.right
                anchors.rightMargin: 3
                anchors.top: parent.top
                anchors.topMargin: -1
                color: droLine.digitsColor
                font.bold: true
                horizontalAlignment: Text.AlignRight
            }

        }

        RowLayout {
            id: rowLayout2
            anchors.top: rowLayout1.bottom
            anchors.topMargin: -1
            anchors.left: parent.left
            anchors.leftMargin: 0
            anchors.right: parent.right
            anchors.rightMargin: 0

            Label {
                id: abs_label
                text: "Abs"
                font.pixelSize: smallFontSize
                anchors.left: parent.left
                anchors.leftMargin: 30
                anchors.topMargin: 0
                verticalAlignment: Text.AlignTop
                color: droLine.digitsColor
                font.bold: true
                horizontalAlignment: Text.AlignLeft
            }

            Label {
                id: abs_dro
                text: round(mc_value, 3)
                font.pixelSize: smallFontSize
                anchors.rightMargin: -(dummySmall.width + 4)
                anchors.right: abs_label.right
                anchors.topMargin: 0
                color: droLine.digitsColor
                font.bold: true
                horizontalAlignment: Text.AlignRight
            }


            Label {
                id: dtg_label
                text: "DTG"
                font.pixelSize: smallFontSize
                anchors.rightMargin: dummySmall.width + 4
                anchors.right: parent.right
                color: droLine.digitsColor
                font.bold: true
                horizontalAlignment: Text.AlignLeft
            }

            Label {
                id: dtg_dro
                text: round(dtg_value, 3)
                font.pixelSize: smallFontSize
                anchors.right: parent.right
                anchors.rightMargin: 4
                color: droLine.digitsColor
                font.bold: true
                horizontalAlignment: Text.AlignRight
            }
        }
    }
}

