import QtQuick 2.12
import QtQuick.Controls 2.12
import "../layouts"
import "../sccs"
import "../../backend/core"

CoreLayout {
    headerPlaceholderItem: SearchProject { id: search }

    ScrollView {
        id: scroll

        anchors.fill: parent
        anchors.margins: 10

        contentWidth: project.width
        contentHeight: project.height + 10

        //ScrollBar.vertical.policy: ScrollBar.AlwaysOn

        clip: true

        DeployProjects {
            id: project

            x: (scroll.width - width)/2

            projectIndex: search.index
        }
    }
}
