#include "Auth.h"
#include <QtNetwork>
#include <QtNetworkAuth>
#include <QtGui>

// TODO: provides external configuration for OAuth2
const QUrl kAuth{"https://.../auth/realms/master/protocol/openid-connect/auth"};
const QUrl kAccessToken{"https://.../auth/realms/master/protocol/openid-connect/token"};
const QString kScope{"profile email"};

Auth::Auth(QObject *parent)
    : QObject(parent)
{
    auto replyHandler = new QOAuthHttpServerReplyHandler(3000, this);
    oauth2.setReplyHandler(replyHandler);
    oauth2.setAuthorizationUrl(kAuth);
    oauth2.setAccessTokenUrl(kAccessToken);
    oauth2.setScope(kScope);

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

Auth::Auth(const QString &clientId, QObject *parent)
    : Auth(parent)
{
    oauth2.setClientIdentifier(clientId);
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

QString Auth::getEmail() {
    if(oauth2.token().isEmpty()) {
        return "";
    }

    auto parts = oauth2.token().split(".");
    auto userdata = QByteArray::fromBase64(parts[1].toUtf8());

    const auto doc = QJsonDocument::fromJson(userdata);
    const auto email = doc.object().value("email").toString();

    return email;
}
