#ifndef VALIDATIONTHREAD_H
#define VALIDATIONTHREAD_H

#include <QThread>
#include <QMutex>
#include <QCryptographicHash>
#include <QFile>

class ValidationThread : public QThread
{
    Q_OBJECT
public:
    explicit ValidationThread(QObject *parent = 0);
    void setFileLocation(QString);
    void run();
    bool Stop; // May never get used, but yeah..
    void setHashType(int);

private:
    QString fileName;
    QCryptographicHash *c = NULL;

signals:
    void CalculationPerformed(QString);

public slots:

};

#endif // VALIDATIONTHREAD_H
