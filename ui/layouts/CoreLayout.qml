import QtQuick 2.12
import QtQuick.Controls 2.12
import "../core"
import "../../backend/core"

Page {
    id: root

    property alias headerPlaceholderItem: header.placeholderItem
    property alias router: navigation.router
    property alias routes: navigation.routes

    Navigation {
        id: navigation
        routes: Store.defaultRoutes
        router: Store.defaultRouter
    }

    header: Header {
        id: header

        onOpenApplicationMenu: navigation.open()
        onOpenParametersPage: navigation.openParametersPage()
    }
}
