import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12

import "../../backend/sccs" as Backend
import "../common"

Item {
    id: root

    property string repositoryName: ""
    property alias filter_environments: data.filter_environments
    property int repositoryHeight: 130
    property int repositoryWidth: 350
    property alias envPerRow: contents.columns
    property string mode: "row"

    signal canPushChanged(int index, bool value)

    implicitHeight: contents.implicitHeight
    implicitWidth: contents.implicitWidth

    function push(index) {
        const item = repeaterWorkflowRepositoryByEnv.itemAt(index)
        if (item !== null) {
           item.push()
        }
    }

    Backend.WatchContinousDeploymentConfig {
        id: data

        repositoryName: root.repositoryName
    }

    Backend.WatchContinuousDeploymentVersionsAvailable {
        id: dataVersionsAvailable

        repositoryName: root.repositoryName
    }

    GridLayout {
        id: contents

        columnSpacing: 10
        rowSpacing: 10
        anchors.margins: 10

        Loading {
            Layout.alignment: Qt.AlignHCenter

            visible: data.processing

            message: qsTr("Collecting continous deployment configurations for %1").arg(root.repositoryName)
        }

        Label {
            Layout.fillWidth: true
            topPadding: 10
            horizontalAlignment: Text.AlignHCenter

            visible: !data.processing && data.dataResponse.count === 0

            text: qsTr("There is no continous deployment configurations available for %1").arg(root.repositoryName)
        }

        Repeater {
            id: repeaterWorkflowRepositoryByEnv
            model: data.dataResponse

            delegate: {
                switch(root.mode){
                case "independent":
                    return independentCpt
                default:
                    return rowCpt
                }
            }
        }
    }

    Dialog {
        id: dialogVersionsAvailable

        property string currentVersion: ""
        property WorkflowRepositoryByEnv itemEdited: null

        anchors.centerIn: Overlay.overlay

        title: qsTr("Deploy a new version")
        standardButtons: Dialog.Apply | Dialog.Cancel
        modal: true

        onCurrentVersionChanged: {
            versions.lastIndex = -1
            versions.updateCurrentIndex()
        }

        onClosed: {
            currentVersion = ""
        }

        onApplied: {
            if (versions.currentIndex !== -1) {
                const versionSelected = versions.model.get(versions.currentIndex).raw.version
                if (versionSelected !== currentVersion) {
                    itemEdited.localUpdate(versionSelected)
                }
            }

            close()
        }

        GridLayout {
            anchors.fill: parent
            columnSpacing: 20
            rowSpacing: 10
            columns: 2

            Label { text: qsTr("Repository:") }
            Label { text: root.repositoryName; font.italic: true}

            Label { text: qsTr("Environment:") }
            Label { text: dialogVersionsAvailable.itemEdited && dialogVersionsAvailable.itemEdited.environment; font.italic: true }

            Label { text: qsTr("Current version:") }
            Label { text: dialogVersionsAvailable.currentVersion; font.italic: true }

            MenuSeparator { Layout.columnSpan: 2; Layout.fillWidth: true }

            Label { Layout.columnSpan: 2; text: qsTr("Choose a new version:") }

            Loading {
                Layout.columnSpan: 2
                Layout.fillWidth: true

                visible: dataVersionsAvailable.processing
            }

            ComboBox {
                id: versions
                Layout.columnSpan: 2
                Layout.fillWidth: true

                property int lastIndex: -1

                visible: !dataVersionsAvailable.processing
                model: dataVersionsAvailable.dataResponse

                function itemToText(item) {
                    return item.build + " - " + item.version
                }

                function updateCurrentIndex() {
                    if(dialogVersionsAvailable.currentVersion === "") {
                        currentIndex = -1
                        return
                    }

                    for(let i=versions.lastIndex+1; i<count; i++) {
                        if(model.get(i).raw.version === dialogVersionsAvailable.currentVersion) {
                            currentIndex = i
                            return
                        }
                    }
                }

                delegate: ItemDelegate {
                    width: parent ? parent.width : 0
                    text: versions.itemToText(raw)
                }

                displayText: currentIndex === -1 ? "" : itemToText(model.get(currentIndex).raw)

                onCountChanged: {
                    if(currentIndex === -1) {
                        updateCurrentIndex()
                    }
                }
            }
        }
    }

    Component {
        id: rowCpt

        WorkflowRepositoryByEnv {
            id: workflowRepository

            Layout.preferredWidth: root.repositoryWidth
            Layout.preferredHeight: root.repositoryHeight

            environment: raw.environment
            version: raw.version
            pullrequest: raw.pullrequest
            readonly: raw.readonly !== undefined ? raw.readonly : false
            repositoryName: root.repositoryName

            onCanPushChanged: {
                root.canPushChanged(index, canPush)
            }

            onEditClicked: {
                if (!dataVersionsAvailable.watching) { dataVersionsAvailable.watch() }
                dialogVersionsAvailable.currentVersion = raw.version
                dialogVersionsAvailable.itemEdited = source
                dialogVersionsAvailable.open()
            }

            Component.onCompleted: {
                if (index > 0) {
                    repeaterWorkflowRepositoryByEnv.itemAt(index - 1).pipe = this
                }
            }
        }
    }

    Component {
        id: independentCpt

        ColumnLayout {
            property alias pipe: workflowRepository.pipe
            property alias canPush: workflowRepository.canPush
            property var push: workflowRepository.push

            Label {
                text: raw.environment
                Layout.fillWidth: true
                horizontalAlignment: Text.AlignHCenter

                padding: 5

                font.bold: true
            }

            Card {
                contentHeight: root.repositoryHeight
                contentWidth: root.repositoryWidth

                WorkflowRepositoryByEnv {
                    id: workflowRepository

                    anchors.fill: parent

                    titleVisible: false

                    environment: raw.environment
                    version: raw.version
                    pullrequest: raw.pullrequest
                    readonly: raw.readonly !== undefined ? raw.readonly : false
                    repositoryName: root.repositoryName

                    onCanPushChanged: {
                        root.canPushChanged(index, canPush)
                    }

                    onEditClicked: {
                        if (!dataVersionsAvailable.watching) { dataVersionsAvailable.watch() }
                        dialogVersionsAvailable.currentVersion = raw.version
                        dialogVersionsAvailable.itemEdited = source
                        dialogVersionsAvailable.open()
                    }

                    Component.onCompleted: {
                        if (index > 0) {
                            repeaterWorkflowRepositoryByEnv.itemAt(index - 1).pipe = this
                        }
                    }
                }
            }
        }
    }
}

