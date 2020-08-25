import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12

import "../../backend/core"

ColumnLayout {
    spacing: 10

    property alias showLanguage: selectLanguage.visible
    signal settingsClicked()

    RowLayout {
        Text {
            padding: 10
            text: Store.user

            Layout.fillWidth: true
        }

        ToolButton {
            icon.name: "settings-configure"
            icon.source: "qrc:/icons/actions/settings-configure.svg"

            onClicked: settingsClicked()
        }
    }

    ComboBox {
        id: selectLanguage
        Layout.fillWidth: true

        model: Store.languagesSupported
    }
}
