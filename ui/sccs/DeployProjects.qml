import QtQuick 2.12
import QtQuick.Controls 2.12

import "../../backend/core"

Item {
    id: root

    property var projectIndex

    Column {
        id: contents

        spacing: 20
        anchors.margins: 20

        Label {
            id: title
            text: Store.sccs_project_settings.projectObj.projects[projectIndex].name
        }

        Repeater {
            model: Store.sccs_project_settings.projectObj.projects.length

            Text {
                text: Store.sccs_project_settings.projectObj.projects[projectIndex].repositories[index].name
            }

            DeployProject {
                id: project

                x: (scroll.width - width)/2

                project: Store.sccs_project_settings.projectObj.projects[projectIndex].repositories[index].name
            }
        }
     }
}

