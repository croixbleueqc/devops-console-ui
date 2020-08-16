import QtQuick 2.12
import "../core"

WSNetworkAbstract {
    id: root
    com: WSComOne
    autoSend: true

    request: "sccs:read:/repositories"

    dataRequest: {
        "plugin": Store.sccs_plugin_settings.plugin,
        "session": Store.sccs_plugin_settings.sessionObj
    }

    onErrorChanged: {
        if( isError() ) {
            console.log("Repositories: " + error)
        }
    }
}
