import QtQuick 2.0
import QtQuick.Layouts 1.1
import QtQuick.Controls 1.2
import Machinekit.Application.Controls 1.0
import "."

RowLayout {
    Label {
        id: label1
        color: MyStyle.labelColor
        text: qsTr("Jog Speed:")
        font.bold: true
    }

    Slider {
        Layout.fillWidth: true
        id: xVelocitySpin
        stepSize: 1
        enabled: xVelocityHandler.enabled
        minimumValue: xVelocityHandler.minimumValue
        maximumValue: xVelocityHandler.status.config.maxLinearVelocity //xVelocityHandler.maximumValue
        property double oldValue: 0

        onValueChanged: {
            if (value != oldValue) {
                xVelocityHandler.value = value
                yVelocityHandler.value = value
                zVelocityHandler.value = value
                oldValue = value
            }
        }

        MyJogVelocityHandler {
            id: xVelocityHandler
            axis: 0
            property double oldValue: 0

            onValueChanged: {
                if (value != oldValue) {
                    xVelocitySpin.value = value
                    oldValue = value
                }
            }
        }

        MyJogVelocityHandler {
            id: yVelocityHandler
            axis: 1
        }

        MyJogVelocityHandler {
            id: zVelocityHandler
            axis: 2
        }
    }

    Label {
        color: MyStyle.labelColor
        text: xVelocitySpin.value * 60
        font.bold: true
        visible: xVelocitySpin.visible
    }


    Label {
        color: MyStyle.labelColor
        text: qsTr("A:")
        font.bold: true
        visible: aVelocitySpin.visible
    }

    SpinBox {
        Layout.fillWidth: true
        id: aVelocitySpin
        visible: aVelocityHandler.status.synced && (aVelocityHandler.status.config.axes > 3)
        enabled: aVelocityHandler.enabled
        minimumValue: aVelocityHandler.minimumValue
        maximumValue: aVelocityHandler.maximumValue
        suffix: aVelocityHandler.units

        onEditingFinished: {            // remove the focus from this control
            label1.forceActiveFocus()
            label1.focus = true
        }

        Binding { target: aVelocitySpin; property: "value"; value: aVelocityHandler.value }
        Binding { target: aVelocityHandler; property: "value"; value: aVelocitySpin.value }

        JogVelocityHandler {
            id: aVelocityHandler
            axis: 3
        }
    }

    Label {
        color: MyStyle.labelColor
        text: aVelocitySpin.value * 60
        font.bold: true
        visible: aVelocitySpin.visible
    }
}
