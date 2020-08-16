import QtQuick 2.12
import QtWebSockets 1.15

WebSocket {
    id: root

    url: "ws://localhost:3000"
    active: true

    signal jsonMessageReceived(var obj)

    function sendJsonMessage(obj) {
        var str = JSON.stringify(obj)
        root.sendTextMessage(str)

        console.log("WSCom: send: uniqueId=" + obj.uniqueId + ", request=" + obj.request)
    }

    onTextMessageReceived: {
        var obj = JSON.parse(message)

        console.log("WSCom: received for: uniqueId=" + obj.uniqueId)

        jsonMessageReceived(obj)
    }

    onStatusChanged: {
        if (status == WebSocket.Error) {
            console.log("socker error: " + root.errorString)
        } else if (status == WebSocket.Closed) {
            console.log("socket closed")
        } else if (status == WebSocket.Open) {
            console.log("socket open")
        } else {
            console.log("socket status undefined: " + status)
        }
    }
}
