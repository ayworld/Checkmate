#include "mainwindow.h"
#include "ui_mainwindow.h"

MainWindow::MainWindow(QWidget *parent) :
    QMainWindow(parent),
    ui(new Ui::MainWindow)
{
    ui->setupUi(this);
    QRect position = frameGeometry();
    position.moveCenter(QDesktopWidget().availableGeometry().center());
    move(position.topLeft());

    ui->statusBar->showMessage("Ready");

    this->establishUIConnections();
    this->working = false;
    this->lVersion = 6; // Important! This is the version checker!!!!!!!
    this->version = "2.0.1";
    this->gversion = "2.0";
}

MainWindow::~MainWindow()
{
    delete ui;
}

void MainWindow::establishUIConnections()
{
    // Menubar action connections
    connect(ui->actionExit, SIGNAL(triggered()), this, SLOT(onExitActionTriggered()));
    connect(ui->actionChecksum_Generator, SIGNAL(triggered()), this, SLOT(OpenChecksumGeneratorWindow()));
    connect(ui->actionAbout, SIGNAL(triggered()), this, SLOT(onAboutActionTriggered()));
    connect(ui->actionUpdates, SIGNAL(triggered()), this, SLOT(onUpdateCheckActionTriggered()));

    // Connect browse buttons with SIGNALS and SLOTS
    connect(ui->bBrowseFile, SIGNAL(clicked()), this, SLOT(onBrowseFileButtonClicked()));
    connect(ui->bBrowseHash, SIGNAL(clicked()), this, SLOT(onBrowseHashButtonClicked()));

    // Connect validate button
    connect(ui->bValidate, SIGNAL(clicked()), this, SLOT(onValidateButtonClicked()));
}

void MainWindow::setHashType(QString ext)
{
    if(ext.toLower() == "md5")
        this->hashType = HASH_MD5;
    else if(ext.toLower() == "sha1")
        this->hashType = HASH_SHA1;
    else if(ext.toLower() == "sha256")
        this->hashType = HASH_SHA256;
}

// Browse File Button Slot
void MainWindow::onBrowseFileButtonClicked()
{
    // Grab filename to get path for leFile
    QString fileName =
            QFileDialog::getOpenFileName(
                this,
                tr("Open File to Validate"),
                "/",
                tr("All Files (*)")
            );

    if(!fileName.isEmpty())
    {
        // Append location to leFile, but change / if on windows machine
        #ifdef Q_OS_WIN32
            ui->leFile->setText(fileName.replace("/", "\\"));
        #else
            ui->leFile->setText(fileName);
        #endif
    }
}

// Browse Hash Button Slot
void MainWindow::onBrowseHashButtonClicked()
{
    // Grab filename to read and obtain hash
    QString fileName =
            QFileDialog::getOpenFileName(
                this,
                tr("Open Checksum Hash File"),
                "/",
                tr("MD5 Hash Files (*.md5);;SHA1 Hash Files (*.sha1);;SHA256 Hash Files (*.sha256);;Text Files (*.txt)") // Added support for multiple hash types
            );

    // check if user selected anything
    if(!fileName.isEmpty())
    {
        // Open file, but in read only!
        QFile file(fileName);
        if(!file.open(QIODevice::ReadOnly))
        {
            this->alert("File Error", file.errorString(), true);
        }

        // Create stream and list for lines
        QTextStream in(&file);
        QStringList lines;

        while(!file.atEnd())
        {
            QString line = in.readLine();
            lines = line.split("  ");
        }

        // Append hash to leHash
        ui->leHash->setText(lines[0]);
        file.close();

        QFileInfo fileInfo(fileName);
        setHashType(fileInfo.suffix());
    }
}

