#include "updater.h"

Updater::Updater(QObject *parent) :
    QObject(parent)
{
    system("taskkill /f /im checkmate.exe");
}

void Updater::begin()
{
    QFile::copy("Checkmate.exe", "Checkmate.exe.old");
    QFile::remove("Checkmate.exe");

    beginDownload();
}

void Updater::beginDownload()
{
    downloader = new FileDownloader();
    downloader->setTitle("Updating Checkmate");
    downloader->setLabelText("Updating, please wait...");

    #ifdef QT_DEBUG
        downloader->setURL("http://cdn.kalebklein.com/debug/chm/updates/Checkmate.exe");
    #else
        downloader->setURL("http://cdn.kalebklein.com/chm/updates/Checkmate.exe");
    #endif

    connect(downloader, SIGNAL(downloadFinished()), this, SLOT(updateComplete()));

    downloader->begin();
}

void Updater::updateComplete()
{
    QString program = "Checkmate.exe";
    QStringList args;

    QFile::remove("Checkmate.exe.old");

    args << "/D";

    QProcess *p = new QProcess(this);
    p->start(program, args);

    qApp->quit();
}
