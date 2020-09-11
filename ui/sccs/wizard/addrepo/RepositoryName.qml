import QtQuick 2.12
import QtQuick.Controls 2.12

import "../../../common/form"

Item {
    property var repository: null
    readonly property alias repositoryParams: repo.jsonAnswers
    readonly property alias repositoryParamsAcceptable: repo.acceptableForm

    implicitHeight: repo.implicitHeight

    DynamicForm {
        id: repo
        width: parent.width

        json: repository
    }
}
