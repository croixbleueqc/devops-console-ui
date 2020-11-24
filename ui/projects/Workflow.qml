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

                    Label {
                        id: content
                        text: modelData.environment
                        width: root.preferredReposPerEnvWidth
                        horizontalAlignment: Text.AlignHCenter

                        padding: 5

                        font.bold: true
                    }
                }
            }
        }
    }

    Flickable {
        id: commands

        implicitHeight: commandsContents.implicitHeight
        contentHeight: commandsContents.implicitHeight
        contentWidth: commandsContents.implicitWidth
        anchors.top: headers.bottom
        width: parent.width

        visible: !data.processing

        interactive: false
        contentX: repositories.contentX

        RowLayout {
            id: commandsContents

            x: width < commands.width ? (commands.width - width)/2 : 0

            spacing: 10

            Repeater {
                id: commandByEnv
                model: root.repositoriesPerEnvironments

                Card {
                    contentWidth: root.preferredReposPerEnvWidth
                    property bool canPush: repeatWorkflowRepostitories.itemAt(index).canPush
                    property var cdRepos: repeatWorkflowRepostitories.model[index].repositories

                    Button {
                        text: "Push"
                        width: root.preferredReposPerEnvWidth
                        visible: canPush
                        padding: 5
                        font.bold: true

                        onClicked: {
                            repeatWorkflowRepostitories.itemAt(index).pipe.update(cdRepos);
                        }
                    }
                }
            }
        }
    }

    Flickable {
        id: repositories

        anchors.top: commands.bottom
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

                        onCanPushChanged: {
                            if (commandByEnv.count > 0) {
                                commandByEnv.itemAt(index).canPush = canPush
                                console.log(commandByEnv.itemAt(index).canPush)
                            }
                        }

                        onCdReposChanged: {
                            if (commandByEnv.count > 0) {
                                commandByEnv.itemAt(index).cdRepos = cdRepos
                            }
                        }
                    }
                }
            }
        }
    }
}
