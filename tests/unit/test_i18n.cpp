#include <QApplication>
#include <QDir>
#include <QFile>
#include <QTranslator>
#include <QtTest>

class TestI18n : public QObject {
    Q_OBJECT

private slots:
    void initTestCase();
    void cleanupTestCase();

    // Test cases
    void testTranslationFilesExist();
    void testTranslationLoading();
    void testTranslationContent();
};

void TestI18n::initTestCase() { qDebug("Starting I18n tests"); }

void TestI18n::cleanupTestCase() { qDebug("Finished I18n tests"); }

void TestI18n::testTranslationFilesExist() {
    // Test that translation source files exist
    QString i18nDir = QDir::currentPath() + "/app/i18n";

    QFile englishTs(i18nDir + "/app_en.ts");
    QVERIFY2(englishTs.exists(),
             "English translation source file should exist");

    QFile chineseTs(i18nDir + "/app_zh.ts");
    QVERIFY2(chineseTs.exists(),
             "Chinese translation source file should exist");
}

void TestI18n::testTranslationLoading() {
    QTranslator translator;

    // Test loading English translation (if compiled .qm exists)
    QString appDir = QApplication::applicationDirPath();
    bool englishLoaded = translator.load("app_en.qm", appDir);

    // Note: .qm files might not exist in test environment
    // This test verifies the loading mechanism works
    if (QFile::exists(appDir + "/app_en.qm")) {
        QVERIFY(englishLoaded);
    }

    // Test loading Chinese translation
    QTranslator chineseTranslator;
    bool chineseLoaded = chineseTranslator.load("app_zh.qm", appDir);

    if (QFile::exists(appDir + "/app_zh.qm")) {
        QVERIFY(chineseLoaded);
    }
}

void TestI18n::testTranslationContent() {
    // Test that translation source files contain expected content
    QString i18nDir = QDir::currentPath() + "/app/i18n";

    // Test Chinese translation file
    QFile chineseTs(i18nDir + "/app_zh.ts");
    if (chineseTs.open(QIODevice::ReadOnly)) {
        QString content = chineseTs.readAll();
        chineseTs.close();

        // Verify it's a valid TS file
        QVERIFY(content.contains("<?xml"));
        QVERIFY(content.contains("<TS"));
        QVERIFY(content.contains("language=\"zh"));

        // Verify it contains some translations
        QVERIFY(content.contains("<message>"));
        QVERIFY(content.contains("<translation>"));
    }

    // Test English translation file
    QFile englishTs(i18nDir + "/app_en.ts");
    if (englishTs.open(QIODevice::ReadOnly)) {
        QString content = englishTs.readAll();
        englishTs.close();

        // Verify it's a valid TS file
        QVERIFY(content.contains("<?xml"));
        QVERIFY(content.contains("<TS"));
        QVERIFY(content.contains("language=\"en"));
    }
}

QTEST_MAIN(TestI18n)
#include "test_i18n.moc"
