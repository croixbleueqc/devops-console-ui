import QtQuick 2.12
import "../core"

WSNetworkAbstract {
    id: root

    property string repositoryName: ""
    property string envName: "";

    property var environment;

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

            if (env.environment === envName) {
                environment = env;
            }
        }
    }

    onErrorChanged: {
        if(isError()) {
            console.log("Repositories Deploy Config: " + error)
        }
    }
}
