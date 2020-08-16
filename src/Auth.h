#ifndef AUTH_H
#define AUTH_H

#include <QtCore>
#include <QOAuth2AuthorizationCodeFlow>

class Auth: public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString email READ getEmail NOTIFY emailChanged)
    Q_PROPERTY(bool authenticated READ isAuthenticated NOTIFY authenticatedChanged)

public:
    Auth(QObject *parent = nullptr);
    Auth(const QString &clientId, QObject *parent = nullptr);
    bool isPermanent() const;
    void setPermanent(bool value);
    bool isAuthenticated() const;

public slots:
    void grant();

signals:
    void authenticatedChanged();
    void emailChanged();

private:
    QOAuth2AuthorizationCodeFlow oauth2;
    bool permanent{false};
    bool authenticated{false};
    QString getEmail();

};

#endif // AUTH_H
