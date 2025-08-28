#pragma once

#include "interfaces/IView.h"
#include <QWidget>
#include <QVBoxLayout>
#include <QHBoxLayout>
#include <QLabel>
#include <QMessageBox>

class IController;

/**
 * @brief Base implementation of IView interface
 * 
 * This class provides a basic implementation of the IView interface
 * with common UI functionality and layout management.
 */
class BaseView : public IView
{
    Q_OBJECT

public:
    explicit BaseView(QWidget *parent = nullptr);
    virtual ~BaseView() = default;

    // IView interface implementation
    bool initialize() override;
    void setController(IController *controller) override;
    IController* getController() const override;
    void updateView() override;
    void showError(const QString &message) override;
    void showInfo(const QString &message) override;
    void setViewEnabled(bool enabled) override;
    bool isViewValid() const override;

protected:
    /**
     * @brief Initialize view-specific UI
     * Override this method in derived classes for custom UI setup
     * @return true if initialization was successful
     */
    virtual bool initializeUI();

    /**
     * @brief Setup the main layout
     * Override this method in derived classes for custom layout
     */
    virtual void setupLayout();

    /**
     * @brief Connect signals and slots
     * Override this method in derived classes for custom connections
     */
    virtual void connectSignals();

    /**
     * @brief Update view-specific content
     * Override this method in derived classes for custom updates
     */
    virtual void updateContent();

    /**
     * @brief Validate the view state
     * Override this method in derived classes for custom validation
     * @return true if the view is valid
     */
    virtual bool validateView() const;

    /**
     * @brief Handle view closing
     * Override this method in derived classes for custom cleanup
     */
    virtual void handleViewClosing();

    /**
     * @brief Get the main layout
     * @return The main layout widget
     */
    QVBoxLayout* getMainLayout() const;

    /**
     * @brief Create a horizontal layout with widgets
     * @param widgets List of widgets to add
     * @return The created layout
     */
    QHBoxLayout* createHorizontalLayout(const QList<QWidget*> &widgets = {});

    /**
     * @brief Create a vertical layout with widgets
     * @param widgets List of widgets to add
     * @return The created layout
     */
    QVBoxLayout* createVerticalLayout(const QList<QWidget*> &widgets = {});

    /**
     * @brief Add a separator line
     */
    void addSeparator();

    /**
     * @brief Set the status text
     * @param text The status text
     */
    void setStatusText(const QString &text);

    /**
     * @brief Get the status text
     * @return The current status text
     */
    QString getStatusText() const;

    // Event handlers
    void closeEvent(QCloseEvent *event) override;

private slots:
    void onControllerStateChanged();

private:
    IController *m_controller;
    QVBoxLayout *m_mainLayout;
    QLabel *m_statusLabel;
    bool m_initialized;
};
