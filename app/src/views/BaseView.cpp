#include "views/BaseView.h"
#include "interfaces/IController.h"
#include <QVBoxLayout>
#include <QHBoxLayout>
#include <QLabel>
#include <QFrame>
#include <QMessageBox>
#include <QCloseEvent>
#include <QDebug>

BaseView::BaseView(QWidget *parent)
    : IView(parent)
    , m_controller(nullptr)
    , m_mainLayout(nullptr)
    , m_statusLabel(nullptr)
    , m_initialized(false)
{
}

bool BaseView::initialize()
{
    if (m_initialized) {
        return true;
    }

    // Setup the main layout
    setupLayout();

    // Initialize UI components
    bool result = initializeUI();

    if (result) {
        // Connect signals
        connectSignals();
        m_initialized = true;
    }

    return result;
}

void BaseView::setController(IController *controller)
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
                this, &BaseView::onControllerStateChanged);
        connect(m_controller, &IController::errorOccurred,
                this, &BaseView::showError);
    }
}

IController* BaseView::getController() const
{
    return m_controller;
}

void BaseView::updateView()
{
    if (!m_initialized) {
        return;
    }

    updateContent();
    emit viewUpdateRequested();
}

void BaseView::showError(const QString &message)
{
    QMessageBox::critical(this, tr("Error"), message);
}

void BaseView::showInfo(const QString &message)
{
    QMessageBox::information(this, tr("Information"), message);
}

void BaseView::setViewEnabled(bool enabled)
{
    setEnabled(enabled);
}

bool BaseView::isViewValid() const
{
    return m_initialized && validateView();
}

bool BaseView::initializeUI()
{
    // Default implementation - override in derived classes
    return true;
}

void BaseView::setupLayout()
{
    // Create main layout
    m_mainLayout = new QVBoxLayout(this);
    m_mainLayout->setContentsMargins(10, 10, 10, 10);
    m_mainLayout->setSpacing(10);

    // Create status label
    m_statusLabel = new QLabel(this);
    m_statusLabel->setStyleSheet("QLabel { color: gray; font-size: 10px; }");
    m_statusLabel->setAlignment(Qt::AlignLeft);
    
    // Add status label at the bottom
    m_mainLayout->addStretch();
    m_mainLayout->addWidget(m_statusLabel);
}

void BaseView::connectSignals()
{
    // Default implementation - override in derived classes
}

void BaseView::updateContent()
{
    // Default implementation - override in derived classes
}

bool BaseView::validateView() const
{
    // Default implementation - override in derived classes
    return true;
}

void BaseView::handleViewClosing()
{
    // Default implementation - override in derived classes
}

QVBoxLayout* BaseView::getMainLayout() const
{
    return m_mainLayout;
}

QHBoxLayout* BaseView::createHorizontalLayout(const QList<QWidget*> &widgets)
{
    QHBoxLayout *layout = new QHBoxLayout();
    layout->setSpacing(5);
    
    for (QWidget *widget : widgets) {
        if (widget) {
            layout->addWidget(widget);
        }
    }
    
    return layout;
}

QVBoxLayout* BaseView::createVerticalLayout(const QList<QWidget*> &widgets)
{
    QVBoxLayout *layout = new QVBoxLayout();
    layout->setSpacing(5);
    
    for (QWidget *widget : widgets) {
        if (widget) {
            layout->addWidget(widget);
        }
    }
    
    return layout;
}

void BaseView::addSeparator()
{
    QFrame *separator = new QFrame(this);
    separator->setFrameShape(QFrame::HLine);
    separator->setFrameShadow(QFrame::Sunken);
    m_mainLayout->insertWidget(m_mainLayout->count() - 2, separator); // Insert before stretch and status
}

void BaseView::setStatusText(const QString &text)
{
    if (m_statusLabel) {
        m_statusLabel->setText(text);
    }
}

QString BaseView::getStatusText() const
{
    return m_statusLabel ? m_statusLabel->text() : QString();
}

void BaseView::closeEvent(QCloseEvent *event)
{
    handleViewClosing();
    emit viewClosing();
    QWidget::closeEvent(event);
}

void BaseView::onControllerStateChanged()
{
    updateView();
}
