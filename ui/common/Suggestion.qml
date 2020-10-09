import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12

import SortFilterProxyModel 0.2

Item {
    id: root

    implicitHeight: search.implicitHeight

    property string filterRoleName: "name"

    property int maxVisibleSuggestions: 3
    property alias placeholderSearch: search.placeholderText
    property alias loading: loadingIndicator.visible

    property bool nonPersistentSelection: false
    signal nonPersistentSelected(var selection)

    property var selected: null
    property string selectedText: ""
    property var suggestionToText: (suggestion) => suggestion[root.filterRoleName]

    property int defaultIndex: -1

    property bool showAdd: false
    signal add(var newValue)

    property var json: null
    property var array: null

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

        if (root.defaultIndex > -1 && root.defaultIndex < root.mainModel.count) {
            root.selected = root.mainModel.get(root.defaultIndex)
        }
    }

    // TODO: implement an ArrayModel
    onArrayChanged: {
        root.mainModel.clear()
        search.text = ""

        if (root.array === null) { return }

        for (const element of root.array) {
            root.mainModel.append({ "name": element })
        }

        if (root.defaultIndex > -1 && root.defaultIndex < root.mainModel.count) {
            root.selected = root.mainModel.get(root.defaultIndex).name
        }
    }

    onSelectedChanged: {
        search.inhibitOpenPopupOnTextChanged = true
        if (root.selected !== null) {
            search.text = json !== null ? root.suggestionToText(root.selected) : root.selected
            root.selectedText = search.text
        } else {
            search.text = ""
            root.selectedText = ""
        }
        search.inhibitOpenPopupOnTextChanged = false
    }

    TextField {
        id: search
        width: parent.width

        inputMethodHints: Qt.ImhNoPredictiveText

        rightPadding: add.width + clear.width

        property bool inhibitOpenPopupOnTextChanged: false

        onFocusChanged: {
            if(focus && !suggestionsPopup.opened) {
                suggestionsPopup.open()
            }
        }

        onTextChanged: {
            suggestions.currentIndex = -1
            if (!inhibitOpenPopupOnTextChanged) { suggestionsPopup.open() }
        }

        Keys.onPressed: {
            // Don't do anything if the popup is not opened !
            if (!suggestionsPopup.opened) { return }

            switch(event.key) {
            case Qt.Key_Escape:
                suggestionsPopup.close()
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
                    const selection = root.json !== null ? proxyModel.get(suggestions.currentIndex) : (proxyModel.get(suggestions.currentIndex)).name

                    if(root.nonPersistentSelection) {
                        root.nonPersistentSelected(selection)
                    } else {
                        root.selected = selection
                    }

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

            visible: root.showAdd && search.text !== "" && search.text !== root.selectedText
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

            visible: root.selected !== null

            flat: true

            anchors.right: add.left

            onClicked: {
                root.selected = null
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
                        const selection = root.json !== null ? proxyModel.get(index) : (proxyModel.get(index)).name

                        if(root.nonPersistentSelection) {
                            root.nonPersistentSelected(selection)
                        } else {
                            root.selected = selection
                        }

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
                if (search.text !== root.selectedText) {
                    search.inhibitOpenPopupOnTextChanged = true
                    search.text = root.selectedText
                    search.inhibitOpenPopupOnTextChanged = false
                }
            }
        }
    }
}
