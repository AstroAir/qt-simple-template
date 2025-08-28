#include <config.h>
#include <QApplication>
#include <QDebug>
#include <QDir>
#include <QStandardPaths>

// MVC Components
#include "controllers/ApplicationController.h"
#include "models/ApplicationModel.h"
#include "services/ConfigurationService.h"
#include "utils/Logger.h"
#include "views/MainWindow.h"

int main(int argc, char **argv) {
    QApplication app(argc, argv);
    app.setStyle("fusion");

    // Set application properties
    app.setApplicationName(PROJECT_NAME);
    app.setApplicationVersion(PROJECT_VER);
    app.setApplicationDisplayName(APP_NAME);
    app.setOrganizationName("Qt Simple Template Developers");
    app.setOrganizationDomain("example.com");

    // Initialize logger
    QString logDir =
        QStandardPaths::writableLocation(QStandardPaths::AppDataLocation);
    QDir().mkpath(logDir);
    QString logFile = QDir(logDir).filePath("application.log");

    Logger::instance()->initialize(logFile, Logger::Info);
    Logger::instance()->info("Application starting", "Main");

    // Create MVC components
    ApplicationModel *model = new ApplicationModel(&app);
    MainWindow *view = new MainWindow();
    ApplicationController *controller = new ApplicationController(&app);

    // Create services
    ConfigurationService *configService = new ConfigurationService(&app);
    configService->initialize();
    configService->start();

    // Wire up MVC components
    controller->setApplicationModel(model);
    controller->setMainWindow(view);

    // Initialize the application
    if (!controller->initializeApplication()) {
        Logger::instance()->error("Failed to initialize application", "Main");
        return -1;
    }

    // Start the application
    controller->startApplication();

    Logger::instance()->info("Application started successfully", "Main");

    // Run the application
    int result = app.exec();

    // Cleanup
    Logger::instance()->info("Application shutting down", "Main");
    configService->stop();

    return result;
}