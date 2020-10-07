import QtQuick 2.12
import QtQuick.Controls 2.12
import "../sccs"

Item {
    property alias repositoryName: cd.repositoryName

    ScrollView {
        anchors.fill: parent
        padding: 10

        contentHeight: cd.height

        clip: true

        RepoContinuousDeployment {
            id: cd

            width: Math.min(500, parent.width)
            x: (parent.width - width) / 2
        }
    }
}
