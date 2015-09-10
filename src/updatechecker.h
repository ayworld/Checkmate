#ifndef UPDATECHECKER_H
#define UPDATECHECKER_H

#include <QApplication> // for QEventLoop

#include <QObject>
#include <QProgressDialog>
#include <QMessageBox>

#include <QUrl>
#include <QNetworkAccessManager>
#include <QNetworkRequest>
#include <QNetworkReply>

#include <QJsonDocument>
#include <QJsonObject>

class UpdateChecker : public QObject
{
    Q_OBJECT
public:
    explicit UpdateChecker(QObject *parent = 0);
    void setTitle(QString title = "Dialog");
    void setLabelText(QString labelText);
    void setMarqueBar(bool marque = false);
    void setUrl(QString url);
    void check();
    void close();

private:
    QUrl url;
    QNetworkAccessManager mgr;
    QNetworkReply *reply;
    QProgressDialog *progress;
    bool autoClose;

signals:
    void checkComplete(QString version,
                       QString versionCode);
public slots:
    void canceledCheck();

};

#endif // UPDATECHECKER_H
