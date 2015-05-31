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
    property var axisColors: ["#F5A9A9", "#A9F5F2", "#81F781", "#D2B48C"]
    property color allColor: "#DDD"
    property var axisNames: ["X", "Y", "Z", "A"]
    property bool zVisible: status.synced ? status.config.axes > 2 : true
    property bool aVisible: status.synced ? status.config.axes > 3 : true

    id: root

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: Screen.pixelDensity
        visible: root.status.synced

        Item {
            id: container
            Layout.fillWidth: true
            Layout.preferredHeight: Math.min(width / 1.2, parent.height)

            Item {
                id: mainItem
                anchors.top: parent.top
                anchors.left: parent.left
                anchors.bottom: parent.bottom
                width: height

                Label {
                    anchors.centerIn: parent
                    text: axisNames[0] + axisNames[1]
                    font.bold: true
                    color: MyStyle.foregroundColor
                }

                HomeButton {
                    id: homeXButton
                    anchors.left: parent.left
                    anchors.top: parent.top
                    width: parent.height * 0.2
                    height: width
                    axis: 0
                    axisName: "X"
                    color: axisColors[0]
                }

                HomeButton {
                    anchors.right: parent.right
                    anchors.top: parent.top
                    width: parent.height * 0.2
                    height: width
                    axis: 1
                    axisName: "Y"
                    color: axisColors[1]
                }

                HomeButton {
                    anchors.right: parent.right
                    anchors.bottom: parent.bottom
                    width: parent.height * 0.2
                    height: width
                    axis: 2
                    axisName: "Z"
                    color: axisColors[2]
                }

                HomeButton {
                    anchors.left: parent.left
                    anchors.bottom: parent.bottom
                    width: parent.height * 0.2
                    height: width
                    axis: -1
                    axisName: "All"
                    color: "white"
                }

                RowLayout {
                    id: xAxisRightLayout
                    anchors.right: parent.right
                    anchors.verticalCenter: parent.verticalCenter
                    width: parent.height / (numberModel.length*2+1) * numberModel.length
                    height: width
                    spacing: 0
                    Repeater {
                        model: numberModel
                        JogButton {
                            Layout.fillWidth: true
                            Layout.preferredHeight: xAxisRightLayout.height / numberModel.length * (index+1)
                            text: numberModel[index]
                            axis: 0
                            distance: numberModel[index] === "∞" ? 0 : numberModel[index]
                            direction: 1
                            style: CustomStyle { baseColor: axisColors[0]; darkness: index*0.06 }
                        }
                    }
                }

                RowLayout {
                    id: xAxisLeftLayout
                    anchors.left: parent.left
                    anchors.verticalCenter: parent.verticalCenter
                    width: parent.height / (numberModel.length*2+1) * numberModel.length
                    height: width
                    spacing: 0
                    Repeater {
                        model: numberModelReverse
                        JogButton {
                            Layout.fillWidth: true
                            Layout.preferredHeight: xAxisLeftLayout.width / numberModel.length * (numberModel.length-index)
                            text: "-" + numberModelReverse[index]
                            axis: 0
                            distance: numberModelReverse[index] === "∞" ? 0 : numberModelReverse[index]
                            direction: -1
                            style: CustomStyle { baseColor: axisColors[0]; darkness: (numberModel.length-index-1)*0.06 }
                        }
                    }
                }

                ColumnLayout {
                    id: yAxisTopLayout
                    anchors.top: parent.top
                    anchors.horizontalCenter: parent.horizontalCenter
                    height: parent.height / (numberModel.length*2+1) * numberModel.length
                    width: height
                    spacing: 0
                    Repeater {
                        model: numberModelReverse
                        JogButton {
                            Layout.preferredWidth: yAxisTopLayout.width / numberModel.length * (numberModel.length-index)
                            Layout.fillHeight: true
                            Layout.alignment: Qt.AlignHCenter
                            text: numberModelReverse[index]
                            axis: 1
                            distance: numberModelReverse[index] === "∞" ? 0 : numberModelReverse[index]
                            direction: 1
                            style: CustomStyle { baseColor: axisColors[1]; darkness: (numberModel.length-index-1)*0.06 }
                        }
                    }
                }

                ColumnLayout {
                    id: yAxisBottomLayout
                    anchors.bottom: parent.bottom
                    anchors.horizontalCenter: parent.horizontalCenter
                    height: parent.height / (numberModel.length*2+1) * numberModel.length
                    width: height
                    spacing: 0
                    Repeater {
                        model: numberModel
                        JogButton {
                            Layout.preferredWidth: yAxisBottomLayout.width / numberModel.length * (index+1)
                            Layout.fillHeight: true
                            Layout.alignment: Qt.AlignHCenter
                            text: "-" + numberModel[index]
                            axis: 1
                            distance: numberModel[index] === "∞" ? 0 : numberModel[index]
                            direction: -1
                            style: CustomStyle { baseColor: axisColors[1]; darkness: index*0.06 }
                        }
                    }
                }
            }

            RowLayout {
                property int axes: status.synced ? status.config.axes - 2 : 2

                id: axisRowLayout
                anchors.left: mainItem.right
                anchors.bottom: parent.bottom
                anchors.top: parent.top
                anchors.leftMargin: parent.height * 0.03
                width: parent.height * 0.20 * axisRowLayout.axes
                spacing: parent.height * 0.03

                Repeater {
                    model: axisRowLayout.axes

                    Item {
                        property int axisIndex: index
                        Layout.fillWidth: true
                        Layout.fillHeight: true

                        Label {
                            anchors.centerIn: parent
                            text: axisNames[2+axisIndex]
                            font.bold: true
                            color: MyStyle.foregroundColor
                        }

                        ColumnLayout {
                            id: axisTopLayout
                            anchors.top: parent.top
                            anchors.left: parent.left
                            height: parent.height / (numberModel.length*2+1) * numberModel.length
                            width: parent.width
                            spacing: 0
                            Repeater {
                                model: numberModelReverse
                                JogButton {
                                    Layout.preferredWidth: axisTopLayout.height / numberModel.length * ((numberModel.length - index - 1) * 0.2 + 1)
                                    Layout.fillHeight: true
                                    Layout.alignment: Qt.AlignHCenter
                                    text: numberModelReverse[index]
                                    axis: 2 + axisIndex
                                    distance: numberModelReverse[index] === "∞" ? 0 : numberModelReverse[index]
                                    direction: 1
                                    style: CustomStyle { baseColor: axisColors[2+axisIndex]; darkness: (numberModel.length-index-1)*0.06 }
                                }
                            }
                        }

                        ColumnLayout {
                            id: axisBottomLayout
                            anchors.bottom: parent.bottom
                            anchors.horizontalCenter: parent.horizontalCenter
                            height: parent.height / (numberModel.length*2+1) * numberModel.length
                            width: parent.width
                            spacing: 0
                            Repeater {
                                model: numberModel
                                JogButton {
                                    Layout.preferredWidth: axisBottomLayout.height / numberModel.length * (index*0.2+1)
                                    Layout.fillHeight: true
                                    Layout.alignment: Qt.AlignHCenter
                                    text: "-" + numberModel[index]
                                    axis: 2 + axisIndex
                                    distance: numberModel[index] === "∞" ? 0 : numberModel[index]
                                    direction: -1
                                    style: CustomStyle { baseColor: axisColors[2+axisIndex]; darkness: index*0.06 }
                                }
                            }
                        }
                    }
                }

              }
        }
        Item {
            Layout.fillHeight: true
        }

        JogSpeeds {}
    }

}
