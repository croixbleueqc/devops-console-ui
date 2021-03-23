import QtQuick 2.12
import "../core"

WSNetworkAbstract {
    id: root

    com: WSComOne
    autoSend: false
    autoReset: true

    property string repositoryName: ""
    property var args: null

    request: "sccs:read:/repository/cd/environments_available"

    dataRequest: {
        "plugin": Store.sccs_plugin_settings.plugin,
        "session": Store.sccs_plugin_settings.sessionObj,
        "repository": repositoryName,
        "args": args
    }

    onDataRequestChanged: repositoryName !== "" && send()

    onDataResponseChanged: console.log(JSON.stringify(dataResponse))
}
