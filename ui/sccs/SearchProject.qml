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
        model: Store.sccs_project_settings.projectObj.projects

        textRole: "name"

        editable: true

        onAccepted: {
            if (find(editText) === -1) {
                console.log("nothing to do")
            }
        }
    }
}
