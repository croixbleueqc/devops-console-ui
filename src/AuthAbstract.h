#ifndef IAUTH_H
#define IAUTH_H

#include <QObject>

class AuthAbstract : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString email READ getEmail NOTIFY emailChanged)
    Q_PROPERTY(bool authenticated READ isAuthenticated NOTIFY authenticatedChanged)
    Q_PROPERTY(bool configured READ isConfigured NOTIFY updatedConfig)
public:
    AuthAbstract(QObject *parent);

    virtual bool isPermanent() const = 0;
    virtual void setPermanent(bool value) = 0;
    virtual bool isAuthenticated() const =0;
    virtual bool isConfigured() const =0;

public slots:
    virtual void grant() = 0;
    virtual void updateConfig() = 0;

signals:
    void authenticatedChanged();
    void emailChanged();
    void updatedConfig();

protected:
    virtual QString getEmail() = 0;
    QString getEmailFromToken(QString token);
};

#endif // IAUTH_H
