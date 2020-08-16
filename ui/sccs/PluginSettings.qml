import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12

import "../../backend/core"

Item {
    GroupBox {
        width: parent.width

        title: qsTr("Sccs plugin")

        ColumnLayout {
            anchors.fill: parent

            TextField {
                id: plugin

                placeholderText: qsTr("Plugin name")
                text: Store.sccs_plugin_settings.plugin

                Layout.fillWidth: true
            }

            TextArea {
                id: session

                placeholderText: qsTr("Session")
                text: Store.sccs_plugin_settings.session

                Layout.fillWidth: true
            }

            Button {
                text: qsTr("Save")

                Layout.alignment: Qt.AlignRight

                onClicked: {
                    Store.sccs_plugin_settings.saveSettings(
                                plugin.text,
                                session.text)
                }
            }
        }
    }
}
