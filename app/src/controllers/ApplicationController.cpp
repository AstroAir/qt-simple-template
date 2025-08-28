#include "controllers/ApplicationController.h"
#include <QCoreApplication>
#include <QDebug>
#include <QThread>
#include <QTimer>
#include "models/ApplicationModel.h"
#include "views/MainWindow.h"

ApplicationController::ApplicationController(QObject *parent)
    : BaseController(parent),
      m_applicationModel(nullptr),
      m_mainWindow(nullptr),
      m_statusTimer(nullptr),
      m_applicationStarted(false) {}

void ApplicationController::setApplicationModel(ApplicationModel *model) {
    if (m_applicationModel == model) {
        return;
    }

    // Disconnect from old model
    if (m_applicationModel) {
        disconnect(m_applicationModel, nullptr, this, nullptr);
    }

    m_applicationModel = model;
    setModel(model);  // Set in base class

    // Connect to application-specific signals
    if (m_applicationModel) {
        connect(m_applicationModel, &ApplicationModel::statusChanged, this,
                &ApplicationController::onApplicationModelStatusChanged);
        connect(m_applicationModel, &ApplicationModel::busyStateChanged, this,
                &ApplicationController::onApplicationModelBusyStateChanged);
        connect(m_applicationModel, &ApplicationModel::themeChanged, this,
                &ApplicationController::onApplicationModelThemeChanged);
    }
}

ApplicationModel *ApplicationController::getApplicationModel() const {
    return m_applicationModel;
}

void ApplicationController::setMainWindow(MainWindow *mainWindow) {
    if (m_mainWindow == mainWindow) {
        return;
    }

    m_mainWindow = mainWindow;
    setView(mainWindow);  // Set in base class

    // Set the application model in the main window
    if (m_mainWindow && m_applicationModel) {
        m_mainWindow->setApplicationModel(m_applicationModel);
    }
}

MainWindow *ApplicationController::getMainWindow() const {
    return m_mainWindow;
}

bool ApplicationController::initializeApplication() {
    if (!m_applicationModel || !m_mainWindow) {
        emitError(tr("Application model or main window not set"));
        return false;
    }

    // Initialize the model
    if (!m_applicationModel->initialize()) {
        emitError(tr("Failed to initialize application model"));
        return false;
    }

    // Initialize the view
    if (!m_mainWindow->initialize()) {
        emitError(tr("Failed to initialize main window"));
        return false;
    }

    // Initialize the controller
    if (!initialize()) {
        emitError(tr("Failed to initialize application controller"));
        return false;
    }

    // Load settings
    loadApplicationSettings();

    return true;
}

void ApplicationController::startApplication() {
    if (m_applicationStarted) {
        return;
    }

    updateApplicationStatus(tr("Starting application..."));

    // Setup status timer
    setupStatusTimer();

    // Show the main window
    if (m_mainWindow) {
        m_mainWindow->show();
    }

    m_applicationStarted = true;
    updateApplicationStatus(tr("Application started"));

    emitOperationCompleted(tr("Application started successfully"));
}

void ApplicationController::stopApplication() {
    if (!m_applicationStarted) {
        return;
    }

    updateApplicationStatus(tr("Stopping application..."));

    // Stop status timer
    if (m_statusTimer) {
        m_statusTimer->stop();
    }

    // Save settings
    saveApplicationSettings();

    m_applicationStarted = false;
    updateApplicationStatus(tr("Application stopped"));
}

bool ApplicationController::initializeController() {
    // Setup status timer
    setupStatusTimer();

    return BaseController::initializeController();
}

void ApplicationController::connectModelAndView() {
    BaseController::connectModelAndView();

    // Additional connections can be made here if needed
}

bool ApplicationController::handleControllerAction(const QString &actionName,
                                                   const QVariant &data) {
    if (actionName == "new") {
        onNewAction();
        return true;
    } else if (actionName == "open") {
        onOpenAction();
        return true;
    } else if (actionName == "save") {
        onSaveAction();
        return true;
    } else if (actionName == "test") {
        onTestAction(data);
        return true;
    }

    return BaseController::handleControllerAction(actionName, data);
}

bool ApplicationController::validateController() const {
    return BaseController::validateController() &&
           m_applicationModel != nullptr && m_mainWindow != nullptr;
}

