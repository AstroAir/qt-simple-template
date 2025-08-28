#pragma once

#include "models/BaseModel.h"
#include <QString>
#include <QDateTime>

/**
 * @brief Main application model
 * 
 * This model represents the main application state and data.
 * It manages application-wide settings and information.
 */
class ApplicationModel : public BaseModel
{
    Q_OBJECT

public:
    explicit ApplicationModel(QObject *parent = nullptr);
    virtual ~ApplicationModel() = default;

    // Property names as constants
    static const QString PROPERTY_APP_NAME;
    static const QString PROPERTY_APP_VERSION;
    static const QString PROPERTY_APP_TITLE;
    static const QString PROPERTY_STATUS_MESSAGE;
    static const QString PROPERTY_IS_BUSY;
    static const QString PROPERTY_LAST_UPDATED;
    static const QString PROPERTY_USER_NAME;
    static const QString PROPERTY_THEME;

    // Convenience getters
    QString getAppName() const;
    QString getAppVersion() const;
    QString getAppTitle() const;
    QString getStatusMessage() const;
    bool isBusy() const;
    QDateTime getLastUpdated() const;
    QString getUserName() const;
    QString getTheme() const;

    // Convenience setters
    void setAppName(const QString &name);
    void setAppVersion(const QString &version);
    void setAppTitle(const QString &title);
    void setStatusMessage(const QString &message);
    void setBusy(bool busy);
    void setLastUpdated(const QDateTime &dateTime);
    void setUserName(const QString &userName);
    void setTheme(const QString &theme);

    // Business logic methods
    void updateStatus(const QString &message);
    void clearStatus();
    bool loadSettings();
    bool saveSettings();

protected:
    bool initializeModel() override;
    bool validateModel() const override;
    void resetModel() override;
    bool beforePropertySet(const QString &propertyName, const QVariant &value) override;
    void afterPropertySet(const QString &propertyName, const QVariant &oldValue, const QVariant &newValue) override;

signals:
    /**
     * @brief Emitted when the application status changes
     * @param message The new status message
     */
    void statusChanged(const QString &message);

    /**
     * @brief Emitted when the busy state changes
     * @param busy The new busy state
     */
    void busyStateChanged(bool busy);

    /**
     * @brief Emitted when the theme changes
     * @param theme The new theme name
     */
    void themeChanged(const QString &theme);

    /**
     * @brief Emitted when settings are loaded
     */
    void settingsLoaded();

    /**
     * @brief Emitted when settings are saved
     */
    void settingsSaved();

private:
    void initializeDefaults();
    bool isValidTheme(const QString &theme) const;
};
