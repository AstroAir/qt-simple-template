#include "views/MainWindow.h"
#include "models/ApplicationModel.h"
#include "interfaces/IController.h"
#include <QApplication>
#include <QVBoxLayout>
#include <QHBoxLayout>
#include <QMenuBar>
#include <QStatusBar>
#include <QToolBar>
#include <QAction>
#include <QPushButton>
#include <QLabel>
#include <QProgressBar>
#include <QMessageBox>
#include <QCloseEvent>
#include <QShowEvent>
#include <QDebug>

MainWindow::MainWindow(QWidget *parent)
    : QMainWindow(parent)
    , m_centralWidget(nullptr)
    , m_menuBar(nullptr)
    , m_toolBar(nullptr)
    , m_statusBar(nullptr)
    , m_newAction(nullptr)
    , m_openAction(nullptr)
    , m_saveAction(nullptr)
    , m_exitAction(nullptr)
    , m_aboutAction(nullptr)
    , m_aboutQtAction(nullptr)
    , m_titleLabel(nullptr)
    , m_infoLabel(nullptr)
    , m_testButton(nullptr)
    , m_statusLabel(nullptr)
    , m_progressBar(nullptr)
    , m_controller(nullptr)
    , m_applicationModel(nullptr)
    , m_initialized(false)
{
    setWindowTitle(tr("Qt Simple Template"));
    setMinimumSize(800, 600);
    resize(1000, 700);
}

bool MainWindow::initialize()
{
    if (m_initialized) {
        return true;
    }

    bool result = initializeUI();
    
    if (result) {
        connectSignals();
        m_initialized = true;
        updateView();
    }

    return result;
}

void MainWindow::setController(IController *controller)
{
    if (m_controller == controller) {
        return;
    }

    // Disconnect from old controller
    if (m_controller) {
        disconnect(m_controller, nullptr, this, nullptr);
    }

    m_controller = controller;

    // Connect to new controller
    if (m_controller) {
        connect(m_controller, &IController::stateChanged,
                this, &MainWindow::updateView);
        connect(m_controller, &IController::errorOccurred,
                this, &MainWindow::showError);
        connect(m_controller, &IController::operationCompleted,
                this, &MainWindow::showInfo);
    }
}

IController* MainWindow::getController() const
{
    return m_controller;
}

void MainWindow::updateView()
{
    if (!m_initialized) {
        return;
    }

    updateContent();
    emit viewUpdateRequested();
}

void MainWindow::showError(const QString &message)
{
    QMessageBox::critical(this, tr("Error"), message);
}

void MainWindow::showInfo(const QString &message)
{
    if (!message.isEmpty()) {
        QMessageBox::information(this, tr("Information"), message);
    }
}

void MainWindow::setViewEnabled(bool enabled)
{
    setEnabled(enabled);
    if (m_toolBar) {
        m_toolBar->setEnabled(enabled);
    }
    if (m_menuBar) {
        m_menuBar->setEnabled(enabled);
    }
}

bool MainWindow::isViewValid() const
{
    return m_initialized && m_centralWidget != nullptr;
}

void MainWindow::setApplicationModel(ApplicationModel *model)
{
    if (m_applicationModel == model) {
        return;
    }

    // Disconnect from old model
    if (m_applicationModel) {
        disconnect(m_applicationModel, nullptr, this, nullptr);
    }

    m_applicationModel = model;

    // Connect to new model
    if (m_applicationModel) {
        connect(m_applicationModel, &ApplicationModel::dataChanged,
                this, &MainWindow::onApplicationModelChanged);
        connect(m_applicationModel, &ApplicationModel::statusChanged,
                this, &MainWindow::onStatusChanged);
        connect(m_applicationModel, &ApplicationModel::busyStateChanged,
                this, &MainWindow::onBusyStateChanged);
        connect(m_applicationModel, &ApplicationModel::themeChanged,
                this, &MainWindow::onThemeChanged);
    }

    updateView();
}

ApplicationModel* MainWindow::getApplicationModel() const
{
    return m_applicationModel;
}

bool MainWindow::initializeUI()
{
    // Create actions
    createActions();

    // Setup UI components
    setupMenuBar();
    setupToolBar();
    setupStatusBar();
    setupCentralWidget();

    return true;
}

