#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QtCore>
#include <QQuickStyle>

#ifdef OAUTH2
#include "Auth.h"
#include "OAuth2Config.h"
#endif

#ifdef WASM_OAUTH2
#include "WASMAuth.h"
#include "OAuth2Config.h"
#endif

#include "asyncsettings.h"

int main(int argc, char *argv[])
{
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);

    QGuiApplication app(argc, argv);
    app.setOrganizationName(QStringLiteral("Pygoscelis"));
    app.setOrganizationDomain(QStringLiteral("pygoscelis.org"));
    app.setApplicationName(QStringLiteral("DevOps"));
    app.setApplicationDisplayName(QStringLiteral("DevOps Console"));

//    QTranslator translator;
//    translator.load("DevOps_fr_CA");
//    QCoreApplication::installTranslator(&translator);

    QQmlApplicationEngine engine;

#ifdef OAUTH2
    qmlRegisterSingletonInstance("QtPygo.authConfig", 1, 0, "AuthConfig", &OAuth2Config::get());
    QScopedPointer<Auth> auth(new Auth());
    qmlRegisterSingletonInstance("QtPygo.auth", 1, 0, "Auth", auth.get());
#endif

#ifdef WASM_OAUTH2
    qmlRegisterSingletonInstance("QtPygo.authConfig", 1, 0, "AuthConfig", &OAuth2Config::get());
    QScopedPointer<WASMAuth> auth(new WASMAuth());
    qmlRegisterSingletonInstance("QtPygo.auth", 1, 0, "Auth", auth.get());
#endif

qmlRegisterType<AsyncSettings>("QtPygo.storage", 1, 0, "Settings");

//Todo: provide guest entry from server.

const QUrl url(QStringLiteral("qrc:/entrypoint/AuthEntry.qml"));

    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
                     &app, [url](QObject *obj, const QUrl &objUrl) {
        if (!obj && url == objUrl)
            QCoreApplication::exit(-1);
    }, Qt::QueuedConnection);
    engine.load(url);
    return app.exec();
}
