/**
 * @file ProgressIndicator.h
 * @brief Custom animated progress indicator widget
 * 
 * This example demonstrates creating a custom Qt widget with:
 * - Custom painting using QPainter
 * - Animation using QPropertyAnimation
 * - Property system integration
 * - Responsive design principles
 */

#pragma once

#include <QWidget>
#include <QPropertyAnimation>
#include <QTimer>
#include <QPainter>
#include <QColor>

/**
 * @class ProgressIndicator
 * @brief Animated circular progress indicator widget
 * 
 * Features:
 * - Smooth rotation animation
 * - Customizable colors and size
 * - Start/stop animation control
 * - Responsive to widget resizing
 * - Property-based configuration
 */
class ProgressIndicator : public QWidget
{
    Q_OBJECT
    Q_PROPERTY(int rotation READ rotation WRITE setRotation)
    Q_PROPERTY(QColor color READ color WRITE setColor)
    Q_PROPERTY(int lineWidth READ lineWidth WRITE setLineWidth)
    Q_PROPERTY(int lineLength READ lineLength WRITE setLineLength)
    Q_PROPERTY(int innerRadius READ innerRadius WRITE setInnerRadius)

public:
    /**
     * @brief Constructor
     * @param parent Parent widget
     */
    explicit ProgressIndicator(QWidget *parent = nullptr);
    
    /**
     * @brief Destructor
     */
    ~ProgressIndicator() override;

    // Property getters
    int rotation() const { return m_rotation; }
    QColor color() const { return m_color; }
    int lineWidth() const { return m_lineWidth; }
    int lineLength() const { return m_lineLength; }
    int innerRadius() const { return m_innerRadius; }
    
    // Property setters
    void setRotation(int rotation);
    void setColor(const QColor &color);
    void setLineWidth(int width);
    void setLineLength(int length);
    void setInnerRadius(int radius);
    
    /**
     * @brief Check if animation is running
     * @return True if animating
     */
    bool isAnimating() const;
    
    /**
     * @brief Get recommended size for the widget
     * @return Recommended size
     */
    QSize sizeHint() const override;
    
    /**
     * @brief Get minimum size for the widget
     * @return Minimum size
     */
    QSize minimumSizeHint() const override;

public slots:
    /**
     * @brief Start the animation
     */
    void startAnimation();
    
    /**
     * @brief Stop the animation
     */
    void stopAnimation();
    
    /**
     * @brief Toggle animation state
     */
    void toggleAnimation();

signals:
    /**
     * @brief Emitted when animation starts
     */
    void animationStarted();
    
    /**
     * @brief Emitted when animation stops
     */
    void animationStopped();

protected:
    /**
     * @brief Paint the widget
     * @param event Paint event
     */
    void paintEvent(QPaintEvent *event) override;
    
    /**
     * @brief Handle resize events
     * @param event Resize event
     */
    void resizeEvent(QResizeEvent *event) override;
    
    /**
     * @brief Handle mouse press events
     * @param event Mouse event
     */
    void mousePressEvent(QMouseEvent *event) override;

private slots:
    /**
     * @brief Handle animation finished
     */
    void onAnimationFinished();

private:
    /**
     * @brief Initialize the widget
     */
    void initializeWidget();
    
    /**
     * @brief Setup animation
     */
    void setupAnimation();
    
    /**
     * @brief Calculate line positions
     * @return List of line rectangles
     */
    QVector<QRectF> calculateLines() const;
    
    /**
     * @brief Get color for specific line
     * @param lineIndex Index of the line
     * @return Color with appropriate alpha
     */
    QColor getLineColor(int lineIndex) const;

private:
    // Animation properties
    int m_rotation;                    ///< Current rotation angle
    QPropertyAnimation *m_animation;   ///< Rotation animation
    
    // Visual properties
    QColor m_color;                    ///< Base color
    int m_lineWidth;                   ///< Width of indicator lines
    int m_lineLength;                  ///< Length of indicator lines
    int m_innerRadius;                 ///< Inner radius of the indicator
    
    // Configuration
    static constexpr int DEFAULT_LINE_COUNT = 12;     ///< Number of indicator lines
    static constexpr int DEFAULT_LINE_WIDTH = 2;      ///< Default line width
    static constexpr int DEFAULT_LINE_LENGTH = 8;     ///< Default line length
    static constexpr int DEFAULT_INNER_RADIUS = 8;    ///< Default inner radius
    static constexpr int ANIMATION_DURATION = 1000;   ///< Animation duration in ms
    static constexpr int MINIMUM_SIZE = 32;           ///< Minimum widget size
};

/**
 * @class ProgressIndicatorDemo
 * @brief Demo widget showing ProgressIndicator usage
 */
class ProgressIndicatorDemo : public QWidget
{
    Q_OBJECT

public:
    explicit ProgressIndicatorDemo(QWidget *parent = nullptr);

private slots:
    void onStartStopClicked();
    void onColorChanged();
    void onSizeChanged(int value);

private:
    void setupUI();
    void setupControls();

private:
    ProgressIndicator *m_indicator;
    class QPushButton *m_startStopButton;
    class QComboBox *m_colorCombo;
    class QSlider *m_sizeSlider;
    class QLabel *m_statusLabel;
};

// Forward declarations
class QPushButton;
class QComboBox;
class QSlider;
class QLabel;
