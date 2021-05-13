import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12

import "../../../../backend/sccs"

Item {
    property alias repositoryParams: data_addrepo.repositoryParams
    property alias template: data_addrepo.template
    property alias templateParams: data_addrepo.templateParams

    implicitHeight: state === "Summary" ? summary.implicitHeight : contents.implicitHeight
    implicitWidth: state === "Summary" ? summary.implicitWidth : contents.implicitWidth

    states: [
        State {
            name: "Adding"
            when: data_addrepo.processing
            PropertyChanges { target: addit; visible: false }
            PropertyChanges { target: adding; visible: true }
        },
        State {
            name: "Summary"
            when: !data_addrepo.processing && data_addrepo.done
            PropertyChanges { target: contents; visible: false }
            PropertyChanges { target: summary; visible: true }
        }
    ]

    AddRepository {
        id: data_addrepo

        // One time operation
        property bool done: false

        onSuccess: done = true
        onErrorChanged: done = true
    }

    ColumnLayout {
        id: contents
        width: parent.width
        spacing: 10

        anchors.centerIn: parent

        Label {
            id: ready
            wrapMode: Text.Wrap

            Layout.fillWidth: true

            horizontalAlignment: Qt.AlignHCenter

            text: {
                if(template !== "") {
                    return qsTr("We are ready to add <strong>%1</strong> with <strong>%2</strong> template.")
                        .arg(repositoryParams.name)
                        .arg(template)
                } else {
                    return qsTr("We are ready to add <strong>%1</strong> without any template.")
                        .arg(repositoryParams.name)
                }
            }
        }

        Button {
            id: addit
            text: qsTr("Add it!")
            highlighted: true

            Layout.alignment: Qt.AlignHCenter

            onClicked: {
                data_addrepo.send()
            }
        }

        BusyIndicator {
            id: adding
            running: visible
            visible: false

            Layout.alignment: Qt.AlignHCenter
        }
    }

    TextEdit {
        id: summary
        visible: false

        width: parent.width

        wrapMode: Text.Wrap

        selectByMouse :true

        readOnly: true

        text: data_addrepo.isError() ? data_addrepo.error : data_addrepo.dataResponse
    }
}
