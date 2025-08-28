#pragma once

#include "controllers/BaseController.h"
#include <QString>
#include <QTimer>

class ApplicationModel;
class MainWindow;

/**
 * @brief Main application controller
 * 
 * This controller manages the main application logic and coordinates
 * between the application model and main window view.
 */
class ApplicationController : public BaseController
{
    Q_OBJECT

public:
    explicit ApplicationController(QObject *parent = nullptr);
    virtual ~ApplicationController() = default;

    /**
     * @brief Set the application model
     * @param model The application model
     */
    void setApplicationModel(ApplicationModel *model);

    /**
     * @brief Get the application model
     * @return The application model
     */
    ApplicationModel* getApplicationModel() const;

    /**
     * @brief Set the main window view
     * @param mainWindow The main window
     */
    void setMainWindow(MainWindow *mainWindow);

    /**
     * @brief Get the main window view
     * @return The main window
     */
    MainWindow* getMainWindow() const;

    /**
     * @brief Initialize the application
     * @return true if initialization was successful
     */
    bool initializeApplication();

    /**
     * @brief Start the application
     */
    void startApplication();

    /**
     * @brief Stop the application
     */
    void stopApplication();

protected:
    bool initializeController() override;
    void connectModelAndView() override;
    bool handleControllerAction(const QString &actionName, const QVariant &data) override;
    bool validateController() const override;
    void updateControllerState() override;
    void onModelDataChanged() override;
    void onViewUpdateRequested() override;
    void onViewClosing() override;

private slots:
    void onNewAction();
    void onOpenAction();
    void onSaveAction();
    void onTestAction(const QVariant &data);
    void onApplicationModelStatusChanged(const QString &message);
    void onApplicationModelBusyStateChanged(bool busy);
    void onApplicationModelThemeChanged(const QString &theme);
    void onStatusUpdateTimer();

private:
    void setupStatusTimer();
    void performTestOperation();
    void simulateLongOperation();
    void loadApplicationSettings();
    void saveApplicationSettings();
    void updateApplicationStatus(const QString &message);

    ApplicationModel *m_applicationModel;
    MainWindow *m_mainWindow;
    QTimer *m_statusTimer;
    bool m_applicationStarted;
};
