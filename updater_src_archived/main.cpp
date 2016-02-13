#include <QApplication>
#include "updater.h"

int main(int argc, char *argv[])
{
    QApplication a(argc, argv);

    Updater *updater = new Updater();
    updater->begin();

    return a.exec();
}
