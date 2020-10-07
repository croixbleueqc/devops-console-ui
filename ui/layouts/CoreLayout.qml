import QtQuick 2.12
import QtQuick.Controls 2.12
import "../core"
import "../../backend/core"

Page {
    id: root

    property alias headerPlaceholderItem: header.placeholderItem
    property alias headerSecondTitle: header.secondTitle
    property alias router: navigation.router
    property alias routes: navigation.routes
    property var openPage: navigation.openPage

    Navigation {
        id: navigation
        routes: Store.defaultRoutes
        router: Store.defaultRouter
    }

    header: Header {
        id: header

        isCanGoBack: navigation.isRemainingPages

        onOpenApplicationMenu: navigation.open()
        onOpenParametersPage: navigation.openParametersPage()
        onGoBack: navigation.goBack()
    }
}
