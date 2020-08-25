import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12

import "../../backend/core"

Drawer {
    id: root
    width: Math.max(parent.width * 0.33, 300)
    height: parent.height

    property var routes: null
    property QtObject router: null

    ColumnLayout {
        anchors.fill: parent

        Rectangle {
            Layout.fillWidth: true
            height: title.height * 2
            color: "grey"

            Text {
                id: title
                text: qsTr("DevOps Console")
                padding: 10
                color: "white"
                font.bold: true
            }
        }

        ListView {
            Layout.fillWidth: true
            Layout.fillHeight: true

            model: routes

            delegate: ItemDelegate {
                text: modelData.name
                width: parent.width

                onClicked: {
                    root.close()
                    root.openPage(modelData.page)
                }
            }

            ScrollIndicator.vertical: ScrollIndicator {}

            boundsBehavior: Flickable.StopAtBounds
        }

        Rectangle {
            Layout.fillWidth: true
            implicitHeight: 1
            color: "grey"
        }

        User {
            showLanguage: false
            onSettingsClicked: {
                root.close()
                root.openParametersPage()
            }
        }
    }

    function openPage(page) {
        if(router !== null) {
            router.replace(page)
        }
    }

    function openParametersPage() {
        openPage("../pages/ParametersPage.qml")
    }
}
