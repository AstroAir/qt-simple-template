#pragma once

#include <QDateTime>
#include <QFile>
#include <QMutex>
#include <QObject>
#include <QString>
#include <QTextStream>

/**
 * @brief Logging utility class
 *
 * This class provides centralized logging functionality
 * with support for different log levels and output destinations.
 */
class Logger : public QObject {
    Q_OBJECT

public:
    enum LogLevel { Debug = 0, Info = 1, Warning = 2, Error = 3, Critical = 4 };
    Q_ENUM(LogLevel)

    static Logger *instance();

    /**
     * @brief Initialize the logger
     * @param logFilePath Path to the log file (optional)
     * @param logLevel Minimum log level to output
     * @return true if initialization was successful
     */
    bool initialize(const QString &logFilePath = QString(),
                    LogLevel logLevel = Info);

    /**
     * @brief Set the minimum log level
     * @param level The minimum log level
     */
    void setLogLevel(LogLevel level);

    /**
     * @brief Get the current log level
     * @return The current log level
     */
    LogLevel getLogLevel() const;

    /**
     * @brief Enable or disable console output
     * @param enabled Whether console output is enabled
     */
    void setConsoleOutput(bool enabled);

    /**
     * @brief Check if console output is enabled
     * @return true if console output is enabled
     */
    bool isConsoleOutputEnabled() const;

    /**
     * @brief Enable or disable file output
     * @param enabled Whether file output is enabled
     */
    void setFileOutput(bool enabled);

    /**
     * @brief Check if file output is enabled
     * @return true if file output is enabled
     */
    bool isFileOutputEnabled() const;

    /**
     * @brief Set the log file path
     * @param filePath The path to the log file
     */
    void setLogFile(const QString &filePath);

    /**
     * @brief Get the log file path
     * @return The path to the log file
     */
    QString getLogFile() const;

    /**
     * @brief Log a message
     * @param level The log level
     * @param message The message to log
     * @param category Optional category for the message
     */
    void log(LogLevel level, const QString &message,
             const QString &category = QString());

    /**
     * @brief Log a debug message
     * @param message The message to log
     * @param category Optional category for the message
     */
    void debug(const QString &message, const QString &category = QString());

    /**
     * @brief Log an info message
     * @param message The message to log
     * @param category Optional category for the message
     */
    void info(const QString &message, const QString &category = QString());

    /**
     * @brief Log a warning message
     * @param message The message to log
     * @param category Optional category for the message
     */
    void warning(const QString &message, const QString &category = QString());

    /**
     * @brief Log an error message
     * @param message The message to log
     * @param category Optional category for the message
     */
    void error(const QString &message, const QString &category = QString());

    /**
     * @brief Log a critical message
     * @param message The message to log
     * @param category Optional category for the message
     */
    void critical(const QString &message, const QString &category = QString());

    /**
     * @brief Clear the log file
     */
    void clearLog();

    /**
     * @brief Get the log level as string
     * @param level The log level
     * @return The log level as string
     */
    static QString logLevelToString(LogLevel level);

signals:
    /**
     * @brief Emitted when a message is logged
     * @param level The log level
     * @param message The message
     * @param category The category
     * @param timestamp The timestamp
     */
    void messageLogged(LogLevel level, const QString &message,
                       const QString &category, const QDateTime &timestamp);

private:
    explicit Logger(QObject *parent = nullptr);
    ~Logger();

    void writeToConsole(const QString &formattedMessage);
    void writeToFile(const QString &formattedMessage);
    QString formatMessage(LogLevel level, const QString &message,
                          const QString &category, const QDateTime &timestamp);

    static Logger *s_instance;
    static QMutex s_mutex;

    QFile *m_logFile;
    QTextStream *m_logStream;
    LogLevel m_logLevel;
    bool m_consoleOutput;
    bool m_fileOutput;
    QString m_logFilePath;
    QMutex m_writeMutex;
};
