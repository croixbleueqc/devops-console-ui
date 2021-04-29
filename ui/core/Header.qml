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
    signal openApplicationMenu()
    signal openParametersPage()
    signal goBack()

    property alias showApplicationMenu: applicationMenu.visible
    property alias showUser: user.visible
    property alias isCanGoBack: back.visible
    property string mainTitle: Qt.application.displayName
    property string secondTitle:""

    readonly property WSCom com: WSComOne

    ToolBar {
        id: toolbar
        width: parent.width

        RowLayout {
            anchors.fill: parent

            ToolButton {
                id: applicationMenu
                icon.name: "application-menu"
                icon.source: "qrc:/icons/actions/application-menu.svg"

                onClicked: root.openApplicationMenu()
            }

            ToolButton {
                id: back
                icon.name: "go-previous"
                icon.source: "qrc:/icons/actions/go-previous.svg"

                onClicked: root.goBack()
            }

            Label {
                id: title
                text: {
                    if(root.secondTitle !== "") {
                        return `${root.mainTitle}<br><i>${root.secondTitle}</i>`
                    }

                    return root.mainTitle
                }
                rightPadding: 10

                visible: placeholderItem === null || toolbar.width > 550
            }

            Pane {
                id: placeholder

                topPadding: 0
                bottomPadding: 0
                leftPadding: 5
                rightPadding: 5

                background: Rectangle {
                    opacity: 0.2
                }

                contentItem: placeholderItem

                contentHeight: placeholderItem ? placeholderItem.height : 0.0

                Layout.fillWidth: true
            }

            ToolButton {
                id: status
                icon.name: com.status !== WebSocket.Open ? "network-disconnect" : "network-connect"
                icon.source: "qrc:/icons/actions/" + (com.status !== WebSocket.Open ? "network-disconnect" : "network-connect") + ".svg"

                onClicked: {
                    com.active = !com.active
                }
            }

            ToolButton {
                id: user
                icon.name: com.status !== WebSocket.Open ? "user-offline" : "user-online"
                icon.source: "qrc:/icons/status/" + (com.status !== WebSocket.Open ? "user-offline" : "user-online") + ".svg"

                onClicked: popupUser.open()

                Popup {
                    id: popupUser

                    focus: true

                    x: -implicitWidth + parent.width - 10
                    y: parent.height

                    User {
                        showLanguage: false
                        onSettingsClicked: {
                            popupUser.close()
                            root.openParametersPage()
                        }
                    }
                }
            }
        }
    }
}
