import QtQuick 2.12
import QtQuick.Controls 2.12

import "../../backend/core"
import "../../backend/sccs" as Backend

Item {
    id: root

    property var projectIndex

    width: scroll.width
    height: 1000

    FetchRepositories {
        id: data
        projectIndex: root.projectIndex
    }

    BusyIndicator {
        id: processing
        visible: data.processing
        running: visible

        width: 200
        height: 200
    }


    Grid {
        id: contents
        visible: !data.processing

        spacing: 20
        columns: Store.currentProject.length

        Repeater {
            model: Store.currentProject.length

            DeployByEnvironment {
                 environment: Store.currentProject[index];
                 width: (scroll.width * 0.8) / Store.currentProject.length;
            }
        }
    }

}

