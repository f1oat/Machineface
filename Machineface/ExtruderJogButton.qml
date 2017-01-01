import QtQuick 2.0
import QtQuick.Controls 1.2

Button {
    property double distance: 0
    property bool direction: false
    property bool activated: false
    property variant _pressTime

    onClicked: {
        if (distance !== 0) {
            jogDistancePin.value = distance
            jogDirectionPin.value = direction
            jogTriggerPin.value = !jogTriggerPin.value
        }
    }
    onPressedChanged: {
        if (distance === 0) {
            jogDirectionPin.value = direction

            if (pressed) {
                _pressTime = Date.now()
                jogContinousPin.value = true
            }
            else {
                var currentTime = Date.now()
                var timeDiff = currentTime - _pressTime

                if (timeDiff < 300) {
                    if (!activated) {
                        activated = true
                        checkable = true
                        checked = true
                    }
                    else {
                        jogContinousPin.value = false
                        activated = false
                        checkable = false
                    }
                }
                else {
                    jogContinousPin.value = false
                }
            }
        }
    }
}
