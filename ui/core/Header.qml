import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12
import QtWebSockets 1.15

import "../../backend/core"

Item {
    id: root
    height: toolbar.height
    width: parent.width

    property Item placeholderItem: null
    signal sidePopupToggle()

    readonly property WSCom com: WSComOne

    ToolBar {
        id: toolbar
        width: parent.width

        RowLayout {
            anchors.fill: parent
            spacing: 10

            ToolButton {
                id: sideControl
                icon.name: "application-menu"
                icon.source: "qrc:/icons/actions/application-menu.svg"

                onClicked: sidePopupToggle()
            }

            Label {
                id: title
                text: qsTr("DevOps Console")
            }

            Pane {
                id: placeholder

                topPadding: 0
                bottomPadding: 0
                leftPadding: 5
                rightPadding: 5

                Layout.margins: 5

                contentItem: placeholderItem

                contentHeight: placeholderItem ? placeholderItem.height : 0.0

                Layout.fillWidth: true
            }

            ToolButton {
                id: status
                text: com.status !== WebSocket.Open ? qsTr("offline") : qsTr("online")

                onClicked: {
                    com.active = !com.active
                }

                Layout.margins: 5
            }
        }
    }
}
