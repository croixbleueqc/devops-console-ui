import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12

import "../../../backend/core"
import "../../common"

Settings {
    id: root

    json: Store.projects_project_settings.project !== "" ? JSON.parse(Store.projects_project_settings.project) : []

    mainTitle: qsTr("Projects")

    showAdd: true

    altControlsItem: Row {
        ToolButton {
            icon.name: "dialog-ok"
            icon.source: "qrc:/icons/actions/dialog-ok.svg"

            enabled: edit.projectName !== ""

            onClicked: {
                const projectConfig = {
                    "name": edit.projectName,
                    "repositories": edit.repos,
                    "environments": edit.envs
                }

                if(edit.editIndex === -1) {
                    root.json.push(projectConfig)
                } else {
                    root.json[edit.editIndex] = projectConfig
                }

                root.jsonChanged()

                edit.editIndex = -1
                mainLayout.currentIndex = 0
            }
        }

        ToolButton {
            icon.name: "dialog-cancel"
            icon.source: "qrc:/icons/actions/dialog-cancel.svg"

            onClicked: {
                edit.editIndex = -1
                mainLayout.currentIndex = 0
            }
        }
    }

    mainSettingsItem: StackLayout {
        id: mainLayout

        ListView {
            model: root.json

            clip: true
            boundsBehavior: Flickable.StopAtBounds

            delegate: ItemDelegate {
                width: parent.width
                text: modelData.name

                onClicked: {
                    edit.projectName = modelData.name
                    edit.repos = modelData.repositories
                    edit.envs = modelData.environments
                    edit.editIndex = index
                    edit.showMainView()
                    mainLayout.currentIndex = 1
                }

                rightPadding: controls.width

                RoundButton {
                    id: controls
                    anchors.right: parent.right

                    flat: true

                    icon.name: "delete"
                    icon.source: "qrc:/icons/actions/delete.svg"
                    icon.color: "transparent"

                    onClicked: {
                        root.json.splice(index, 1)
                        root.jsonChanged()
                    }
                }
            }
        }

        Project {
            id: edit

            property int editIndex: -1
        }

        onCurrentIndexChanged: root.showAlt = currentIndex !== 0
    }

    onAddClicked: {
        edit.projectName = ""
        edit.repos = []
        edit.envs = []
        edit.showMainView()
        mainLayout.currentIndex = 1
    }

    onSaveClicked: {
        Store.projects_project_settings.saveSettings(JSON.stringify(root.json))
    }
}
