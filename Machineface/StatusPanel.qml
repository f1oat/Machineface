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
    //width: col.width
    height: col.height

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
    property var _axisNames: ["x", "y", "z", "a", "b", "c", "u", "v", "w"]
    property var g5xOffset: /*_ready ? status.motion.g5xOffset : */ {"x":-5.0, "y":+12.0, "z":-70, "a":2.0}
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

    property var tool_in_spindle: _ready ? status.io.toolTable[0] : null
    property int tool_number: _ready ? tool_in_spindle.id : 0
    property double tool_length: (_ready && tool_in_spindle.id  >0) ? tool_in_spindle.offset.z : 0

    property var gcodes_num: status.interp.gcodes
    property var mcodes_num: status.interp.mcodes

    property var gcodes
    property var mcodes

    function min(a, b) {
        return a < b ? a : b
    }

    function compareNumbers(a, b)
    {
        return a - b;
    }

    function sortint(arr) {
        return arr.slice(1).sort(compareNumbers);
    }

    function update_gcodes()
    {
        var _gcodes = sortint(gcodes_num);
        var tmp = ""

        for (var i = 0, len = _gcodes.length; i < len; i++) {
            var code = _gcodes[i]
            if (code === -1) continue
            else if ( (code %10) == 0) tmp += " G" + code/10
            else tmp += " G" + Math.floor(code/10) + "." + (code%10)
        }

        return tmp
    }

    function update_mcodes()
    {
        var tmp = "";
        var _mcodes = sortint(mcodes_num);

        for (var i = 0, len = _mcodes.length; i < len; i++) {
            var code = _mcodes[i];
            if (code === -1) continue;
            else tmp += " M" + code;
        }

        return tmp;
    }

    function onGcodes_numChanged()
    {
        gcodes = update_gcodes()
    }

    function onMcodes_numChanged()
    {
        mcodes = update_mcodes()
    }

    Timer {
        interval: 1000; running: true; repeat: true
        onTriggered: {
            var new_gcodes = update_gcodes();
            if (new_gcodes !== gcodes) gcodes = new_gcodes;
        }

    }

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
        id: col
        spacing: 2

        Rectangle { // Modal GCODES
            id: modal_status
            width: statusPanel.width
            height: gcode_list.height + 2
            color: "black"
            border.color: "white"
            border.width: 1

            Label {
                id: gcode_list
                anchors.margins: 2
                anchors.left: parent.left
                anchors.top: parent.top
                color: "yellow"
                text: gcodes
            }
        }

        Row {
            id: container
            enabled:  halRemoteComponent.ready //.connected
            spacing: 4

            Column { // DRO
                id: coords
                width: 300
                spacing: 1

                Repeater {
                    model: statusPanel.axes
                    DroLine {
                        width: coords.width
                        title: statusPanel.axisNames[index]

                        property string axisName: statusPanel._axisNames[index]

                        mc_value: status.motion.actualPosition[axisName]
                        wc_value: mc_value - (g5xOffset[axisName] + g92Offset[axisName] + toolOffset[axisName])
                        dtg_value: status.motion.dtg[axisName]

                        g5x: statusPanel.g5xNames[statusPanel.g5xIndex-1]
                        smallFontSize: statusPanel.smallFontSize
                        foregroundColor: statusPanel.foregroundColor
                        backgroundColor: statusPanel.backgroundColor
                        digitsColor: statusPanel.axisHomed[index].homed ? statusPanel.homedColor : statusPanel.unhomedColor
                        homed: statusPanel.axisHomed[index].homed
                    }
                }

                Rectangle { // Safety disable
                    id: safety_disabled_indicator
                    width: parent.width
                    height: 28
                    property string _color: "#e99e08"
                    property bool tictac: false
                    color: _color

                    Timer {
                        interval: 250; running: true; repeat: true
                        onTriggered: {
                            safety_disabled_indicator.tictac = !safety_disabled_indicator.tictac
                            safety_disabled_indicator.state = pin_safety_disable.value & safety_disabled_indicator.tictac ? 'on' : 'off'
                        }
                    }

                    Text {
                        id: text1
                        x: 54
                        y: 2
                        color: "#970303"
                        text: qsTr("SAFETY DISABLED")
                        font.bold: true
                        font.pixelSize: 19
                    }

                    states: [
                        State {
                            name: "on"
                            PropertyChanges { target: text1; visible: true }
                            PropertyChanges { target: safety_disabled_indicator; color: _color }
                        },
                        State {
                            name: "off"
                            PropertyChanges { target: text1; visible: false }
                            PropertyChanges { target: safety_disabled_indicator; color: "black" }                    }
                    ]
                }

            }

            Column {
                id: _cstatus
                Grid { // Spindle and velocity
                    spacing: 1
                    columns: 3

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

                    Led {
                        id: ledSpindle
                        width: 20
                        height: 20
                        onColor: "orange"
                        blink: !pin_spindle_at_speed.value
                        blinkInterval: 150
                        value: statusPanel.spindleEnabled
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

                Grid { // Status LEDs
                    spacing: 3
                    columns: 4
                    columnSpacing: 15

                    Label {
                        id: labelDoorClosed
                        color: foregroundColor
                        text: "Door Closed:"
                        font.pixelSize: 14
                        font.bold: true
                        property point pos
                        Component.onCompleted: {
                            pos = labelDoorClosed.mapToItem(statusPanel, 0, 0)
                        }
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

                Row { // Feedrate and spindle rate
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

//        Button {
//            text: "Debug"
//            onClicked: {
//                console.log(JSON.stringify(status))
//                console.log(status.interp.interpState)
//                console.log(status.interp.interpreterErrcode)
//                console.log(JSON.stringify(status.io.toolTable[0]))
//                console.log(tool_in_spindle.offset.z)
//                gcodes = update_gcodes()
//                mcodes = update_mcodes()
//            }
//        }
    }

    Rectangle {
        x: labelDoorClosed.pos.x -4
        y: labelDoorClosed.pos.y -3
        width: ledPressureOK.x + ledPressureOK.width - labelDoorClosed.x +6
        height: ledPressureOK.y + ledPressureOK.height - labelDoorClosed.y +6
        color: "#00000000"
        radius: 5
        border.width: 3
        property bool ok: ledDoorClosed.value
                          && ledViseLocked.value
                          && ledPressureOK.value
        border.color: ok ? "green" : "red"
    }
}