void ApplicationController::updateControllerState() {
    BaseController::updateControllerState();

    // Update application-specific state
    if (m_applicationModel) {
        m_applicationModel->setLastUpdated(QDateTime::currentDateTime());
    }
}

void ApplicationController::onModelDataChanged() {
    BaseController::onModelDataChanged();

    // Handle application model changes
    if (m_mainWindow) {
        m_mainWindow->updateView();
    }
}

void ApplicationController::onViewUpdateRequested() {
    BaseController::onViewUpdateRequested();
}

void ApplicationController::onViewClosing() {
    stopApplication();
    BaseController::onViewClosing();
}

void ApplicationController::onNewAction() {
    updateApplicationStatus(tr("Creating new document..."));

    // Simulate some work
    QThread::msleep(500);

    updateApplicationStatus(tr("New document created"));
    emitOperationCompleted(tr("New document created successfully"));
}

void ApplicationController::onOpenAction() {
    updateApplicationStatus(tr("Opening document..."));

    // Simulate some work
    QThread::msleep(800);

    updateApplicationStatus(tr("Document opened"));
    emitOperationCompleted(tr("Document opened successfully"));
}

void ApplicationController::onSaveAction() {
    updateApplicationStatus(tr("Saving document..."));

    // Simulate some work
    QThread::msleep(600);

    updateApplicationStatus(tr("Document saved"));
    emitOperationCompleted(tr("Document saved successfully"));
}

void ApplicationController::onTestAction(const QVariant &data) {
    QString message = data.toString();
    if (message.isEmpty()) {
        message = tr("Test action performed");
    }

    updateApplicationStatus(tr("Performing test action..."));
    performTestOperation();
    updateApplicationStatus(message);

    emitOperationCompleted(message);
}

void ApplicationController::onApplicationModelStatusChanged(
    const QString &message) {
    qDebug() << "Application status changed:" << message;
}

void ApplicationController::onApplicationModelBusyStateChanged(bool busy) {
    qDebug() << "Application busy state changed:" << busy;
}

void ApplicationController::onApplicationModelThemeChanged(
    const QString &theme) {
    qDebug() << "Application theme changed:" << theme;
    updateApplicationStatus(tr("Theme changed to: %1").arg(theme));
}

void ApplicationController::onStatusUpdateTimer() {
    if (m_applicationModel) {
        QString currentTime = QDateTime::currentDateTime().toString("hh:mm:ss");
        // Don't update status if the application is busy
        if (!m_applicationModel->isBusy()) {
            updateApplicationStatus(tr("Ready - %1").arg(currentTime));
        }
    }
}

void ApplicationController::setupStatusTimer() {
    if (!m_statusTimer) {
        m_statusTimer = new QTimer(this);
        connect(m_statusTimer, &QTimer::timeout, this,
                &ApplicationController::onStatusUpdateTimer);
    }

    m_statusTimer->start(30000);  // Update every 30 seconds
}

void ApplicationController::performTestOperation() {
    // Simulate a test operation
    if (m_applicationModel) {
        m_applicationModel->setBusy(true);
    }

    QThread::msleep(1000);  // Simulate work

    if (m_applicationModel) {
        m_applicationModel->setBusy(false);
    }
}

void ApplicationController::simulateLongOperation() {
    if (m_applicationModel) {
        m_applicationModel->setBusy(true);
    }

    updateApplicationStatus(tr("Performing long operation..."));
    QThread::msleep(3000);  // Simulate long work

    if (m_applicationModel) {
        m_applicationModel->setBusy(false);
    }

    updateApplicationStatus(tr("Long operation completed"));
}

void ApplicationController::loadApplicationSettings() {
    if (m_applicationModel) {
        m_applicationModel->loadSettings();
        updateApplicationStatus(tr("Settings loaded"));
    }
}

void ApplicationController::saveApplicationSettings() {
    if (m_applicationModel) {
        m_applicationModel->saveSettings();
        updateApplicationStatus(tr("Settings saved"));
    }
}

void ApplicationController::updateApplicationStatus(const QString &message) {
    if (m_applicationModel) {
        m_applicationModel->updateStatus(message);
    }
}
