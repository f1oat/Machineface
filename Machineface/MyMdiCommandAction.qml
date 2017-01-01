import QtQuick 2.0
import Machinekit.Application 1.0
import Machinekit.Application.Controls 1.0

MdiCommandAction {
    signal queue(string cmd)
    property bool progress: false
    property var fifo: []
    property bool _running: status.running
    property var timer: null
    signal abort

    function kick() {
        console.log("kick")
        if (fifo.length == 0) {
            console.log("empty")
            progress = false
            return
        }

        progress = true
        mdiCommand = fifo.shift()
        trigger()
        console.log("trigger " + mdiCommand)
    }

    onQueue: {
        console.log("qeueue  " + cmd)
        fifo.push(cmd)
        if (!progress) kick()
    }

    on_RunningChanged: {
        console.log("on_Running Changed " + _running)
        if (!_running && progress) {
            timer.interval = 250;
            timer.repeat = false;
            timer.triggered.connect(kick);
            timer.start();
        }
    }

    onAbort: {
        console.log("abort")
        progress = false
        timer.stop()
        fifo = []
    }
}

