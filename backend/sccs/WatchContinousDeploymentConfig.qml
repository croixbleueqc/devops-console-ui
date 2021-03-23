import QtQuick 2.12
import "../core"

WSWatcherModelAbstract {
    id: root

    com: WSComOne

    property string repositoryName: ""
    property var filter_environments: null
    property var args: null

    request: "sccs:watch:/repository/cd/config"
    dataRequest: {
        "plugin": Store.sccs_plugin_settings.plugin,
        "session": Store.sccs_plugin_settings.sessionObj,
        "repository": repositoryName,
        "environments": filter_environments,
        "args": args
    }

    onDataRequestChanged: repositoryName !== "" && watch()
}
