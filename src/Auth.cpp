#include "Auth.h"
#include <QtNetwork>
#include <QtNetworkAuth>
#include <QtGui>
#include <QDebug>

Auth::Auth(QObject *parent)
    : QObject(parent)
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

Auth::Auth(const QString &clientId, QObject *parent)
    : Auth(parent)
{
    oauth2.setClientIdentifier(clientId);
}

Auth::Auth(QScopedPointer<OAuth2Config> &_config_ptr, QObject *parent):
    Auth(parent)
{
   config_ptr = &_config_ptr;
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
    auto config = config_ptr->data();
    oauth2.setAuthorizationUrl(config->get_kAuth());
    oauth2.setAccessTokenUrl(config->get_kAccessToken());
    oauth2.setScope(config->get_kScope());
}

QString Auth::getEmail() {
    if(oauth2.token().isEmpty()) {
        return "";
    }

    auto parts = oauth2.token().split(".");
    auto userdata = QByteArray::fromBase64(parts[1].toUtf8());

    qInfo()<< QByteArray::fromBase64(parts[0].toUtf8());
    const auto doc = QJsonDocument::fromJson(userdata);
    qInfo()<<doc;
    const auto email = doc.object().value("email").toString();
    qInfo()<< parts[2];
    return email;
}
