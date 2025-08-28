#pragma once

#include <QHash>
#include <QSettings>
#include <QString>
#include <QVariant>
#include "interfaces/IService.h"

/**
 * @brief Configuration service for managing application settings
 *
 * This service provides centralized configuration management
 * with support for different configuration sources.
 */
class ConfigurationService : public IService {
    Q_OBJECT

public:
    explicit ConfigurationService(QObject *parent = nullptr);
    virtual ~ConfigurationService() = default;

    // IService interface implementation
    bool initialize() override;
    bool start() override;
    void stop() override;
    bool isRunning() const override;
    QString getServiceName() const override;
    QVariant getConfiguration(const QString &key) const override;
    bool setConfiguration(const QString &key, const QVariant &value) override;

    /**
     * @brief Get configuration value with default
     * @param key The configuration key
     * @param defaultValue The default value if key doesn't exist
     * @return The configuration value or default
     */
    QVariant getConfiguration(const QString &key,
                              const QVariant &defaultValue) const;

    /**
     * @brief Check if a configuration key exists
     * @param key The configuration key
     * @return true if the key exists
     */
    bool hasConfiguration(const QString &key) const;

    /**
     * @brief Remove a configuration key
     * @param key The configuration key
     * @return true if the key was removed
     */
    bool removeConfiguration(const QString &key);

    /**
     * @brief Get all configuration keys
     * @return List of all configuration keys
     */
    QStringList getAllKeys() const;

    /**
     * @brief Clear all configuration
     */
    void clearConfiguration();

    /**
     * @brief Save configuration to persistent storage
     * @return true if save was successful
     */
    bool saveConfiguration();

    /**
     * @brief Load configuration from persistent storage
     * @return true if load was successful
     */
    bool loadConfiguration();

    /**
     * @brief Reset configuration to defaults
     */
    void resetToDefaults();

    /**
     * @brief Set configuration file path
     * @param filePath The path to the configuration file
     */
    void setConfigurationFile(const QString &filePath);

    /**
     * @brief Get configuration file path
     * @return The path to the configuration file
     */
    QString getConfigurationFile() const;

signals:
    /**
     * @brief Emitted when configuration is loaded
     */
    void configurationLoaded();

    /**
     * @brief Emitted when configuration is saved
     */
    void configurationSaved();

    /**
     * @brief Emitted when configuration is reset
     */
    void configurationReset();

private:
    void initializeDefaults();
    void setupSettings();

    QSettings *m_settings;
    QHash<QString, QVariant> m_cache;
    QString m_configurationFile;
    bool m_running;
};
