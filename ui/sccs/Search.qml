import QtQuick 2.12
import QtQuick.Controls 2.12

import "../../backend/sccs" as Backend

//import "../../backend/core"

Item {
    id: root

    height: combobox.height

    property alias currentText: combobox.currentText

    Backend.Repositories {
        id: repos
    }

//    StoreUse {
//        id: repositories
//        module: "repos"

//        // Component.onCompleted: item.send()
//    }

    ComboBox {
        id: combobox

        width: root.width
        model: repos.dataResponse
//        model: repositories.item === null ? null : repositories.item.dataResponse

        textRole: "name"

        editable: true

        onAccepted: {
            if (find(editText) === -1) {
                console.log("nothing to do")
            }
        }
    }
}
