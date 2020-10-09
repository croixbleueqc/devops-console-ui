import QtQuick 2.12
import QtQuick.Controls 2.12

import "../common"

Item {
    id: root

    property var environment
    property var nextEnvironment: undefined

    implicitHeight: contents.implicitHeight

    Card {
        id: contents
        width: parent.width

        Column {
            spacing: 10
            width: parent.width

            Text {
                text: root.environment.name
                font.bold: true

                width: parent.width
                horizontalAlignment: Text.AlignHCenter
            }

            Repeater {
                model: root.environment.repositories !== undefined ? root.environment.repositories.length : 0

                Rectangle {
                    color: environment.repositories[index].isUpdated === true ? "lightyellow" : "lightgreen"

                    width: parent.width
                    height: 130

                    DeployRepository {
                        id: project

                        width: parent.width
                        height: 110

                        anchors.centerIn: parent

                        repository: environment.repositories[index]
                        envNameToDeploy: root.nextEnvironment !== undefined ? nextEnvironment.name : "none"
                    }
                }
            }
         }
    }

}

