#include <controls/Slider.h>
#include <QApplication>
#include <QtTest>
#include "Widget.h"

class BenchmarkWidgetPerformance : public QObject {
    Q_OBJECT

private slots:
    void initTestCase();
    void cleanupTestCase();

    // Benchmark test cases
    void benchmarkWidgetCreation();
    void benchmarkWidgetShow();
    void benchmarkSliderCreation();
    void benchmarkSliderValueChange();

private:
    Widget* widget;
};

void BenchmarkWidgetPerformance::initTestCase() {
    qDebug("Starting Widget Performance benchmarks");
}

void BenchmarkWidgetPerformance::cleanupTestCase() {
    qDebug("Finished Widget Performance benchmarks");
}

void BenchmarkWidgetPerformance::benchmarkWidgetCreation() {
    QBENCHMARK {
        Widget* testWidget = new Widget();
        delete testWidget;
    }
}

void BenchmarkWidgetPerformance::benchmarkWidgetShow() {
    widget = new Widget();

    QBENCHMARK {
        widget->show();
        QApplication::processEvents();
        widget->hide();
        QApplication::processEvents();
    }

    delete widget;
    widget = nullptr;
}

void BenchmarkWidgetPerformance::benchmarkSliderCreation() {
    QBENCHMARK {
        Slider* slider = new Slider();
        delete slider;
    }
}

void BenchmarkWidgetPerformance::benchmarkSliderValueChange() {
    Slider* slider = new Slider();

    QBENCHMARK {
        for (int i = 0; i < 100; ++i) {
            slider->setValue(i % 100);
        }
    }

    delete slider;
}

QTEST_MAIN(BenchmarkWidgetPerformance)
#include "benchmark_widget_performance.moc"
