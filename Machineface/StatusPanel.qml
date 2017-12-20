import QtQuick 2.0
import QtQuick.Controls 1.2
import QtQuick.Layouts 1.0
import Machinekit.Application 1.0
import Machinekit.Application.Controls 1.0
import Machinekit.Controls 1.0
import Machinekit.HalRemote 1.0
import Machinekit.HalRemote.Controls 1.0
import Machinekit.Service 1.0
import QtQuick 2.1

ApplicationItem {
    id: statusPanel
    width: 600
    height: 249

    property color foregroundColor: "white"
    property color backgroundColor: "black"
    property color background: "black"
    property color homedColor: "green"
    property color unhomedColor: "red"

    property bool _ready: status.synced

    property int axes: _ready ? status.config.axes : 4
    property var axisHomed: _ready ? status.motion.axis : [{"homed":false}, {"homed":false}, {"homed":false}, {"homed":false}]
    property var axisNames: ["X", "Y", "Z", "A", "B", "C", "U", "V", "W"]
    property var g5xNames: ["G54", "G55", "G56", "G57", "G58", "G59", "G59.1", "G59.2", "G59.3"]
    property int g5xIndex: _ready ? status.motion.g5xIndex : 1
    property var mc_position: getPosition(false)
    property var wc_position: getPosition(true)
    property var dtg: _ready ? status.motion.dtg : {"x":0.0, "y":0.0, "z":0.0, "a":0.0}
    property var _axisNames: ["x", "y", "z", "a", "b", "c", "u", "v", "w"]
    property var g5xOffset: _ready ? status.motion.g5xOffset : {"x":-5.0, "y":+12.0, "z":-70, "a":2.0}
    property var g92Offset: _ready ? status.motion.g92Offset : {"x":0.0, "y":0.0, "z":0.0, "a":0.0}
    property var toolOffset: _ready ? status.io.toolOffset : {"x":0.0, "y":0.0, "z":0.0, "a":0.0}
    property double currentVel: _ready ? status.motion.currentVel * _timeFactor : 0.0
    property double _timeFactor: (_ready && (status.config.timeUnits === ApplicationStatus.TimeUnitsMinute)) ? 60 : 1
    property double spindleSpeed: _ready ? status.motion.spindleSpeed : 0.0
    property double spindleEnabled: _ready ? status.motion.spindleEnabled : false
    property bool vise_locked: ledViseLocked.value

    property double real_feedrate: _ready ? status.interp.settings[1] * status.motion.feedrate : 0
    property double real_spindlerate: _ready ? status.interp.settings[2] * status.motion.spindlerate : 0

    property int bigFontSize: 24
    property int smallFontSize: 12

    property alias _pin_vise_locked_led: ledViseLocked.halPin
    property alias _pin_safety_disable: pin_safety_disable
    property alias _pin_vise_lock: pin_vise_lock

    property var tool_in_spindle: _ready ? status.io.toolTable[0] : { id:0, zOffset:0 }
    property int tool_number: (_ready && tool_in_spindle.id  >0) ? tool_in_spindle.id : 0
    property double tool_length: (_ready && tool_in_spindle.id  >0) ? tool_in_spindle.zOffset : 0

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

    function min(a, b) {
        return a < b ? a : b
    }

    Rectangle {
        id: container
        anchors.fill: parent
        color: background
        radius: 0
        anchors.rightMargin: 0
        anchors.leftMargin: 0
        anchors.topMargin: 0
        anchors.bottomMargin: 0
        enabled:  halRemoteComponent.ready //.connected

        HalPin {
            id: pin_spindle_at_speed
            name: "spindle-at-speed"
            type: HalPin.Bit
            direction: HalPin.In
        }

        HalPin {
            id: pin_safety_disable
            name: "safety-disable"
            type: HalPin.Bit
            direction: HalPin.Out
        }

        HalPin {
            id: pin_vise_lock
            name: "vise-lock"
            type: HalPin.Bit
            direction: HalPin.Out
        }

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
                model: statusPanel.axes
                DroLine {
                    width: coords.width
                    title: statusPanel.axisNames[index]
                    wc_value: statusPanel.wc_position[statusPanel._axisNames[index]].toFixed(3)
                    mc_value: statusPanel.mc_position[statusPanel._axisNames[index]].toFixed(3)
                    dtg_value: statusPanel.dtg[statusPanel._axisNames[index]].toFixed(3)
                    g5x: statusPanel.g5xNames[statusPanel.g5xIndex-1]
                    smallFontSize: statusPanel.smallFontSize
                    foregroundColor: statusPanel.foregroundColor
                    backgroundColor: statusPanel.backgroundColor
                    digitsColor: statusPanel.axisHomed[index].homed ? statusPanel.homedColor : statusPanel.unhomedColor
                    homed: statusPanel.axisHomed[index].homed
                }
            }
        }

        Led {
            id: ledSpindle
            x: 552
            y: 8
            width: 20
            height: 20
            onColor: "orange"
            blink: !pin_spindle_at_speed.value
            blinkInterval: 150
            value: statusPanel.spindleEnabled
        }

        Rectangle {
            x: 307
            y: 82
            width: 135
            height: 73
            color: "#00000000"
            radius: 5
            border.width: 3
            property bool ok: ledDoorClosed.value
                              && ledViseLocked.value
                              && ledPressureOK.value
            border.color: ok ? "green" : "red"
        }

        Grid {
            x: 312
            y: 88
            width: 234
            height: 83
            spacing: 3
            columns: 4
            columnSpacing: 15

            Label {
                id: labeDoorClosed
                color: foregroundColor
                text: "Door Closed:"
                font.pixelSize: 14
                font.bold: true
            }

            HalLed {
                id: ledDoorClosed
                name: "door-closed-led"
                width: 20
                height: 20
                onColor: "green"
            }

            Label {
                id: labelDoorLocked
                color: foregroundColor
                text: "Door Locked:"
                font.pixelSize: 14
                font.bold: true
            }

            HalLed {
                id: ledDoorLocked
                name: "door-unlocked-led"
                invert: true
                width: 20
                height: 20
                onColor: "green"
            }

            Label {
                id: labelViseLocked
                color: foregroundColor
                text: "Vise Locked:"
                font.pixelSize: 14
                font.bold: true
            }

            HalLed {
                id: ledViseLocked
                name: "vise-locked-led"
                width: 20
                height: 20
                onColor: "green"
            }

            Label {
                id: labelToolLocked
                color: foregroundColor
                text: "Tool Locked:"
                font.pixelSize: 14
                font.bold: true
            }

            HalLed {
                id: ledToolUnLocked
                name: "tool-unlocked-led"
                onColor: "green"
                invert: true
                width: 20
                height: 20
            }

            Label {
                id: labelPressureOK
                color: foregroundColor
                text: "Pressure OK:"
                font.pixelSize: 14
                font.bold: true
            }

            HalLed {
                id: ledPressureOK
                name: "pressure-ok-led"
                onColor: "green"
                width: 20
                height: 20
            }

            Label {
                id: labelMistOn
                color: foregroundColor
                text: "Mist On:"
                font.pixelSize: 14
                font.bold: true
            }

            HalLed {
                id: ledMistOn
                name: "mist-on-led"
                onColor: "orange"
                width: 20
                height: 20
            }

            Label {
                id: labelCurrentTool
                color: foregroundColor
                text: "Current Tool:"
                font.pixelSize: 14
                font.bold: true
            }

            Label {
                id: labelToolNumber
                color: statusPanel.foregroundColor
                text: tool_number ? tool_number : "-"
                font.pixelSize: 14
                font.bold: true

            }

            Label {
                id: labelToolLength
                color: foregroundColor
                text: "Length:"
                font.pixelSize: 14
                font.bold: true
            }

            Label {
                id: labelToolLength2
                color: statusPanel.foregroundColor
                text: tool_length.toFixed(2)
                font.pixelSize: 14
                font.bold: true
            }

            Label {
                id: labelProbe
                color: foregroundColor
                text: "Probe:"
                font.pixelSize: 14
                font.bold: true
            }

            HalLed {
                id: ledProbe
                name: "probe-led"
                onColor: "orange"
                width: 20
                height: 20
            }
        }

        Rectangle {
            id: safety_disabled_indicator
            x: 307
            y: 202
            width: 285
            height: 39
            color: "#e99e08"
            visible: pin_safety_disable.value

            Timer {
                interval: 250; running: true; repeat: true
                onTriggered: safety_disabled_indicator.visible = pin_safety_disable.value ? !safety_disabled_indicator.visible : false
            }

            Text {
                id: text1
                x: 54
                y: 8
                color: "#970303"
                text: qsTr("SAFETY DISABLED")
                font.bold: true
                font.pixelSize: 19
            }
        }

        Grid {
            x: 310
            y: 8
            spacing: 1
            columns: 2

            Label {
                id: labelSpindle
                color: foregroundColor
                font.bold: true
                text: "Spindle:"
                font.pixelSize: 14
            }

            Gauge {
                id: gaugeSpindle
                width: 170
                height: 20
                maximumValue: 3000.0
                z0BorderValue: 1e9
                z1BorderValue: 1e9
                backgroundColor: statusPanel.backgroundColor
                textColor: statusPanel.foregroundColor
                value: min(pin.value, maximumValue)
                decimals: 0

                HalPin {
                    id: pin
                    name: "spindle-speed"
                    type: HalPin.Float
                    direction: HalPin.In
                }
            }

            Label {
                id: labelVelocity
                color: foregroundColor
                font.bold: true
                text: "Velocity:"
                font.pixelSize: 14
            }

            Gauge {
                id: gaugeVelocity
                width: 170
                height: 20
                z: 1
                minimumValue: 0
                maximumValue: status.config.maxLinearVelocity * 60.0
                z0BorderValue: 1e9
                z1BorderValue: 1e9
                value: min(statusPanel.currentVel, maximumValue)
                backgroundColor: statusPanel.backgroundColor
                textColor: statusPanel.foregroundColor
                decimals: 0
            }
        }

        Row {
            x: 312
            y: 55
            spacing: 20
            Label {
                id: labelFeedrate
                color: foregroundColor
                font.bold: true
                text: "F " + real_feedrate
                font.pixelSize: 20
            }

            Label {
                id: labelSpindlerate
                color: foregroundColor
                font.bold: true
                text: "S " + real_spindlerate
                font.pixelSize: 20
            }

        }
    }
}
