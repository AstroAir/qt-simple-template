#include "views/MainWindow.h"
#include <QAction>
#include <QApplication>
#include <QCloseEvent>
#include <QDebug>
#include <QHBoxLayout>
#include <QLabel>
#include <QMenuBar>
#include <QMessageBox>
#include <QProgressBar>
#include <QPushButton>
#include <QShowEvent>
#include <QStatusBar>
#include <QToolBar>
#include <QVBoxLayout>
#include "interfaces/IController.h"
#include "models/ApplicationModel.h"

MainWindow::MainWindow(QWidget *parent)
    : QMainWindow(parent),
      m_centralWidget(nullptr),
      m_menuBar(nullptr),
      m_toolBar(nullptr),
      m_statusBar(nullptr),
      m_newAction(nullptr),
      m_openAction(nullptr),
      m_saveAction(nullptr),
      m_exitAction(nullptr),
      m_aboutAction(nullptr),
      m_aboutQtAction(nullptr),
      m_titleLabel(nullptr),
      m_infoLabel(nullptr),
      m_testButton(nullptr),
      m_statusLabel(nullptr),
      m_progressBar(nullptr),
      m_controller(nullptr),
      m_applicationModel(nullptr),
      m_initialized(false) {
    setWindowTitle(tr("Qt Simple Template"));
    setMinimumSize(800, 600);
    resize(1000, 700);
}

// Minimal implementations for methods expected by MOC
void MainWindow::onNewAction() { emit userAction("new"); }
void MainWindow::onOpenAction() { emit userAction("open"); }
void MainWindow::onSaveAction() { emit userAction("save"); }
void MainWindow::onExitAction() { close(); }
void MainWindow::onAboutAction() {
    QMessageBox::about(this, tr("About"), tr("Qt Simple Template"));
}
void MainWindow::onAboutQtAction() { QMessageBox::aboutQt(this); }
void MainWindow::onTestButtonClicked() { emit userAction("test"); }
void MainWindow::onApplicationModelChanged() {}
void MainWindow::onStatusChanged(const QString &) {}
void MainWindow::onBusyStateChanged(bool) {}
void MainWindow::onThemeChanged(const QString &) {}
void MainWindow::closeEvent(QCloseEvent *event) {
    emit viewClosing();
    QMainWindow::closeEvent(event);
}
void MainWindow::showEvent(QShowEvent *event) {
    QMainWindow::showEvent(event);
}
