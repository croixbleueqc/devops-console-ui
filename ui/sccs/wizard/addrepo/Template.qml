import QtQuick 2.12
import QtQuick.Layouts 1.12
import "../../../common"
import "../../../common/form"

Item {
    property string templateName: template.selected !== null ? template.selected : ""
    property alias templateParams: params.jsonAnswers
    property bool templateRequired: false

    readonly property bool templateAcceptable:
        (templateName === "" && !templateRequired) ||
        (templateName !== "" && params.acceptableForm)

    implicitHeight: template.implicitHeight + params.implicitHeight

    property var templates: null

    Suggestion {
        id: template

        array: Object.keys(templates)

        placeholderSearch: qsTr("Which template do you want to use ?")

        maxVisibleSuggestions: 4
        showAdd: false

        width: parent.width
    }

    DynamicForm {
        id: params
        anchors.top: template.bottom
        width: parent.width

        json: template.selected !== null ? templates[template.selected] : {}
    }
}
