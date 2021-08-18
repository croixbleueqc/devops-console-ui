import QtQuick 2.12

import QtPygo.authConfig 1.0
import QtPygo.auth 1.0

import "../core"
WSNetworkAbstract {
    id: root
    com: WSComOne
    autoSend: true

    request: "oauth2:read:/config"
    dataRequest:
    {
        "sccs_plugin": Store.sccs_plugin_settings.plugin,
        "sccs_session": Store.sccs_plugin_settings.sessionObj
    }
    onErrorChanged: {
        if( isError() ) {
            console.log("OAuth2: " + error)
        }
        AuthConfig.unlock()
    }
    onDataRequestChanged: send()

    onDataResponseChanged: {
        AuthConfig.lockForWrite()
        AuthConfig.issuer = dataResponse.Config.Issuer
        AuthConfig.kAuth = dataResponse.Config.kAuth
        AuthConfig.kAccessToken = dataResponse.Config.kAccessToken
        AuthConfig.clientID = dataResponse.Config.clientID
        AuthConfig.kScope = dataResponse.Config.kScope
        AuthConfig.unlock()

        Auth.updateConfig()
    }
}
