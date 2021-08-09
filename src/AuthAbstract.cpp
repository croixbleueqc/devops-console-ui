#include "AuthAbstract.h"
#include <QJsonDocument>
#include <QJsonObject>

AuthAbstract::AuthAbstract(QObject *parent) : QObject(parent)
{

}

QString AuthAbstract::getEmailFromToken(QString token)
{
    if(token.isEmpty()) {
        return "";
    }

    auto parts = token.split(".");
    auto userdata = QByteArray::fromBase64(parts[1].toUtf8());

    const auto doc = QJsonDocument::fromJson(userdata);
    const auto email = doc.object().value("email").toString();
    return email;
}
