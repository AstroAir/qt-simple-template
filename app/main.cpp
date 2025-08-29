#include <config.h>
#include <QApplication>
#include <QDebug>
#include "Widget.h"

int main(int argc, char **argv) {
    QApplication app(argc, argv);
    app.setStyle("fusion");

    // Set application properties
    app.setApplicationName(PROJECT_NAME);
    app.setApplicationVersion(PROJECT_VER);
    app.setApplicationDisplayName(APP_NAME);
    app.setOrganizationName("Qt Simple Template Developers");
    app.setOrganizationDomain("example.com");

    // Create and show the main widget
    Widget widget;
    widget.show();

    // Run the application
    return app.exec();
}