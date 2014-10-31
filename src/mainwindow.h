#ifndef MAINWINDOW_H
#define MAINWINDOW_H

#include <QMainWindow>
#include <QDesktopServices>
#include <QtCore>

#include "validationthread.h"
#include "checksumgenerator.h"
#include "aboutdialog.h"
#include "filedownloader.h"

namespace Ui {
class MainWindow;
}

class MainWindow : public QMainWindow
{
    Q_OBJECT

public:
    explicit MainWindow(QWidget *parent = 0);
    ~MainWindow();
    ValidationThread *mThread;

private:
    Ui::MainWindow *ui;
    void alert(QString, QString, bool critical = false);
    void establishUIConnections();
    bool working;
    int lVersion;
    QString version, gversion;
    FileDownloader *downloader;
    void setHashType(QString);
    int hashType;

protected:
    void closeEvent(QCloseEvent * e = NULL);

private slots:
    void onExitActionTriggered();
    void onAboutActionTriggered();
    void onBrowseFileButtonClicked();
    void onBrowseHashButtonClicked();
    void onValidateButtonClicked();
    void onCalculationPerformed(QString);
    void OpenChecksumGeneratorWindow();
    void onUpdateCheckActionTriggered();

    void onCompleted();
    void onUpdateComplete();

};

#endif // MAINWINDOW_H
