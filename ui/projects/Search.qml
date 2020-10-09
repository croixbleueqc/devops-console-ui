import QtQuick 2.12
import QtQuick.Controls 2.12

import "../../backend/core"


Item {
    id: root

    height: combobox.height

    property alias index: combobox.currentIndex

    ComboBox {
        id: combobox

        width: root.width
        model: Store.projects_project_settings.projectObj

        textRole: "name"

        editable: false
        flat: true

        onCurrentIndexChanged: {
            Store.processing = true;

            const enabledEnvs = []
            for(const env of Store.projects_project_settings.projectObj[search.index].environments) {
                if(env.enabled) {
                    enabledEnvs.push(Object.assign({}, env))
                }
            }

            Store.currentProject = enabledEnvs

            for (var i = 0; i < Store.currentProject.length; i++) {
              Store.currentProject[i].repositories = [];
            }

            Store.currentProjectChanged();
        }
    }
}
