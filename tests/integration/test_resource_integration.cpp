#include <QApplication>
#include <QDir>
#include <QFile>
#include <QPixmap>
#include <QtTest>

class TestResourceIntegration : public QObject {
    Q_OBJECT

private slots:
    void initTestCase();
    void cleanupTestCase();

    // Resource integration test cases
    void testImageResources();
    void testStylesheetResources();
    void testTranslationResources();
    void testResourceAccessibility();
};

void TestResourceIntegration::initTestCase() {
    qDebug("Starting Resource Integration tests");
}

void TestResourceIntegration::cleanupTestCase() {
    qDebug("Finished Resource Integration tests");
}

void TestResourceIntegration::testImageResources() {
    // Test that image resources are accessible and valid
    QFile lightThemeFile(":/images/light/theme");
    QVERIFY2(lightThemeFile.exists(),
             "Light theme image resource should exist");

    QFile darkThemeFile(":/images/dark/theme");
    QVERIFY2(darkThemeFile.exists(), "Dark theme image resource should exist");

    // Test that images can be loaded
    QPixmap lightPixmap(":/images/light/theme");
    QVERIFY2(!lightPixmap.isNull(), "Light theme image should be loadable");

    QPixmap darkPixmap(":/images/dark/theme");
    QVERIFY2(!darkPixmap.isNull(), "Dark theme image should be loadable");

    // Test that images have reasonable dimensions
    QVERIFY(lightPixmap.width() > 0);
    QVERIFY(lightPixmap.height() > 0);
    QVERIFY(darkPixmap.width() > 0);
    QVERIFY(darkPixmap.height() > 0);
}

void TestResourceIntegration::testStylesheetResources() {
    // Test that stylesheet files are accessible from filesystem
    QString appDir = QApplication::applicationDirPath();
    QString stylesDir = appDir + "/styles";

    // Check if styles are in application directory
    QFile lightStyleFile(stylesDir + "/light.qss");
    QFile darkStyleFile(stylesDir + "/dark.qss");

    if (!lightStyleFile.exists()) {
        // Try relative path for development/testing
        lightStyleFile.setFileName("assets/styles/light.qss");
        darkStyleFile.setFileName("assets/styles/dark.qss");
    }

    if (lightStyleFile.exists()) {
        QVERIFY(lightStyleFile.open(QIODevice::ReadOnly));
        QString lightContent = lightStyleFile.readAll();
        lightStyleFile.close();

        QVERIFY(!lightContent.isEmpty());
        QVERIFY(lightContent.contains("QWidget") || lightContent.contains("*"));
    }

    if (darkStyleFile.exists()) {
        QVERIFY(darkStyleFile.open(QIODevice::ReadOnly));
        QString darkContent = darkStyleFile.readAll();
        darkStyleFile.close();

        QVERIFY(!darkContent.isEmpty());
        QVERIFY(darkContent.contains("QWidget") || darkContent.contains("*"));
    }
}

void TestResourceIntegration::testTranslationResources() {
    // Test that translation files are accessible
    QString appDir = QApplication::applicationDirPath();

    // Check for compiled translation files
    QFile englishQm(appDir + "/app_en.qm");
    QFile chineseQm(appDir + "/app_zh.qm");

    // Note: .qm files might not exist in test environment
    // This test verifies the resource system can handle them
    if (englishQm.exists()) {
        QVERIFY(englishQm.size() > 0);
    }

    if (chineseQm.exists()) {
        QVERIFY(chineseQm.size() > 0);
    }

    // Test source translation files
    QFile englishTs("app/i18n/app_en.ts");
    QFile chineseTs("app/i18n/app_zh.ts");

    if (englishTs.exists()) {
        QVERIFY(englishTs.open(QIODevice::ReadOnly));
        QString content = englishTs.readAll();
        englishTs.close();
        QVERIFY(content.contains("<?xml"));
    }

    if (chineseTs.exists()) {
        QVERIFY(chineseTs.open(QIODevice::ReadOnly));
        QString content = chineseTs.readAll();
        chineseTs.close();
        QVERIFY(content.contains("<?xml"));
    }
}

void TestResourceIntegration::testResourceAccessibility() {
    // Test that all resource systems work together

    // Test image resource loading
    QPixmap testPixmap(":/images/light/theme");
    bool imageResourcesWork = !testPixmap.isNull();

    // Test stylesheet resource loading
    QString appDir = QApplication::applicationDirPath();
    QFile styleFile(appDir + "/styles/light.qss");
    if (!styleFile.exists()) {
        styleFile.setFileName("assets/styles/light.qss");
    }

    bool stylesheetResourcesWork = styleFile.exists();

    // At least one resource system should work
    QVERIFY2(imageResourcesWork || stylesheetResourcesWork,
             "At least one resource system should be functional");

    // Test that resource paths are consistent
    if (imageResourcesWork) {
        QVERIFY(QFile::exists(":/images/light/theme"));
        QVERIFY(QFile::exists(":/images/dark/theme"));
    }
}

QTEST_MAIN(TestResourceIntegration)
#include "test_resource_integration.moc"
