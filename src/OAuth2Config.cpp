#include "OAuth2Config.h"

#include <cstdio>
#include <string>

#include <QReadLocker>
#include <QWriteLocker>

//initialise the singleton
OAuth2Config OAuth2Config::singleton;

OAuth2Config::OAuth2Config(QObject *parent):
    QObject(parent),mutex(QReadWriteLock::Recursive){}

OAuth2Config &OAuth2Config::get()  noexcept
{
             return singleton;
}

void OAuth2Config::lockForWrite()
{
    mutex.lockForWrite();
}

void OAuth2Config::lockForRead()
{
      mutex.lockForRead();
}

void OAuth2Config::unlock()
{
     mutex.unlock();
}

QReadWriteLock &OAuth2Config::getLock()
{
        return mutex;
}

QUrl OAuth2Config::getIssuer()
{
    QReadLocker gard (&mutex);
    return issuer;
}

QUrl OAuth2Config::getKAuth()
{
    QReadLocker gard (&mutex);
    return kAuth;
}

QUrl OAuth2Config::getKAccessToken()
{
    QReadLocker gard (&mutex);
    return kAccessToken;
}

QString OAuth2Config::getKScope()
{
    QReadLocker gard (&mutex);
    return kScope;
}

QString OAuth2Config::getClientID()
{
    QReadLocker gard (&mutex);
    return clientID;
}

void OAuth2Config::setIssuer(const QUrl &newIssuer)
{
    QWriteLocker gard (&mutex);
    if (issuer == newIssuer)
        return;
    issuer = newIssuer;
    emit IssuerChanged();
}

void OAuth2Config::setKAuth(const QUrl &newKAuth)
{
    QWriteLocker gard (&mutex);
    if (kAuth == newKAuth)
        return;
    kAuth = newKAuth;
    emit kAuthChanged();
}

void OAuth2Config::setKAccessToken(const QUrl &newKAccessToken)
{
     QWriteLocker gard (&mutex);
    if (kAccessToken == newKAccessToken)
        return;
    kAccessToken = newKAccessToken;
    emit kAccessTokenChanged();
}

void OAuth2Config::setKScope(const QString &newKScope)
{
    QWriteLocker gard (&mutex);
    if (kScope == newKScope)
        return;
    kScope = newKScope;
    emit kScopeChanged();
}

void OAuth2Config::setClientID(const QString &newClientID)
{
    QWriteLocker gard (&mutex);
    if (clientID == newClientID)
        return;
    clientID = newClientID;
    emit clientIDChanged();
}

