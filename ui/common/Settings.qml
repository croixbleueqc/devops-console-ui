import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls.Material 2.12

Item {
    id: root

    implicitWidth: contents.implicitWidth
    implicitHeight: contents.implicitHeight

    property var json: null
    property alias mainTitle: title.text

    property Item mainSettingsItem: null
    property Item altControlsItem: null
    property bool showAlt: false

    property bool showAdd: false
    property bool showRaw: true

    property var validateRawValue: (value) => true

    signal saveClicked()
    signal addClicked()

    states: [
        State {
            name: "main"
            when: settingsLayout.currentIndex === 0 && !root.showAlt
            PropertyChanges { target: mainControls; visible: true }
            PropertyChanges { target: altControls; visible: false }
            PropertyChanges { target: rawControls; visible: false }
        },
        State {
            name: "main-alt"
            when: settingsLayout.currentIndex === 0 && root.showAlt
            PropertyChanges { target: mainControls; visible: false }
            PropertyChanges { target: altControls; visible: true }
            PropertyChanges { target: rawControls; visible: false }
        },
        State {
            name: "raw"
            when: settingsLayout.currentIndex === 1
            PropertyChanges { target: mainControls; visible: false }
            PropertyChanges { target: altControls; visible: false }
            PropertyChanges { target: rawControls; visible: true }
        }
    ]

    Card {
        id: contents

        anchors.fill: parent
        padding: 0

        implicitHeight: settingsHeader.implicitHeight + settingsLayout.implicitHeight + settingsLayout.anchors.margins*2
        implicitWidth: Math.max(settingsHeader.implicitWidth, settingsLayout.implicitWidth + settingsLayout.anchors.margins*2)

        ToolBar {
            id: settingsHeader

            width: parent.width

            Material.primary: Material.accent
            Material.elevation: 0

            RowLayout {
                anchors.fill: parent

                Label {
                    id: title
                    Layout.fillWidth: true
                    leftPadding: 10
                }

                Row {
                    id: mainControls
                    ToolButton {
                        visible: root.showAdd

                        icon.name: "list-add"
                        icon.source: "qrc:/icons/actions/list-add.svg"

                        onClicked: root.addClicked()
                    }

                    ToolButton {
                        visible: root.showRaw

                        icon.name: "code-context"
                        icon.source: "qrc:/icons/actions/code-context.svg"

                        onClicked: {
                            rawText.text = JSON.stringify(root.json, null, 4)
                            settingsLayout.currentIndex = 1
                        }
                    }

                    ToolButton {
                        icon.name: "document-save"
                        icon.source: "qrc:/icons/actions/document-save.svg"
                        onClicked: root.saveClicked()
                    }
                }

                Row {
                    id: rawControls
                    ToolButton {
                        icon.name: "dialog-ok"
                        icon.source: "qrc:/icons/actions/dialog-ok.svg"

                        onClicked: {
                            const newJsonValue = JSON.parse(rawText.text)
                            if(root.validateRawValue(newJsonValue)) {
                                root.json = newJsonValue
                                settingsLayout.currentIndex = 0
                            }
                        }
                    }

                    ToolButton {
                        icon.name: "dialog-cancel"
                        icon.source: "qrc:/icons/actions/dialog-cancel.svg"

                        onClicked: settingsLayout.currentIndex = 0
                    }
                }

                Pane {
                    id: altControls

                    padding: 0
                    background: null

                    contentItem: root.altControlsItem
                }
            }
        }


        StackLayout {
            id: settingsLayout

            anchors.top: settingsHeader.bottom
            anchors.bottom: parent.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.margins: 5

            implicitHeight: currentIndex === 0 ? mainSettingsPlaceholder.implicitHeight : scrollRawText.implicitHeight
            implicitWidth: currentIndex === 0 ? mainSettingsPlaceholder.implicitWidth : scrollRawText.implicitWidth

            Pane {
                id: mainSettingsPlaceholder
                padding: 0
                contentItem: root.mainSettingsItem
            }

            ScrollView {
                id: scrollRawText
                TextArea {
                    id: rawText
                }
            }
        }
    }
}