void MainWindow::setupMenuBar()
{
    m_menuBar = menuBar();

    // File menu
    QMenu *fileMenu = m_menuBar->addMenu(tr("&File"));
    fileMenu->addAction(m_newAction);
    fileMenu->addAction(m_openAction);
    fileMenu->addAction(m_saveAction);
    fileMenu->addSeparator();
    fileMenu->addAction(m_exitAction);

    // Help menu
    QMenu *helpMenu = m_menuBar->addMenu(tr("&Help"));
    helpMenu->addAction(m_aboutAction);
    helpMenu->addAction(m_aboutQtAction);
}

void MainWindow::setupToolBar()
{
    m_toolBar = addToolBar(tr("Main"));
    m_toolBar->addAction(m_newAction);
    m_toolBar->addAction(m_openAction);
    m_toolBar->addAction(m_saveAction);
    m_toolBar->addSeparator();
}

void MainWindow::setupStatusBar()
{
    m_statusBar = statusBar();
    
    m_statusLabel = new QLabel(tr("Ready"));
    m_statusBar->addWidget(m_statusLabel);
    
    m_progressBar = new QProgressBar();
    m_progressBar->setVisible(false);
    m_progressBar->setMaximumWidth(200);
    m_statusBar->addPermanentWidget(m_progressBar);
}

void MainWindow::setupCentralWidget()
{
    m_centralWidget = new QWidget(this);
    setCentralWidget(m_centralWidget);

    QVBoxLayout *layout = new QVBoxLayout(m_centralWidget);
    layout->setContentsMargins(20, 20, 20, 20);
    layout->setSpacing(20);

    // Title
    m_titleLabel = new QLabel(tr("Qt Simple Template"), this);
    m_titleLabel->setAlignment(Qt::AlignCenter);
    m_titleLabel->setStyleSheet("QLabel { font-size: 24px; font-weight: bold; color: #2c3e50; }");
    layout->addWidget(m_titleLabel);

    // Info label
    m_infoLabel = new QLabel(tr("Welcome to the Qt Simple Template application!"), this);
    m_infoLabel->setAlignment(Qt::AlignCenter);
    m_infoLabel->setWordWrap(true);
    m_infoLabel->setStyleSheet("QLabel { font-size: 14px; color: #7f8c8d; margin: 20px; }");
    layout->addWidget(m_infoLabel);

    // Test button
    m_testButton = new QPushButton(tr("Test Action"), this);
    m_testButton->setMinimumHeight(40);
    m_testButton->setStyleSheet("QPushButton { font-size: 14px; padding: 10px; }");
    
    QHBoxLayout *buttonLayout = new QHBoxLayout();
    buttonLayout->addStretch();
    buttonLayout->addWidget(m_testButton);
    buttonLayout->addStretch();
    
    layout->addLayout(buttonLayout);
    layout->addStretch();
}

void MainWindow::connectSignals()
{
    // Connect actions
    connect(m_newAction, &QAction::triggered, this, &MainWindow::onNewAction);
    connect(m_openAction, &QAction::triggered, this, &MainWindow::onOpenAction);
    connect(m_saveAction, &QAction::triggered, this, &MainWindow::onSaveAction);
    connect(m_exitAction, &QAction::triggered, this, &MainWindow::onExitAction);
    connect(m_aboutAction, &QAction::triggered, this, &MainWindow::onAboutAction);
    connect(m_aboutQtAction, &QAction::triggered, this, &MainWindow::onAboutQtAction);

    // Connect test button
    connect(m_testButton, &QPushButton::clicked, this, &MainWindow::onTestButtonClicked);
}

void MainWindow::updateContent()
{
    updateWindowTitle();
    updateStatusBar();
}

void MainWindow::closeEvent(QCloseEvent *event)
{
    emit viewClosing();
    QMainWindow::closeEvent(event);
}

void MainWindow::showEvent(QShowEvent *event)
{
    QMainWindow::showEvent(event);
    if (m_initialized) {
        updateView();
    }
}

void MainWindow::onNewAction()
{
    emit userAction("new");
}

void MainWindow::onOpenAction()
{
    emit userAction("open");
}

void MainWindow::onSaveAction()
{
    emit userAction("save");
}

void MainWindow::onExitAction()
{
    close();
}

void MainWindow::onAboutAction()
{
    QString aboutText = tr(
        "<h3>Qt Simple Template</h3>"
        "<p>A comprehensive Qt6 application template with modern build system.</p>"
        "<p>Features:</p>"
        "<ul>"
        "<li>MVC Architecture</li>"
        "<li>Multi-platform packaging</li>"
        "<li>Package manager priority system</li>"
        "<li>Comprehensive documentation</li>"
        "</ul>"
        "<p>Version: %1</p>"
    ).arg(m_applicationModel ? m_applicationModel->getAppVersion() : "Unknown");

    QMessageBox::about(this, tr("About Qt Simple Template"), aboutText);
}

