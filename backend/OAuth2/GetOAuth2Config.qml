import QtQuick 2.12
import "../core"
import ""
WSNetworkAbstract {
    id: root
    com: WSComOne
    autoSend: false

    request: "oauth2:read:/config"

    dataRequest:
    {
        "sccs_plugin": Store.sccs_plugin_settings.plugin,
        "sccs_session": Store.sccs_plugin_settings.sessionObj
    }
    onDataResponseChanged: console.log(JSON.stringify(dataResponse))
}
