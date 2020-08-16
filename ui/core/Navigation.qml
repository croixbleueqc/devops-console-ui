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

        ListView {
            Layout.fillWidth: true
            Layout.fillHeight: true

            model: routes

            delegate: ItemDelegate {
                text: modelData.name
                width: parent.width

                onClicked: {
                    if(router !== null) {
                        router.replace(modelData.page)
                    }
                    root.close()
                }
            }

            ScrollIndicator.vertical: ScrollIndicator {}
        }

        Rectangle {
            Layout.fillWidth: true
            implicitHeight: 1
            color: "black"
        }

        Text {
            padding: 10
            text: Store.user
        }
    }
}
