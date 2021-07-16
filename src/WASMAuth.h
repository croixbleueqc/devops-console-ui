
//#ifdef Q_OS_WASM
#ifndef WASMAUTH_H
#define WASMAUTH_H
#include <emscripten/val.h>
#include <QObject>
#include <ctime>
#include "OAuth2Config.h"

class WASMAuth : public QObject
{
    //typedef void OAuthWASM(const char * ,const char *);
    Q_OBJECT
    Q_PROPERTY(QString email READ getEmail NOTIFY emailChanged)
    Q_PROPERTY(bool authenticated READ isAuthenticated NOTIFY authenticatedChanged)

public:
    WASMAuth(QObject *parent = nullptr);
    WASMAuth(const QString &clientId, QObject *parent = nullptr);
    WASMAuth(QScopedPointer<OAuth2Config> &config,QObject *parent);
    bool isPermanent() const;
    void setPermanent(bool value);
    bool isAuthenticated() const;
    ~WASMAuth();
public slots:
    void grant();
    void updateConfig ();

signals:
    void authenticatedChanged();
    void emailChanged();

private:
    time_t expiration =0;
    bool permanent{false};
    bool authenticated{false};
    QString getEmail();
    QScopedPointer<OAuth2Config>* config_ptr;
};


#endif // WASMAUTH_H
//#endif //Q_OS_WASM
