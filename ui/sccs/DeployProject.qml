import QtQuick 2.12
import QtQuick.Controls 2.12

import "../../backend/sccs" as Backend

Item {
    id: root

    property alias project: data.repositoryName
    readonly property alias availables: data.availables

    height: Math.max(contents.visible ? contents.height : 0, processing.visible ? processing.height : 0, incompatible.visible ? incompatible.height : 0)

    Backend.RepositoryDeployConfig {
        id: data
    }

    BusyIndicator {
        id: processing
        visible: data.processing
        running: visible

        width: parent.width
        height: 48
    }

    Label {
        id: incompatible
        visible: !data.processing && data.dataResponse === null && data.repositoryName !== ""

        text: qsTr("%1 is not compatible !").arg(data.repositoryName)

        width: parent.width
        horizontalAlignment: Qt.AlignHCenter
    }

    Column {
        id: contents
        visible: !data.processing && data.dataResponse !== null

        spacing: 20
        anchors.margins: 20

        Label {
            id: title
            text: data.repositoryName
        }

        Repeater {
            model: data.repositoryName !== "" ? data.environments : null

            Deploy {
                environment: modelData.environment
                width: root.width

                version: modelData.version
                availables: root.availables
                readOnly: modelData.readonly !== undefined ? modelData.readonly : false
                repositoryName: root.project
            }
        }
    }
}

