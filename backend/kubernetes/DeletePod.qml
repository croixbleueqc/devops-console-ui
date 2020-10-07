import QtQuick 2.12
import "../core"

WSNetworkAbstract {
    id: root

    com: WSComOne
    autoSend: false

    property string name: ""
    property string repositoryName: ""
    property string environment: ""

    request: "k8s:delete:/pod"
    dataRequest: {
        "sccs_plugin": Store.sccs_plugin_settings.plugin,
        "sccs_session": Store.sccs_plugin_settings.sessionObj,
        "repository": repositoryName,
        "environment": environment,
        "name": name
    }
}
