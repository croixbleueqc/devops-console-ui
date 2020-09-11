import QtQuick 2.12
import QtQuick.Controls 2.12
import "../layouts"
import "../sccs"

import "../../backend/core"

CoreLayout {

    Popup {
        id: wizard
        anchors.centerIn: Overlay.overlay
        modal: true

        contentHeight : Math.min(600, Math.max(300, add.implicitHeight))
        contentWidth: 500

        closePolicy: add.processing ? Popup.NoAutoClose : Popup.CloseOnPressOutside

        RepoAddWizard {
            id: add
            anchors.fill: parent

            repositoryName: "bitbucket-management-storage"
        }

    }

    Component.onCompleted: {
        wizard.open()
    }
}
