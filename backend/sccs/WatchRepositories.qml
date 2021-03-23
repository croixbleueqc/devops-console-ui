import QtQuick 2.12
import "../core"

WSWatcherModelAbstract {
    id: root
    com: WSComOne

    request: "sccs:watch:/repositories"

    dataRequest: {
        "plugin": Store.sccs_plugin_settings.plugin,
        "session": Store.sccs_plugin_settings.sessionObj
    }

    onDataRequestChanged: watch()
}
