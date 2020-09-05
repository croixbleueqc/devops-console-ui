import QtQuick 2.12
import QtQuick.Controls 2.12
import Qt.labs.qmlmodels 1.0

import "../"

Item {
    id: root

    implicitHeight: contents.implicitHeight

    property var json: ({})

    onJsonChanged: {
        internal.reset()
    }

    QtObject {
        id: internal
        property var fieldsStatus: ({})
        property bool acceptableForm: false
        property var jsonAnswers: ({})

        function reset(){
            internal.fieldsStatus = {}
            internal.acceptableForm = Object.keys(root.json).length === 0
            internal.jsonAnswers = {}
        }

        function updateAcceptableForm() {
            // Check parameters validity based on form settings

            for(const field of Object.entries(json)) {
                const key = field[0]
                const config = field[1]

                const required = config["required"] !== undefined ? config["required"] : false
                const state = internal.fieldsStatus[key]

                if(state === undefined) {
                    if(required) {
                        internal.acceptableForm = false
                        return
                    }
                } else {
                    if(state === false) {
                        internal.acceptableForm = false
                        return
                    }
                }
            }

            internal.acceptableForm = true
        }

        function updateFieldStatus(key, value, acceptableInput, required) {
            const previousStatus = internal.fieldsStatus[key]

            if(previousStatus !== undefined && !required && value === "") {
                // No more value to validate. Removes it as it is not a required field
                delete internal.fieldsStatus[key]
                internal.fieldsStatusChanged()

                delete internal.jsonAnswers[key]
                internal.jsonAnswersChanged()

                if(!internal.acceptableForm && !previousStatus) {
                    // the global status is now maybe true as removing this field remove a wrong field status
                    internal.updateAcceptableForm()
                }

                return
            }

            internal.fieldsStatus[key] = acceptableInput
            if(previousStatus === undefined) {
                // we added a new key so we need to notify about this change
                internal.fieldsStatusChanged()
            }

            internal.jsonAnswers[key] = value
            internal.jsonAnswersChanged()

            if(previousStatus !== undefined) {
                if(acceptableInput !== previousStatus) {
                    // we can maybe change the state of the form with this field value as previous status differ from the new one.
                    internal.updateAcceptableForm()
                }
            } else {
                if(internal.acceptableForm !== acceptableInput) {
                    // we can maybe change the state of the form with this field value as the global status differ from this one.
                    internal.updateAcceptableForm()
                }
            }
        }

        function isPreviousFieldStatus(key) {
            return internal.fieldsStatus[key] !== undefined
        }
    }

    readonly property alias jsonAnswers: internal.jsonAnswers

    readonly property alias acceptableForm: internal.acceptableForm

    Column {
        id: contents
        anchors.fill: parent

        Repeater {
            id: form
            anchors.fill: parent

            model: Object.values(json)

            delegate: DelegateChooser {
                role: "type"
                DelegateChoice {
                    roleValue: "string"

                    TextField {
                        readonly property string key: Object.keys(root.json)[index]
                        readonly property bool required: modelData.required

                        width: parent.width

                        placeholderText: modelData.description + (required ? " *" : "")
                        validator: RegExpValidator {
                            regExp: new RegExp(modelData.validator)
                        }

                        text: modelData.default !== undefined ? modelData.default : null

                        inputMethodHints: Qt.ImhNoPredictiveText

                        onTextChanged: {
                            internal.updateFieldStatus(key, text, acceptableInput, required)
                        }

                        rightPadding: error.width

                        ToolButton {
                            id: error
                            visible: !parent.acceptableInput && internal.isPreviousFieldStatus(key)

                            icon.name: "data-error"
                            icon.source: "qrc:/icons/status/data-error.svg"
                            icon.color: "transparent"

                            anchors.right: parent.right
                        }
                    }
                }

                DelegateChoice {
                    roleValue: "bool"

                    CheckBox {
                        readonly property string key: Object.keys(root.json)[index]

                        width: parent.width

                        text: modelData.description
                        checked: modelData.default

                        onCheckedChanged: {
                            internal.updateFieldStatus(key, checked, true, true)
                        }
                    }
                }

                DelegateChoice {
                    roleValue: "suggestion"

                    Suggestion {
                        readonly property string key: Object.keys(root.json)[index]
                        readonly property bool required: modelData.required

                        width: parent.width

                        placeholderSearch: modelData.description + (required ? " *" : "")

                        filterRoleName: modelData.roleName
                        showAdd: false

                        json: modelData.values

                        onSelectedChanged: {
                            internal.updateFieldStatus(key, selected !== undefined ? selected : "", selected !== null, required)
                        }

                    }
                }
            }
        }
    }
}
