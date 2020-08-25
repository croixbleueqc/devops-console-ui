import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12

import SortFilterProxyModel 0.2

Item {
    id: root

    height: search.height

    property string filterRoleName: ""

    property int maxVisibleSuggestions: 3
    property alias placeholderSearch: search.placeholderText
    property alias loading: loadingIndicator.visible

    property var selected: null
    property var suggestionToText: (suggestion) => suggestion.lastName + " (" + suggestion.firstName + ")"

    property bool showAdd: false
    signal add(var newValue)

    property var json: null

    property QtObject mainModel: ListModel {}

    readonly property QtObject proxyModel: SortFilterProxyModel {
        sourceModel: root.mainModel
        filters: RegExpFilter {
            roleName: root.filterRoleName
            pattern: search.text
            caseSensitivity: Qt.CaseInsensitive
            enabled: root.filterRoleName !== ""
        }
        sorters: StringSorter {
            roleName: root.filterRoleName
            enabled: root.filterRoleName !== ""
        }
    }

    // TODO: implement a JsonListModel (as done in https://felgo.com/doc/felgo-jsonlistmodel/)
    onJsonChanged: {
        root.mainModel.clear()
        search.text = ""

        if (root.json === null) { return }

        for(const element of root.json) {
            root.mainModel.append(element)
        }
    }

    TextField {
        id: search
        focus: true
        width: parent.width
        //height: Math.max(contentHeight, add.height)

        rightPadding: add.width + clear.width

        property bool inhibitOnTextChanged: false

        onTextChanged: {
            if (inhibitOnTextChanged) { return }

            suggestions.currentIndex = -1
            suggestionsPopup.open()
            if (selected !== null) { selected = null }
        }

        Keys.onPressed: {
            // Don't do anything if the popup is not opened !
            if (!suggestionsPopup.opened) { return }

            switch(event.key) {
            case Qt.Key_Escape:
                if (text === "") {
                    suggestionsPopup.close()
                } else {
                    text = ""
                }
                event.accepted = true
                break
            case Qt.Key_Down:
                if (suggestions.count !== 0) {
                    suggestions.currentIndex = (suggestions.currentIndex + 1) % suggestions.count
                    event.accepted = true
                }
                break
            case Qt.Key_Up:
                if (suggestions.count !== 0) {
                    if (suggestions.currentIndex === 0) {
                        suggestions.currentIndex = suggestions.count - 1
                    } else {
                        suggestions.currentIndex--
                    }
                    event.accepted = true
                }
                break
            case Qt.Key_Return:
                if (suggestions.currentIndex !== -1) {
                    root.selected = proxyModel.get(suggestions.currentIndex)
                    suggestionsPopup.close()
                    event.accepted = true
                }
                break
            }
        }

        ToolButton {
            id: add
            icon.name: "list-add"
            icon.source: "qrc:/icons/actions/list-add.svg"
            y: -5

            visible: root.showAdd && search.text !== "" && root.selected === null
            width: visible ? implicitWidth : 0

            flat: true

            anchors.right: search.right

            onClicked: {
                const toAdd = search.text
                suggestionsPopup.close()
                root.add(toAdd)
            }
        }

        ToolButton {
            id: clear
            icon.name: "edit-clear"
            icon.source: "qrc:/icons/actions/edit-clear.svg"
            y: -5

            visible: search.text !== ""

            flat: true

            anchors.right: add.left

            onClicked: {
                search.text = ""
                search.focus = true
            }
        }

        BusyIndicator {
            id: loadingIndicator
            visible: false
            running: visible

            height: 36
            width: 36

            anchors.right: search.right
        }

        Popup {
            id: suggestionsPopup

            width: parent.width

            // TODO: contentHeight doesn't change the effective height inside a ToolBar{}. Seems to be a bug as it is working in an Application{}
            //  contentHeight: nothing.visible ? nothing.height : suggestions.height
            height: (nothing.visible ? nothing.height : suggestions.height) + bottomPadding + topPadding
            y: parent.height

            closePolicy: Popup.CloseOnPressOutsideParent

            ListView {
                id: suggestions
                model: root.proxyModel
                delegate: ItemDelegate {
                    text: root.suggestionToText(model)
                    width: parent !== null ? parent.width : 0

                    highlighted: suggestions.currentIndex === index

                    onClicked: {
                        root.selected = root.proxyModel.get(index)
                        suggestionsPopup.close()
                    }
                }

                width: parent.width
                height: count > root.maxVisibleSuggestions ? contentHeight / count * root.maxVisibleSuggestions : contentHeight
                clip: true

                boundsBehavior: Flickable.StopAtBounds
            }

            Text {
                id: nothing
                text: qsTr("No suggestion available !")
                visible: suggestions.count === 0

                width: parent.width
            }

            onOpenedChanged:{
                if (opened) { return }

                // from open to close
                search.inhibitOnTextChanged = true
                if (root.selected !== null) {
                    search.text = root.suggestionToText(root.selected)
                } else {
                    search.text = ""
                }
                search.inhibitOnTextChanged = false
            }
        }
    }
}
