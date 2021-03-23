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
    property string pullrequest: ""
    property bool readonly: false
    property WorkflowRepositoryByEnv pipe: null
    property alias localUpdateScope: triggerCd.localScope

    property bool titleVisible: true

    readonly property bool canPush: root.pipe && root.pipe.pullrequest === "" && root.pipe.version !== root.version

    readonly property alias error: triggerCd.error
    property bool processing: false
    readonly property var isError: triggerCd.isError

    signal editClicked(WorkflowRepositoryByEnv source)

    implicitHeight: decoration.implicitHeight
    implicitWidth: decoration.implicitWidth

    function update(newVersion) {
        triggerCd.version = newVersion
        triggerCd.localScope = false
        triggerCd.send()
    }

    function localUpdate(newVersion) {
        triggerCd.version = newVersion
        triggerCd.localScope = true
        triggerCd.send()
    }

    function push() {
        if(root.canPush && !root.processing && !root.pipe.processing) {
            root.pipe.update(root.version)
        }
    }

    onVersionChanged: if (root.processing && !triggerCd.processing ) { root.processing = false } // update event that should stop the processing (see triggerCd)
    onPullrequestChanged: if (root.processing && !triggerCd.processing) { root.processing = false } // update event that should stop the processing (see triggerCd)

    states: [
        State {
            name: "retry_local"
            when: root.localUpdateScope && root.isError()
            PropertyChanges { target: decoration; color: "transparent"; border.color: Material.accentColor}
        },
        State {
            name: "no_action"
            when: !root.canPush && root.pullrequest === ""
            PropertyChanges { target: decoration; color: "lightgreen"; border.color: "lightgreen" }
        },
        State {
            name: "push"
            when: root.canPush && (root.pipe.localUpdateScope || !root.pipe.isError())  && root.pullrequest === ""
            PropertyChanges { target: decoration; color: "transparent"; border.color: "lightgreen" }
        },
        State {
            name: "retry_push"
            when: root.canPush && !root.pipe.localUpdateScope && root.pipe.isError() && root.pullrequest === ""
            PropertyChanges { target: decoration; color: "transparent"; border.color: Material.accentColor}
        },
        State {
            name: "pushing"
            when: root.canPush && !root.pipe.localUpdateScope && root.pipe.processing && root.pullrequest === ""
            PropertyChanges { target: decoration; color: "transparent"; border.color: "lightgreen"}
        },
        State {
            name: "pending_request"
            when: root.pullrequest !== ""
            PropertyChanges { target: decoration; color: "transparent"; border.color: Material.accentColor}
        }
    ]

    RepoTriggerContinuousDeployment {
        id: triggerCd

        property bool localScope: false

        environment: root.environment
        repositoryName: root.repositoryName

        onErrorChanged: { console.log(error) }

        onProcessingChanged: {
            if(processing) {
                root.processing = true
            } else if (isError()) {
                root.processing = false
            }
            // else: we will received an event that will stop the processing
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

                visible: root.titleVisible

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
                visible: root.pullrequest !== ""

                bottomPadding: 5

                text: `<a href="${root.pullrequest}">` + qsTr("pending request") + "</a>"

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

            RowLayout {
                Layout.alignment: Qt.AlignRight

                RoundButton {
                    visible: !root.readonly && !root.processing && root.pullrequest === ""

                    icon.name: "editor"
                    icon.source: "qrc:/icons/actions/editor.svg"

                    flat: true
                    highlighted: root.localUpdateScope && root.isError()

                    onClicked: root.editClicked(root)
                }

                Button {
                    visible: !root.processing && root.canPush
                    enabled: root.pipe && !root.pipe.processing

                    text: root.pipe && root.pipe.isError() && !root.pipe.localUpdateScope ? qsTr("Try to push again") : root.pipe && root.pipe.processing && !root.pipe.localUpdateScope ? qsTr("Pushing...") : qsTr("Push")

                    highlighted: root.pipe && root.pipe.isError() && !root.pipe.localUpdateScope

                    onClicked: root.push()
                }
            }

        }
    }
}
