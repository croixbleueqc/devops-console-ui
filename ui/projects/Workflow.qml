import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12

import "../common"
import "../../backend/projects"

Item {
    id: root
    property var project: null
    property int preferredReposPerEnvWidth: 350
    property int preferredRepoHeight: 130
    property int preferredHeaderHeight: 48

    Flickable {
        id: headers

        implicitHeight: headersContents.implicitHeight
        contentHeight: headersContents.implicitHeight
        contentWidth: headersContents.implicitWidth
        width: parent.width

        interactive: false
        contentX: repositories.contentX

        RowLayout {
            id: headersContents

            x: width < headers.width ? (headers.width - width)/2 : 0

            spacing: 10

            Repeater {
                id: repeaterHeader
                model: root.project !== null ? root.project.environments.filter(env => env.enabled === true) : null

                Pane {
                    contentWidth: root.preferredReposPerEnvWidth
                    contentHeight: root.preferredHeaderHeight
                    padding: 0

                    property int environmentIndex: index
                    property int nbCanPush: 0

                    RowLayout {
                        anchors.fill: parent

                        Label {
                            id: content
                            text: modelData.name
                            Layout.fillWidth: true
                            horizontalAlignment: Text.AlignHCenter

                            padding: 5

                            font.bold: true
                        }

                        Button {
                            Layout.alignment: Qt.AlignRight

                            visible: nbCanPush > 0

                            text: qsTr("Push for all")

                            onClicked: {
                                for(let i=0; i<repeatWorkflowRepository.count; i++){
                                    repeatWorkflowRepository.itemAt(i).push(environmentIndex)
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    Flickable {
        id: repositories

        anchors.top: headers.bottom
        anchors.bottom: parent.bottom
        width: parent.width

        clip: true

        contentHeight: repositoriesContents.implicitHeight
        contentWidth: repositoriesContents.implicitWidth

        ScrollBar.horizontal: ScrollBar { id: hbar; active: vbar.active }
        ScrollBar.vertical: ScrollBar { id: vbar; active: hbar.active }

        boundsBehavior: Flickable.StopAtBounds

        ColumnLayout {
            id: repositoriesContents

            x: width < repositories.width ? (repositories.width - width)/2 : 0

            spacing: 10

            Repeater {
                id: repeatWorkflowRepository
                model: root.project !== null ? root.project.repositories : null

                Card {
                    property var push: workflowRepository.push
                    property int repositoryIndex: index

                    WorkflowRepository {
                        id: workflowRepository

                        width: root.preferredReposPerEnvWidth
                        repositoryHeight: root.preferredRepoHeight
                        repositoryWidth: root.preferredReposPerEnvWidth

                        repositoryName: modelData
                        filter_environments: {
                            if (root.project === null) { return null }

                            const filter = []
                            for(var item of root.project.environments) {
                                if(item.enabled) { filter.push(item.name) }
                            }

                            return filter.length === root.project.environments.length ? null : filter
                        }

                        onCanPushChanged: {
                            const headerItem = repeaterHeader.itemAt(index)
                            if(headerItem === null) { return }
                            headerItem.nbCanPush += value ? +1 : -1
                        }
                    }
                }
            }
        }
    }
}
