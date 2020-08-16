#include "asyncsettings.h"
#include <QtCore/qtimer.h>

AsyncSettings::AsyncSettings(QObject *parent) : QObject(parent)
{
//    this->prepare();
}

void AsyncSettings::prepare()
{
    if (m_settings.status() == QSettings::NoError) {
        emit this->ready();
    } else {
        QTimer::singleShot(10, this, &AsyncSettings::prepare);
    }
}

void AsyncSettings::sync()
{
    m_settings.sync();
}

void AsyncSettings::writeSettings(const QString &key, const QVariant &value)
{
    m_settings.setValue(key, value);
}

QVariant AsyncSettings::readSettings(const QString &key, const QVariant &defaultValue) const
{
    return m_settings.value(key, defaultValue);
}

void AsyncSettings::classBegin()
{
}

void AsyncSettings::componentComplete()
{
    this->prepare();
}
