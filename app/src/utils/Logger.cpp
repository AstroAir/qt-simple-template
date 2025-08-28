#include "utils/Logger.h"
#include <QCoreApplication>
#include <QDebug>
#include <QDir>
#include <QStandardPaths>
#include <iostream>

Logger *Logger::s_instance = nullptr;
QMutex Logger::s_mutex;

Logger::Logger(QObject *parent)
    : QObject(parent),
      m_logFile(nullptr),
      m_logStream(nullptr),
      m_logLevel(Info),
      m_consoleOutput(true),
      m_fileOutput(false) {}

Logger::~Logger() {
    if (m_logStream) {
        delete m_logStream;
    }
    if (m_logFile) {
        m_logFile->close();
        delete m_logFile;
    }
}

Logger *Logger::instance() {
    QMutexLocker locker(&s_mutex);
    if (!s_instance) {
        s_instance = new Logger();
    }
    return s_instance;
}

bool Logger::initialize(const QString &logFilePath, LogLevel logLevel) {
    m_logLevel = logLevel;

    if (!logFilePath.isEmpty()) {
        setLogFile(logFilePath);
        setFileOutput(true);
    }

    info("Logger initialized", "Logger");
    return true;
}

void Logger::setLogLevel(LogLevel level) { m_logLevel = level; }

Logger::LogLevel Logger::getLogLevel() const { return m_logLevel; }

void Logger::setConsoleOutput(bool enabled) { m_consoleOutput = enabled; }

bool Logger::isConsoleOutputEnabled() const { return m_consoleOutput; }

void Logger::setFileOutput(bool enabled) { m_fileOutput = enabled; }

bool Logger::isFileOutputEnabled() const { return m_fileOutput; }

void Logger::setLogFile(const QString &filePath) {
    QMutexLocker locker(&m_writeMutex);

    // Close existing file
    if (m_logStream) {
        delete m_logStream;
        m_logStream = nullptr;
    }
    if (m_logFile) {
        m_logFile->close();
        delete m_logFile;
        m_logFile = nullptr;
    }

    m_logFilePath = filePath;

    if (!m_logFilePath.isEmpty()) {
        // Create directory if it doesn't exist
        QDir dir = QFileInfo(m_logFilePath).absoluteDir();
        if (!dir.exists()) {
            dir.mkpath(".");
        }

        // Open log file
        m_logFile = new QFile(m_logFilePath);
        if (m_logFile->open(QIODevice::WriteOnly | QIODevice::Append)) {
            m_logStream = new QTextStream(m_logFile);
        } else {
            delete m_logFile;
            m_logFile = nullptr;
            qWarning() << "Failed to open log file:" << m_logFilePath;
        }
    }
}

QString Logger::getLogFile() const { return m_logFilePath; }

void Logger::log(LogLevel level, const QString &message,
                 const QString &category) {
    if (level < m_logLevel) {
        return;
    }

    QDateTime timestamp = QDateTime::currentDateTime();
    QString formattedMessage =
        formatMessage(level, message, category, timestamp);

    if (m_consoleOutput) {
        writeToConsole(formattedMessage);
    }

    if (m_fileOutput) {
        writeToFile(formattedMessage);
    }

    emit messageLogged(level, message, category, timestamp);
}

void Logger::debug(const QString &message, const QString &category) {
    log(Debug, message, category);
}

void Logger::info(const QString &message, const QString &category) {
    log(Info, message, category);
}

void Logger::warning(const QString &message, const QString &category) {
    log(Warning, message, category);
}

void Logger::error(const QString &message, const QString &category) {
    log(Error, message, category);
}

void Logger::critical(const QString &message, const QString &category) {
    log(Critical, message, category);
}

void Logger::clearLog() {
    QMutexLocker locker(&m_writeMutex);

    if (m_logFile) {
        m_logFile->resize(0);
    }
}

QString Logger::logLevelToString(LogLevel level) {
    switch (level) {
        case Debug:
            return "DEBUG";
        case Info:
            return "INFO";
        case Warning:
            return "WARNING";
        case Error:
            return "ERROR";
        case Critical:
            return "CRITICAL";
        default:
            return "UNKNOWN";
    }
}

void Logger::writeToConsole(const QString &formattedMessage) {
    std::cout << formattedMessage.toStdString() << std::endl;
}

void Logger::writeToFile(const QString &formattedMessage) {
    QMutexLocker locker(&m_writeMutex);

    if (m_logStream) {
        *m_logStream << formattedMessage << Qt::endl;
        m_logStream->flush();
    }
}

QString Logger::formatMessage(LogLevel level, const QString &message,
                              const QString &category,
                              const QDateTime &timestamp) {
    QString formattedMessage =
        QString("[%1] [%2]")
            .arg(timestamp.toString("yyyy-MM-dd hh:mm:ss.zzz"))
            .arg(logLevelToString(level));

    if (!category.isEmpty()) {
        formattedMessage += QString(" [%1]").arg(category);
    }

    formattedMessage += QString(" %1").arg(message);

    return formattedMessage;
}
