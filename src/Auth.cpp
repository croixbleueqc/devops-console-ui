#include "Auth.h"
#include "OAuth2Config.h"

#include <QtNetwork>
#include <QtNetworkAuth>
#include <QtGui>

Auth::Auth(QObject *parent)
    : AuthAbstract(parent)
{
    auto replyHandler = new QOAuthHttpServerReplyHandler(3000, this);
    oauth2.setReplyHandler(replyHandler);

    connect(&oauth2, &QOAuth2AuthorizationCodeFlow::statusChanged, [=](
            QAbstractOAuth::Status status) {

        switch (status) {
            case QAbstractOAuth::Status::Granted:
                this->authenticated = true;
                break;
            case QAbstractOAuth::Status::NotAuthenticated:
                this->authenticated = false;
                break;
            default:
                return;
        }

        emit this->authenticatedChanged();
        emit this->emailChanged();
    });
    oauth2.setModifyParametersFunction([&](QAbstractOAuth::Stage stage, QVariantMap *parameters) {
        if (stage == QAbstractOAuth::Stage::RequestingAuthorization && isPermanent())
            parameters->insert("duration", "permanent");
    });
    connect(&oauth2, &QOAuth2AuthorizationCodeFlow::authorizeWithBrowser,
            &QDesktopServices::openUrl);
}

bool Auth::isPermanent() const {
    return permanent;
}

void Auth::setPermanent(bool value) {
    permanent = value;
}

void Auth::grant() {
    oauth2.grant();
}

bool Auth::isAuthenticated() const {
    return authenticated;
}

void Auth::updateConfig()
{
    QReadLocker gard (&OAuth2Config::get().getLock());
    oauth2.setAuthorizationUrl(OAuth2Config::get().getKAuth());
    oauth2.setAccessTokenUrl(OAuth2Config::get().getKAccessToken());
    oauth2.setScope(OAuth2Config::get().getKScope());
    oauth2.setClientIdentifier(OAuth2Config::get().getClientID());
}

QString Auth::getEmail() {
    return getEmailFromToken(oauth2.token());
}
