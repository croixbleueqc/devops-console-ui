import QtQuick 2.12
import QtQuick.Controls 2.12
import "../sccs"
import "../projects"

Item {
    id: root
    property alias repositoryName: cd.repositoryName

    ScrollView {
        anchors.fill: parent
        padding: 10

        contentHeight: cd.implicitHeight

        clip: true

        WorkflowRepository {
            id: cd

            width: root.width
            envPerRow: root.width / repositoryWidth
            mode: "independent"
        }
    }
}
