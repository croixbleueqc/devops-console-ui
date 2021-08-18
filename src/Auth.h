#ifndef AUTH_H
#define AUTH_H

#include "AuthAbstract.h"

#include <QtCore>
#include <QOAuth2AuthorizationCodeFlow>

class Auth: public AuthAbstract
{
public:
    Auth(QObject *parent = nullptr);
    bool isPermanent() const;
    void setPermanent(bool value);
    bool isAuthenticated() const;

public slots:
    void grant();
    void updateConfig();

private:
    QOAuth2AuthorizationCodeFlow oauth2;
    bool permanent{false};
    bool authenticated{false};
    QString getEmail();
};

#endif // AUTH_H
