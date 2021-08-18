#ifndef OAUTH2CONFIG_H
#define OAUTH2CONFIG_H
#include <string>

#include <QUrl>
#include <QString>
#include <QObject>
#include <QReadWriteLock>

class OAuth2Config :public QObject
{
    Q_OBJECT

public:

    Q_PROPERTY(QUrl issuer WRITE setIssuer MEMBER issuer NOTIFY IssuerChanged)
    Q_PROPERTY(QUrl kAuth READ getKAuth WRITE setKAuth NOTIFY kAuthChanged)
    Q_PROPERTY(QUrl kAccessToken READ getKAccessToken WRITE setKAccessToken NOTIFY kAccessTokenChanged)
    Q_PROPERTY(QString kScope READ getKScope WRITE setKScope NOTIFY kScopeChanged)
    Q_PROPERTY(QString clientID READ getClientID WRITE setClientID NOTIFY clientIDChanged)

    static OAuth2Config &get() noexcept;

    QUrl        getIssuer();
    QUrl        getKAuth() ;
    QUrl        getKAccessToken();
    QString     getKScope() ;
    QString     getClientID() ;

    void setIssuer(const QUrl &newIssuer);
    void setKAuth(const QUrl &newKAuth);
    void setKAccessToken(const QUrl &newKAccessToken);
    void setKScope(const QString &newKScope);
    void setClientID(const QString &newClientID);

    OAuth2Config(const OAuth2Config&) = delete;
    OAuth2Config& operator=(const OAuth2Config&) = delete;

signals:
    void IssuerChanged();
    void kAuthChanged();
    void kAccessTokenChanged();
    void kScopeChanged();
    void clientIDChanged();

public slots:
    void lockForWrite();
    void lockForRead();
    void unlock();

    QReadWriteLock &getLock();

private:
    QUrl issuer;
    QUrl kAuth;
    QUrl kAccessToken;
    QString kScope;
    QString clientID;
    QReadWriteLock mutex ;
    OAuth2Config(QObject *parent = nullptr);

    static OAuth2Config singleton;
};

#endif // OAUTH2CONFIG_H
