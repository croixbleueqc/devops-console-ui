import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12

import "../../backend/core"
import "../common"

Settings {
    mainTitle: qsTr("Sccs plugin")

    showAdd: false

    mainSettingsItem: ColumnLayout {
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

            selectByMouse: true
            Layout.fillWidth: true
        }
    }

    onSaveClicked: {
        Store.sccs_plugin_settings.saveSettings(
                    plugin.text,
                    session.text)
    }

}
