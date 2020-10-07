import QtQuick 2.12
import QtQuick.Controls 2.12

import "../../../common"

Item {
    id: root
    implicitWidth: contents.implicitWidth
    implicitHeight: contents.implicitHeight

    property var json: null

    Flow {
        id: contents
        width: parent.width
        spacing: 10

        Repeater {
            id: containerStatuses
            model: root.json ? root.json.containerStatuses : null

            Card {
                ContainerStatus {
                    json: modelData
                }
            }
        }

        Repeater {
            id: initContainerStatuses
            model: root.json ? root.json.initContainerStatuses : null

            Card {
                ContainerStatus {
                    json: modelData
                }
            }
        }
    }
}
