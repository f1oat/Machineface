import QtQuick 2.0
import QtQuick.Layouts 1.1
import QtQuick.Controls 1.2
import QtQuick.Controls.Styles 1.2
import QtQuick.Window 2.0
import Machinekit.Application 1.0
import Machinekit.Application.Controls 1.0
import Machinekit.Service 1.0
import Machinekit.HalRemote 1.0
import Machinekit.HalRemote.Controls 1.0
import "."

ApplicationItem {
    property var numberModel: numberModelBase.concat(["∞"])
    property var numberModelBase: status.synced ? status.config.increments.split(" ") : []
    property var numberModelReverse: {
        var tmp = numberModel.slice()
        tmp.reverse()
        return tmp
    }
    property var axisNames: ["X", "Y", "Z", "A"]
    property bool zVisible: status.synced ? status.config.axes > 2 : true
    property bool aVisible: status.synced ? status.config.axes > 3 : true
    property bool jogVisible: halRemoteComponent.ready
    property var _jog_speeds: [ 3000, 1000, 500, 100 ]
    property var _jog_speed_index: 0
    property var _booting: true

    function normalize_speed(speed) {
        if (speed >= _jog_speeds[0]) return 0;
        for (var i=1; i<_jog_speeds.length; i++) {
            if (speed >= _jog_speeds[i]) {
                if (speed > (_jog_speeds[i] + _jog_speeds[i-1])/2) return i-1
                else return i;
            }
        }
    }

    id: root

    Item {
        //visible: jogVisible

        HalPin {
            id: pin_jog_speed
            name: "jog-speed"
            type: HalPin.Float
            direction: HalPin.Out
            onSyncedChanged: {
                if (_booting) {
                    console.log("jog-speed=", value)
                    _jog_speed_index = normalize_speed(value)
                    value = _jog_speeds[_jog_speed_index]
                    console.log("normalized jog-speed=", value)
                }
                _booting = false
            }
        }

        HalPin {
            id: pin_jog_increment
            name: "jog-increment"
            type: HalPin.Float
            direction: HalPin.Out
        }

        HalPin {
            id: pin_jog_0_plus
            name: "jog.0.plus"
            type: HalPin.Bit
            direction: HalPin.Out
        }

        HalPin {
            id: pin_jog_0_minus
            name: "jog.0.minus"
            type: HalPin.Bit
            direction: HalPin.Out
        }

        HalPin {
            id: pin_jog_0_inc_plus
            name: "jog.0.increment-plus"
            type: HalPin.Bit
            direction: HalPin.Out
        }

        HalPin {
            id: pin_jog_0_inc_minus
            name: "jog.0.increment-minus"
            type: HalPin.Bit
            direction: HalPin.Out
        }

        HalPin {
            id: pin_jog_1_plus
            name: "jog.1.plus"
            type: HalPin.Bit
            direction: HalPin.Out
        }

        HalPin {
            id: pin_jog_1_minus
            name: "jog.1.minus"
            type: HalPin.Bit
            direction: HalPin.Out
        }

        HalPin {
            id: pin_jog_1_inc_plus
            name: "jog.1.increment-plus"
            type: HalPin.Bit
            direction: HalPin.Out
        }

        HalPin {
            id: pin_jog_1_inc_minus
            name: "jog.1.increment-minus"
            type: HalPin.Bit
            direction: HalPin.Out
        }

        HalPin {
            id: pin_jog_2_plus
            name: "jog.2.plus"
            type: HalPin.Bit
            direction: HalPin.Out
        }

        HalPin {
            id: pin_jog_2_minus
            name: "jog.2.minus"
            type: HalPin.Bit
            direction: HalPin.Out
        }

        HalPin {
            id: pin_jog_2_inc_plus
            name: "jog.2.increment-plus"
            type: HalPin.Bit
            direction: HalPin.Out
        }

        HalPin {
            id: pin_jog_2_inc_minus
            name: "jog.2.increment-minus"
            type: HalPin.Bit
            direction: HalPin.Out
        }
    }


    RowLayout {
        visible: root.status.synced
        anchors.fill: parent

        ColumnLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true

            GridLayout {
                id: jog_buttons
                columns: 4
                Layout.fillWidth: true
                Layout.fillHeight: true

                Repeater {
                    model: 6

                    MyButton {
                        property var _label: [ "X-", "X+", "Y-", "Y+", "Z-", "Z+"]
                        property var _pos: [ [0, 1], [2, 1], [1, 2], [1, 0], [3, 2], [3, 0]]
                        property var _pin: [pin_jog_0_minus, pin_jog_0_plus, pin_jog_1_minus, pin_jog_1_plus, pin_jog_2_minus, pin_jog_2_plus]

                        Layout.fillWidth: true
                        Layout.row: _pos[index][1]
                        Layout.column: _pos[index][0]
                        text: _label[index]
                        onPressedChanged: _pin[index].value = pressed
                    }
                }
            }

            RowLayout {
                id: home_buttons
                Layout.fillWidth: true
                Layout.fillHeight: true
                Repeater {
                    model: 4

                    HomeButton {
                        property var _name: ["All", "X", "Y", "Z"]
                        property var _axis: [-1, 0, 1, 2]

                        axis: _axis[index]
                        Layout.fillWidth: true
                        axisName: _name[index]
                    }
                }
            }
        }

        MyGroupBox {
            title: "Jog speed"
            Layout.alignment: Qt.AlignTop

            ColumnLayout {
                id: jog_speed
                ExclusiveGroup { id: jog_speed_group }
                Repeater {
                    model: _jog_speeds
                    MyButton {
                        text: modelData
                        Layout.fillHeight: true
                        Layout.fillWidth: true

                        property int speed: modelData
                        onClicked: checked = !checked
                        exclusiveGroup: jog_speed_group
                        onCheckedChanged: {
                            console.log(text + " checked=" + checked)
                            if (checked) {
                                pin_jog_speed.value = speed
                            }
                        }
                        checked: index === _jog_speed_index
                    }
                }
            }
        }

        MyGroupBox {
            title: "Jog steps"
            Layout.alignment: Qt.AlignTop

            ColumnLayout {
                id: jog_steps
                ExclusiveGroup { id: jog_steps_group }
                Repeater {
                    model: [ 0.01, 0.1, 1, "Cont" ]
                    MyButton {
                        Layout.fillHeight: true
                        Layout.fillWidth: true
                        text: modelData
                        onClicked: checked = !checked
                        exclusiveGroup: jog_steps_group
                    }
                }
            }
        }
    }
}
