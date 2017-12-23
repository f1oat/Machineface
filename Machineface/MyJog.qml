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
    property var _jog_steps: [ 0, 1, 0.1 , 0.01 ]
    property var _jog_steps_labels: [ "Cont", 1, 0.1 , 0.01 ]

    id: root

    Item {
        //visible: jogVisible

        HalPin {
            id: pin_jog_speed
            name: "jog-speed"
            type: HalPin.Float
            direction: HalPin.Out

            property bool _booting: true
            onSyncedChanged: {
                if (_booting) jog_speed.value = value
                _booting = false
            }
        }

        HalPin {
            id: pin_jog_increment
            name: "jog-increment"
            type: HalPin.Float
            direction: HalPin.Out

            property bool _booting: true
            onSyncedChanged: {
                if (_booting) jog_step.value = value
                _booting = false
                console.log("**** " + value)
            }
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
                id: jog_layout
                columns: 4
                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                Layout.fillWidth: true

                // Jog Buttons

                Repeater {
                    id: jog_buttons
                    model: 6

                    MyButton {
                        property var _label: [ "X-", "X+", "Y-", "Y+", "Z-", "Z+"]
                        property var _pos: [ [0, 1], [2, 1], [1, 2], [1, 0], [3, 2], [3, 0]]
                        property var _pin: [pin_jog_0_minus, pin_jog_0_plus, pin_jog_1_minus, pin_jog_1_plus, pin_jog_2_minus, pin_jog_2_plus]

                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        Layout.maximumHeight: MyStyle.buttonSize
                        Layout.maximumWidth: MyStyle.buttonSize

                        Layout.row: _pos[index][1]
                        Layout.column: _pos[index][0]
                        text: _label[index]
                        onPressedChanged: _pin[index].value = pressed
                    }
                }

                // Home Buttons

                Repeater {
                    id: home_buttons
                    model: 4

                    HomeButton {
                        property var _name: ["All", "X", "Y", "Z"]
                        property var _axis: [-1, 0, 1, 2]
                        property var _pos: [ [0, 2], [ 0, 0], [2, 2], [3, 1]]

                        axis: _axis[index]
                        axisName: _name[index]

                        Layout.preferredWidth: 50
                        Layout.preferredHeight: Layout.preferredWidth
                        Layout.row: _pos[index][1]
                        Layout.column: _pos[index][0]
                        Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                    }
                }
            }
        }

        Selector {
            id: jog_speed
            title: "Jog Speed"
            values_list: _jog_speeds
            value: 100

            onValueChanged: {
                pin_jog_speed.value = value
            }
        }

        Selector {
            id: jog_step
            title: "Jog Step"
            values_list: _jog_steps
            labels_list: _jog_steps_labels
            value: 0.01

            onValueChanged: {
                pin_jog_increment.value = value
            }
        }
    }
}
