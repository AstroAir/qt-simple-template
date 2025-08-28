#pragma once

#include "interfaces/IController.h"
#include <QObject>

class IModel;
class IView;

/**
 * @brief Base implementation of IController interface
 * 
 * This class provides a basic implementation of the IController interface
 * with common controller functionality and MVC coordination.
 */
class BaseController : public IController
{
    Q_OBJECT

public:
    explicit BaseController(QObject *parent = nullptr);
    virtual ~BaseController() = default;

    // IController interface implementation
    bool initialize() override;
    void setModel(IModel *model) override;
    IModel* getModel() const override;
    void setView(IView *view) override;
    IView* getView() const override;
    void handleUserAction(const QString &actionName, const QVariant &data = QVariant()) override;
    void updateView() override;
    bool isValid() const override;

protected:
    /**
     * @brief Initialize controller-specific logic
     * Override this method in derived classes for custom initialization
     * @return true if initialization was successful
     */
    virtual bool initializeController();

    /**
     * @brief Connect model and view signals
     * Override this method in derived classes for custom connections
     */
    virtual void connectModelAndView();

    /**
     * @brief Handle controller-specific user actions
     * Override this method in derived classes for custom action handling
     * @param actionName The name of the action
     * @param data Optional data associated with the action
     * @return true if the action was handled
     */
    virtual bool handleControllerAction(const QString &actionName, const QVariant &data);

    /**
     * @brief Validate the controller state
     * Override this method in derived classes for custom validation
     * @return true if the controller is valid
     */
    virtual bool validateController() const;

    /**
     * @brief Update controller-specific state
     * Override this method in derived classes for custom updates
     */
    virtual void updateControllerState();

    /**
     * @brief Handle model data changes
     * Override this method in derived classes for custom model handling
     */
    virtual void onModelDataChanged();

    /**
     * @brief Handle view update requests
     * Override this method in derived classes for custom view handling
     */
    virtual void onViewUpdateRequested();

    /**
     * @brief Handle view closing
     * Override this method in derived classes for custom cleanup
     */
    virtual void onViewClosing();

    /**
     * @brief Emit an error signal
     * @param message The error message
     */
    void emitError(const QString &message);

    /**
     * @brief Emit an operation completed signal
     * @param message Optional success message
     */
    void emitOperationCompleted(const QString &message = QString());

private slots:
    void onModelDataChangedSlot();
    void onViewUpdateRequestedSlot();
    void onViewClosingSlot();
    void onUserActionSlot(const QString &actionName, const QVariant &data);

private:
    IModel *m_model;
    IView *m_view;
    bool m_initialized;
};
