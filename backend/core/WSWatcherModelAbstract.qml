import QtQuick 2.12

Item {
    id: root

    property alias request: watcher.request
    property alias dataRequest: watcher.dataRequest
    property alias com: watcher.com
    property bool autoWatch: false

    readonly property alias processing: watcher.processing
    readonly property alias error: watcher.error
    readonly property alias watching: watcher.watching

    readonly property alias dataResponseInfo: watcher._dataResponseInfo
    readonly property ListModel dataResponse: ListModel {}
    readonly property alias dataResponseKeys: watcher._dataResponseKeys

    signal info(string key, var value)
    signal added(string key, var value)
    signal deleted(int index, string key, var value)
    signal modified(int index, string key, var value)
    signal reset()

    function watch() {
        if (watching) {
            // restart mode
            watcher.restart = true
            stop_watch(true)
        } else {
            watcher.watching = true
            watcher.send()
        }
    }

    function stop_watch(reset) {
        if (watching) {
            watcher.watching = false
            com.sendJsonMessage(
                            {
                                "uniqueId": watcher.uniqueId,
                                "request": "ws:watch:close",
                                "dataRequest": null
                            }
                        )

            if (reset === true) {
                watcher._reset()
            }
        }
    }

    WSNetworkAbstract {
        id: watcher

        property bool restart: false
        property bool watching: false
        property var _dataResponseInfo: ({})
        property var _dataResponseKeys: []

        function _reset() {
            root.dataResponse.clear()
            _dataResponseInfo = ({})
            _dataResponseKeys = []
            root.reset()
        }

        autoSend: false

        onSuccess: {
            if (restart) {
                if (watcher.dataResponse["status"] !== "ws:watch:closed") { return } // can be an event from the previous request (close in progress)
                _reset()
                restart = false
                root.watch()
                return
            }

            if (!watching) { return }

            const type = watcher.dataResponse["type"]
            const key = watcher.dataResponse["key"]
            const value = watcher.dataResponse["value"]
            const index = root.dataResponseKeys.indexOf(key)

            switch(type) {
            case "INFO":
                root.dataResponseInfo[key] = value
                root.dataResponseInfoChanged()
                root.info(key, value)
                break
            case "ADDED":
                root.dataResponse.append({raw: value, key: key})
                root.dataResponseKeys.push(key)
                root.added(key, value)
                break
            case "MODIFIED":
                root.dataResponse.set(index, {raw: value, key: key})
                root.modified(index, key, value)
                break
            case "DELETED":
                root.dataResponse.remove(index)
                root.dataResponseKeys.splice(index, 1)
                root.deleted(index, key, value)
                break
            default:
                break
            }
        }
    }

    function isError() {
        return root.error !== "";
    }

    Component.onCompleted: {
        if(autoWatch) {
            watch()
        }
    }

    Component.onDestruction: {
        // Request to close the watcher on server side
        stop_watch(false)
    }
}
