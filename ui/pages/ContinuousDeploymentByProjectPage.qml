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
        padding: 10

        DeployProject {
            id: project
            x: width < scroll.width ? (scroll.width - width)/2 : 0

            projectIndex: search.index
        }
    }
}
