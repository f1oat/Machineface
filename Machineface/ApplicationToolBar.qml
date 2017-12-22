import QtQuick 2.0
import QtQuick.Layouts 1.1
import QtQuick.Window 2.0
import QtQuick.Controls 1.2
import QtQuick.Dialogs 1.2
import Machinekit.Controls 1.0
import Machinekit.Application.Controls 1.0

Rectangle {
    id: rect
    color: "#000000"

    SystemPalette { id: systemPalette }
    FontLoader { id: iconFont; source: "icons/material-icon-font.ttf" }

    signal abort()

    Row {
        id: toolBar

        TouchButton {
            height: rect.height
            width: height
            action : EstopAction { id: estopAction }
            iconSource: "icons/ic_report_white_48dp.png"
        }
        TouchButton {
            height: rect.height
            width: height
            action : PowerAction { }
            iconSource: "icons/ic_settings_power_white_48dp.png"
        }
        TouchButton {
            height: rect.height
            width: height
            action : OpenAction { fileDialog: applicationFileDialog}
            iconSource: "icons/ic_folder_open_white_48dp.png"
        }
        TouchButton {
            height: rect.height
            width: height
            action : ReopenAction { }
            iconSource: "icons/ic_refresh_white_48dp.png"
        }
        TouchButton {
            height: rect.height
            width: height
            action : RunProgramAction { }
            iconSource: "icons/ic_play_arrow_white_48dp.png"
        }
        TouchButton {
            height: rect.height
            width: height
            action : PauseResumeProgramAction { }
            iconSource: "icons/ic_pause_white_48dp.png"
        }
        TouchButton {
            height: rect.height
            width: height
            action : StopProgramAction { }
            iconSource: "icons/ic_stop_white_48dp.png"
            onClicked: abort()
        }
        TouchButton {
            height: rect.height
            width: height
            action : StepProgramAction { }
            iconSource: "icons/ic_skip_next_white_48dp.png"
        }


        TouchButton {
            height: rect.height
            width: height
            onClicked: applicationMenu.popup()
            iconSource: "icons/ic_more_horiz_white_48dp.png"
        }

        ApplicationMenu {
            id: applicationMenu
        }

        AboutDialog {
            id: aboutDialog
        }
    }
}
