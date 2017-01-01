import QtQuick 2.0
import QtQuick.Controls 1.2
import QtQuick.Layouts 1.1
import Machinekit.Application 1.0
import Machinekit.Application.Controls 1.0

/*JogStick {
            id: jogStick
            status: applicationStatus
            command: applicationCommand
        }*/

ColumnLayout {
    anchors.fill: parent
    anchors.margins: 5

    TouchOffDialog {
        id: touchOffDialog
        axis: axisRadioGroup.axis
        height: window.height * 0.2
    }

    RowLayout {
        Layout.fillWidth: true

        Button {
            Layout.fillWidth: false
            action: MistAction { }
        }

        Button {
            Layout.fillWidth: false
            action: FloodAction { }
        }

        Item {
            Layout.fillWidth: true
        }
    }

    Label {
        text: qsTr("Spindle")
    }

    RowLayout {
        Layout.fillWidth: true

        Button {
            action: SpindleCcwAction { }
        }
        Button {
            action: StopSpindleAction { }
        }
        Button {
            action: SpindleCwAction { }
        }

        Item {
            Layout.fillWidth: true
        }
    }

    RowLayout {
        Layout.fillWidth: true

        Button {
            action: DecreaseSpindleSpeedAction { }
        }
        Button {
            action: IncreaseSpindleSpeedAction { }
        }

        Item {
            Layout.fillWidth: true
        }
    }

    Item {
        Layout.fillHeight: true
    }
}

/*
GridLayout {
    width: 200
    height: 20
    anchors.top: parent.top
    anchors.topMargin: 0
    rows: 2
    columns: 2

    LedButton {
        name: "Spindle"
    }

    RowLayout {
        SpindleSpeedHandler {
            id: handler
        }

        SpindleCwAction {

        }

        SpindlerateSlider {

        }


        Slider {
            id: spindle_speed
            Layout.fillWidth: true
            stepSize: 1
            minimumValue: 100
            maximumValue: 3000

            property alias core: handler.core
            property alias status: handler.status
            property alias command: handler.command

            //minimumValue: handler.minimumValue
            //maximumValue: handler.maximumValue
            enabled: handler.enabled

            //Binding { target: spindle_speed; property: "value"; value: handler.value }
            Binding { target: handler; property: "value"; value: spindle_speed.value }
            value: handler.speed

        }

        Label {
            text: handler.value
            font.bold: true
        }
    }

    Button {
        text: "Mist"
        action: MistAction { }
    }
}
*/
