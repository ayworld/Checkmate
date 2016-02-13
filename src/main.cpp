#include "mainwindow.h"
#include "msgbox.h"
#include <QApplication>
#include <QFile>
#include <QDir>
#include <QDesktopServices>
#include <QFontDatabase>

int main(int argc, char *argv[])
{
    QApplication a(argc, argv);
    MainWindow w;

    QFile setup(QString("%1/AppData/Local/Temp/%2").arg(QDir::homePath(), "checkmate_setup.exe"));
    if(setup.exists())
    {
        setup.remove();
    }

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

    return a.exec();
}
