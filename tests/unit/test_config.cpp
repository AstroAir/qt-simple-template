#include "config.h"
#include <QApplication>
#include <QtTest>

class TestConfig : public QObject {
    Q_OBJECT

private slots:
    void initTestCase();
    void cleanupTestCase();

    // Test cases
    void testProjectConstants();
    void testVersionConstants();
    void testApplicationInfo();
};

void TestConfig::initTestCase() { qDebug("Starting Config tests"); }

void TestConfig::cleanupTestCase() { qDebug("Finished Config tests"); }

void TestConfig::testProjectConstants() {
    // Test that project constants are defined and not empty
    QVERIFY(QString(PROJECT_NAME).length() > 0);
    QVERIFY(QString(APP_NAME).length() > 0);

    // Test that project name is reasonable
    QString projectName(PROJECT_NAME);
    QVERIFY(!projectName.isEmpty());
    QVERIFY(projectName.length() < 100);  // Reasonable length
}

void TestConfig::testVersionConstants() {
    // Test that version constants are defined
    QVERIFY(QString(PROJECT_VER).length() > 0);
    QVERIFY(QString(PROJECT_VER_MAJOR).length() > 0);
    QVERIFY(QString(PROJECT_VER_MINOR).length() > 0);
    QVERIFY(QString(PROJECT_VER_PATCH).length() > 0);

    // Test version format (basic validation)
    QString version(PROJECT_VER);
    QVERIFY(version.contains('.'));

    // Test that version components are numeric
    bool ok;
    QString(PROJECT_VER_MAJOR).toInt(&ok);
    QVERIFY(ok);

    QString(PROJECT_VER_MINOR).toInt(&ok);
    QVERIFY(ok);

    QString(PROJECT_VER_PATCH).toInt(&ok);
    QVERIFY(ok);
}

void TestConfig::testApplicationInfo() {
    // Test that the application can be configured with these constants
    QApplication::setApplicationName(PROJECT_NAME);
    QApplication::setApplicationVersion(PROJECT_VER);
    QApplication::setApplicationDisplayName(APP_NAME);

    QCOMPARE(QApplication::applicationName(), QString(PROJECT_NAME));
    QCOMPARE(QApplication::applicationVersion(), QString(PROJECT_VER));
    QCOMPARE(QApplication::applicationDisplayName(), QString(APP_NAME));
}

QTEST_MAIN(TestConfig)
#include "test_config.moc"
