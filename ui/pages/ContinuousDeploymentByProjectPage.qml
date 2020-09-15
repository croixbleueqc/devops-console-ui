import QtQuick 2.12
import QtQuick.Controls 2.12
import "../layouts"
import "../projects"
import "../../backend/core"

CoreLayout {
    headerPlaceholderItem: Search { id: search }

    ScrollView {
        id: scroll
        visible: search.index !== -1

        anchors.fill: parent
        anchors.margins: 10

        contentWidth: project.width
        contentHeight: project.height + 10

        clip: true

        DeployProject {
            id: project
            x: (scroll.width - width)/2
            projectIndex: search.index
        }
    }
}
