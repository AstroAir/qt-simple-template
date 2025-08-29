# Hello World Example

A minimal Qt application demonstrating the basic structure and concepts of Qt development.

## 📋 Overview

This example shows the absolute minimum required to create a functional Qt application with:
- A simple window with widgets
- Basic user interaction
- Event handling through signals and slots
- Proper application lifecycle management

## 🎯 Learning Objectives

After studying this example, you will understand:
- How to set up a basic Qt application
- Widget creation and layout management
- Signal-slot connection mechanism
- Basic event handling patterns
- Application properties and metadata

## 🏗️ Code Structure

```cpp
// Key components demonstrated:
QApplication app(argc, argv);    // Application instance
QWidget widget;                  // Main window
QVBoxLayout layout;             // Layout manager
QPushButton button;             // Interactive widget
QLabel label;                   // Display widget
```

## 🔧 Building and Running

### Prerequisites
- Qt 6.2 or later
- CMake 3.20 or later
- C++20 compatible compiler

### Build Commands

```bash
# From project root
mkdir build && cd build
cmake ..
cmake --build . --target hello_world_example

# Run the example
./examples/basic-usage/hello-world/hello_world_example
```

### Alternative Build (Standalone)

```bash
# From this directory
mkdir build && cd build
cmake ..
cmake --build .
./hello_world_example
```

## 🎮 Usage

1. **Launch the application** - A window will appear with a welcome message
2. **Click "Say Hello!"** - A message box will show the greeting
3. **Observe the counter** - The status label updates with click count
4. **Exit the application** - Click "Exit" and confirm

## 📚 Key Concepts Explained

### QApplication
```cpp
QApplication app(argc, argv);
```
- Entry point for Qt applications
- Manages application-wide resources
- Handles event loop and system integration

### Widget Hierarchy
```cpp
QWidget *parent = nullptr;  // Top-level widget
QVBoxLayout *layout;        // Layout manager
QLabel *child;              // Child widget
```
- Widgets form a parent-child hierarchy
- Parent widgets manage child lifetimes
- Layouts handle automatic positioning

### Signals and Slots
```cpp
connect(button, &QPushButton::clicked,
        this, &HelloWorldWidget::onButtonClicked);
```
- Type-safe callback mechanism
- Decouples sender from receiver
- Supports one-to-many connections

### Event Handling
```cpp
void onButtonClicked() {
    // Handle user interaction
    QMessageBox::information(this, "Title", "Message");
}
```
- Slot functions handle events
- Can update UI state
- May trigger additional actions

## 🔍 Code Walkthrough

### 1. Application Setup
```cpp
QApplication app(argc, argv);
app.setApplicationName("Hello World Example");
app.setApplicationVersion("1.0.0");
```

### 2. Widget Creation
```cpp
HelloWorldWidget widget;
widget.show();
```

### 3. UI Construction
```cpp
auto *layout = new QVBoxLayout(this);
auto *label = new QLabel("Welcome!");
auto *button = new QPushButton("Say Hello!");
layout->addWidget(label);
layout->addWidget(button);
```

### 4. Event Connection
```cpp
connect(button, &QPushButton::clicked,
        this, &HelloWorldWidget::onButtonClicked);
```

### 5. Event Loop
```cpp
return app.exec();  // Start processing events
```

## 🎨 Customization Ideas

Try modifying the example to:
- Change window size and title
- Add more buttons with different actions
- Implement keyboard shortcuts
- Add icons and styling
- Create custom layouts
- Add tooltips and status tips

## 🐛 Common Issues

### Build Problems
- **Qt not found**: Ensure Qt6 is installed and CMAKE_PREFIX_PATH is set
- **C++ standard**: Verify compiler supports C++20
- **MOC errors**: Check Q_OBJECT macro placement

### Runtime Issues
- **Missing DLLs**: Use windeployqt on Windows
- **Display problems**: Check QT_QPA_PLATFORM environment variable
- **Font issues**: Verify system font availability

## 📖 Next Steps

After mastering this example, explore:
1. **Layouts Example** - Advanced layout management
2. **Signals & Slots Example** - Complex event handling
3. **Resources Example** - Using Qt Resource System
4. **Custom Widgets** - Creating reusable components

## 📚 References

- [QApplication Documentation](https://doc.qt.io/qt-6/qapplication.html)
- [QWidget Documentation](https://doc.qt.io/qt-6/qwidget.html)
- [Signals & Slots](https://doc.qt.io/qt-6/signalsandslots.html)
- [Qt Layouts](https://doc.qt.io/qt-6/layout.html)
