import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12

import "../../backend/core"

Item {
    ScrollView {
        id: view
        anchors.fill: parent

        GroupBox {
            anchors.fill: parent

            title: qsTr("Project")

            ColumnLayout {
                anchors.fill: parent

                TextArea {
                    id: project

                    placeholderText: qsTr("Configuration")
                    text: Store.sccs_project_settings.project

                    Layout.fillWidth: true
                }

                Button {
                    text: qsTr("Save")

                    Layout.alignment: Qt.AlignRight

                    onClicked: {
                        Store.sccs_project_settings.saveSettings(project.text)
                    }
                }
            }
        }
    }
}
