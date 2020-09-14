import QtQuick 2.12
import QtQuick.Controls 2.12
import "../layouts"
import "../sccs"
import "../../backend/core"

CoreLayout {
    headerPlaceholderItem: SearchProject { id: search }

    ScrollView {
        id: scroll
        visible: search.index !== -1

        anchors.fill: parent
        anchors.margins: 10

        contentWidth: project.width
        contentHeight: project.height + 10

        clip: true

        DeployProjects {
            id: project

            x: (scroll.width - width)/2

            projectIndex: {

                if (Store.currentProject === undefined) {
                      Store.currentProject = Store.sccs_project_settings.projectObj.projects[search.index].environments;

                      for (var i = 0; i < Store.currentProject.length; i++) {
                        Store.currentProject[i].repositories = [];
                      }
                  }

                 return search.index
            }
        }
    }
}