void MainWindow::onValidateButtonClicked()
{
    // Instantiate mThread
    this->mThread = new ValidationThread();

    QString file = ui->leFile->text();
    QString hash = ui->leHash->text();

    // Get filename for statusbar
    QStringList pieces = file.split("\\");
    QString fileName = pieces.value(pieces.length() - 1);

    // For checking if file exists
    QFile filed(file);

    if(file.isEmpty())
    {
        this->alert("No File", "You need to supply the file's location!", true);
    }
    else if(hash.isEmpty())
    {
        this->alert("No Hash", "You need to supply the hash or browse for a hash file!", true);
    }
    else if(!filed.exists())
    {
        this->alert("File Not Found", "That file cannot be found!", true);
    }
    else
    {
        this->mThread->setFileLocation(file);
        this->mThread->setHashType(this->hashType);
        connect(mThread, SIGNAL(CalculationPerformed(QString)), this, SLOT(onCalculationPerformed(QString)));
        this->mThread->start();

        // Status Bar
        ui->statusBar->showMessage("Computing checksum of file: " + fileName + " | Please Wait...");

        // Validate Button
        ui->bValidate->setEnabled(false);
        ui->bValidate->setText("Validating..");

        // set working to true
        this->working = true;
    }
}

void MainWindow::onCalculationPerformed(QString hash)
{
    if(ui->leHash->text() == hash)
    {
        this->alert("Success", "The file checksum is valid!");
        ui->statusBar->showMessage("Validation successful!");
    }
    else
    {
        this->alert("Failed", "The file checksum did not match the checksum supplied!");
        ui->statusBar->showMessage("Validation failed!");
    }
    ui->bValidate->setEnabled(true);
    ui->bValidate->setText("Run Validator");

    // revert working to false
    this->working = false;
}

void MainWindow::alert(QString title, QString message, bool critical)
{
    if(critical)
    {
        QMessageBox::critical(0, title, message);
    }
    else
    {
        QMessageBox::information(0, title, message);
    }
}

void MainWindow::OpenChecksumGeneratorWindow()
{
    ChecksumGenerator *w = new ChecksumGenerator();
    w->show();
}

void MainWindow::onAboutActionTriggered()
{
    AboutDialog *w = new AboutDialog();
    w->setAppVersion(version);
    w->setGenVersion(gversion);
    w->show();
}

void MainWindow::onUpdateCheckActionTriggered()
{
    QUrl url("http://cdn.kalebklein.com/chm/version.txt");
    downloader = new FileDownloader(url, this);

    connect(downloader, SIGNAL(downloaded()), SLOT(onCompleted()));
}

void MainWindow::onCompleted()
{
    int wVersion = QString(downloader->downloadedData()).toInt();
    if(lVersion < wVersion)
    {
        QMessageBox::StandardButton reply;
        reply = QMessageBox::question(this, "New Update Available", "An update is now available, would you like to download the update?", QMessageBox::Yes|QMessageBox::No);
        if(reply == QMessageBox::Yes)
        {
            QDesktopServices::openUrl(QString("http://www.kalebklein.com/applications/checkmate"));
        }
    }
    else
    {
        QMessageBox::information(this, "Check for Updates", "You are currently up to date!");
    }
}

// Used from actionExit to trigger closeEvent()
void MainWindow::onExitActionTriggered()
{
    if(this->working)
    {
        QMessageBox::StandardButton reply;
        reply = QMessageBox::question(this, "Close", "Checkmate is still hard at work, are you sure you want to exit?", QMessageBox::Yes|QMessageBox::No);
        if(reply == QMessageBox::Yes)
        {
            QApplication::quit();
        }
    }
    else
    {
        QApplication::quit();
    }
}

// Override main window closeEvent to shutdown app upon close
void MainWindow::closeEvent(QCloseEvent *event)
{
    if(this->working)
    {
        QMessageBox::StandardButton reply;
        reply = QMessageBox::question(this, "Close", "Checkmate is still hard at work, are you sure you want to exit?", QMessageBox::Yes|QMessageBox::No);
        if(reply == QMessageBox::Yes)
        {
            qApp->quit();
        }
        else
        {
            event->ignore();
        }
    }
    else
    {
        qApp->quit();
    }
}