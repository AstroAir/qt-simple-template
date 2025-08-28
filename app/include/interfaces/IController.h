#pragma once

#include <QObject>
#include <QString>
#include <QVariant>

class IModel;
class IView;

/**
 * @brief Base interface for all controller classes
 *
 * This interface defines the common contract that all controller classes
 * should implement in the MVC architecture.
 */
class IController : public QObject {
    Q_OBJECT

public:
    explicit IController(QObject *parent = nullptr) : QObject(parent) {}
    virtual ~IController() = default;

    /**
     * @brief Initialize the controller
     * @return true if initialization was successful
     */
    virtual bool initialize() = 0;

    /**
     * @brief Set the model for this controller
     * @param model The model instance
     */
    virtual void setModel(IModel *model) = 0;

    /**
     * @brief Get the model for this controller
     * @return The model instance
     */
    virtual IModel *getModel() const = 0;

    /**
     * @brief Set the view for this controller
     * @param view The view instance
     */
    virtual void setView(IView *view) = 0;

    /**
     * @brief Get the view for this controller
     * @return The view instance
     */
    virtual IView *getView() const = 0;

    /**
     * @brief Handle a user action from the view
     * @param actionName The name of the action
     * @param data Optional data associated with the action
     */
    virtual void handleUserAction(const QString &actionName,
                                  const QVariant &data = QVariant()) = 0;

    /**
     * @brief Update the view based on model changes
     */
    virtual void updateView() = 0;

    /**
     * @brief Check if the controller is in a valid state
     * @return true if the controller is valid
     */
    virtual bool isValid() const = 0;

signals:
    /**
     * @brief Emitted when the controller state changes
     */
    void stateChanged();

    /**
     * @brief Emitted when an error occurs
     * @param message The error message
     */
    void errorOccurred(const QString &message);

    /**
     * @brief Emitted when an operation completes successfully
     * @param message Optional success message
     */
    void operationCompleted(const QString &message = QString());
};
