#include "mainwindow.h"
#include "msgbox.h"
#include <QApplication>
#include <QFile>
#include <QDesktopServices>
#include <QFontDatabase>

int main(int argc, char *argv[])
{
    QApplication a(argc, argv);
    MainWindow w;

    QFile f(":res/styles/flat.css");
    if(f.exists())
    {
       f.open(QFile::ReadOnly | QFile::Text);
        QTextStream ts(&f);
        qApp->setStyleSheet(ts.readAll());
    }

    int id = QFontDatabase::addApplicationFont(":res/fonts/ubuntu.ttf");
    QString fam = QFontDatabase::applicationFontFamilies(id).at(0);
    QFont ubuntu(fam);
    qApp->setFont(ubuntu);

    w.show();

    if(QCoreApplication::arguments().count() > 1)
    {
        QString arg = QCoreApplication::arguments().at(1);
        if(arg == QString("/D") || arg == QString("/d"))
        {
            QFile oldFile("Checkmate.exe.old");
            QFile upFile("CheckmateUpdater.exe");
            if(oldFile.exists())
                oldFile.remove();
            if(upFile.exists())
                upFile.remove();

            MsgBox msg(&w, "Up to Date", "You are now up to date! Would you like to view the changelog?", MsgBox::YesNo, MsgBox::IconQuestion);
            if(msg.exec() == MsgBox::Yes)
            {
                QDesktopServices::openUrl(QString("http://kalebklein.com/portfolio/post/checkmate"));
            }
        }
    }

    return a.exec();
}
