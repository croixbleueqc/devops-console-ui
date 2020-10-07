import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12

import QtQuick.Controls.Material 2.12

import "../../backend/core"

Drawer {
    id: root
    width: Math.max(parent.width * 0.33, 300)
    height: parent.height

    property var routes: null
    property QtObject router: null

    readonly property bool isRemainingPages: router === null ? false : router.depth > 1

    ColumnLayout {
        anchors.fill: parent

        ToolBar {
            Layout.fillWidth: true

            RowLayout {
                anchors.fill: parent

                Label {
                    Layout.fillWidth: true
                    leftPadding: 10

                    text: qsTr("DevOps Console")
                }

                ToolButton {
                    icon.name: "go-home"
                    icon.source: "qrc:/icons/actions/go-home.svg"

                    onClicked: openWelcomePage()
                }

                ToolButton {
                    icon.name: "go-previous"
                    icon.source: "qrc:/icons/actions/go-previous.svg"

                    onClicked: root.close()
                }
            }
        }

        ListView {
            Layout.fillWidth: true
            Layout.fillHeight: true

            model: routes

            clip: true

            delegate: ItemDelegate {
                text: modelData.name
                width: parent.width

                icon.name: modelData.icon ? modelData.icon.name : ""
                icon.source: modelData.icon ? modelData.icon.source : ""

                onClicked: root.openPage(modelData.page, true)
            }

            ScrollIndicator.vertical: ScrollIndicator {}

            boundsBehavior: Flickable.StopAtBounds
        }

        ToolBar {
            Layout.fillWidth: true

            Material.primary: Material.accent

            User {
                anchors.fill: parent

                showLanguage: false
                onSettingsClicked: root.openParametersPage()
            }
        }
    }

    function openPage(page, main=false) {
        if(router === null) {
            return
        }

        if(root.opened) {
            root.close()
        }

        if(main) {
            if(root.isRemainingPages) {
                router.pop(null)
            }
            router.replace(page)
        } else {
            router.push(page)
        }
    }

    function openParametersPage(main=false) {
        openPage("../pages/ParametersPage.qml", main)
    }

    function openWelcomePage() {
        openPage("../pages/WelcomePage.qml", true)
    }

    function goBack() {
        if(router !== null) {
            router.pop()
        }
    }
}
