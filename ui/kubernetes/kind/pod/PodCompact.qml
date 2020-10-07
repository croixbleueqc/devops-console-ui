import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12

import "../../metadata"
import "../../../../backend/kubernetes"

Item {
    id: root

    implicitHeight: content.implicitHeight
    implicitWidth: content.implicitWidth

    property var json: null
    property alias showDelete: actionDelete.visible
    property alias repositoryName: deletePod.repositoryName
    property alias environment: deletePod.environment

    DeletePod {
        id: deletePod

        name: json !== null ? json.metadata.name : ""
    }

    ColumnLayout {
        id: content
        anchors.fill: parent

        RowLayout {
            Layout.fillWidth: true

            MetadataName {
                json: root.json.metadata
            }

            Item {
                Layout.fillWidth: true
                Layout.minimumWidth: 10
            }

            PodStatus {
                json: root.json.status
            }

            Item {
                Layout.fillWidth: true
                Layout.minimumWidth: 10
            }

            ToolButton {
                Layout.alignment: Qt.AlignRight

                icon.name: "description"
                icon.source: "qrc:/icons/actions/description.svg"

                onClicked: descriptionLoader.active = !descriptionLoader.active

            }

            ToolButton {
                id: actionDelete
                Layout.alignment: Qt.AlignRight

                icon.name: "delete"
                icon.source: "qrc:/icons/actions/delete.svg"
                icon.color: "transparent"

                onClicked: {
                    deletePod.send()
                }
            }
        }

        Component {
            id: descriptionComponent

            ContainersStatuses {
                width: content.width
                json: root.json.status
            }
        }

        Loader {
            id: descriptionLoader
            active: false
            sourceComponent: descriptionComponent
            visible: active
        }
    }
}
