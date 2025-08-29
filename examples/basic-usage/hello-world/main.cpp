/**
 * @file main.cpp
 * @brief Hello World Example - Minimal Qt Application
 * 
 * This example demonstrates the absolute minimum required to create
 * a Qt application with a simple window and basic interaction.
 * 
 * Key concepts demonstrated:
 * - QApplication setup
 * - Basic widget creation
 * - Simple event handling
 * - Application lifecycle
 */

#include <QApplication>
#include <QWidget>
#include <QVBoxLayout>
#include <QLabel>
#include <QPushButton>
#include <QMessageBox>
#include <QFont>

/**
 * @class HelloWorldWidget
 * @brief Simple widget demonstrating basic Qt functionality
 */
class HelloWorldWidget : public QWidget
{
    Q_OBJECT

public:
    explicit HelloWorldWidget(QWidget *parent = nullptr)
        : QWidget(parent)
    {
        setupUI();
        connectSignals();
    }

private slots:
    /**
     * @brief Handle button click event
     */
    void onButtonClicked()
    {
        static int clickCount = 0;
        ++clickCount;
        
        QString message = QString("Hello World!\nButton clicked %1 time(s)")
                         .arg(clickCount);
        
        QMessageBox::information(this, "Hello World", message);
        
        // Update the label
        m_statusLabel->setText(QString("Clicked %1 time(s)").arg(clickCount));
    }
    
    /**
     * @brief Handle application exit
     */
    void onExitClicked()
    {
        QMessageBox::StandardButton reply = QMessageBox::question(
            this,
            "Exit Application",
            "Are you sure you want to exit?",
            QMessageBox::Yes | QMessageBox::No,
            QMessageBox::No
        );
        
        if (reply == QMessageBox::Yes) {
            QApplication::quit();
        }
    }

private:
    /**
     * @brief Setup the user interface
     */
    void setupUI()
    {
        setWindowTitle("Hello World - Qt Simple Template Example");
        setFixedSize(400, 300);
        
        // Create layout
        auto *layout = new QVBoxLayout(this);
        layout->setSpacing(20);
        layout->setContentsMargins(30, 30, 30, 30);
        
        // Create title label
        auto *titleLabel = new QLabel("Welcome to Qt Simple Template!");
        titleLabel->setAlignment(Qt::AlignCenter);
        
        // Set title font
        QFont titleFont = titleLabel->font();
        titleFont.setPointSize(16);
        titleFont.setBold(true);
        titleLabel->setFont(titleFont);
        
        // Create description label
        auto *descLabel = new QLabel(
            "This is a basic example demonstrating:\n"
            "• QApplication setup\n"
            "• Widget creation and layout\n"
            "• Signal-slot connections\n"
            "• Basic event handling"
        );
        descLabel->setAlignment(Qt::AlignCenter);
        descLabel->setWordWrap(true);
        
        // Create status label
        m_statusLabel = new QLabel("Ready - Click the button!");
        m_statusLabel->setAlignment(Qt::AlignCenter);
        m_statusLabel->setStyleSheet("color: blue; font-style: italic;");
        
        // Create buttons
        m_helloButton = new QPushButton("Say Hello!");
        m_helloButton->setMinimumHeight(40);
        
        auto *exitButton = new QPushButton("Exit");
        exitButton->setMinimumHeight(40);
        exitButton->setStyleSheet("QPushButton { background-color: #ff6b6b; color: white; }");
        
        // Add widgets to layout
        layout->addWidget(titleLabel);
        layout->addWidget(descLabel);
        layout->addStretch();
        layout->addWidget(m_statusLabel);
        layout->addWidget(m_helloButton);
        layout->addWidget(exitButton);
        layout->addStretch();
        
        setLayout(layout);
    }
    
    /**
     * @brief Connect signals to slots
     */
    void connectSignals()
    {
        connect(m_helloButton, &QPushButton::clicked,
                this, &HelloWorldWidget::onButtonClicked);
        
        connect(m_helloButton, &QPushButton::clicked,
                this, &HelloWorldWidget::onExitClicked);
    }

private:
    QLabel *m_statusLabel;
    QPushButton *m_helloButton;
};

/**
 * @brief Application entry point
 * @param argc Argument count
 * @param argv Argument values
 * @return Application exit code
 */
int main(int argc, char *argv[])
{
    // Create QApplication instance
    QApplication app(argc, argv);
    
    // Set application properties
    app.setApplicationName("Hello World Example");
    app.setApplicationVersion("1.0.0");
    app.setOrganizationName("Qt Simple Template");
    
    // Create and show main widget
    HelloWorldWidget widget;
    widget.show();
    
    // Start event loop
    return app.exec();
}

// Include the MOC file for Q_OBJECT macro
#include "main.moc"
