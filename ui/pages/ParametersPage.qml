import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12
import "../layouts"

import "../sccs"
import "../projects/settings"

CoreLayout {
    headerSecondTitle: qsTr("Settings")

    ScrollView {
        id: scroll
        anchors.fill: parent
        padding: 10

        Flow {
            width: scroll.width - scroll.padding * 2
            spacing: 10

            PluginSettings {
                id: pluginSettings
                width: Math.min(parent.width, 600)
            }

            ProjectsSettings {
                height: 500
                width: Math.min(parent.width, 500)
            }
        }
    }
}
