import QtQuick 2.0
import QtQuick.Controls 1.2
import QtQuick.Layouts 1.1

TableView {
    id: logTableView
    Layout.fillWidth: true
    Layout.fillHeight: true
    model: null
    headerVisible: false
    property variant filter: ["motion stopped by enable input"]

    function addNotification (type, text)
    {
        var f = filter.indexOf(text)
        if (f < 0) model.append({"type": type, "text": text})
    }

    TableViewColumn{ role: "type"  ; title: "Type"  }
    TableViewColumn{ role: "text"  ; title: "Text"  }
}
