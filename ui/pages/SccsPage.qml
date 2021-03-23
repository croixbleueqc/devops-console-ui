import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12

import "../core"
import "../layouts"
import "../fragments"
import "../sccs"
import "../../backend/core"

CoreLayout {
    id: root
    headerPlaceholderItem: Search { id: search }

    readonly property alias repositoryName : search.currentText
    readonly property alias environment : repo_resume.environment

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 10

        Item {
            Layout.fillWidth: true
            Layout.fillHeight: true

            RepoResume {
                id: repo_resume
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
                width: Math.min(250, parent.width)

                repositoryName: root.repositoryName
            }
        }

        Flow {
            Layout.fillWidth: true

            Button {
                flat: true
                icon.name: "cloud-upload"
                icon.source: "qrc:/icons/actions/cloud-upload.svg"

                text: qsTr("Continuous Deployment")

                //enabled: root.repositoryName !== "" && root.environment !== ""

                onClicked: root.openPage(continousDeploymentComponent)
            }

            Button {
                flat: true
                icon.name: "folder-html"
                icon.source: "qrc:/icons/places/folder-html.svg"

                text: qsTr("Kubernetes")

                enabled: root.repositoryName !== "" && root.environment !== ""

                onClicked: root.openPage(kubernetesComponent)
            }
        }
    }

    Component {
        id: continousDeploymentComponent

        CoreLayout{
            headerSecondTitle: qsTr("Continuous Deployment")

            headerPlaceholderItem: HeaderPlaceholderLabel { text: root.repositoryName }

            ContinuousDeploymentFragment {
                anchors.fill: parent

                repositoryName: root.repositoryName
            }
        }
    }

    Component {
        id: kubernetesComponent

        CoreLayout {
            headerSecondTitle: qsTr("Kubernetes / Pods")

            headerPlaceholderItem: HeaderPlaceholderLabel { text: root.repositoryName }

            PodsFragment {
                anchors.fill: parent

                repositoryName: root.repositoryName
                environment: root.environment
            }
        }
    }
}
