import QtQuick 2.12
import "../core"

WSWatcherModelAbstract {
    id: root

    com: WSComOne

    property string repositoryName: ""
    property var args: null

    request: "sccs:watch:/repository/cd/versions_available"
    dataRequest: {
        "plugin": Store.sccs_plugin_settings.plugin,
        "session": Store.sccs_plugin_settings.sessionObj,
        "repository": repositoryName,
        "args": args
    }

    //onDataRequestChanged: repositoryName !== "" && send()
}
