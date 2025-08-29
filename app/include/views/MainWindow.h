#pragma once

#include <QAction>
#include <QCloseEvent>
#include <QLabel>
#include <QMainWindow>
#include <QMenuBar>
#include <QProgressBar>
#include <QPushButton>
#include <QShowEvent>
#include <QStatusBar>
#include <QToolBar>
#include <QWidget>
#include "views/BaseView.h"

class ApplicationModel;

/**
 * @brief Main window view for the application
 *
 * This class represents the main window of the application,
 * providing the primary user interface.
 */
class MainWindow : public QMainWindow, public IView {
    Q_OBJECT

public:
    explicit MainWindow(QWidget *parent = nullptr);
    virtual ~MainWindow() = default;

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

    /**
     * @brief Set the application model for data binding
     * @param model The application model
     */
    void setApplicationModel(ApplicationModel *model);

    /**
     * @brief Get the application model
     * @return The application model
     */
    ApplicationModel *getApplicationModel() const;

protected:
    /**
     * @brief Initialize the main window UI
     * @return true if initialization was successful
     */
    bool initializeUI();

    /**
     * @brief Setup the menu bar
     */
    void setupMenuBar();

    /**
     * @brief Setup the tool bar
     */
    void setupToolBar();

    /**
     * @brief Setup the status bar
     */
    void setupStatusBar();

    /**
     * @brief Setup the central widget
     */
    void setupCentralWidget();

    /**
     * @brief Connect signals and slots
     */
    void connectSignals();

    /**
     * @brief Update the window content
     */
    void updateContent();

    // Event handlers
    void closeEvent(QCloseEvent *event) override;
    void showEvent(QShowEvent *event) override;

private slots:
    void onNewAction();
    void onOpenAction();
    void onSaveAction();
    void onExitAction();
    void onAboutAction();
    void onAboutQtAction();
    void onTestButtonClicked();
    void onApplicationModelChanged();
    void onStatusChanged(const QString &message);
    void onBusyStateChanged(bool busy);
    void onThemeChanged(const QString &theme);

private:
    void createActions();
    void updateWindowTitle();
    void updateStatusBar();
    void applyTheme(const QString &theme);

    // UI components
    QWidget *m_centralWidget;
    QMenuBar *m_menuBar;
    QToolBar *m_toolBar;
    QStatusBar *m_statusBar;

    // Actions
    QAction *m_newAction;
    QAction *m_openAction;
    QAction *m_saveAction;
    QAction *m_exitAction;
    QAction *m_aboutAction;
    QAction *m_aboutQtAction;

    // Central widget components
    QLabel *m_titleLabel;
    QLabel *m_infoLabel;
    QPushButton *m_testButton;

    // Status bar components
    QLabel *m_statusLabel;
    QProgressBar *m_progressBar;

    // Data
    IController *m_controller;
    ApplicationModel *m_applicationModel;
    bool m_initialized;
};
