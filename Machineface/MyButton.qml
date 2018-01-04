import QtQuick 2.0
import QtQuick.Controls 1.2
import QtQuick.Layouts 1.1
import QtQuick.Window 2.0
import QtQuick.Controls.Styles 1.3
import "."

ToolButton {
    id: button
    property int pixelSize: 14
    property color textColor: MyStyle.foregroundColor
    property string pressed_color: "lightgreen"
    property bool showIcon: true

    implicitWidth: MyStyle.buttonSize
    implicitHeight: MyStyle.buttonSize*0.7

    style: ButtonStyle {
        background: Rectangle {
            //implicitWidth: parent.width
            //implicitHeight: parent.height
            border.width: 3
            border.color: button.checked ? pressed_color : "grey"
            radius: 4
            color: control.pressed ? "grey" : MyStyle.backgroundColor
        }

        label: Item {
            opacity: control.enabled ? 1.0 : 0.4

            function hasIcon() {
                return control.iconSource != ""
            }

            Image {
                id: img
                anchors.centerIn: parent
                width: parent.width * 0.6
                height: width
                source: control.iconSource
                smooth: true
                sourceSize: Qt.size(width, height)
                visible: hasIcon() && showIcon
            }

            Label {
                anchors.fill: parent
                anchors.margins: parent.width * 0.06
                horizontalAlignment: !(hasIcon() && showIcon)  ? "AlignHCenter" : "AlignRight"
                verticalAlignment: !(hasIcon() && showIcon)  ? "AlignVCenter" : "AlignBottom"
                text: control.text
                color: button.textColor
                font.bold: (hasIcon() && showIcon) ? false : true
                font.pixelSize: button.pixelSize
                wrapMode: Text.WordWrap
            }

//            ShaderEffect {
//                visible: control.iconSource != ""
//                property variant src: img

//                width: img.width
//                height: img.height

//                vertexShader: "
//                    uniform highp mat4 qt_Matrix;
//                    attribute highp vec4 qt_Vertex;
//                    attribute highp vec2 qt_MultiTexCoord0;
//                    varying highp vec2 coord;

//                    void main() {
//                        coord = qt_MultiTexCoord0;
//                        gl_Position = qt_Matrix * qt_Vertex;
//                    }
//                "

//                fragmentShader: "
//                    varying highp vec2 coord;
//                    uniform sampler2D src;

//                    void main() {
//                        lowp vec4 clr = texture2D(src, coord);
//                        lowp float avg = (clr.r + clr.g + clr.b) / 3.;
//                        if (avg < 0.01) gl_FragColor = vec4(1. - avg, 1. - avg, 1. - avg, clr.a);
//                        else gl_FragColor = vec4(0., 0., 0., clr.a);
//                    }
//                "
//            }
        }
    }
}
