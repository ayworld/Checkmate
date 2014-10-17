#ifndef CHECKSUMGENERATOR_H
#define CHECKSUMGENERATOR_H

#include <QMainWindow>
#include <QFile>
#include <QFileDialog>
#include <QMessageBox>
#include <QRect>
#include <QDesktopWidget>
#include <QCloseEvent>

#include "validationthread.h"

#define HASH_MD5        0x01
#define HASH_SHA1       0x02
#define HASH_SHA256     0x03

namespace Ui {
class ChecksumGenerator;
}

class ChecksumGenerator : public QMainWindow
{
    Q_OBJECT

public:
    explicit ChecksumGenerator(QWidget *parent = 0);
    ~ChecksumGenerator();
    ValidationThread *mThread;

private:
    Ui::ChecksumGenerator *ui;
    bool working;
    void closeEvent(QCloseEvent *);
    int optionSelected;
    void uncheckCheckedItem();
    QString f; // filename, needed for saving
    QString getFilterOption();

private slots:
    void onBrowseButtonClicked();
    void onGenerateButtonClicked();
    void onSaveButtonClicked();
    void onCalculationPerformed(QString);

    // Menu slots
    void onActionMD5Checked();
    void onActionSHA1Checked();
    void onActionSHA256Checked();
};

#endif // CHECKSUMGENERATOR_H
