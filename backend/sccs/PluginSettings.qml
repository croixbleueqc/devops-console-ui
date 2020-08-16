import QtQuick 2.12

import QtPygo.storage 1.0

Settings {
    id: root
    property string plugin: ""
    property string session: ""
    readonly property var sessionObj: session !== "" ? JSON.parse(session) : null

    onReady: {
        console.log("Loading DevOps Sccs Settings...")
        loadSettings()
    }

    function saveSettings(plugin_value, session_value) {
        writeSettings("devops_sccs/plugin", plugin_value)
        writeSettings("devops_sccs/session", session_value)
        sync()
        loadSettings()
    }

    function loadSettings() {
        root.plugin = readSettings("devops_sccs/plugin", "")
        root.session = readSettings("devops_sccs/session", "")
    }
}
