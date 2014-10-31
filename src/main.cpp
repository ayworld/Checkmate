#include "mainwindow.h"
#include <QApplication>

int main(int argc, char *argv[])
{
    QApplication a(argc, argv);
    MainWindow w;
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

            QMessageBox::information(&w, "Up to Date", "You are now up to date!");
        }
    }

    return a.exec();
}
