import QtQuick 2.0

Item {
    property bool processing: false
    property var data: null
    property string uri: ""

    property string error: ""
    signal success()

    function beginProcessing() {
//        if(uri === "") {
//            return;
//        }

        if(error !== "") {
            //reset error state
            error = "";
        }

        processing = true;
    }

    function endProcessingWithError(error_msg) {
        if (error_msg !== undefined && error_msg !== "") {
            error = error_msg;
        } else {
            error = qsTr("Unknown error !");
        }

        processing = false;
    }

    function endProcessing(new_data) {
        if (new_data !== undefined) {
            data = new_data;
        }

        success();
        processing = false;
    }

    function isError() {
        return error !== "";
    }
}

