import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12
import "../layouts"
import "../sccs"
import "../../backend/core"

CoreLayout {
    headerPlaceholderItem: Search { id: search }

    ScrollView {
        anchors.fill: parent
        padding: 10

        contentHeight: cd.height

        clip: true

        RepoContinuousDeployment {
            id: cd

            width: Math.min(500, parent.width)
            x: (parent.width - width) / 2

            repositoryName: search.currentText
        }
    }
}
