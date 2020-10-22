import QtQuick 2.12

import "../sccs"

Item {
    id: root
    property var project: null

    property bool processing: false
    property var error: null
    property int countSuccess: 0
    signal success()

    onProjectChanged: {
        error = []
        countSuccess = 0
    }

    onCountSuccessChanged: {
        if(countSuccess === repeatRepoCDC.count) {
            success()
        }
    }

    function dataResponseAt(index) {
        return repeatRepoCDC.itemAt(index).dataResponse
    }

    function isError() {
        return error.length !== 0
    }

    Repeater {
        id: repeatRepoCDC
        model: root.project !== null ? root.project.repositories : null

        RepoContinuousDeploymentConfig {
            args: {
                "skip_available": true
            }

            repositoryName: modelData

            onProcessingChanged: {
                // case: processing
                if(processing) {
                    if(!root.processing) {
                        root.processing = true
                    }
                    return
                }

                // case: I'm not processing anymore but maybe someone else is processing
                for(var i=0; i<repeatRepoCDC.count; i++) {
                    if(repeatRepoCDC.itemAt(i).processing) {
                        return
                    }
                }

                // case: done for everyone
                root.processing = false
            }

            onErrorChanged: {
                root.error[index] = error
                root.errorChanged()
            }

            onSuccess: root.countSuccess++
        }
    }
}
