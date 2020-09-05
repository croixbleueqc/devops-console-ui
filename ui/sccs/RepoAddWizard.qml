import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12

import "./wizard/addrepo" as Wizard
import "../../backend/sccs"

Item {
    id: root
    property string repositoryName: ""
    readonly property bool processing: stepAdding.state === "Adding"

    implicitHeight: title.implicitHeight + view.implicitHeight + indicator.implicitHeight

    RepoAddContract {
        id: data_contract
    }

    property alias wizard: data_contract.dataResponse

    RowLayout {
        id: title
        width: parent.width

        Label {
            text: qsTr("Add a new repository")

            padding: 10

            Layout.fillWidth: true
        }

        ToolButton {
            icon.name: "go-previous"
            icon.source: "qrc:/icons/actions/go-previous.svg"

            visible: (view.currentIndex > 0 && view.currentIndex < 2) ||
                     (view.currentIndex === 2 && stepAdding.state == "")

            onClicked: view.decrementCurrentIndex()
        }

        ToolButton {
            icon.name: enabled ? "go-next" : "errornext"
            icon.source: enabled ? "qrc:/icons/actions/go-next.svg" : "qrc:/icons/actions/errornext.svg"

            enabled: view.interactive
            visible: view.currentIndex < view.count - 1

            onClicked: view.incrementCurrentIndex()
        }
    }

    SwipeView {
        id: view

        anchors.top: title.bottom
        width: parent.width
        height: parent.height - indicator.implicitHeight - title.implicitHeight

        clip: true

        interactive:
            (currentIndex === 0 && stepRepoName.repositoryParamsAcceptable) ||
            (currentIndex === 1 && stepTemplate.templateAcceptable) ||
            (currentIndex === 2 && stepAdding.state == "")

        Wizard.RepositoryName {
            id: stepRepoName

            repository: Object.assign(
                {
                    "name": {
                        "type": "string",
                        "description": "Repository",
                        "required": true,
                        "default": repositoryName,
                        "validator": wizard ? wizard.main.repository_validator : ""
                    }
                },
                wizard ? wizard.repository : {}
            )
        }

        Wizard.Template {
            id: stepTemplate

            templates: wizard ? wizard.templates : {}
            templateRequired: wizard ? wizard.main.template_required : false
        }

        Wizard.Adding {
            id: stepAdding

            repositoryParams: stepRepoName.repositoryParams
            template: stepTemplate.templateName
            templateParams: stepTemplate.templateParams
        }
    }

    PageIndicator {
        id: indicator

        count: view.count
        currentIndex: view.currentIndex

        anchors.top: view.bottom
        anchors.horizontalCenter: parent.horizontalCenter
    }
}
