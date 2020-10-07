import QtQuick 2.12
import "../core"

WSNetworkAbstract {
    id: root

    property string repositoryName: ""

    com: WSComOne
    autoSend: false
    autoReset: true

    request: "sccs:read:/repository/runnable/environments"

    dataRequest: {
        "plugin": Store.sccs_plugin_settings.plugin,
        "session": Store.sccs_plugin_settings.sessionObj,
        "repository": root.repositoryName
    }

    onDataRequestChanged: repositoryName !== "" && send()
}
