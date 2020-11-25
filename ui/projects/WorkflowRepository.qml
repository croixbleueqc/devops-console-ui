import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls.Material 2.12

import "../../backend/sccs"
import "../common"

Item {
    id: root

    property string environment: ""
    property string repositoryName: ""
    property string version: ""
    property alias pullrequest: triggerCd.pullrequest
    property WorkflowRepository pipe: null

    readonly property bool canPush: root.pipe && root.pipe.pullrequest === null && root.pipe.version !== root.version

    readonly property alias error: triggerCd.error
    readonly property alias processing: triggerCd.processing
    readonly property var isError: triggerCd.isError

    implicitHeight: decoration.implicitHeight
    implicitWidth: decoration.implicitWidth

    function update(newVersion) {
        triggerCd.version = newVersion
        triggerCd.send()
    }

    function push() {
        if(root.canPush && !root.processing && !root.pipe.processing) {
            root.pipe.update(root.version)
        }
    }

    states: [
        State {
            name: "no_action"
            when: !root.canPush && root.pullrequest === null
            PropertyChanges { target: decoration; color: "lightgreen"; border.color: "lightgreen" }
        },
        State {
            name: "push"
            when: root.canPush && !root.pipe.isError() && root.pullrequest === null
            PropertyChanges { target: decoration; color: "transparent"; border.color: "lightgreen" }
        },
        State {
            name: "retry_push"
            when: root.canPush && root.pipe.isError() && root.pullrequest === null
            PropertyChanges { target: decoration; color: "transparent"; border.color: Material.accentColor}
        },
        State {
            name: "pushing"
            when: root.canPush && root.pipe.processing && root.pullrequest === null
            PropertyChanges { target: decoration; color: "transparent"; border.color: "lightgreen"}
        },
        State {
            name: "pending_request"
            when: root.pullrequest !== null
            PropertyChanges { target: decoration; color: "transparent"; border.color: Material.accentColor}
        }
    ]

    RepoTriggerContinuousDeployment {
        id: triggerCd
        environment: root.environment
        repositoryName: root.repositoryName

        onSuccess: {
            if(dataResponse.version !== root.version) {
                root.version = dataResponse.version
            }
        }

        onErrorChanged: {
            console.log(error)
        }
    }

    Rectangle {
        id: decoration

        implicitHeight: contents.implicitHeight + contents.anchors.margins * 2
        implicitWidth: contents.implicitWidth + contents.anchors.margins * 2

        anchors.fill: parent

        radius: 5
        border.width: 2

        ColumnLayout {
            id: contents
            anchors.fill: parent
            anchors.margins: 10

            Label {
                Layout.fillWidth: true

                text: root.repositoryName
                elide: Text.ElideRight

                font.bold: true
            }

            Label {
                Layout.fillWidth: true

                text: root.version
                elide: Text.ElideMiddle

                font.italic: true
            }

            Label {
                Layout.alignment: Qt.AlignHCenter
                visible: root.pullrequest !== null

                bottomPadding: 5

                text: `<a href="${triggerCd.pullrequest}">` + qsTr("pending request") + "</a>"

                onLinkActivated: Qt.openUrlExternally(link)
            }

            Loading {
                Layout.alignment: Qt.AlignHCenter

                visible: root.processing
                message: qsTr("Deploying...")
            }

            Item {
                id: spacer
                Layout.fillHeight: true
            }

            Button {
                Layout.alignment: Qt.AlignRight

                visible: !root.processing && root.canPush
                enabled: root.pipe && !root.pipe.processing

                text: root.pipe && root.pipe.isError() ? qsTr("Try to push again") : root.pipe && root.pipe.processing ? qsTr("Pushing...") : qsTr("Push")

                highlighted: root.pipe && root.pipe.isError()

                onClicked: root.push()
            }

        }
    }
}
