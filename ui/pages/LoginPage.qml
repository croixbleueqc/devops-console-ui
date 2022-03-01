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
        
        function onUpdatedConfig(){
            if(Auth.configured) {
                console.log("config is configured")
                // Fixme: Bug uncaught runtime error when Auth.grant() called on callback.
                // Using two buttons (SSO and Login) as a workaround
                // Auth.grant()
            }else{
                console.log("config not configured")
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
            visible: !Auth.configured
            onClicked:
            {
                Store.register("OAuth2")
            }
        }  
        Button {
            Layout.alignment: Qt.AlignHCenter

            text: qsTr("Login")
            visible: Auth.configured
            enabled: Auth.configured
            onClicked:
            {
                Auth.grant()
            }
        }  
    }

}
