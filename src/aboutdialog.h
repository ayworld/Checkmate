#ifndef ABOUTDIALOG_H
#define ABOUTDIALOG_H

#include <QDialog>
#include <QRect>
#include <QDesktopWidget>
#include <QDesktopServices>
#include <QtCore>

namespace Ui {
class AboutDialog;
}

class AboutDialog : public QDialog
{
    Q_OBJECT

public:
    explicit AboutDialog(QWidget *parent = 0);
    ~AboutDialog();
    void setAppVersion(QString);
    void setGenVersion(QString);

private slots:
    void onCloseButtonClicked();
    void onSiteButtonClicked();

private:
    Ui::AboutDialog *ui;
};

#endif // ABOUTDIALOG_H
