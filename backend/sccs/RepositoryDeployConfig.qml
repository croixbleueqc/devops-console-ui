import QtQuick 2.12
import "../core"

WSNetworkAbstract {
    id: root

    property string repositoryName: ""
    property var branches: []
    property var commits: []

    com: WSComOne
    autoReset: true

    request: "sccs::/passthrough"
    dataRequest: {
        "plugin": Store.sccs_plugin_settings.plugin,
        "request": "deploy:config",
        "session": Store.sccs_plugin_settings.sessionObj,
        "args": {
            "name": repositoryName
        }
    }

    onDataRequestChanged: repositoryName !== "" && send()

    onDataResponseChanged: {
        if (dataResponse === undefined || dataResponse === null) {
            // Data unavailable
            commits = []
            branches = []
            return
        }

        var pipelinesForUi = []

        for (const pipeline of dataResponse.pipelines) {
            pipelinesForUi.push(
                        {
                            build: pipeline.build,
                            commit: pipeline.commit,
                            display: pipeline.build + " - " + pipeline.commit
                        })
        }

        commits = pipelinesForUi
        branches = dataResponse.branches
    }

    onErrorChanged: {
        if(isError()) {
            console.log("Repositories Deploy Config: " + error)
        }
    }
}
