import QtQuick 2.12
import "../core"

WSNetworkAbstract {
    id: root

    property string repositoryName: ""

    com: WSComOne
    autoReset: true

    request: "sccs:read:/repository/cd/config"
    dataRequest: {
        "plugin": Store.sccs_plugin_settings.plugin,
        "session": Store.sccs_plugin_settings.sessionObj,
        "repository": repositoryName
    }

    onDataRequestChanged: repositoryName !== "" && send()

    onDataResponseChanged: {

        if (dataResponse === undefined || dataResponse === null) {
            return
        }

        for (const env of dataResponse.environments) {
            for (var j = 0; j < Store.currentProject.length; j++) {
                if (Store.currentProject[j].envName === env.environment) {

                    var isRepoNotFound = true;
                    for (var z= 0; z < Store.currentProject[j].repositories.length; z++) {

                        if ( Store.currentProject[j].repositories[z].name === repositoryName) {

                            isRepoNotFound = false;
                            Store.currentProject[j].repositories[z].version = env.version;
                        }
                    }

                    if (isRepoNotFound) {
                        Store.currentProject[j].repositories.push(
                        {
                            name: repositoryName,
                            version: env.version
                        })
                    }
                }
            }
        }

        Store.currentProjectChanged();
    }

    onErrorChanged: {
        if(isError()) {
            console.log("Repositories Deploy Config: " + error)
        }
    }
}
