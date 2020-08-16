import QtQuick 2.12
import QtQuick.Controls 2.12

import "../../backend/sccs" as Backend
import "../common"

Item {
    id: root

    property alias branchName: backend.branchName
    property alias repositoryName: backend.repositoryName

    property var commitsAvailable: []
    property string commit: ""
    property bool readOnly: false

    height: main.height + 20 + Math.max((controls.visible ? controls.height : 0), (applying.visible ? applying.height : 0))

    Behavior on height {
        NumberAnimation { duration: 150 }
    }

    function updateCurrentIndex() {
        commits.currentIndex = commits.indexOfValue(commit);
    }

    onCommitChanged: updateCurrentIndex()
    onCommitsAvailableChanged: updateCurrentIndex()

    Backend.RepositoryDeployUpdate {
        id: backend
        commit: commits.currentIndex !== -1 ? commits.currentValue : ""

        onSuccess: {
            root.commit = commits.currentValue
        }

        onErrorChanged: {
            if(isError()) {
                console.log("An error occured: " + error)
            }
        }
    }

    states: [
        State {
            name: "Deploying"
            when: backend.processing
            PropertyChanges { target: controls; opacity: 0.0}
            PropertyChanges { target: applying; opacity: 1.0}
            PropertyChanges { target: commits; enabled: false}
        },
        State {
            name: "Validation"
            when: !backend.processing && commits.currentIndex !== commits.indexOfValue(commit)
            PropertyChanges { target: controls; opacity: 1.0 }
            PropertyChanges { target: applying; opacity: 0.0}
        },
        State {
            name: ""
            PropertyChanges { target: controls; opacity: 0.0}
            PropertyChanges { target: applying; opacity: 0.0}
        }

    ]

    Card {
        anchors.fill: parent

        Column {
            id: main

            spacing: 10
            anchors.right: parent.right
            anchors.left: parent.left

            Text {
                id: branch
                text: branchName

                width: parent.width

                horizontalAlignment: Text.AlignHCenter
            }

            ComboBox {
                id: commits
                width: parent.width

                enabled: !readOnly

                textRole: "display"
                valueRole: "commit"

                model: commitsAvailable

                Component.onCompleted: {
                    updateCurrentIndex();
                }
            }
        }

        Row {
            id: controls

            spacing: 10
            anchors.top: main.bottom
            anchors.horizontalCenter: parent.horizontalCenter

            visible: opacity !== 0.0
            opacity: 0.0

            Button {
                id: cancel
                text: qsTr("Cancel")

                onClicked: {
                    commits.currentIndex = commits.indexOfValue(commit)
                }
            }

            Button {
                id: apply
                text: backend.isError() ? qsTr("Try again") : qsTr("Deploy")

                onClicked: backend.send()

                highlighted: backend.isError()
            }


            Behavior on opacity {
                NumberAnimation {
                    duration: 150
                    easing.type: Easing.InOutQuad
                }
            }
        }

        BusyIndicator {
            id: applying
            running: visible
            visible: opacity !== 0.0
            opacity: 0.0
            width: 32
            height: 32

            anchors.top: main.bottom
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottom: controls.bottom

            Behavior on opacity {
                NumberAnimation {
                    duration: 150
                    easing.type: Easing.InOutQuad
                }
            }
        }
    }
}
