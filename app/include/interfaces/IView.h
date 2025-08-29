#pragma once

#include <QString>
#include <QWidget>

class IController;

/**
 * @brief Base interface for all view classes
 *
 * This interface defines the common contract that all view classes
 * should implement in the MVC architecture.
 */
class IView {
public:
    IView() = default;
    virtual ~IView() = default;

    /**
     * @brief Initialize the view
     * @return true if initialization was successful
     */
    virtual bool initialize() = 0;

    /**
     * @brief Set the controller for this view
     * @param controller The controller instance
     */
    virtual void setController(IController *controller) = 0;

    /**
     * @brief Get the controller for this view
     * @return The controller instance
     */
    virtual IController *getController() const = 0;

    /**
     * @brief Update the view with new data
     */
    virtual void updateView() = 0;

    /**
     * @brief Show an error message
     * @param message The error message to display
     */
    virtual void showError(const QString &message) = 0;

    /**
     * @brief Show an information message
     * @param message The information message to display
     */
    virtual void showInfo(const QString &message) = 0;

    /**
     * @brief Enable or disable the view
     * @param enabled Whether the view should be enabled
     */
    virtual void setViewEnabled(bool enabled) = 0;

    /**
     * @brief Check if the view is in a valid state
     * @return true if the view is valid
     */
    virtual bool isViewValid() const = 0;

signals:
    /**
     * @brief Emitted when the view needs to be updated
     */
    void viewUpdateRequested();

    /**
     * @brief Emitted when the user performs an action
     * @param actionName The name of the action
     * @param data Optional data associated with the action
     */
    void userAction(const QString &actionName,
                    const QVariant &data = QVariant());

    /**
     * @brief Emitted when the view is about to close
     */
    void viewClosing();
};
