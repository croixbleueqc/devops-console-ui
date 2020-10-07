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
        if (root.json === null) {
            root.state = ""
        }

        if (root.json.state.waiting) {
            root.state= "waiting"
        } else if(root.json.state.running) {
            root.state = root.json.ready ? "running" : "running-notready"
        } else if(root.json.state.terminated) {
            root.state = root.json.state.terminated.exitCode === 0 ? "terminated" : "terminated-error"
        }
    }

    states: [
        State {
            name: "waiting"
            PropertyChanges { target: container; color: "darkorange" }
        },
        State {
            name: "running"
            PropertyChanges { target: container; color: "lightgreen" }
        },
        State {
            name: "running-notready"
            PropertyChanges { target: container; color: "orange" }
        },
        State {
            name: "terminated"
            PropertyChanges { target: container; color: "grey" }
        },
        State {
            name: "terminated-error"
            PropertyChanges { target: container; color: "red" }
        }
    ]

    RowLayout {
        id: contents
        spacing: 5

        Rectangle {
            id: container

            Layout.alignment: Qt.AlignTop

            width: root.statusSize
            height: root.statusSize

            radius: root.statusSize*0.4
        }

        Text {
            Layout.preferredWidth: 300
            Layout.alignment: Qt.AlignTop

            text: {
                var summary = `<b>${root.json.name}</b><br>`

                switch(root.state) {
                case "waiting":
                    summary += `Reason: ${root.json.state.waiting.reason}`
                    break
                case "running":
                    summary += `Started At: ${root.json.state.running.startedAt}`
                    break
                case "running-notready":
                    summary += `Started At: ${root.json.state.running.startedAt}<br>`
                    summary += `<i>Not ready</i>`
                    break
                case "terminated":
                case "terminated-error":
                    summary += `Exit Code: ${root.json.state.terminated.exitCode}<br>`
                    summary += `Reason: ${root.json.state.terminated.reason}<br>`
                    summary += `Started At: ${root.json.state.terminated.startedAt}<br>`
                    summary += `Finished At: ${root.json.state.terminated.finishedAt}`
                    break
                default:
                    break
                }

                summary += `<br>Restart Count: ${root.json.restartCount}`

                return summary
            }
        }

        Column {
            ToolButton {
                icon.name: "viewlog"
                icon.source: "qrc:/icons/actions/viewlog.svg"
            }

            ToolButton {
                icon.name: "new-command-alarm"
                icon.source: "qrc:/icons/actions/new-command-alarm.svg"

                enabled: root.state === "running"
            }
        }
    }
}
