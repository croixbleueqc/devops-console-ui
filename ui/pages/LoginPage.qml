import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12

import QtPygo.auth 1.0
import QtPygo.authConfig 1.0

import "../layouts"
import "../../backend/core"
import "../../backend/OAuth2"

SimpleLayout {
    Connections {
        target: Auth

        function onAuthenticatedChanged() {
            if(Auth.authenticated) {
                Store.user = Auth.email
                Store.defaultRouter.replace("WelcomePage.qml")
            }
        }
    }

    ColumnLayout {
        id: login

        anchors.centerIn: parent

        Text {
            text: qsTr("Welcome to %1").arg(Qt.application.displayName)
        }

        Button {
            Layout.alignment: Qt.AlignHCenter

            text: qsTr("SSO")

            onPressed:
            {
             Store.register("OAuth2")
            }

            onClicked:
            {
                Auth.grant()
            }
        }    
    }

}
