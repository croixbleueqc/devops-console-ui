import QtQuick 2.12
import QtQuick.Controls 2.12
import "../layouts"
import "../projects"
import "../../backend/core"

CoreLayout {
    headerPlaceholderItem: Search { id: search }

    Workflow {
        id: workflow
        anchors.fill: parent

        project: search.index !== -1 ? Store.projects_project_settings.projectObj[search.index] : null
    }
}
