import QtQuick 2.0
import QtQuick.Controls 1.2
import QtQuick.Layouts 1.1
import QtQuick.Window 2.0
import Machinekit.Application.Controls 1.0

Tab {
    title: qsTr("Settings")
    Item {
        ColumnLayout {
            anchors.fill: parent
            anchors.margins: Screen.pixelDensity * 1

            ToggleSettingCheck {
                groupName: "dro"
                valueName: "showOffsets"
                text: qsTr("Show offsets")
            }

            ToggleSettingCheck {
                id: showVelocityAction
                groupName: "dro"
                valueName: "showVelocity"
                text: qsTr("Show velocity")
            }

            ToggleSettingCheck {
                id: showDistanceToGoAction
                groupName: "dro"
                valueName: "showDistanceToGo"
                text: qsTr("Show distance to go")
            }

            ToggleSettingCheck {
                id: enablePreviewAction
                groupName: "preview"
                valueName: "enable"
                text: qsTr("Enable preview")
            }

            ToggleSettingCheck {
                id: showMachineLimitsAction
                groupName: "preview"
                valueName: "showMachineLimits"
                text: qsTr("Show machine limits")
            }

            ToggleSettingCheck {
                id: showProgramAction
                groupName: "preview"
                valueName: "showProgram"
                text: qsTr("Show program")
            }

            ToggleSettingCheck {
                id: showProgramExtentsAction
                groupName: "preview"
                valueName: "showProgramExtents"
                text: qsTr("Show program extents")
            }

            ToggleSettingCheck {
                id: showProgramRapidsAction
                groupName: "preview"
                valueName: "showProgramRapids"
                text: qsTr("Show program rapids")
            }

            ToggleSettingCheck {
                id: alphaBlendProgramAction
                groupName: "preview"
                valueName: "alphaBlendProgram"
                text: qsTr("Alpha-blend program")
            }

            ToggleSettingCheck {
                id: showLivePlotAction
                groupName: "preview"
                valueName: "showLivePlot"
                text: qsTr("Show live plot")
            }

            ToggleSettingCheck {
                id: showToolAction
                groupName: "preview"
                valueName: "showTool"
                text: qsTr("Show tool")
            }

            ToggleSettingCheck {
                id: showCoordinateAction
                groupName: "preview"
                valueName: "showCoordinate"
                text: qsTr("Show coordinate")
            }
            Item {
                Layout.fillHeight: true
            }
        }




    }
}
