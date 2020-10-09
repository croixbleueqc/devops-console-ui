import QtQuick 2.12
import QtQuick.Controls 2.12

import "../../backend/sccs" as Backend

import "../common"

Item {
    id: root

    height: suggestions.height

    property string currentText: suggestions.selected !== null ? suggestions.selected.name : ""
    property string proposedRepositoryName: ""
    property alias placeholderSearch: suggestions.placeholderSearch
    property bool showAdd: true
    property alias nonPersistentSelection: suggestions.nonPersistentSelection
    signal nonPersistentSelected(var selection)

    Backend.Repositories {
        id: repos
    }

    Suggestion {
        id: suggestions

        width: root.width

        filterRoleName: "name"
        maxVisibleSuggestions: 4
        showAdd: root.showAdd

        json: repos.dataResponse

        loading: repos.processing

        onAdd: {
            root.proposedRepositoryName = newValue
            loadRepoAddWizard.active = true
        }

        onNonPersistentSelected: root.nonPersistentSelected(selection)
    }

    Component {
        id: repoAddWizard

        Popup {
            anchors.centerIn: Overlay.overlay
            modal: true

            contentHeight : Math.min(600, Math.max(300, add.implicitHeight))
            contentWidth: 500

            closePolicy: add.processing ? Popup.NoAutoClose : Popup.CloseOnPressOutside

            RepoAddWizard {
                id: add
                anchors.fill: parent

                repositoryName: root.proposedRepositoryName
            }

            onOpenedChanged: {
                if(!opened) {
                    loadRepoAddWizard.active = false
                }
            }

            Component.onCompleted: open()
        }
    }

    Loader {
        id: loadRepoAddWizard
        active: false
        sourceComponent: repoAddWizard
    }
}
