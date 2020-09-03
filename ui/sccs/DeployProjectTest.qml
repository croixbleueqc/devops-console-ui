import QtQuick 2.12
import QtQuick.Controls 2.12

import "../../backend/sccs" as Backend

Item {
    id: root

    property var repository;
    property var envNameToDeploy;

    height: Math.max(contents.height)
    width: Math.max(contents.width)

    Column {
        id: contents

        spacing: 10
        anchors.margins: 20

        Label {
            id: title
            text: root.repository.name
        }

        Label {
            id: version

            font.pixelSize: 10
            text: root.repository.version
        }

        DeployTest {
            id: deploy

            environment: root.envNameToDeploy
            width: 100

            version: root.repository.version
            repositoryName: root.repository.name

            anchors.top: version.bottom
        }
    }
}

