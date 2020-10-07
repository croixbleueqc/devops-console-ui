import QtQuick 2.12

Item {
    id: root

    property alias request: watch.request
    property alias dataRequest: watch.dataRequest
    property alias com: watch.com
    property alias autoSend: watch.autoSend

    property alias processing: watch.processing
    property alias error: watch.error

    readonly property var dataResponseInfo: ({})
    readonly property var dataResponse: ({})
    readonly property var dataResponseKeys: []

    signal info(string key, var value)
    signal added(string key, var value)
    signal deleted(int index, string key, var value)
    signal modified(int index, string key, var value)

    WSNetworkAbstract {
        id: watch

        onSuccess: {
            const type = watch.dataResponse["type"]
            const key = watch.dataResponse["key"]
            const value = watch.dataResponse["value"]
            const index = root.dataResponseKeys.indexOf(key)

            switch(type) {
            case "INFO":
                root.dataResponseInfo[key] = value
                root.dataResponseInfoChanged()
                root.info(key, value)
                break
            case "ADDED":
                root.dataResponse[key] = value
                root.dataResponseKeys.push(key)
                root.dataResponseChanged()
                root.added(key, value)
                break
            case "MODIFIED":
                root.dataResponse[key] = value
                root.dataResponseChanged()
                root.modified(index, key, value)
                break
            case "DELETED":
                delete root.dataResponse[key]
                root.dataResponseKeys.splice(index, 1)
                root.dataResponseChanged()
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

    Component.onDestruction: {
        // Request to close the watcher on server side
        root.request = "ws:watch:close"
        watch.send()
    }
}
