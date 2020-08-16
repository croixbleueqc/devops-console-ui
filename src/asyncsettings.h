#ifndef ASYNCSETTINGS_H
#define ASYNCSETTINGS_H

#include <QtCore/qobject.h>
#include <qsettings.h>
#include <QtQml/QQmlParserStatus>

class AsyncSettings : public QObject, public QQmlParserStatus
{
    Q_OBJECT
    Q_INTERFACES(QQmlParserStatus)

public:
    explicit AsyncSettings(QObject *parent = nullptr);
    Q_INVOKABLE void writeSettings(const QString &key, const QVariant &value);
    Q_INVOKABLE QVariant readSettings(const QString &key, const QVariant &defaultValue = QVariant()) const;
    Q_INVOKABLE void sync(void);

signals:
    void ready();

protected:
    void classBegin();
    void componentComplete();

private:
    void prepare();

    QSettings m_settings;
};

#endif // ASYNCSETTINGS_H
