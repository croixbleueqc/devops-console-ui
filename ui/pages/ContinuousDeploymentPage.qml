import QtQuick 2.12
import QtQuick.Controls 2.12
import "../layouts"
import "../sccs"
import "../fragments"

CoreLayout {
    headerPlaceholderItem: Search { id: search }

    ContinuousDeploymentFragment {
        anchors.fill: parent
        repositoryName: search.currentText
    }
}
