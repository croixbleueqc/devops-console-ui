#ifndef WASMAUTH_H
#define WASMAUTH_H

#include "OAuth2Config.h"
#include "AuthAbstract.h"
#include <emscripten/val.h>
#include <QObject>
#include <mutex>

class WASMAuth : public AuthAbstract
{
public:
    WASMAuth(QObject *parent = nullptr);

    bool isPermanent() const;
    void setPermanent(bool value);
    bool isAuthenticated() const;
    bool isConfigured() const;

    ~WASMAuth();
public slots:
    void grant();
    void updateConfig();

private:
    time_t expiration =0;
    bool permanent{false};
    bool authenticated{false};
    bool configured{false};
    QString getEmail();
    std::mutex jsonLock;
};
#endif // WASMAUTH_H
