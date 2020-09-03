import QtQuick 2.12
import QtQuick.Controls 2.12

import "../../backend/core"
import "../../backend/sccs" as Backend

Item {
    id: root

    property var projectIndex;
    property bool processing: true

    Repeater {
        id: dataRepository
        model: Store.sccs_project_settings.projectObj.projects[projectIndex].repositories.length

        Backend.RepositoryDeployConfigTest {
            repositoryName: Store.sccs_project_settings.projectObj.projects[projectIndex].repositories[index].name
            projectIndex: projectIndex;

            onProcessingChanged: {
                if(dataRepository.model === undefined) {
                    root.processing = true
                    return
                }

                for(var i=0; i<dataRepository.model; i++) {
                    if(dataRepository.itemAt(i).processing) {
                        return
                    }
                }

                root.processing = false
            }
        }
    }
}

