import QtQuick 2.12
import QtQuick.Controls 2.12

import "../../backend/sccs" as Backend
import "../common"

Item {
    id: root

    property alias environment: backend.environment
    property alias repositoryName: backend.repositoryName
    property alias version: backend.version

    property var isDone: false;

    Backend.RepositoryDeployUpdate {
        id: backend

        onSuccess: {
            root.isDone = true
        }

        onErrorChanged: {
            if(isError()) {
                console.log("An error occured: " + error)
            }
        }
    }

    Button {
        visible: backend.environment !== "none"

        id: apply
        text: root.isDone ? qsTr("Done !") :  backend.isError() ? qsTr("Try again") : qsTr("Deploy to " + backend.environment)

        onClicked: backend.send()

        highlighted: backend.isError()
    }
}
