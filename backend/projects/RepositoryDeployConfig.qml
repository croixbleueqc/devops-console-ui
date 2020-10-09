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
            for (const project of Store.currentProject) {
                if (project.name === env.environment) {

                    var isRepoNotFound = true;
                    for (const repository of project.repositories) {

                        if ( repository.name === repositoryName) {

                            isRepoNotFound = false;
                            repository.version = env.version;
                            break;
                        }
                    }

                    if (isRepoNotFound) {
                        project.repositories.push(
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
