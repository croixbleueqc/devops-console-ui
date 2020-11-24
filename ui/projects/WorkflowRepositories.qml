import QtQuick 2.12

Item {
    id: root
    property var repositories: []
    property string environment: ""
    property int repositoryHeight: 130
    property WorkflowRepositories pipe: null

    readonly property alias canPush: repeatWorkflowRepository.canPush

    function workflowRepositoryAt(index) {
        return repeatWorkflowRepository.itemAt(index)
    }

    function push() {
        if(root.canPush) {
            for (var index=0; index<repeatWorkflowRepository.count; index++) {
                repeatWorkflowRepository.itemAt(index).push()
            }
        }
    }

    onPipeChanged: {
        // Pipe relevant repositories together

        for (var index=0; index<repeatWorkflowRepository.count; index++) {
            const nextItem = repeatWorkflowRepository.itemAt(index)
            nextItem.pipe = root.pipe.workflowRepositoryAt(index)
        }
    }

    implicitHeight: contents.implicitHeight
    implicitWidth: contents.implicitWidth

    Column {
        id: contents
        anchors.fill: parent
        spacing: 10

        Repeater {
            id: repeatWorkflowRepository

            property bool canPush: false

            model: root.repositories

            WorkflowRepository {
                width: parent.width
                height: root.repositoryHeight

                environment: root.environment
                repositoryName: modelData.name
                version: modelData.version
                pullrequest: modelData.pullrequest !== undefined ? modelData.pullrequest : null

                onCanPushChanged: {
                    if (canPush) {
                        repeatWorkflowRepository.canPush = true
                        return
                    }

                    for (var index=0; index<repeatWorkflowRepository.count; index++) {
                        if(repeatWorkflowRepository.itemAt(index).canPush) {
                            repeatWorkflowRepository.canPush = true
                            return
                        }
                    }

                    repeatWorkflowRepository.canPush = false
                }
            }
        }
    }
}
