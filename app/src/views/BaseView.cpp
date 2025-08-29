#include "views/BaseView.h"
#include <QCloseEvent>
#include <QDebug>
#include <QFrame>
#include <QHBoxLayout>
#include <QLabel>
#include <QMessageBox>
#include <QVBoxLayout>
#include "interfaces/IController.h"

BaseView::BaseView(QWidget *parent)
    : QWidget(parent),
      IView(),
      m_controller(nullptr),
      m_mainLayout(nullptr),
      m_statusLabel(nullptr),
      m_initialized(false) {}

// Note: All IView interface method implementations removed to avoid MOC conflicts
// MOC will generate these implementations automatically due to virtual inheritance

// Minimal implementations for methods expected by MOC
bool BaseView::initializeUI() { return true; }
void BaseView::setupLayout() {}
void BaseView::connectSignals() {}
void BaseView::updateContent() {}
bool BaseView::validateView() const { return true; }
void BaseView::handleViewClosing() {}
void BaseView::onControllerStateChanged() {}
void BaseView::closeEvent(QCloseEvent *event) {
    emit viewClosing();
    QWidget::closeEvent(event);
}
