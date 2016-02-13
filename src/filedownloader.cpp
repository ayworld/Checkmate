#include "filedownloader.h"

FileDownloader::FileDownloader(QObject *parent) :
    QObject(parent)
{
    progress = new QProgressDialog();

    connect(progress, SIGNAL(canceled()), this, SLOT(cancelDownload()));
}

void FileDownloader::startRequest(QUrl url)
{
    reply = manager->get(QNetworkRequest(url));

    connect(reply, SIGNAL(readyRead()), this, SLOT(httpReadyRead()));
    connect(reply, SIGNAL(downloadProgress(qint64,qint64)), this, SLOT(updateDownloadProgress(qint64,qint64)));
    connect(reply, SIGNAL(finished()), this, SLOT(httpDownloadFinished()));
}

void FileDownloader::setSilentDownload(bool silent)
{
    this->silent = silent;
}

void FileDownloader::deleteFileAtEnd(bool del)
{
    this->del = del;
}

void FileDownloader::setTitle(QString title)
{
    progress->setWindowTitle(title);
}

void FileDownloader::setLabelText(QString labelText)
{
    progress->setLabelText(labelText);
}

void FileDownloader::httpReadyRead()
{
    if(file)
        file->write(reply->readAll());
}

void FileDownloader::httpDownloadFinished()
{
    if(this->httpRequestAborted)
    {
        if(file)
        {
            file->close();
            file->remove();
            delete file;
            file = 0;
        }
        reply->deleteLater();
        progress->hide();
        return;
    }

    // Normal finish
    progress->hide();
    file->flush();
    file->close();

    QVariant redirecTarget = reply->attribute(QNetworkRequest::RedirectionTargetAttribute);
    if(reply->error() == QNetworkReply::HostNotFoundError)
    {
        emit connectionFailed();
    }
    else if(reply->error())
    {
        file->remove();
        MsgBox msg(0, "HTTP", tr("Download failed: %1").arg(reply->errorString()));
        msg.setIcon(MsgBox::IconError);
        msg.exec();
    }
    else if(!redirecTarget.isNull())
    {
        QUrl newUrl = url.resolved(redirecTarget.toUrl());
        MsgBox msg(0, "HTTP", tr("Redirect to %1?").arg(newUrl.toString()),
                   MsgBox::YesNo, MsgBox::IconQuestion);
        if(msg.exec() == MsgBox::Yes)
        {
            url = newUrl;
            reply->deleteLater();
            file->open(QIODevice::WriteOnly);
            file->resize(0);
            startRequest(url);
            return;
        }
    }
    else
    {
        reply->deleteLater();
        reply = 0;
        delete file;
        file = 0;
        manager = 0;

        emit downloadFinished();
    }
}

void FileDownloader::updateDownloadProgress(qint64 bytesRead, qint64 totalBytes)
{
    if(httpRequestAborted)
        return;

    if(!this->silent)
    {
        progress->setMaximum(totalBytes);
        progress->setValue(bytesRead);
    }
}

void FileDownloader::cancelDownload()
{
    httpRequestAborted = true;
    reply->abort();
    MsgBox msg(0, "HTTP", "You have canceled the download. Click \"Check for Updates\" to retry.");
    msg.setIcon(MsgBox::IconInfo);
    msg.exec();
}

void FileDownloader::setMarqueBar(bool marque)
{
    if(marque)
    {
        progress->setMaximum(0);
        this->setSilentDownload(true);
    }
}

void FileDownloader::setURL(QString url)
{
    this->url = url;
}

void FileDownloader::begin()
{
    progress->show();

    manager = new QNetworkAccessManager(this);

    QFileInfo fileInfo(url.path());
    QString fileName = fileInfo.fileName();

    if(fileName.isEmpty())
        fileName = "empty.txt";

    file = new QFile(QString("%1/AppData/Local/Temp/%2").arg(QDir::homePath(), fileName));
    if(!file->open(QIODevice::WriteOnly))
    {
        MsgBox msg(0, "ERROR", tr("Unable to save the file %1: %2").arg(fileName).arg(file->errorString()));
        msg.setIcon(MsgBox::IconError);
        msg.exec();
        delete file;
        file = 0;
        return;
    }

    httpRequestAborted = false;

    startRequest(url);
}
