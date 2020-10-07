import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12

Item {
    id: root
    implicitWidth: contents.implicitWidth
    implicitHeight: contents.implicitHeight

    property var json: null
    property int statusSize: 16

    onJsonChanged: {
        if (root.json === undefined || root.json === null) {
            root.state = ""
        }

        const containers = root.json.containerStatuses.length
        let ready = 0
        let pod_status = "terminated"

        for (const container of [...root.json.containerStatuses, ...(root.json.initContainerStatuses ? root.json.initContainerStatuses : [])]) {
            let status = "terminated"

            if (container.state.waiting) {
                status = "waiting"
            } else if(container.state.running) {
                if (container.ready) {
                    status = "running"
                    ready++
                } else {
                    status = "running-notready"
                }
            } else if(container.state.terminated) {
                status = container.state.terminated.exitCode === 0 ? "terminated" : "terminated-error"
            }

            if (compareOrderedStatus(pod_status, status) === 1) {
                pod_status = status

                if (pod_status === "terminated-error") {
                    // can't be worst !
                    break
                }
            }
        }

        phase.text = root.json.phase + ` (${ready}/${containers})`
        root.state = pod_status
    }

    function compareOrderedStatus(status1, status2) {
        let order = ["terminated-error", "waiting", "running-notready", "running", "terminated"]

        const index1 = order.indexOf(status1)
        const index2 = order.indexOf(status2)

        if (index1 < index2) {
            return -1
        } else if (index1 === index2) {
            return 0
        } else {
            return 1
        }
    }

    states: [
        State {
            name: "waiting"
            PropertyChanges { target: status; color: "darkorange" }
        },
        State {
            name: "running"
            PropertyChanges { target: status; color: "lightgreen" }
        },
        State {
            name: "running-notready"
            PropertyChanges { target: status; color: "orange" }
        },
        State {
            name: "terminated"
            PropertyChanges { target: status; color: "grey" }
        },
        State {
            name: "terminated-error"
            PropertyChanges { target: status; color: "red" }
        }
    ]

    RowLayout {
        id: contents
        spacing: 5

        Rectangle {
            id: status

            width: root.statusSize
            height: root.statusSize

            radius: root.statusSize*0.4
        }

        Label {
            id: phase
            text: ""
        }
    }
}
