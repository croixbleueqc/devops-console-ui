import QtQuick 2.12

import QtPygo.storage 1.0

Settings {
    id: root
    property string project: ""
    readonly property var projectObj: session !== "" ? JSON.parse(session) : null

    onReady: {
        console.log("Loading DevOps Sccs project Settings...")
        loadSettings()
    }

    function saveSettings(project_value) {
        writeSettings("devops_sccs/project", project_value)
        sync()
        loadSettings()
    }

    function loadSettings() {
        root.project = readSettings("devops_sccs/project", "")
    }
}
