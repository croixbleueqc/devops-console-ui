import QtQuick 2.0

Item {
    property string module: ""
    property QtObject item: null

    Component.onCompleted: {
        var storeloader = Store.register(module)
        item = Qt.binding(() => storeloader.item)
    }

    Component.onDestruction: {
        data = null
        item = null
        Store.unregister(module)
    }
}