void MainWindow::onAboutQtAction()
{
    QMessageBox::aboutQt(this);
}

void MainWindow::onTestButtonClicked()
{
    emit userAction("test", tr("Test button was clicked!"));
}

void MainWindow::onApplicationModelChanged()
{
    updateView();
}

void MainWindow::onStatusChanged(const QString &message)
{
    if (m_statusLabel) {
        m_statusLabel->setText(message);
    }
}

void MainWindow::onBusyStateChanged(bool busy)
{
    if (m_progressBar) {
        m_progressBar->setVisible(busy);
        if (busy) {
            m_progressBar->setRange(0, 0); // Indeterminate progress
        }
    }

    setViewEnabled(!busy);
}

void MainWindow::onThemeChanged(const QString &theme)
{
    applyTheme(theme);
}

void MainWindow::createActions()
{
    m_newAction = new QAction(QIcon(":/icons/new.png"), tr("&New"), this);
    m_newAction->setShortcut(QKeySequence::New);
    m_newAction->setStatusTip(tr("Create a new file"));

    m_openAction = new QAction(QIcon(":/icons/open.png"), tr("&Open"), this);
    m_openAction->setShortcut(QKeySequence::Open);
    m_openAction->setStatusTip(tr("Open an existing file"));

    m_saveAction = new QAction(QIcon(":/icons/save.png"), tr("&Save"), this);
    m_saveAction->setShortcut(QKeySequence::Save);
    m_saveAction->setStatusTip(tr("Save the current file"));

    m_exitAction = new QAction(tr("E&xit"), this);
    m_exitAction->setShortcut(QKeySequence::Quit);
    m_exitAction->setStatusTip(tr("Exit the application"));

    m_aboutAction = new QAction(tr("&About"), this);
    m_aboutAction->setStatusTip(tr("Show information about the application"));

    m_aboutQtAction = new QAction(tr("About &Qt"), this);
    m_aboutQtAction->setStatusTip(tr("Show information about Qt"));
}

void MainWindow::updateWindowTitle()
{
    QString title = tr("Qt Simple Template");

    if (m_applicationModel) {
        QString appTitle = m_applicationModel->getAppTitle();
        if (!appTitle.isEmpty()) {
            title = appTitle;
        }

        QString version = m_applicationModel->getAppVersion();
        if (!version.isEmpty()) {
            title += tr(" - v%1").arg(version);
        }
    }

    setWindowTitle(title);
}

void MainWindow::updateStatusBar()
{
    if (!m_applicationModel || !m_statusLabel) {
        return;
    }

    QString status = m_applicationModel->getStatusMessage();
    if (status.isEmpty()) {
        status = tr("Ready");
    }

    m_statusLabel->setText(status);
}

void MainWindow::applyTheme(const QString &theme)
{
    QString styleSheet;

    if (theme == "dark") {
        styleSheet = R"(
            QMainWindow {
                background-color: #2b2b2b;
                color: #ffffff;
            }
            QMenuBar {
                background-color: #3c3c3c;
                color: #ffffff;
            }
            QMenuBar::item:selected {
                background-color: #4a4a4a;
            }
            QToolBar {
                background-color: #3c3c3c;
                border: none;
            }
            QStatusBar {
                background-color: #3c3c3c;
                color: #ffffff;
            }
            QPushButton {
                background-color: #4a4a4a;
                color: #ffffff;
                border: 1px solid #666666;
                padding: 8px;
                border-radius: 4px;
            }
            QPushButton:hover {
                background-color: #5a5a5a;
            }
            QPushButton:pressed {
                background-color: #3a3a3a;
            }
        )";
    } else if (theme == "light") {
        styleSheet = R"(
            QMainWindow {
                background-color: #ffffff;
                color: #000000;
            }
            QPushButton {
                background-color: #f0f0f0;
                color: #000000;
                border: 1px solid #cccccc;
                padding: 8px;
                border-radius: 4px;
            }
            QPushButton:hover {
                background-color: #e0e0e0;
            }
            QPushButton:pressed {
                background-color: #d0d0d0;
            }
        )";
    }

    setStyleSheet(styleSheet);
}
