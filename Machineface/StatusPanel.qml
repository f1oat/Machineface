import QtQuick 2.0
import QtQuick.Controls 1.2
import QtQuick.Layouts 1.0
import Machinekit.Application 1.0
import Machinekit.Application.Controls 1.0
import Machinekit.Controls 1.0
import Machinekit.HalRemote.Controls 1.0
import QtQuick 2.1

ApplicationItem {
    id: dro
    width: 600
    height: 249

    property color foregroundColor: "white"
    property color backgroundColor: "black"
    property color background: "black"
    property color homedColor: "green"
    property color unhomedColor: "red"

    property int axes: _ready ? status.config.axes : 4
    property var axisHomed: _ready ? status.motion.axis : [{"homed":false}, {"homed":false}, {"homed":false}, {"homed":false}]
    property var axisNames: ["X", "Y", "Z", "A", "B", "C", "U", "V", "W"]
    property var g5xNames: ["G54", "G55", "G56", "G57", "G58", "G59", "G59.1", "G59.2", "G59.3"]
    property int g5xIndex: _ready ? status.motion.g5xIndex : 1
    property var mc_position: getPosition(false)
    property var wc_position: getPosition(true)
    property var dtg: _ready ? status.motion.dtg : {"x":0.0, "y":0.0, "z":0.0, "a":0.0}
    property bool _ready: status.synced
    property var _axisNames: ["x", "y", "z", "a", "b", "c", "u", "v", "w"]
    property var g5xOffset: _ready ? status.motion.g5xOffset : {"x":-5.0, "y":+12.0, "z":-70, "a":2.0}
    property var g92Offset: _ready ? status.motion.g92Offset : {"x":0.0, "y":0.0, "z":0.0, "a":0.0}
    property var toolOffset: _ready ? status.io.toolOffset : {"x":0.0, "y":0.0, "z":0.0, "a":0.0}
    property double currentVel: _ready ? status.motion.currentVel * _timeFactor : 0.0
    property double _timeFactor: (_ready && (status.config.timeUnits === ApplicationStatus.TimeUnitsMinute)) ? 60 : 1
    property double spindleSpeed: _ready ? status.motion.spindleSpeed : 0.0
    property double spindleEnabled: _ready ? status.motion.spindleEnabled : false

    property int bigFontSize: 24
    property int smallFontSize: 12

    function getPosition(workpiece_coordinates) {
        var basePosition
        if (_ready) {
            basePosition = status.motion.actualPosition
        }
        else {
            basePosition = {"x":0.0, "y":0.0, "z":0.0, "a":0.0}
        }

        if (workpiece_coordinates) {
            for (var i = 0; i < axes; ++i) {
                var axisName = _axisNames[i]
                basePosition[axisName] -= g5xOffset[axisName] + g92Offset[axisName] + toolOffset[axisName]
            }
        }

        return basePosition
    }


    Rectangle {
        anchors.fill: parent
        color: background
        anchors.rightMargin: 0
        anchors.leftMargin: 0
        anchors.topMargin: 0
        anchors.bottomMargin: 0

        Column {
            id: coords
            x: 1
            y: 1
            width: 300
            anchors.bottomMargin: 2
            anchors.left: parent.left
            anchors.leftMargin: spacing
            anchors.top: parent.top
            anchors.topMargin: spacing
            anchors.bottom: parent.bottom
            spacing: 1

            Repeater {
                model: dro.axes
                DroLine {
                    width: coords.width
                    title: dro.axisNames[index]
                    wc_value: dro.wc_position[dro._axisNames[index]].toFixed(3)
                    mc_value: dro.mc_position[dro._axisNames[index]].toFixed(3)
                    dtg_value: dro.dtg[dro._axisNames[index]].toFixed(3)
                    g5x: dro.g5xNames[dro.g5xIndex-1]
                    smallFontSize: dro.smallFontSize
                    foregroundColor: dro.foregroundColor
                    backgroundColor: dro.backgroundColor
                    digitsColor: dro.axisHomed[index].homed ? dro.homedColor : dro.unhomedColor
                    homed: dro.axisHomed[index].homed
                }
            }
        }

        Label {
            id: labelSpindle
            x: 307
            y: 4
            color: foregroundColor
            font.bold: true
            text: "Spindle:"
            font.pixelSize: 14
        }

        Gauge {
            id: gaugeSpindle
            x: 376
            y: 2
            width: 170
            height: 20
            maximumValue: 3000.0
            z0BorderValue: maximumValue/3.0
            z1BorderValue: maximumValue*2.0/3.0
            value: dro.spindleSpeed
            backgroundColor: dro.backgroundColor
            textColor: dro.foregroundColor
            decimals: 0
        }

        Led {
            id: ledSpindle
            x: 552
            y: 2
            width: 20
            height: 20
            onColor: "orange"
            blink: true
            value: dro.spindleEnabled
        }

        Label {
            id: labelFeedrate
            x: 307
            y: 30
            color: foregroundColor
            font.bold: true
            text: "Feedrate:"
            font.pixelSize: 14
        }

        Gauge {
            id: gaugeFeedrate
            x: 376
            y: 28
            width: 170
            height: 20
            maximumValue: 1000.0
            value: status.motion.feedrate * 60.0
            backgroundColor: dro.backgroundColor
            textColor: dro.foregroundColor
            decimals: 0
        }

        Label {
            id: labelVelocity
            x: 307
            y: 56
            color: foregroundColor
            font.bold: true
            text: "Velocity:"
            font.pixelSize: 14
        }

        Gauge {
            id: gaugeVelocity
            x: 376
            y: 54
            width: 170
            height: 20
            maximumValue: 1000.0
            z0BorderValue: maximumValue/3.0
            z1BorderValue: maximumValue*2.0/3.0
            value: dro.currentVel
            backgroundColor: dro.backgroundColor
            textColor: dro.foregroundColor
            decimals: 0
        }

        Label {
            id: labeDoorClosed
            x: 307
            y: 82
            color: foregroundColor
            text: "Door Closed:"
            font.pixelSize: 14
            font.bold: true
        }

        HalLed {
            id: ledDoorClosed
            x: 402
            y: 80
            width: 20
            height: 20
            onColor: "green"
        }

        Label {
            id: labelViceLocked
            x: 431
            y: 82
            color: foregroundColor
            text: "Vice Locked:"
            font.pixelSize: 14
            font.bold: true
        }

        HalLed {
            id: ledViceLocked
            x: 526
            y: 82
            width: 20
            height: 20
            onColor: "green"
        }
    }
}
