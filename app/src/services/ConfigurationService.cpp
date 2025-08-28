#include "services/ConfigurationService.h"
#include <QStandardPaths>
#include <QDir>
#include <QDebug>

ConfigurationService::ConfigurationService(QObject *parent)
    : IService(parent)
    , m_settings(nullptr)
    , m_running(false)
{
}

bool ConfigurationService::initialize()
{
    setupSettings();
    initializeDefaults();
    return true;
}

bool ConfigurationService::start()
{
    if (m_running) {
        return true;
    }

    if (!loadConfiguration()) {
        emit serviceError(tr("Failed to load configuration"));
        return false;
    }

    m_running = true;
    emit serviceStarted();
    return true;
}

void ConfigurationService::stop()
{
    if (!m_running) {
        return;
    }

    saveConfiguration();
    m_running = false;
    emit serviceStopped();
}

bool ConfigurationService::isRunning() const
{
    return m_running;
}

QString ConfigurationService::getServiceName() const
{
    return tr("Configuration Service");
}

QVariant ConfigurationService::getConfiguration(const QString &key) const
{
    // First check cache
    if (m_cache.contains(key)) {
        return m_cache.value(key);
    }

    // Then check settings
    if (m_settings) {
        return m_settings->value(key);
    }

    return QVariant();
}

bool ConfigurationService::setConfiguration(const QString &key, const QVariant &value)
{
    QVariant oldValue = getConfiguration(key);

    // Update cache
    m_cache[key] = value;

    // Update settings
    if (m_settings) {
        m_settings->setValue(key, value);
    }

    // Emit signals
    emit configurationChanged(key, value);
    
    return true;
}

QVariant ConfigurationService::getConfiguration(const QString &key, const QVariant &defaultValue) const
{
    QVariant value = getConfiguration(key);
    return value.isValid() ? value : defaultValue;
}

bool ConfigurationService::hasConfiguration(const QString &key) const
{
    return m_cache.contains(key) || (m_settings && m_settings->contains(key));
}

bool ConfigurationService::removeConfiguration(const QString &key)
{
    // Remove from cache
    m_cache.remove(key);

    // Remove from settings
    if (m_settings) {
        m_settings->remove(key);
    }

    emit configurationChanged(key, QVariant());
    return true;
}

QStringList ConfigurationService::getAllKeys() const
{
    QStringList keys;

    // Add keys from cache
    keys.append(m_cache.keys());

    // Add keys from settings
    if (m_settings) {
        keys.append(m_settings->allKeys());
    }

    // Remove duplicates
    keys.removeDuplicates();
    return keys;
}

void ConfigurationService::clearConfiguration()
{
    m_cache.clear();

    if (m_settings) {
        m_settings->clear();
    }

    emit configurationChanged(QString(), QVariant());
}

bool ConfigurationService::saveConfiguration()
{
    if (!m_settings) {
        return false;
    }

    // Sync cache to settings
    for (auto it = m_cache.constBegin(); it != m_cache.constEnd(); ++it) {
        m_settings->setValue(it.key(), it.value());
    }

    m_settings->sync();

    emit configurationSaved();
    return true;
}

bool ConfigurationService::loadConfiguration()
{
    if (!m_settings) {
        return false;
    }

    // Load all settings into cache
    m_cache.clear();
    QStringList keys = m_settings->allKeys();
    for (const QString &key : keys) {
        m_cache[key] = m_settings->value(key);
    }

    emit configurationLoaded();
    return true;
}

void ConfigurationService::resetToDefaults()
{
    clearConfiguration();
    initializeDefaults();
    emit configurationReset();
}

void ConfigurationService::setConfigurationFile(const QString &filePath)
{
    if (m_configurationFile == filePath) {
        return;
    }

    m_configurationFile = filePath;
    setupSettings();
}

QString ConfigurationService::getConfigurationFile() const
{
    return m_configurationFile;
}

void ConfigurationService::initializeDefaults()
{
    // Set default configuration values
    if (!hasConfiguration("application/theme")) {
        setConfiguration("application/theme", "default");
    }
    
    if (!hasConfiguration("application/language")) {
        setConfiguration("application/language", "en");
    }
    
    if (!hasConfiguration("window/width")) {
        setConfiguration("window/width", 1000);
    }
    
    if (!hasConfiguration("window/height")) {
        setConfiguration("window/height", 700);
    }
    
    if (!hasConfiguration("window/maximized")) {
        setConfiguration("window/maximized", false);
    }
}

void ConfigurationService::setupSettings()
{
    // Clean up old settings
    if (m_settings) {
        delete m_settings;
        m_settings = nullptr;
    }

    // Create new settings
    if (m_configurationFile.isEmpty()) {
        // Use default application settings
        m_settings = new QSettings(this);
    } else {
        // Use custom configuration file
        m_settings = new QSettings(m_configurationFile, QSettings::IniFormat, this);
    }
}
