import QtQuick 2.12
import QtQuick.Controls 2.12

Item {
    id: root
    implicitWidth: name.implicitWidth
    implicitHeight: name.implicitHeight

    property var json: null

    Label {
        id: name
        width: parent.width
        height: parent.height

        text: root.json ? root.json.name : ""
    }
}
