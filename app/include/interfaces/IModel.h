#pragma once

#include <QObject>
#include <QVariant>
#include <QString>

/**
 * @brief Base interface for all model classes
 * 
 * This interface defines the common contract that all model classes
 * should implement in the MVC architecture.
 */
class IModel : public QObject
{
    Q_OBJECT

public:
    explicit IModel(QObject *parent = nullptr) : QObject(parent) {}
    virtual ~IModel() = default;

    /**
     * @brief Initialize the model
     * @return true if initialization was successful
     */
    virtual bool initialize() = 0;

    /**
     * @brief Check if the model is valid
     * @return true if the model is in a valid state
     */
    virtual bool isValid() const = 0;

    /**
     * @brief Get a property value by name
     * @param propertyName The name of the property
     * @return The property value
     */
    virtual QVariant getProperty(const QString &propertyName) const = 0;

    /**
     * @brief Set a property value by name
     * @param propertyName The name of the property
     * @param value The new value
     * @return true if the property was set successfully
     */
    virtual bool setProperty(const QString &propertyName, const QVariant &value) = 0;

    /**
     * @brief Reset the model to its default state
     */
    virtual void reset() = 0;

signals:
    /**
     * @brief Emitted when the model data changes
     */
    void dataChanged();

    /**
     * @brief Emitted when a property changes
     * @param propertyName The name of the changed property
     * @param newValue The new value
     */
    void propertyChanged(const QString &propertyName, const QVariant &newValue);

    /**
     * @brief Emitted when the model's validity state changes
     * @param isValid The new validity state
     */
    void validityChanged(bool isValid);
};
