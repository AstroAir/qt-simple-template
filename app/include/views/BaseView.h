#pragma once

#include <QHBoxLayout>
#include <QLabel>
#include <QMessageBox>
#include <QVBoxLayout>
#include <QWidget>
#include "interfaces/IView.h"

class IController;

/**
 * @brief Base implementation of IView interface
 *
 * This class provides a basic implementation of the IView interface
 * with common UI functionality and layout management.
 */
class BaseView : public QWidget, public IView {
    Q_OBJECT

public:
    explicit BaseView(QWidget *parent = nullptr);
    virtual ~BaseView() = default;

signals:
    // Qt signals for this view class
    void viewUpdateRequested();
    void userAction(const QString &actionName, const QVariant &data = QVariant());
    void viewClosing();

    // IView interface implementation - declared as virtual to avoid MOC conflicts
    virtual bool initialize() override;
    virtual void setController(IController *controller) override;
    virtual IController *getController() const override;
    virtual void updateView() override;
    virtual void showError(const QString &message) override;
    virtual void showInfo(const QString &message) override;
    virtual void setViewEnabled(bool enabled) override;
    virtual bool isViewValid() const override;

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
    QVBoxLayout *getMainLayout() const;

    /**
     * @brief Create a horizontal layout with widgets
     * @param widgets List of widgets to add
     * @return The created layout
     */
    QHBoxLayout *createHorizontalLayout(const QList<QWidget *> &widgets = {});

    /**
     * @brief Create a vertical layout with widgets
     * @param widgets List of widgets to add
     * @return The created layout
     */
    QVBoxLayout *createVerticalLayout(const QList<QWidget *> &widgets = {});

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
