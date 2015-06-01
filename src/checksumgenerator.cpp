#include "checksumgenerator.h"
#include "ui_checksumgenerator.h"

#include <QTextStream>

ChecksumGenerator::ChecksumGenerator(QWidget *parent) :
    QMainWindow(parent),
    ui(new Ui::ChecksumGenerator)
{
    ui->setupUi(this);
    QRect position = frameGeometry();
    position.moveCenter(QDesktopWidget().availableGeometry().center());
    move(position.topLeft());

    connect(ui->bBrowse, SIGNAL(clicked()), this, SLOT(onBrowseButtonClicked()));
    connect(ui->bGenerate, SIGNAL(clicked()), this, SLOT(onGenerateButtonClicked()));
    connect(ui->bSave, SIGNAL(clicked()), this, SLOT(onSaveButtonClicked()));
    connect(ui->actionHash_MD5, SIGNAL(triggered()), this, SLOT(onActionMD5Checked()));
    connect(ui->actionHash_S1, SIGNAL(triggered()), this, SLOT(onActionSHA1Checked()));
    connect(ui->actionHash_S256, SIGNAL(triggered()), this, SLOT(onActionSHA256Checked()));
    connect(ui->actionClose, SIGNAL(triggered()), this, SLOT(close()));

    this->working = false;
    this->optionSelected = HASH_MD5;
}

ChecksumGenerator::~ChecksumGenerator()
{
    delete ui;
}

void ChecksumGenerator::closeEvent(QCloseEvent *event)
{
    if(this->working)
        {
            QMessageBox::StandardButton reply;
            reply = QMessageBox::question(this, "Close", "The generator is still hard at work, are you sure you want to exit?", QMessageBox::Yes|QMessageBox::No);
            if(reply == QMessageBox::Yes)
            {
                event->accept();
            }
            else
            {
                event->ignore();
            }
        }
}

void ChecksumGenerator::onBrowseButtonClicked()
{
    QString fileName =
            QFileDialog::getOpenFileName(
                this,
                tr("Open File"),
                "/",
                tr("All Files (*)")
            );

    if(!fileName.isEmpty())
    {
        ui->leFile->setText(fileName.replace("/", "\\")); // WIN32 hack
        ui->bSave->setEnabled(false);
    }
}

void ChecksumGenerator::onGenerateButtonClicked()
{
    f = ui->leFile->text();
    QFile file(f);

    if(f.isEmpty())
        QMessageBox::critical(0, "Error", "You need to supply a location!");
    else if(!file.exists())
        QMessageBox::critical(0, "Not Found", "That file cannot be found!");
    else
    {
        this->mThread = new ValidationThread();
        this->mThread->setFileLocation(f);
        this->mThread->setHashType(this->optionSelected);
        connect(this->mThread, SIGNAL(CalculationPerformed(QString)), this, SLOT(onCalculationPerformed(QString)));
        this->mThread->start();

        ui->bGenerate->setEnabled(false);
        ui->bGenerate->setText("Generating Checksum, please wait..");
        this->working = true;
    }
}

void ChecksumGenerator::onSaveButtonClicked()
{
    QFileInfo fi(f);
    QString fileName =
            QFileDialog::getSaveFileName(
                this,
                "Save Hash File",
                QString("%1%2").arg(fi.filePath().replace(fi.fileName(), ""), fi.fileName().replace("." + fi.suffix(), "")),
                getFilterOption()
            );

    QFile file(fileName);
    if(file.open(QIODevice::ReadWrite))
    {
        QTextStream stream(&file);
        stream << ui->leFile->text() << "  " << fi.fileName();
        QMessageBox::information(this, "Save Success", QString("The hash has been successfully saved to: %1").arg(fileName));
        ui->leFile->setText(f);
        ui->bSave->setEnabled(false);
    }
    file.close();
}

void ChecksumGenerator::onCalculationPerformed(QString hash)
{
    ui->bGenerate->setEnabled(true);
    ui->bSave->setEnabled(true);

    ui->bGenerate->setText("Generate Checksum");
    ui->leFile->setText(hash);

    QMessageBox::information(0, "Success", "A new checksum has been successfully generated for you. You may copy it or save it as a hash file.");
    this->working = false;
}

void ChecksumGenerator::onActionMD5Checked()
{
    uncheckCheckedItem();
    ui->actionHash_MD5->setChecked(true);
    this->optionSelected = HASH_MD5;
}

void ChecksumGenerator::onActionSHA1Checked()
{
    uncheckCheckedItem();
    ui->actionHash_S1->setChecked(true);
    this->optionSelected = HASH_SHA1;
}

void ChecksumGenerator::onActionSHA256Checked()
{
    uncheckCheckedItem();
    ui->actionHash_S256->setChecked(true);
    this->optionSelected = HASH_SHA256;
}

void ChecksumGenerator::uncheckCheckedItem()
{
    switch(this->optionSelected)
    {
    case HASH_MD5:
        ui->actionHash_MD5->setChecked(false);
        break;
    case HASH_SHA1:
        ui->actionHash_S1->setChecked(false);
        break;
    case HASH_SHA256:
        ui->actionHash_S256->setChecked(false);
        break;
    }
}

QString ChecksumGenerator::getFilterOption()
{
    QString option;
    switch(this->optionSelected)
    {
    case HASH_MD5:
        option = "MD5 Hash File (*.md5)";
        break;
    case HASH_SHA1:
        option = "SHA1 Hash File (*.sha1)";
        break;
    case HASH_SHA256:
        option = "SHA256 Hash File (*.sha256)";
        break;
    }

    return option;
}
