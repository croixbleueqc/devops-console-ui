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

    implicitHeight: backend.processing ? processing.height : apply.visible ? apply.height : 0
    implicitWidth: backend.processing ? processing.width : apply.visible ? apply.width : 0

    Backend.RepoTriggerContinuousDeployment {
        id: backend

        onSuccess: {

            for (var j = 0; j < Store.currentProject.length; j++) {
                if (Store.currentProject[j].name === root.environment) {
                    for (var z= 0; z < Store.currentProject[j].repositories.length; z++) {

                        if ( Store.currentProject[j].repositories[z].name === repositoryName) {
                            Store.currentProject[j].repositories[z].version = root.version;
                            Store.currentProject[j].repositories[z].isUpdated = true;
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

    BusyIndicator {
        id: processing
        visible: backend.processing
        running: visible

        width: 48
        height: 48
    }

    Button {
        id: apply
        visible: {

            var isVisible = !backend.processing && backend.environment !== "none";

            if (isVisible) {
                for (var j = 0; j < Store.currentProject.length; j++) {
                    if (Store.currentProject[j].name === root.environment) {
                        for (var z= 0; Store.currentProject[j].repositories !== undefined && z < Store.currentProject[j].repositories.length; z++) {

                            if ( Store.currentProject[j].repositories[z].name === repositoryName) {

                                if (Store.currentProject[j].repositories[z].version === root.version) {
                                    return false;
                                }
                            }
                        }
                    }

                }
            }

            return isVisible
        }

        text: backend.isError() ? qsTr("Try again") : qsTr("Deploy:" + backend.environment)

        onClicked: backend.send()

        highlighted: backend.isError()
    }
}
