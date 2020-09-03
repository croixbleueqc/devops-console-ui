import QtQuick 2.12
import QtQuick.Controls 2.12

import "../../backend/sccs" as Backend

Item {
    id: root

    property var environment;

    width: parent.width;
    height: 1000;

    Rectangle {
        id: rect;

        color: "lightgray";
        width: root.width;
        height: 1000;

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
                model: root.environment.repositories.length

                Rectangle {
                    id: repo
                    color: "green";
                    width: rect.width * 0.8;
                    height: 100;

                    DeployProjectTest {
                        id: project

                        repository: environment.repositories[index]
                        envNameToDeploy: environment.deployToEnvName
                    }
                }
            }
         }
    }

}

