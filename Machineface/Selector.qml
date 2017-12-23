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

MyGroupBox {
    title: "Speed"
    property var labels_list
    property var values_list
    property real value: -1

    function normalize(value) {
        // Sort values in descending order
        var indexedTest = values_list.map(function(e,i){return {ind: i, val: e}});
        indexedTest.sort(function(x, y){return x.val < y.val ? 1 : x.val === y.val ? 0 : -1});
        var indices = indexedTest.map(function(e){return e.ind});

        if (value >= values_list[indices[0]]) return indices[0];
        for (var i=1; i<values_list.length; i++) {
            if (value >= values_list[indices[i]]) {
                if (value > (values_list[indices[i]] + values_list[indices[i-1]])/2) return indices[i-1]
                else return indices[i]
            }
        }
        return indices[values_list.length-1]
    }

    onValueChanged: {
        var idx = normalize(value)
        value = values_list[idx]
    }

    function set(v) {
        var idx = normalize(v)
        value = values_list[idx]
    }

    ColumnLayout {
        id: col
        anchors.fill: parent
        ExclusiveGroup { id: my_group }

        Repeater {
            model: values_list
            MyButton {
                text: labels_list ? labels_list[index] : modelData

                Layout.fillWidth: true
                Layout.fillHeight: true
                Layout.maximumHeight: MyStyle.buttonSize
                Layout.maximumWidth: MyStyle.buttonSize

                property real _value: modelData
                onClicked: checked = true
                exclusiveGroup: my_group

                onCheckedChanged: {
                    if (checked) {
                        value = _value
                    }
                }
                checked: value == _value
            }
        }
    }
}

