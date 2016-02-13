#ifndef FILEDOWNLOADER_H
#define FILEDOWNLOADER_H

#include <QObject>
#include <QtNetwork>
#include <QProgressDialog>
#include <QDir>

#include "msgbox.h"

class FileDownloader : public QObject
{
    Q_OBJECT
public:
    explicit FileDownloader(QObject *parent = 0);
    void startRequest(QUrl);
    void setSilentDownload(bool silent = false);
    void deleteFileAtEnd(bool del = false);
    void setTitle(QString title = "Dialog");
    void setLabelText(QString);
    void setMarqueBar(bool marque = false);
    void setURL(QString);


signals:
    void downloadFinished();
    void connectionFailed();

public slots:
    void httpReadyRead();
    void httpDownloadFinished();
    void updateDownloadProgress(qint64, qint64);
    void cancelDownload();
    void begin();

private:
    QUrl url;
    QNetworkAccessManager *manager;
    QNetworkReply *reply;
    QProgressDialog *progress;
    QFile *file;
    bool httpRequestAborted;
    qint64 fileSize;
    bool silent, del;

};

#endif // FILEDOWNLOADER_H
