import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12

import "../../backend/sccs"

Item {
    id: root

    implicitHeight: contents.implicitHeight
    implicitWidth: contents.implicitWidth

    property alias repositoryName: dataEnvs.repositoryName
    property string environment: ""

    WatchContinousDeploymentEnvironmentsAvailable {
        id: dataEnvs
    }

    ColumnLayout {
        id: contents
        anchors.fill: parent

        Label {
            Layout.fillWidth: true

            horizontalAlignment: Text.AlignHCenter

            text: root.repositoryName !== "" ? root.repositoryName : qsTr("Please select a repository")
        }

        ComboBox {
            id: environments
            Layout.fillWidth: true

            visible: root.repositoryName !== ""
            enabled: !dataEnvs.processing

            model: dataEnvs.dataResponse

            function itemToText(item) {
                return item.environment
            }

            delegate: ItemDelegate {
                width: parent ? parent.width : 0
                text: environments.itemToText(raw)
            }

            displayText: currentIndex === -1 ? "" : itemToText(model.get(currentIndex).raw)

            onCurrentIndexChanged: root.environment = currentIndex === -1 ? "" : itemToText(model.get(currentIndex).raw)
        }
    }
}
