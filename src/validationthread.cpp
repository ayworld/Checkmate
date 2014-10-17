#include "validationthread.h"

ValidationThread::ValidationThread(QObject *parent) :
    QThread(parent)
{
}

void ValidationThread::setFileLocation(QString fileName)
{
    this->fileName = fileName;
}

void ValidationThread::run()
{
    QMutex mutex;
    mutex.lock();

    if(c == NULL)
        setHashType(0x00);
    QFile file(this->fileName);
    file.open(QFile::ReadOnly);
    while(!file.atEnd())
    {
        c->addData(file.read(8192));
    }
    QByteArray hashData = c->result();
    QString hash = hashData.toHex();

    mutex.unlock();

    emit CalculationPerformed(hash);
}

void ValidationThread::setHashType(int type)
{
    switch(type)
    {
    case 0x01:
        c = new QCryptographicHash(QCryptographicHash::Md5);
        break;
    case 0x02:
        c = new QCryptographicHash(QCryptographicHash::Sha1);
        break;
    case 0x03:
        c = new QCryptographicHash(QCryptographicHash::Sha256);
        break;
    default:
        c = new QCryptographicHash(QCryptographicHash::Md5);
        break;
    }
}
