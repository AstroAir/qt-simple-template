#include "controllers/BaseController.h"
#include <QDebug>
#include "interfaces/IModel.h"
#include "interfaces/IView.h"

BaseController::BaseController(QObject *parent)
    : IController(parent),
      m_model(nullptr),
      m_view(nullptr),
      m_initialized(false) {}

bool BaseController::initialize() {
    if (m_initialized) {
        return true;
    }

    // Initialize controller-specific logic
    bool result = initializeController();

    if (result) {
        // Connect model and view if both are available
        if (m_model && m_view) {
            connectModelAndView();
        }

        m_initialized = true;
        emit stateChanged();
    }

    return result;
}

void BaseController::setModel(IModel *model) {
    if (m_model == model) {
        return;
    }

    // Disconnect from old model
    if (m_model) {
        disconnect(m_model, nullptr, this, nullptr);
    }

    m_model = model;

    // Connect to new model
    if (m_model) {
        connect(m_model, &IModel::dataChanged, this,
                &BaseController::onModelDataChangedSlot);
        connect(m_model, &IModel::validityChanged, this,
                &BaseController::stateChanged);
    }

    // Reconnect model and view if both are available
    if (m_initialized && m_model && m_view) {
        connectModelAndView();
    }

    emit stateChanged();
}

IModel *BaseController::getModel() const { return m_model; }

void BaseController::setView(IView *view) {
    if (m_view == view) {
        return;
    }

    // Disconnect from old view
    // TODO: Fix signal/slot connections for IView interface
    // if (m_view) {
    //     disconnect(m_view, nullptr, this, nullptr);
    // }

    m_view = view;

    // Connect to new view
    // TODO: Fix signal/slot connections for IView interface
    // if (m_view) {
    //     connect(m_view, &IView::viewUpdateRequested, this,
    //             &BaseController::onViewUpdateRequestedSlot);
    //     connect(m_view, &IView::userAction, this,
    //             &BaseController::onUserActionSlot);
    //     connect(m_view, &IView::viewClosing, this,
    //             &BaseController::onViewClosingSlot);
    // }

    // Set this controller in the view
    if (m_view) {
        m_view->setController(this);
    }

    // Reconnect model and view if both are available
    if (m_initialized && m_model && m_view) {
        connectModelAndView();
    }

    emit stateChanged();
}

IView *BaseController::getView() const { return m_view; }

void BaseController::handleUserAction(const QString &actionName,
                                      const QVariant &data) {
    if (!m_initialized) {
        emitError(tr("Controller not initialized"));
        return;
    }

    // Try to handle the action in the derived class first
    if (handleControllerAction(actionName, data)) {
        return;
    }

    // Handle common actions
    if (actionName == "refresh" || actionName == "update") {
        updateView();
        emitOperationCompleted(tr("View updated"));
    } else {
        qDebug() << "Unhandled user action:" << actionName
                 << "with data:" << data;
    }
}

void BaseController::updateView() {
    if (!m_view) {
        return;
    }

    updateControllerState();
    m_view->updateView();
}

bool BaseController::isValid() const {
    return m_initialized && validateController();
}

bool BaseController::initializeController() {
    // Default implementation - override in derived classes
    return true;
}

void BaseController::connectModelAndView() {
    // Default implementation - override in derived classes
    // This is where you would connect specific model signals to view updates
}

bool BaseController::handleControllerAction(const QString &actionName,
                                            const QVariant &data) {
    Q_UNUSED(actionName)
    Q_UNUSED(data)
    // Default implementation - override in derived classes
    return false;
}

bool BaseController::validateController() const {
    // Default implementation - override in derived classes
    return m_model != nullptr && m_view != nullptr;
}

void BaseController::updateControllerState() {
    // Default implementation - override in derived classes
}

void BaseController::onModelDataChanged() {
    // Default implementation - override in derived classes
    updateView();
}

void BaseController::onViewUpdateRequested() {
    // Default implementation - override in derived classes
    updateView();
}

void BaseController::onViewClosing() {
    // Default implementation - override in derived classes
}

void BaseController::emitError(const QString &message) {
    emit errorOccurred(message);
}

void BaseController::emitOperationCompleted(const QString &message) {
    emit operationCompleted(message);
}

void BaseController::onModelDataChangedSlot() { onModelDataChanged(); }

void BaseController::onViewUpdateRequestedSlot() { onViewUpdateRequested(); }

void BaseController::onViewClosingSlot() { onViewClosing(); }

void BaseController::onUserActionSlot(const QString &actionName,
                                      const QVariant &data) {
    handleUserAction(actionName, data);
}
