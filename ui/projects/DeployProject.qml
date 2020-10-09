import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12

import "../../backend/core"

Item {
    id: root

    property alias projectIndex: data.projectIndex
    property int environmentWidth: 400

    implicitHeight: processing.running ? processing.height : contents.implicitHeight
    implicitWidth: processing.running ? processing.width : contents.implicitWidth

    FetchRepositories {
        id: data
    }

    BusyIndicator {
        id: processing
        visible: Store.processing
        running: visible

        width: 48
        height: 48

        anchors.horizontalCenter: parent.horizontalCenter;
    }


    RowLayout {
        id: contents

        visible: !Store.processing

        spacing: 10

        Repeater {
            model: Store.currentProject.length

            DeployByEnvironment {
                width: root.environmentWidth
                environment: Store.currentProject[index]
                nextEnvironment: Store.currentProject[index+1]
            }
        }
    }

}

