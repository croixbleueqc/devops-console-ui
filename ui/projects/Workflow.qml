import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12

import "../common"
import "../../backend/projects"

Item {
    id: root
    property alias project: data.project
    property int preferredReposPerEnvWidth: 350
    property int preferredRepoHeight: 130
    property int preferredHeaderHeight: 48

    property var repositoriesPerEnvironments: []

    ProjectContinuousDeploymentConfig {
        id: data

        onSuccess: {
            const repositoriesPerEnvironments = []
            var dictEnvs={}

            // create per environments structure
            for(const projectEnv of project.environments) {
                if(projectEnv.enabled) {
                    const repositoriesPerEnvironment = {
                        environment: projectEnv.name,
                        repositories: []
                    }

                    dictEnvs[projectEnv.name] = repositoriesPerEnvironment
                    repositoriesPerEnvironments.push(repositoriesPerEnvironment)
                }
            }

            // fill each environment by adding repositories details
            for(let i=0;i<root.project.repositories.length;i++) {
                const dataResponse = dataResponseAt(i)
                const repositoryName = root.project.repositories[i]

                for(const dataEnv of dataResponse.environments) {
                    const envRef = dictEnvs[dataEnv.environment]
                    if(envRef !== undefined) {
                        envRef.repositories.push(
                                    {
                                        name: repositoryName,
                                        version: dataEnv.version,
                                        pullrequest: dataEnv.pullrequest,
                                        readonly: dataEnv.readonly !== undefined ? dataEnv.readonly : false
                                    })
                    }
                }
            }

            root.repositoriesPerEnvironments = repositoriesPerEnvironments
        }

        onErrorChanged: {
            if(isError()) {
                root.repositoriesPerEnvironments = []
            }
        }
    }

    Loading {
        anchors.centerIn: parent

        visible: data.processing

        inline: false
        message: qsTr("Collecting continous deployment configurations for %1").arg(data.project !== null ? data.project.name : "")
    }

    Label {
        anchors.centerIn: parent

        visible: data.isError()

        text: qsTr("An error occured !")
    }

    Flickable {
        id: headers

        implicitHeight: headersContents.implicitHeight
        contentHeight: headersContents.implicitHeight
        contentWidth: headersContents.implicitWidth
        width: parent.width

        visible: !data.processing

        interactive: false
        contentX: repositories.contentX

        RowLayout {
            id: headersContents

            x: width < headers.width ? (headers.width - width)/2 : 0

            spacing: 10

            Repeater {
                model: root.repositoriesPerEnvironments

                Card {
                    contentWidth: root.preferredReposPerEnvWidth
                    contentHeight: root.preferredHeaderHeight

                    RowLayout {
                        anchors.fill: parent

                        Label {
                            id: content
                            text: modelData.environment
                            Layout.fillWidth: true
                            horizontalAlignment: Text.AlignHCenter

                            padding: 5

                            font.bold: true
                        }

                        Button {
                            Layout.alignment: Qt.AlignRight

                            visible: {
                                const workflowRepositories = repeatWorkflowRepostitories.itemAt(index)
                                return workflowRepositories !== null && workflowRepositories.canPush
                            }

                            text: qsTr("Push for all")

                            onClicked: repeatWorkflowRepostitories.itemAt(index).push()
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

        visible: !data.processing

        clip: true

        contentHeight: repositoriesContents.implicitHeight
        contentWidth: repositoriesContents.implicitWidth

        ScrollBar.horizontal: ScrollBar { id: hbar; active: vbar.active }
        ScrollBar.vertical: ScrollBar { id: vbar; active: hbar.active }

        boundsBehavior: Flickable.StopAtBounds

        RowLayout {
            id: repositoriesContents

            x: width < repositories.width ? (repositories.width - width)/2 : 0

            spacing: 10

            Repeater {
                id: repeatWorkflowRepostitories
                model: root.repositoriesPerEnvironments

                Card {
                    property alias pipe: workflowRepository.pipe
                    property alias canPush: workflowRepository.canPush
                    property var push: workflowRepository.push

                    WorkflowRepositories {
                        id: workflowRepository
                        width: root.preferredReposPerEnvWidth
                        repositoryHeight: root.preferredRepoHeight

                        repositories: modelData.repositories
                        environment: modelData.environment

                        Component.onCompleted: {
                            if(index > 0) {
                                repeatWorkflowRepostitories.itemAt(index - 1).pipe = this
                            }
                        }
                    }
                }
            }
        }
    }
}
