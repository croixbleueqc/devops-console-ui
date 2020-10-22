import QtQuick 2.12
import QtQuick.Controls 2.12

import "../../backend/core"


Item {
    id: root

    height: combobox.height

    property alias index: combobox.currentIndex

    ComboBox {
        id: combobox

        width: root.width
        model: Store.projects_project_settings.projectObj

        textRole: "name"

        editable: false
        flat: true
    }
}
