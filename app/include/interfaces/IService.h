#pragma once

#include <QObject>
#include <QString>
#include <QVariant>

/**
 * @brief Base interface for all service classes
 *
 * This interface defines the common contract that all service classes
 * should implement. Services provide business logic and data access.
 */
class IService : public QObject {
    Q_OBJECT

public:
    explicit IService(QObject *parent = nullptr) : QObject(parent) {}
    virtual ~IService() = default;

    /**
     * @brief Initialize the service
     * @return true if initialization was successful
     */
    virtual bool initialize() = 0;

    /**
     * @brief Start the service
     * @return true if the service started successfully
     */
    virtual bool start() = 0;

    /**
     * @brief Stop the service
     */
    virtual void stop() = 0;

    /**
     * @brief Check if the service is running
     * @return true if the service is running
     */
    virtual bool isRunning() const = 0;

    /**
     * @brief Get the service name
     * @return The service name
     */
    virtual QString getServiceName() const = 0;

    /**
     * @brief Get service configuration
     * @param key The configuration key
     * @return The configuration value
     */
    virtual QVariant getConfiguration(const QString &key) const = 0;

    /**
     * @brief Set service configuration
     * @param key The configuration key
     * @param value The configuration value
     * @return true if the configuration was set successfully
     */
    virtual bool setConfiguration(const QString &key,
                                  const QVariant &value) = 0;

signals:
    /**
     * @brief Emitted when the service starts
     */
    void serviceStarted();

    /**
     * @brief Emitted when the service stops
     */
    void serviceStopped();

    /**
     * @brief Emitted when a service error occurs
     * @param message The error message
     */
    void serviceError(const QString &message);

    /**
     * @brief Emitted when service configuration changes
     * @param key The configuration key that changed
     * @param value The new value
     */
    void configurationChanged(const QString &key, const QVariant &value);
};
