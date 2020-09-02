import QtQuick 2.12
import QtQuick.Controls 2.12

import "../../backend/sccs" as Backend

Item {
    id: root

    property alias project: data.repositoryName;
    property alias envName: data.envName;
    property var envNameToDeploy;

    height: Math.max(contents.visible ? contents.height : 0, processing.visible ? processing.height : 0, incompatible.visible ? incompatible.height : 0)
    width: Math.max(contents.visible ? contents.width : 0, processing.visible ? processing.width : 0, incompatible.visible ? incompatible.width : 0)

    Backend.RepositoryDeployConfigTest {
        id: data
    }

    BusyIndicator {
        id: processing
        visible: data.processing
        running: visible

        width: 48
        height: 48
    }

    Label {
        id: incompatible
        visible: !data.processing && data.dataResponse === null && data.repositoryName !== ""

        text: qsTr("%1 is not compatible !").arg(data.repositoryName)
    }

    Column {
        id: contents
        visible: !data.processing && data.dataResponse !== null

        spacing: 10
        anchors.margins: 20

        Label {
            id: title
            text: data.repositoryName
        }

        Label {
            id: version

            font.pixelSize: 10
            text: data.environment.version
        }

        DeployTest {
            id: deploy

            environment: root.envNameToDeploy
            width: 100

            version: data.environment.version
            repositoryName: data.repositoryName

            anchors.top: version.bottom
        }

    }
}

