import QtQuick 2.12
import "network.js" as RESTful

NetworkAbstract {
    onUriChanged: get()

    function get() {
        beginProcessing();

        if(uri === "") {
            endProcessingWithError("uri not set !");
            return;
        }

        RESTful.get(uri,
                    (result) => {
                        endProcessing(result);
                    },
                    (error_msg) => {
                        endProcessingWithError(error_msg);
                    }
                    )
    }
}
