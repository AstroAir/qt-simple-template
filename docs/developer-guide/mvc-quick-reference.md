# MVC Quick Reference Guide

This guide provides quick reference information for working with the MVC architecture in qt-simple-template.

## Quick Start Checklist

### Setting Up Development Environment

- [ ] Qt 6.7+ installed
- [ ] CMake 3.28+ installed
- [ ] IDE configured with include paths: `app/include/`
- [ ] Build system configured for MVC structure

### Creating New Components

#### New Model Checklist

- [ ] Inherit from `BaseModel`
- [ ] Define property constants
- [ ] Implement getter/setter methods
- [ ] Override `validateModel()` if needed
- [ ] Add to CMakeLists.txt

#### New View Checklist

- [ ] Inherit from `BaseView` or `QMainWindow` + `IView`
- [ ] Override `initializeUI()`
- [ ] Override `connectSignals()`
- [ ] Override `updateContent()`
- [ ] Add to CMakeLists.txt

#### New Controller Checklist

- [ ] Inherit from `BaseController`
- [ ] Override `handleControllerAction()`
- [ ] Override `connectModelAndView()`
- [ ] Implement action handlers
- [ ] Add to CMakeLists.txt

## Code Templates

### Model Template

```cpp
// Header file (include/models/YourModel.h)
#pragma once
#include "models/BaseModel.h"

class YourModel : public BaseModel
{
    Q_OBJECT

public:
    // Property constants
    static const QString PROPERTY_NAME;
    static const QString PROPERTY_VALUE;

    explicit YourModel(QObject *parent = nullptr);

    // Convenience getters/setters
    QString getName() const;
    void setName(const QString &name);

protected:
    bool initializeModel() override;
    bool validateModel() const override;
};

// Implementation file (src/models/YourModel.cpp)
#include "models/YourModel.h"

const QString YourModel::PROPERTY_NAME = "name";
const QString YourModel::PROPERTY_VALUE = "value";

YourModel::YourModel(QObject *parent) : BaseModel(parent) {}

QString YourModel::getName() const {
    return getProperty(PROPERTY_NAME).toString();
}

void YourModel::setName(const QString &name) {
    setProperty(PROPERTY_NAME, name);
}

bool YourModel::initializeModel() {
    setPropertySilent(PROPERTY_NAME, QString());
    return BaseModel::initializeModel();
}

bool YourModel::validateModel() const {
    return !getName().isEmpty();
}
```

### View Template

```cpp
// Header file (include/views/YourView.h)
#pragma once
#include "views/BaseView.h"
#include <QLineEdit>
#include <QPushButton>

class YourView : public BaseView
{
    Q_OBJECT

public:
    explicit YourView(QWidget *parent = nullptr);

protected:
    bool initializeUI() override;
    void connectSignals() override;
    void updateContent() override;

private slots:
    void onButtonClicked();

private:
    QLineEdit *m_nameEdit;
    QPushButton *m_button;
};

// Implementation file (src/views/YourView.cpp)
#include "views/YourView.h"
#include <QVBoxLayout>

YourView::YourView(QWidget *parent) : BaseView(parent) {}

bool YourView::initializeUI() {
    m_nameEdit = new QLineEdit(this);
    m_button = new QPushButton("Submit", this);
    
    QVBoxLayout *layout = createVerticalLayout({m_nameEdit, m_button});
    getMainLayout()->insertLayout(0, layout);
    
    return BaseView::initializeUI();
}

void YourView::connectSignals() {
    connect(m_button, &QPushButton::clicked, this, &YourView::onButtonClicked);
    BaseView::connectSignals();
}

void YourView::updateContent() {
    // Update UI based on model data
    BaseView::updateContent();
}

void YourView::onButtonClicked() {
    emit userAction("submit", m_nameEdit->text());
}
```

### Controller Template

