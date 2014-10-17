#include "aboutdialog.h"
#include "ui_aboutdialog.h"

AboutDialog::AboutDialog(QWidget *parent) :
    QDialog(parent),
    ui(new Ui::AboutDialog)
{
    ui->setupUi(this);
    QRect position = frameGeometry();
    position.moveCenter(QDesktopWidget().availableGeometry().center());
    move(position.topLeft());

    // Close button connection
    connect(ui->bClose, SIGNAL(clicked()), this, SLOT(onCloseButtonClicked()));
}

AboutDialog::~AboutDialog()
{
    delete ui;
}

void AboutDialog::onCloseButtonClicked()
{
    this->close();
}

void AboutDialog::setAppVersion(QString version)
{
    ui->lblAppVersion->setText("Application Version: " + version);
}

void AboutDialog::setGenVersion(QString version)
{
    ui->lblGenVersion->setText("Checksum Generator Version: " + version);
}
