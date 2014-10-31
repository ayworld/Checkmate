#ifndef UPDATER_H
#define UPDATER_H

#include <QObject>
#include <QMessageBox>
#include <QtCore>

#include "filedownloader.h"

class Updater : public QObject
{
    Q_OBJECT
public:
    explicit Updater(QObject *parent = 0);
    void begin();

private:
    FileDownloader *downloader;
    void beginDownload();

signals:

public slots:

private slots:
    void updateComplete();
};

#endif // UPDATER_H
