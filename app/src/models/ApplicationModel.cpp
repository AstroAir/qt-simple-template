#include "models/ApplicationModel.h"
#include <QCoreApplication>
#include <QDebug>
#include <QSettings>

// Property name constants
const QString ApplicationModel::PROPERTY_APP_NAME = "appName";
const QString ApplicationModel::PROPERTY_APP_VERSION = "appVersion";
const QString ApplicationModel::PROPERTY_APP_TITLE = "appTitle";
const QString ApplicationModel::PROPERTY_STATUS_MESSAGE = "statusMessage";
const QString ApplicationModel::PROPERTY_IS_BUSY = "isBusy";
const QString ApplicationModel::PROPERTY_LAST_UPDATED = "lastUpdated";
const QString ApplicationModel::PROPERTY_USER_NAME = "userName";
const QString ApplicationModel::PROPERTY_THEME = "theme";

ApplicationModel::ApplicationModel(QObject *parent) : BaseModel(parent) {}

QString ApplicationModel::getAppName() const {
    return getProperty(PROPERTY_APP_NAME).toString();
}

QString ApplicationModel::getAppVersion() const {
    return getProperty(PROPERTY_APP_VERSION).toString();
}

QString ApplicationModel::getAppTitle() const {
    return getProperty(PROPERTY_APP_TITLE).toString();
}

QString ApplicationModel::getStatusMessage() const {
    return getProperty(PROPERTY_STATUS_MESSAGE).toString();
}

bool ApplicationModel::isBusy() const {
    return getProperty(PROPERTY_IS_BUSY).toBool();
}

QDateTime ApplicationModel::getLastUpdated() const {
    return getProperty(PROPERTY_LAST_UPDATED).toDateTime();
}

QString ApplicationModel::getUserName() const {
    return getProperty(PROPERTY_USER_NAME).toString();
}

QString ApplicationModel::getTheme() const {
    return getProperty(PROPERTY_THEME).toString();
}

void ApplicationModel::setAppName(const QString &name) {
    setProperty(PROPERTY_APP_NAME, name);
}

void ApplicationModel::setAppVersion(const QString &version) {
    setProperty(PROPERTY_APP_VERSION, version);
}

void ApplicationModel::setAppTitle(const QString &title) {
    setProperty(PROPERTY_APP_TITLE, title);
}

void ApplicationModel::setStatusMessage(const QString &message) {
    setProperty(PROPERTY_STATUS_MESSAGE, message);
}

void ApplicationModel::setBusy(bool busy) {
    setProperty(PROPERTY_IS_BUSY, busy);
}

void ApplicationModel::setLastUpdated(const QDateTime &dateTime) {
    setProperty(PROPERTY_LAST_UPDATED, dateTime);
}

void ApplicationModel::setUserName(const QString &userName) {
    setProperty(PROPERTY_USER_NAME, userName);
}

void ApplicationModel::setTheme(const QString &theme) {
    setProperty(PROPERTY_THEME, theme);
}

void ApplicationModel::updateStatus(const QString &message) {
    setStatusMessage(message);
    setLastUpdated(QDateTime::currentDateTime());
}

void ApplicationModel::clearStatus() { setStatusMessage(QString()); }

bool ApplicationModel::loadSettings() {
    QSettings settings;

    settings.beginGroup("Application");
    setUserName(settings.value("userName", QString()).toString());
    setTheme(settings.value("theme", "default").toString());
    settings.endGroup();

    emit settingsLoaded();
    return true;
}

bool ApplicationModel::saveSettings() {
    QSettings settings;

    settings.beginGroup("Application");
    settings.setValue("userName", getUserName());
    settings.setValue("theme", getTheme());
    settings.endGroup();

    settings.sync();

    emit settingsSaved();
    return true;
}

bool ApplicationModel::initializeModel() {
    initializeDefaults();
    return true;
}

bool ApplicationModel::validateModel() const {
    // Check required properties
    if (getAppName().isEmpty() || getAppVersion().isEmpty()) {
        return false;
    }

    // Validate theme
    if (!isValidTheme(getTheme())) {
        return false;
    }

    return true;
}

void ApplicationModel::resetModel() { initializeDefaults(); }

bool ApplicationModel::beforePropertySet(const QString &propertyName,
                                         const QVariant &value) {
    // Validate theme before setting
    if (propertyName == PROPERTY_THEME) {
        return isValidTheme(value.toString());
    }

    return BaseModel::beforePropertySet(propertyName, value);
}

void ApplicationModel::afterPropertySet(const QString &propertyName,
                                        const QVariant &oldValue,
                                        const QVariant &newValue) {
    Q_UNUSED(oldValue)

    // Emit specific signals for certain properties
    if (propertyName == PROPERTY_STATUS_MESSAGE) {
        emit statusChanged(newValue.toString());
    } else if (propertyName == PROPERTY_IS_BUSY) {
        emit busyStateChanged(newValue.toBool());
    } else if (propertyName == PROPERTY_THEME) {
        emit themeChanged(newValue.toString());
    }

    BaseModel::afterPropertySet(propertyName, oldValue, newValue);
}

void ApplicationModel::initializeDefaults() {
    setPropertySilent(PROPERTY_APP_NAME, QCoreApplication::applicationName());
    setPropertySilent(PROPERTY_APP_VERSION,
                      QCoreApplication::applicationVersion());
    setPropertySilent(PROPERTY_APP_TITLE, "Qt Simple Template");
    setPropertySilent(PROPERTY_STATUS_MESSAGE, "Ready");
    setPropertySilent(PROPERTY_IS_BUSY, false);
    setPropertySilent(PROPERTY_LAST_UPDATED, QDateTime::currentDateTime());
    setPropertySilent(PROPERTY_USER_NAME, QString());
    setPropertySilent(PROPERTY_THEME, "default");
}

bool ApplicationModel::isValidTheme(const QString &theme) const {
    static const QStringList validThemes = {"default", "dark", "light"};
    return validThemes.contains(theme);
}
