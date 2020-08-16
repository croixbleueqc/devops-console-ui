import QtQuick 2.12
import "../layouts"
import "../../backend/core"

CoreLayout {
    Text {
        id: welcome
        anchors.centerIn: parent

        text: qsTr("Welcome %1 !").arg(Store.user)
     }
}
