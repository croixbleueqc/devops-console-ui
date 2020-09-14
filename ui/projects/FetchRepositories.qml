import QtQuick 2.12
import QtQuick.Controls 2.12

import "../../backend/core"
import "../../backend/projects" as Backend

Item {
    id: root

    property var projectIndex;

    Repeater {
        id: dataRepository
        model: Store.projects_project_settings.projectObj.projects[projectIndex].repositories.length

        Backend.RepositoryDeployConfig {
            repositoryName: Store.projects_project_settings.projectObj.projects[projectIndex].repositories[index].name

            onProcessingChanged: {
                if(dataRepository.model === undefined) {
                    Store.processing = true
                    return
                }

                for(var i=0; i<dataRepository.model; i++) {
                    if(dataRepository.itemAt(i).processing) {
                        return
                    }
                }

                Store.processing = false
                Store.processingChanged();
            }
        }
    }
}

