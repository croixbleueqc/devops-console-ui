import QtQuick 2.12
import QtQuick.Controls 2.12

Item {
    id: root

    property var repository;
    property var envNameToDeploy;

    height: Math.max(contents.height)
    width: Math.max(contents.width)

    anchors.horizontalCenter: parent.horizontalCenter

    Column {
        id: contents
        spacing: 10

        Label {
            id: title
            text: root.repository.name
            font.pointSize: rect.width / 35
            anchors.horizontalCenter: parent.horizontalCenter
        }

        Label {
            id: version

            font.pointSize: rect.width / 40
            text: root.repository.version
            anchors.horizontalCenter: parent.horizontalCenter
        }

        Deploy {
            id: deploy

            environment: root.envNameToDeploy
            width: 100

            version: root.repository.version
            repositoryName: root.repository.name

            anchors.top: version.bottom
            anchors.horizontalCenter: parent.horizontalCenter
        }
    }
}

