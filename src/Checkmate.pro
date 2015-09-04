QT       += core gui network

greaterThan(QT_MAJOR_VERSION, 4): QT += widgets

TARGET = Checkmate
TEMPLATE = app

RC_FILE = icon.rc

SOURCES += main.cpp\
        mainwindow.cpp \
    validationthread.cpp \
    aboutdialog.cpp \
    checksumgenerator.cpp \
    filedownloader.cpp

HEADERS  += mainwindow.h \
    validationthread.h \
    aboutdialog.h \
    checksumgenerator.h \
    filedownloader.h \
    version.h

FORMS    += mainwindow.ui \
    aboutdialog.ui \
    checksumgenerator.ui

RESOURCES += \
    gear_icon_resource.qrc
