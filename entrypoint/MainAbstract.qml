import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.12

import "../ui/pages" as Pages
import "../backend/core"

Window {
    id: root
    visible: true
    width: 640
    height: 480
    title: qsTr("DevOps")

    property Component first: null

    StackView {
        id: main
        anchors.fill: parent

        initialItem: first

        Component.onCompleted: {
            Store.defaultRouter = main
        }
    }
}
