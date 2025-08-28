#pragma once

#include <QHash>
#include <QMutex>
#include <QString>
#include <QVariant>
#include "interfaces/IModel.h"

/**
 * @brief Base implementation of IModel interface
 *
 * This class provides a basic implementation of the IModel interface
 * with property management and thread safety.
 */
class BaseModel : public IModel {
    Q_OBJECT

public:
    explicit BaseModel(QObject *parent = nullptr);
    virtual ~BaseModel() = default;

    // IModel interface implementation
    bool initialize() override;
    bool isValid() const override;
    QVariant getProperty(const QString &propertyName) const override;
    bool setProperty(const QString &propertyName,
                     const QVariant &value) override;
    void reset() override;

protected:
    /**
     * @brief Initialize model-specific data
     * Override this method in derived classes for custom initialization
     * @return true if initialization was successful
     */
    virtual bool initializeModel();

    /**
     * @brief Validate the model state
     * Override this method in derived classes for custom validation
     * @return true if the model is valid
     */
    virtual bool validateModel() const;

    /**
     * @brief Reset model-specific data
     * Override this method in derived classes for custom reset logic
     */
    virtual void resetModel();

    /**
     * @brief Called before a property is set
     * Override this method to add custom validation or preprocessing
     * @param propertyName The name of the property
     * @param value The new value
     * @return true if the property should be set
     */
    virtual bool beforePropertySet(const QString &propertyName,
                                   const QVariant &value);

    /**
     * @brief Called after a property is set
     * Override this method to add custom post-processing
     * @param propertyName The name of the property
     * @param oldValue The old value
     * @param newValue The new value
     */
    virtual void afterPropertySet(const QString &propertyName,
                                  const QVariant &oldValue,
                                  const QVariant &newValue);

    /**
     * @brief Set a property without triggering signals (for internal use)
     * @param propertyName The name of the property
     * @param value The new value
     */
    void setPropertySilent(const QString &propertyName, const QVariant &value);

    /**
     * @brief Check if a property exists
     * @param propertyName The name of the property
     * @return true if the property exists
     */
    bool hasProperty(const QString &propertyName) const;

    /**
     * @brief Get all property names
     * @return List of all property names
     */
    QStringList getPropertyNames() const;

    /**
     * @brief Clear all properties
     */
    void clearProperties();

private:
    QHash<QString, QVariant> m_properties;
    mutable QMutex m_mutex;
    bool m_initialized;
};
