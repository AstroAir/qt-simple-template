#include <QtTest>
#include <QApplication>
#include <QFile>
#include <QDir>

class TestTheme : public QObject
{
    Q_OBJECT

private slots:
    void initTestCase();
    void cleanupTestCase();

    // Test cases
    void testThemeFilesExist();
    void testThemeFileContent();
    void testThemeApplication();

};

void TestTheme::initTestCase()
{
    qDebug("Starting Theme tests");
}

void TestTheme::cleanupTestCase()
{
    qDebug("Finished Theme tests");
}

void TestTheme::testThemeFilesExist()
{
    // Test that theme files exist in the expected locations
    QString assetsDir = QDir::currentPath() + "/assets/styles";
    
    QFile lightTheme(assetsDir + "/light.qss");
    QVERIFY2(lightTheme.exists(), "Light theme file should exist");
    
    QFile darkTheme(assetsDir + "/dark.qss");
    QVERIFY2(darkTheme.exists(), "Dark theme file should exist");
}

void TestTheme::testThemeFileContent()
{
    QString assetsDir = QDir::currentPath() + "/assets/styles";
    
    // Test light theme content
    QFile lightTheme(assetsDir + "/light.qss");
    QVERIFY(lightTheme.open(QIODevice::ReadOnly));
    QString lightContent = lightTheme.readAll();
    lightTheme.close();
    
    QVERIFY(!lightContent.isEmpty());
    QVERIFY(lightContent.contains("QWidget") || lightContent.contains("*"));
    
    // Test dark theme content
    QFile darkTheme(assetsDir + "/dark.qss");
    QVERIFY(darkTheme.open(QIODevice::ReadOnly));
    QString darkContent = darkTheme.readAll();
    darkTheme.close();
    
    QVERIFY(!darkContent.isEmpty());
    QVERIFY(darkContent.contains("QWidget") || darkContent.contains("*"));
    
    // Themes should be different
    QVERIFY(lightContent != darkContent);
}

void TestTheme::testThemeApplication()
{
    QString assetsDir = QDir::currentPath() + "/assets/styles";
    
    // Test applying light theme
    QFile lightTheme(assetsDir + "/light.qss");
    if (lightTheme.open(QIODevice::ReadOnly)) {
        QString lightStyle = lightTheme.readAll();
        lightTheme.close();
        
        // Apply theme to application
        qApp->setStyleSheet(lightStyle);
        
        // Verify it was applied (basic check)
        QString currentStyle = qApp->styleSheet();
        QVERIFY(!currentStyle.isEmpty());
    }
    
    // Test applying dark theme
    QFile darkTheme(assetsDir + "/dark.qss");
    if (darkTheme.open(QIODevice::ReadOnly)) {
        QString darkStyle = darkTheme.readAll();
        darkTheme.close();
        
        // Apply theme to application
        qApp->setStyleSheet(darkStyle);
        
        // Verify it was applied (basic check)
        QString currentStyle = qApp->styleSheet();
        QVERIFY(!currentStyle.isEmpty());
    }
    
    // Reset stylesheet
    qApp->setStyleSheet("");
}

QTEST_MAIN(TestTheme)
#include "test_theme.moc"
