import QtQuick 2.12

Item {
    property string request: ""
    property var dataRequest: null
    readonly property string uniqueId: Qt.md5(this)

    property var dataResponse: null

    property bool processing: false
    property string error: ""
    signal success()

    property bool autoReset: false
    property bool autoSend: false

    property WSCom com: null

    Connections {
        target: com

        function onJsonMessageReceived(obj) {
            if (obj === undefined) {
                return
            }

            if (obj.uniqueId === uniqueId) {
                // I'm the requester

                if (obj.error !== undefined) {
                    receivedWithError(obj.error)
                } else {
                    received(obj.dataResponse)
                }
            }
        }

        function onErrorStringChanged() {
            receivedWithError(com.errorString)
        }
    }

    function send() {
        processing = true;

        if(error !== "") {
            //reset error state
            error = "";
        }

        if(autoReset) {
            dataResponse = null
        }

        com.sendJsonMessage(
                        {
                            "uniqueId": uniqueId,
                            "request": request,
                            "dataRequest": dataRequest
                        }
                    )
    }

    function receivedWithError(error_msg) {

        if (error_msg !== "") {
            error = error_msg;
        } else {
            error = qsTr("Unknown error !");
        }

        processing = false;
    }

    function received(response) {

        if (response === undefined) {
            dataResponse = null
        } else {
            dataResponse = response;
        }

        success();
        processing = false;
    }

    function isError() {
        return error !== "";
    }

    Component.onCompleted: {
        if(autoSend) {
            send()
        }
    }
}