```cpp
// Header file (include/controllers/YourController.h)
#pragma once
#include "controllers/BaseController.h"

class YourModel;
class YourView;

class YourController : public BaseController
{
    Q_OBJECT

public:
    explicit YourController(QObject *parent = nullptr);

    void setYourModel(YourModel *model);
    void setYourView(YourView *view);

protected:
    bool handleControllerAction(const QString &actionName, const QVariant &data) override;
    void connectModelAndView() override;

private slots:
    void onSubmitAction(const QVariant &data);
};

// Implementation file (src/controllers/YourController.cpp)
#include "controllers/YourController.h"
#include "models/YourModel.h"
#include "views/YourView.h"

YourController::YourController(QObject *parent) : BaseController(parent) {}

void YourController::setYourModel(YourModel *model) {
    setModel(model);
}

void YourController::setYourView(YourView *view) {
    setView(view);
}

bool YourController::handleControllerAction(const QString &actionName, const QVariant &data) {
    if (actionName == "submit") {
        onSubmitAction(data);
        return true;
    }
    return BaseController::handleControllerAction(actionName, data);
}

void YourController::connectModelAndView() {
    // Connect model changes to view updates
    BaseController::connectModelAndView();
}

void YourController::onSubmitAction(const QVariant &data) {
    YourModel *model = qobject_cast<YourModel*>(getModel());
    if (model) {
        model->setName(data.toString());
        emitOperationCompleted("Data submitted successfully");
    }
}
```

## Common Patterns

### Property Management in Models

```cpp
// Define property constants
static const QString PROPERTY_NAME = "name";

// Getter
QString getName() const {
    return getProperty(PROPERTY_NAME).toString();
}

// Setter with validation
void setName(const QString &name) {
    if (!name.isEmpty()) {
        setProperty(PROPERTY_NAME, name);
    }
}

// Silent setter (no signals)
void initializeDefaults() {
    setPropertySilent(PROPERTY_NAME, "Default");
}
```

### Signal/Slot Connections

```cpp
// In controller's connectModelAndView()
connect(model, &YourModel::dataChanged, 
        this, &YourController::updateView);

connect(view, &YourView::userAction,
        this, &YourController::handleUserAction);
```

### Error Handling

```cpp
// In controller
if (!operation()) {
    emitError("Operation failed");
    return;
}
emitOperationCompleted("Operation successful");

// In view
void showError(const QString &message) override {
    QMessageBox::critical(this, "Error", message);
}
```

### Logging

```cpp
#include "utils/Logger.h"

// Log messages
Logger::instance()->info("Operation started", "YourController");
Logger::instance()->error("Operation failed", "YourController");
Logger::instance()->debug("Debug info", "YourController");
```

### Configuration

```cpp
#include "services/ConfigurationService.h"

// Get configuration
QString theme = configService->getConfiguration("theme", "default").toString();

// Set configuration
configService->setConfiguration("theme", "dark");
```

## Debugging Tips

### Common Issues

1. **Signals not working**: Check connections in `connectSignals()` or `connectModelAndView()`
2. **View not updating**: Ensure `updateView()` is called after model changes
3. **Memory leaks**: Check parent-child relationships in Qt objects
4. **Thread issues**: Ensure UI operations are on main thread

### Debug Logging

```cpp
// Enable debug logging
Logger::instance()->setLogLevel(Logger::Debug);

// Add debug output
qDebug() << "Model property changed:" << propertyName << newValue;
```

### Validation

```cpp
// Check MVC component validity
Q_ASSERT(controller->isValid());
Q_ASSERT(model->isValid());
Q_ASSERT(view->isViewValid());
```

## Performance Tips

1. **Minimize signal emissions**: Batch property changes when possible
2. **Use lazy loading**: Load expensive data only when needed
3. **Cache frequently accessed data**: Store computed values in models
4. **Optimize UI updates**: Update only changed elements

## Testing Patterns

### Model Testing

```cpp
void testModelProperty() {
    YourModel model;
    model.initialize();
    
    model.setName("Test");
    QCOMPARE(model.getName(), "Test");
    QVERIFY(model.isValid());
}
```

### Controller Testing

```cpp
void testControllerAction() {
    YourModel model;
    YourView view;
    YourController controller;
    
    controller.setYourModel(&model);
    controller.setYourView(&view);
    controller.initialize();
    
    controller.handleUserAction("submit", "Test Data");
    QCOMPARE(model.getName(), "Test Data");
}
```

This quick reference provides the essential patterns and templates for working efficiently with the MVC architecture.
