import QtQuick 2.12
import QtQuick.Controls 2.12

import "../../../backend/sccs"
import "../../common"

Popup {
    id: root

    property alias repositoryName: dataEnvs.repositoryName
    property var envsExpected: []
    property alias envs: dataEnvs.dataResponse

    signal compatible()

    contentHeight: dataEnvs.processing ? loading.implicitHeight : msg.implicitHeight
    contentWidth: dataEnvs.processing ? loading.implicitWidth : msg.implicitWidth

    padding: 10

    RunnableEnvironments {
        id: dataEnvs

        onSuccess: {
            // check if envs are matching

            // first
            if(root.envsExpected.length === 0){
                root.compatible()
                root.close()
                return
            }

            // regular case
            const isEqualAtIndex = (currentValue, index) => currentValue === root.envsExpected[index].name
            if((root.envsExpected.length === dataResponse.length) && dataResponse.every(isEqualAtIndex)){
                root.compatible()
                root.close()
                return
            }
        }
    }

    Loading {
        id: loading
        anchors.centerIn: parent

        visible: dataEnvs.processing

        message: qsTr("Collecting environments...")
    }

    Label {
        id: msg
        visible: !dataEnvs.processing
        text: {
            if(dataEnvs.isError()){
                return qsTr("Failed to collect environments !")
            }

            return qsTr("Environments are not compatible with previous ones !")
        }
    }
}
