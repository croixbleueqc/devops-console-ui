import QtQuick 2.12
import QtQuick.Controls 2.12

Item {
    id: root

    property var environment;

    width: parent.width;
    height: parent.height;

    Rectangle {
        id: rect;

        color: "lightgray";
        width: parent.width;
        height: parent.height;

        Text {
            id: env
            padding: 50
            text: root.environment.name
            font.pixelSize: 20
            font.family: "AvantGarde-Medium"
            smooth: true
            verticalAlignment: Text.AlignVCenter
            anchors.horizontalCenter: rect.horizontalCenter;
        }

        Column {
            id: contents

            spacing: 20
            anchors.horizontalCenter: rect.horizontalCenter;
            anchors.top: env.bottom;

            Repeater {
                model: root.environment.repositories !== undefined ? root.environment.repositories.length : 0

                Rectangle {
                    id: repo
                    color: environment.repositories[index].isUpdated === true ? "yellow" : "green";
                    width: rect.width * 0.8;
                    height: 100;

                    DeployRepository {
                        id: project

                        repository: environment.repositories[index]
                        envNameToDeploy: environment.deployToEnvName
                    }
                }
            }
         }
    }

}

