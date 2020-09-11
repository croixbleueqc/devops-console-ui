import QtQuick 2.12
import QtQuick.Controls 2.12

import "../../backend/sccs" as Backend
import "../common"

Item {
    id: root

    property alias environment: backend.environment
    property alias repositoryName: backend.repositoryName

    property var availables: []
    property string version: ""
    property bool readOnly: false

    height: main.height + 20 + Math.max((controls.visible ? controls.height : 0), (applying.visible ? applying.height : 0))

    Behavior on height {
        NumberAnimation { duration: 150 }
    }

    function updateCurrentIndex() {
        versions.currentIndex = versions.indexOfValue(version);
    }

    onVersionChanged: updateCurrentIndex()
    onAvailablesChanged: updateCurrentIndex()

    Backend.RepoTriggerContinuousDeployment {
        id: backend
        version: versions.currentIndex !== -1 ? versions.currentValue : ""

        onSuccess: {
            root.version = versions.currentValue
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
            PropertyChanges { target: versions; enabled: false}
        },
        State {
            name: "Validation"
            when: !backend.processing && versions.currentIndex !== versions.indexOfValue(version)
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
                text: environment

                width: parent.width

                horizontalAlignment: Text.AlignHCenter
            }

            ComboBox {
                id: versions
                width: parent.width

                enabled: !readOnly

                textRole: "display"
                valueRole: "version"

                model: availables

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
                    versions.currentIndex = versions.indexOfValue(version)
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
