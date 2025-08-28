#include "models/BaseModel.h"
#include <QMutexLocker>
#include <QDebug>

BaseModel::BaseModel(QObject *parent)
    : IModel(parent)
    , m_initialized(false)
{
}

bool BaseModel::initialize()
{
    QMutexLocker locker(&m_mutex);
    
    if (m_initialized) {
        return true;
    }
    
    // Initialize base properties
    clearProperties();
    
    // Call derived class initialization
    bool result = initializeModel();
    
    if (result) {
        m_initialized = true;
        emit dataChanged();
        emit validityChanged(isValid());
    }
    
    return result;
}

bool BaseModel::isValid() const
{
    QMutexLocker locker(&m_mutex);
    return m_initialized && validateModel();
}

QVariant BaseModel::getProperty(const QString &propertyName) const
{
    QMutexLocker locker(&m_mutex);
    return m_properties.value(propertyName);
}

bool BaseModel::setProperty(const QString &propertyName, const QVariant &value)
{
    QMutexLocker locker(&m_mutex);
    
    // Check if we should set this property
    if (!beforePropertySet(propertyName, value)) {
        return false;
    }
    
    QVariant oldValue = m_properties.value(propertyName);
    
    // Only proceed if the value actually changed
    if (oldValue == value) {
        return true;
    }
    
    m_properties[propertyName] = value;
    
    // Unlock before emitting signals to avoid deadlock
    locker.unlock();
    
    // Call post-processing
    afterPropertySet(propertyName, oldValue, value);
    
    // Emit signals
    emit propertyChanged(propertyName, value);
    emit dataChanged();
    
    // Check if validity changed
    bool currentValidity = isValid();
    emit validityChanged(currentValidity);
    
    return true;
}

void BaseModel::reset()
{
    QMutexLocker locker(&m_mutex);
    
    clearProperties();
    resetModel();
    
    locker.unlock();
    
    emit dataChanged();
    emit validityChanged(isValid());
}

bool BaseModel::initializeModel()
{
    // Default implementation - override in derived classes
    return true;
}

bool BaseModel::validateModel() const
{
    // Default implementation - override in derived classes
    return true;
}

void BaseModel::resetModel()
{
    // Default implementation - override in derived classes
}

bool BaseModel::beforePropertySet(const QString &propertyName, const QVariant &value)
{
    Q_UNUSED(propertyName)
    Q_UNUSED(value)
    // Default implementation - override in derived classes
    return true;
}

void BaseModel::afterPropertySet(const QString &propertyName, const QVariant &oldValue, const QVariant &newValue)
{
    Q_UNUSED(propertyName)
    Q_UNUSED(oldValue)
    Q_UNUSED(newValue)
    // Default implementation - override in derived classes
}

void BaseModel::setPropertySilent(const QString &propertyName, const QVariant &value)
{
    m_properties[propertyName] = value;
}

bool BaseModel::hasProperty(const QString &propertyName) const
{
    QMutexLocker locker(&m_mutex);
    return m_properties.contains(propertyName);
}

QStringList BaseModel::getPropertyNames() const
{
    QMutexLocker locker(&m_mutex);
    return m_properties.keys();
}

void BaseModel::clearProperties()
{
    m_properties.clear();
}
