#include <QtTest>
#include <QApplication>
#include <QFile>
#include "Widget.h"

class BenchmarkThemeSwitching : public QObject
{
    Q_OBJECT

private slots:
    void initTestCase();
    void cleanupTestCase();
    void init();
    void cleanup();

    // Benchmark test cases
    void benchmarkThemeApplication();
    void benchmarkStylesheetLoading();
    void benchmarkThemeSwitching();

private:
    Widget* widget;
};

void BenchmarkThemeSwitching::initTestCase()
{
    qDebug("Starting Theme Switching benchmarks");
}

void BenchmarkThemeSwitching::cleanupTestCase()
{
    qDebug("Finished Theme Switching benchmarks");
}

void BenchmarkThemeSwitching::init()
{
    widget = new Widget();
    widget->show();
    QApplication::processEvents();
}

void BenchmarkThemeSwitching::cleanup()
{
    delete widget;
    widget = nullptr;
}

void BenchmarkThemeSwitching::benchmarkThemeApplication()
{
    QBENCHMARK {
        widget->applyTheme("light");
        QApplication::processEvents();
    }
}

void BenchmarkThemeSwitching::benchmarkStylesheetLoading()
{
    QString appDir = QApplication::applicationDirPath();
    QString stylePath = appDir + "/styles/light.qss";
    
    // Fallback for development environment
    if (!QFile::exists(stylePath)) {
        stylePath = "assets/styles/light.qss";
    }
    
    QBENCHMARK {
        QFile styleFile(stylePath);
        if (styleFile.open(QIODevice::ReadOnly)) {
            QString styleContent = styleFile.readAll();
            styleFile.close();
            qApp->setStyleSheet(styleContent);
        }
    }
}

void BenchmarkThemeSwitching::benchmarkThemeSwitching()
{
    QBENCHMARK {
        widget->applyTheme("light");
        QApplication::processEvents();
        widget->applyTheme("dark");
        QApplication::processEvents();
    }
}

QTEST_MAIN(BenchmarkThemeSwitching)
#include "benchmark_theme_switching.moc"
