#include <controls/Slider.h>
#include <QApplication>
#include <QtTest>

class TestSlider : public QObject {
    Q_OBJECT

private slots:
    void initTestCase();
    void cleanupTestCase();
    void init();
    void cleanup();

    // Test cases
    void testSliderCreation();
    void testSliderValue();
    void testSliderRange();
    void testSliderSignals();
    void testSliderProperties();

private:
    Slider* slider;
};

void TestSlider::initTestCase() {
    // Called before the first test function is executed
    qDebug("Starting Slider tests");
}

void TestSlider::cleanupTestCase() {
    // Called after the last test function was executed
    qDebug("Finished Slider tests");
}

void TestSlider::init() {
    // Called before each test function is executed
    slider = new Slider();
    QVERIFY(slider != nullptr);
}

void TestSlider::cleanup() {
    // Called after every test function
    delete slider;
    slider = nullptr;
}

void TestSlider::testSliderCreation() {
    QVERIFY(slider != nullptr);
    QVERIFY(slider->isEnabled());
}

void TestSlider::testSliderValue() {
    // Test default value
    QCOMPARE(slider->value(), 0);

    // Test setting value
    slider->setValue(50);
    QCOMPARE(slider->value(), 50);

    // Test value bounds
    slider->setValue(-10);
    QVERIFY(slider->value() >= slider->minimum());

    slider->setValue(200);
    QVERIFY(slider->value() <= slider->maximum());
}

void TestSlider::testSliderRange() {
    // Test default range
    QCOMPARE(slider->minimum(), 0);
    QCOMPARE(slider->maximum(), 99);

    // Test setting range
    slider->setRange(10, 90);
    QCOMPARE(slider->minimum(), 10);
    QCOMPARE(slider->maximum(), 90);

    // Test invalid range
    slider->setRange(90, 10);
    QVERIFY(slider->minimum() <= slider->maximum());
}

void TestSlider::testSliderSignals() {
    QSignalSpy valueSpy(slider, &Slider::valueChanged);
    QVERIFY(valueSpy.isValid());

    slider->setValue(25);
    QCOMPARE(valueSpy.count(), 1);

    QList<QVariant> arguments = valueSpy.takeFirst();
    QCOMPARE(arguments.at(0).toInt(), 25);
}

void TestSlider::testSliderProperties() {
    // Test orientation
    QCOMPARE(slider->orientation(), Qt::Horizontal);

    slider->setOrientation(Qt::Vertical);
    QCOMPARE(slider->orientation(), Qt::Vertical);

    // Test tracking
    QVERIFY(slider->hasTracking());

    slider->setTracking(false);
    QVERIFY(!slider->hasTracking());
}

QTEST_MAIN(TestSlider)
#include "test_slider.moc"
