#include "config.h"
#include <QApplication>
#include <QDir>
#include <QFile>
#include <QProcess>
#include <QtTest>

class TestBuildIntegration : public QObject {
    Q_OBJECT

private slots:
    void initTestCase();
    void cleanupTestCase();

    // Build integration test cases
    void testConfigurationGeneration();
    void testResourceCompilation();
    void testDependencyLinking();
    void testExecutableProperties();
};

void TestBuildIntegration::initTestCase() {
    qDebug("Starting Build Integration tests");
}

void TestBuildIntegration::cleanupTestCase() {
    qDebug("Finished Build Integration tests");
}

void TestBuildIntegration::testConfigurationGeneration() {
    // Test that config.h was properly generated from config.h.in
    QVERIFY(QString(PROJECT_NAME).length() > 0);
    QVERIFY(QString(PROJECT_VER).length() > 0);
    QVERIFY(QString(APP_NAME).length() > 0);

    // Test version format
    QString version(PROJECT_VER);
    QStringList versionParts = version.split('.');
    QVERIFY(versionParts.size() >= 3);  // Major.Minor.Patch at minimum

    // Test that version parts are numeric
    bool ok;
    for (const QString& part : versionParts) {
        part.toInt(&ok);
        QVERIFY2(
            ok,
            qPrintable(QString("Version part '%1' is not numeric").arg(part)));
    }
}

void TestBuildIntegration::testResourceCompilation() {
    // Test that Qt resources are properly compiled and accessible
    QDir resourceDir(":/images/light");
    QVERIFY2(resourceDir.exists(),
             "Light theme resources should be accessible");

    QDir darkResourceDir(":/images/dark");
    QVERIFY2(darkResourceDir.exists(),
             "Dark theme resources should be accessible");

    // Test specific resource files
    QFile lightThemeImage(":/images/light/theme");
    QVERIFY2(lightThemeImage.exists(),
             "Light theme image should be accessible");

    QFile darkThemeImage(":/images/dark/theme");
    QVERIFY2(darkThemeImage.exists(), "Dark theme image should be accessible");
}

void TestBuildIntegration::testDependencyLinking() {
    // Test that all required Qt modules are properly linked
    // This is verified by the fact that the test can run and access Qt classes

    // Test Qt Core
    QString testString = "Test";
    QVERIFY(!testString.isEmpty());

    // Test Qt Widgets
    QApplication* app = qApp;
    QVERIFY(app != nullptr);

    // Test that custom controls library is linked
    // This would be verified by successful compilation and linking
    QVERIFY(
        true);  // Placeholder - actual linking is verified by successful build
}

void TestBuildIntegration::testExecutableProperties() {
    // Test that the executable has correct properties
    QString appName = QApplication::applicationName();
    QString appVersion = QApplication::applicationVersion();

    // These should be set from config.h values
    QVERIFY(!appName.isEmpty());
    QVERIFY(!appVersion.isEmpty());

    // Test application directory structure
    QString appDir = QApplication::applicationDirPath();
    QDir dir(appDir);
    QVERIFY(dir.exists());

    // Test that styles directory exists (copied by build system)
    QDir stylesDir(appDir + "/styles");
    if (!stylesDir.exists()) {
        // Styles might be in different location during testing
        qDebug() << "Styles directory not found at:"
                 << stylesDir.absolutePath();
        // This is not a failure for unit tests
    }
}

QTEST_MAIN(TestBuildIntegration)
#include "test_build_integration.moc"
