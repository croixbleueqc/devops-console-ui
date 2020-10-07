import QtQuick 2.12
import "../core"

WSWatcherAbstract {
    id: root

    com: WSComOne
    autoSend: true

    property string repositoryName: ""
    property string environment: ""

    request: "k8s:watch:/pods"
    dataRequest: {
        "sccs_plugin": Store.sccs_plugin_settings.plugin,
        "sccs_session": Store.sccs_plugin_settings.sessionObj,
        "repository": repositoryName,
        "environment": environment
    }
}
