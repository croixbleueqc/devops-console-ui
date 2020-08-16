import QtQuick 2.12
import "network.js" as RESTful

NetworkAbstract {
    function put() {
        beginProcessing();

        if(uri === "") {
            endProcessingWithError("uri not set !");
            return;
        }

        // Simulate PUT
        console.log(uri + ": " + JSON.stringify(data));

        RESTful.update(uri,
                       data,
                       (result) => {
                           timer.start();
                       },
                       (error_msg) => {
                           timer_err.start();
//                           endProcessingWithError("error_msg")
                       }
                       )
    }

    function update() {
        put();
    }

    Timer {
        id: timer
        interval: 2000
        repeat: false
        onTriggered: {
            endProcessing();
        }
    }

    Timer {
        id: timer_err
        interval: 2000
        repeat: false
        onTriggered: {
            endProcessingWithError("tmp");
        }
    }
}
