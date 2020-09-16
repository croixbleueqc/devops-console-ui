import QtQuick 2.12
import "../layouts"

import "../sccs"
import "../projects"

CoreLayout {

    PluginSettings {
        id: pluginSettings
        height: parent.height;
        width: parent.width * 0.5;

        anchors.left: parent.left;
        anchors.margins: 10;
    }

    ProjectSettings {
        height: parent.height;
        width: parent.width * 0.5;

        anchors.left: pluginSettings.right;
        anchors.margins: 10;
    }
}
