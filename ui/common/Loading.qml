import QtQuick 2.12
import QtQuick.Controls 2.12

Item {
    id: root

    property alias message: msg.text
    property bool inline: true
    property int busySize: 32

    implicitHeight: inline ? Math.max(indicator.height, msg.implicitHeight) : indicator.height + msg.implicitHeight
    implicitWidth: inline ? indicator.width + msg.implicitWidth : Math.max(indicator.width, msg.implicitWidth)

    states: [
        State {
            name: "horizontal"
            when: root.inline

            AnchorChanges {
                target: msg
                anchors.left: indicator.right
                anchors.verticalCenter: indicator.verticalCenter
            }
        },
        State {
            name: "vertical"
            when: !root.inline

            AnchorChanges {
                target: indicator
                anchors.horizontalCenter: msg.horizontalCenter
            }

            AnchorChanges {
                target: msg
                anchors.top: indicator.bottom
            }
        }
    ]

    BusyIndicator {
        id: indicator

        running: root.visible

        width: root.busySize
        height: root.busySize
    }

    Label {
        id: msg

        text: qsTr("Loading...")
    }
}
