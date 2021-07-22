#include "OAuth2Config.h"
#include <cstdio>
#include <string>

OAuth2Config::OAuth2Config(QObject *parent):
    QObject(parent)
{

}

void OAuth2Config::get_Json(char * dest,std::string currUrl) const
{
    std::sprintf(dest,"{\"authority\": \"%s\","
    "\"client_id\": \"%s\","
    "\"silent_redirect_uri\":\"%s/silent-redirect.html\","
    "\"popup_redirect_uri\": \"%s/popup-signin.html\","
    "\"response_type\": \"code\","
    "\"scope\": \"%s\"}",
     Issuer.toString().toStdString().c_str(),
     clientID.toStdString().c_str(),
     currUrl.c_str(),
     currUrl.c_str(),
     kScope.toStdString().c_str()
    );
}

QUrl OAuth2Config::get_kAuth() const
{
    return kAuth;
}

QUrl OAuth2Config::get_kAccessToken() const
{
    return kAccessToken;
}

QString OAuth2Config::get_kScope() const
{
    return kScope;
}

QString OAuth2Config::get_clientID() const
{
    return clientID;
}

void OAuth2Config::setIssuer(const QUrl &newIssuer)
{
    if (Issuer == newIssuer)
        return;
    Issuer = newIssuer;
    emit IssuerChanged();
}

void OAuth2Config::setKAuth(const QUrl &newKAuth)
{
    if (kAuth == newKAuth)
        return;
    kAuth = newKAuth;
    emit kAuthChanged();
}

void OAuth2Config::setKAccessToken(const QUrl &newKAccessToken)
{
    if (kAccessToken == newKAccessToken)
        return;
    kAccessToken = newKAccessToken;
    emit kAccessTokenChanged();
}

void OAuth2Config::setKScope(const QString &newKScope)
{
    if (kScope == newKScope)
        return;
    kScope = newKScope;
    emit kScopeChanged();
}

void OAuth2Config::setClientID(const QString &newClientID)
{
    if (clientID == newClientID)
        return;
    clientID = newClientID;
    emit clientIDChanged();
}
