import QtQuick 2.12
import QtQuick.Controls 2.12
import "../core"

Page {
    id: root

    property alias headerPlaceholderItem: header.placeholderItem

    header: Header {
        id: header

        showApplicationMenu: false
        showUser: false
    }
}
