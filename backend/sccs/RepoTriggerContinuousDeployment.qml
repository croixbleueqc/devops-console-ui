import QtQuick 2.12
import "../core"

WSNetworkAbstract {
    id: root

    property string repositoryName: ""
    property string environment: ""
    property string version: ""

    com: WSComOne

    request: "sccs:write:/repository/cd/trigger"

    dataRequest: {
        "plugin": Store.sccs_plugin_settings.plugin,
        "session": Store.sccs_plugin_settings.sessionObj,
        "repository": repositoryName,
        "environment": environment,
        "version": version
    }
}
