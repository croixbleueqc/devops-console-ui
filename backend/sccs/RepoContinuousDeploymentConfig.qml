import QtQuick 2.12
import "../core"

WSNetworkAbstract {
    id: root

    property string repositoryName: ""
    property var environments: []
    property var availables: []
    property var args: null

    com: WSComOne
    autoReset: true

    request: "sccs:read:/repository/cd/config"
    dataRequest: {
        "plugin": Store.sccs_plugin_settings.plugin,
        "session": Store.sccs_plugin_settings.sessionObj,
        "repository": repositoryName,
        "args": args
    }

    onDataRequestChanged: repositoryName !== "" && send()

    onDataResponseChanged: {
        if (dataResponse === undefined || dataResponse === null) {
            // Data unavailable
            environments = []
            availables = []
            return
        }

        var pipelinesForUi = []

        for (const pipeline of dataResponse.availables) {
            pipelinesForUi.push(
                        {
                            build: pipeline.build,
                            version: pipeline.version,
                            display: pipeline.build + " - " + pipeline.version
                        })
        }

        availables = pipelinesForUi
        environments = dataResponse.environments
    }

    onErrorChanged: {
        if(isError()) {
            console.log("Repositories Deploy Config: " + error)
        }
    }
}
