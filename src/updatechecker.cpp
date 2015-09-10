#include "updatechecker.h"

UpdateChecker::UpdateChecker(QObject *parent)
    : QObject(parent)
{
    progress = new QProgressDialog();
    connect(progress, SIGNAL(canceled()), this, SLOT(canceledCheck()));
    autoClose = false;
}

void UpdateChecker::setTitle(QString title)
{
    progress->setWindowTitle(title);
}

void UpdateChecker::setLabelText(QString labelText)
{
    progress->setLabelText(labelText);
}

void UpdateChecker::setMarqueBar(bool marque)
{
    if(marque)
        progress->setMaximum(0);
}

void UpdateChecker::setUrl(QString url)
{
    this->url = QUrl(url);
}

void UpdateChecker::close()
{
    autoClose = true;
    progress->close();
}

void UpdateChecker::canceledCheck()
{
    if(!autoClose)
    {
        QMessageBox::information(0, "Update Canceled", "You have caceled the update check. Click \"Check for Updates\" again to retry.");
    }
}

void UpdateChecker::check()
{
    progress->show();

    QEventLoop evtLoop;

    connect(&mgr, SIGNAL(finished(QNetworkReply*)), &evtLoop, SLOT(quit()));

    QNetworkRequest req(this->url);
    reply = mgr.get(req);
    evtLoop.exec();

    if(reply->error() == QNetworkReply::NoError)
    {
        QString strReply = (QString)reply->readAll();

        QJsonDocument jDoc = QJsonDocument::fromJson(strReply.toUtf8());
        QJsonObject json = jDoc.object();

        emit checkComplete(json["version"].toString(),
                json["versionCode"].toString());

        delete reply;
    }
    else
    {
        QMessageBox::critical(0, "Update Error", reply->errorString());
        delete reply;
        progress->close();
    }
}
