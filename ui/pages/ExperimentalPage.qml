import QtQuick 2.12
import QtQuick.Controls 2.12
import "../layouts"
import "../sccs"

import "../../backend/core"

CoreLayout {
    Column {
        anchors.fill: parent

        Search { id: search; width:parent.width }
        Search { id: search2; width:parent.width }

    }

//    property var repositories: repos2.item === null ? null : repos2.item.dataResponse

    StoreUse {
        id: repos
        module: "repos"

        Component.onCompleted: {
            //item.send()
        }
    }

//    StoreUse {
//        id: repos2
//        module: "repos"
//    }

//    onRepositoriesChanged: {
//        console.log("exp: repo: " + JSON.stringify(repositories))
//    }
}
