import QtQuick 2.12
import QtQuick.Controls 2.12

import "../../backend/sccs" as Backend
import "../../backend/core"
import "../common"

Item {
    id: root

    property alias environment: backend.environment
    property alias repositoryName: backend.repositoryName
    property alias version: backend.version

    Backend.RepoTriggerContinuousDeployment {
        id: backend

        onSuccess: {

            for (var j = 0; j < Store.currentProject.length; j++) {
                if (Store.currentProject[j].envName === root.environment) {
                    for (var z= 0; z < Store.currentProject[j].repositories.length; z++) {

                        if ( Store.currentProject[j].repositories[z].name === repositoryName) {
                            Store.currentProject[j].repositories[z].version = root.version;
                        }
                    }
                }

            }

            Store.currentProjectChanged();
        }

        onErrorChanged: {
            if(isError()) {
                console.log("An error occured: " + error)
            }
        }
    }

    Button {
        visible: {

            var isVisible = backend.environment !== "none";

            if (isVisible) {
                for (var j = 0; j < Store.currentProject.length; j++) {
                    if (Store.currentProject[j].envName === root.environment) {
                        for (var z= 0; z < Store.currentProject[j].repositories.length; z++) {

                            if ( Store.currentProject[j].repositories[z].name === repositoryName) {

                                if (Store.currentProject[j].repositories[z].version === root.version) {
                                    isVisible = false;
                                }
                            }
                        }
                    }

                }
            }

            return isVisible
        }

        id: apply
        text: backend.isError() ? qsTr("Try again") : qsTr("Deploy to " + backend.environment)

        onClicked: backend.send()

        highlighted: backend.isError()
    }
}
