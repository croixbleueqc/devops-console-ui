import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12

Item {
    id: root

    property var repository;
    property var envNameToDeploy;

    implicitHeight: contents.implicitHeight
    implicitWidth: contents.implicitWidth

    ColumnLayout {
        id: contents
        anchors.fill: parent
        spacing: 10

        Label {
            id: title
            Layout.alignment: Qt.AlignHCenter

            text: root.repository.name
            font.bold: true
        }

        Label {
            id: version
            Layout.alignment: Qt.AlignHCenter

            text: root.repository.version
        }

        Deploy {
            id: deploy
            Layout.alignment: Qt.AlignHCenter

            environment: root.envNameToDeploy

            version: root.repository.version
            repositoryName: root.repository.name
        }
    }
}

