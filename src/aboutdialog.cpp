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

    // button connections
    connect(ui->bClose, SIGNAL(clicked()), this, SLOT(onCloseButtonClicked()));
    connect(ui->bSite, SIGNAL(clicked()), this, SLOT(onSiteButtonClicked()));
}

AboutDialog::~AboutDialog()
{
    delete ui;
}

void AboutDialog::onCloseButtonClicked()
{
    this->close();
}

void AboutDialog::onSiteButtonClicked()
{
    QDesktopServices::openUrl(QString("http://kalebklein.com/portfolio/post/checkmate"));
}

void AboutDialog::setAppVersion(QString version)
{
    ui->lblAppVersion->setText("Application Version: " + version);
}

void AboutDialog::setGenVersion(QString version)
{
    ui->lblGenVersion->setText("Checksum Generator Version: " + version);
}
