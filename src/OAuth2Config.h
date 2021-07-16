#ifndef OAUTH2CONFIG_H
#define OAUTH2CONFIG_H
#include <string>
#include <QUrl>
#include <QString>
#include <QObject>
#include <qqml.h>

class OAuth2Config :public QObject
{
    Q_OBJECT


public:
    Q_PROPERTY(QUrl Issuer WRITE setIssuer MEMBER Issuer NOTIFY IssuerChanged)
    Q_PROPERTY(QUrl kAuth READ get_kAuth WRITE setKAuth NOTIFY kAuthChanged)
    Q_PROPERTY(QUrl kAccessToken READ get_kAccessToken WRITE setKAccessToken NOTIFY kAccessTokenChanged)
    Q_PROPERTY(QString kScope READ get_kScope WRITE setKScope NOTIFY kScopeChanged)
    Q_PROPERTY(QString clientID READ get_clientID WRITE setClientID NOTIFY clientIDChanged)
    OAuth2Config(QObject *parent = nullptr);
    void get_Json (char * dest, std::string currUrl) const;
    QUrl        get_kAuth() const;
    QUrl        get_kAccessToken() const;
    QString     get_kScope() const;
    QString     get_clientID() const;
    void setIssuer(const QUrl &newIssuer);
    void setKAuth(const QUrl &newKAuth);
    void setKAccessToken(const QUrl &newKAccessToken);
    void setKScope(const QString &newKScope);
    void setClientID(const QString &newClientID);

signals:
    void IssuerChanged();
    void kAuthChanged();
    void kAccessTokenChanged();
    void kScopeChanged();
    void clientIDChanged();

private:
    QUrl Issuer;
    QUrl kAuth;
    QUrl kAccessToken;
    QString kScope;
    QString clientID;

};

#endif // OIDCCONFIG_H
