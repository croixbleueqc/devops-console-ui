import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12

import "../../sccs"

Item {
    id:root
    property alias projectName: name.text
    property var repos: null
    property var envs: null

    function showMainView() {
        bar.currentIndex = 0
    }

    ColumnLayout {
        id: contents
        anchors.fill: parent

        TextField {
            id: name
            Layout.fillWidth: true

            placeholderText: qsTr("Project's name")
        }

        StackLayout {
            currentIndex: bar.currentIndex

            ColumnLayout {
                Search {
                    id: search
                    Layout.fillWidth: true

                    placeholderSearch: qsTr("Add a repository...")

                    showAdd: false
                    nonPersistentSelection: true

                    onNonPersistentSelected: {
                        if (root.repos.indexOf(selection.name) === -1) {
                            checkEnvs.repositoryName = selection.name
                            checkEnvs.open()
                        }
                    }

                    CheckingEnvironments {
                        id: checkEnvs
                        modal: true

                        width: parent.width

                        envsExpected: root.envs

                        onCompatible: {
                            if(root.repos.length === 0){
                                for(const env of checkEnvs.envs) {
                                    root.envs.push({ "name": env.environment, "enabled": true })
                                }
                                root.envsChanged()
                            }
                            root.repos.push(repositoryName)
                            root.reposChanged()
                        }
                    }
                }

                ListView {
                    id: repositories
                    Layout.fillWidth: true
                    Layout.fillHeight: true

                    clip: true
                    boundsBehavior: Flickable.StopAtBounds

                    model: root.repos

                    delegate: ItemDelegate {
                        text: modelData

                        width: parent.width

                        rightPadding: controls.width

                        RoundButton {
                            id: controls
                            anchors.right: parent.right

                            flat: true

                            icon.name: "delete"
                            icon.source: "qrc:/icons/actions/delete.svg"
                            icon.color: "transparent"

                            onClicked: {
                                root.repos.splice(index, 1)
                                if(root.repos.length === 0){
                                    root.envs = []
                                }
                                root.reposChanged()
                            }
                        }
                    }
                }
            }

            ListView {
                id: environments

                clip: true
                boundsBehavior: Flickable.StopAtBounds

                model: root.envs

                delegate: SwitchDelegate {
                    checked: root.envs[index].enabled
                    text: modelData.name

                    width: parent.width

                    onCheckedChanged: {
                        root.envs[index].enabled = checked
                    }
                }
            }
        }

        TabBar {
            id: bar
            Layout.fillWidth: true

            TabButton {
                text: qsTr("Repositories")
            }

            TabButton {
                text: qsTr("Environments")
            }
        }
    }
}
