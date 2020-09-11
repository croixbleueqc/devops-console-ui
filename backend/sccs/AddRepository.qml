import QtQuick 2.12
import "../core"

WSNetworkAbstract {
    id: root

    property var repositoryParams: null
    property string template: ""
    property var templateParams: null

    com: WSComOne
    autoSend: false

    request: "sccs:write:/repository/add"

    dataRequest: {
        "plugin": Store.sccs_plugin_settings.plugin,
        "session": Store.sccs_plugin_settings.sessionObj,
        "repository": repositoryParams,
        "template": template,
        "template_params": templateParams
    }
}
