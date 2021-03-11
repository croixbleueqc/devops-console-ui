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
    readonly property ListModel dataResponse: ListModel {}
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

    Component.onDestruction: {
        // Request to close the watcher on server side
        root.request = "ws:watch:close"
        watch.send()
    }
}
