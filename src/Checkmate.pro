QT       += core gui network

greaterThan(QT_MAJOR_VERSION, 4): QT += widgets

TARGET = Checkmate
TEMPLATE = app

CONFIG(debug, release|debug):DEFINES += _DEBUG

RC_FILE = res/resource.rc

SOURCES += main.cpp\
        mainwindow.cpp \
    validationthread.cpp \
    aboutdialog.cpp \
    checksumgenerator.cpp \
    filedownloader.cpp \
    updatechecker.cpp \
    msgbox.cpp

HEADERS  += mainwindow.h \
    validationthread.h \
    aboutdialog.h \
    checksumgenerator.h \
    filedownloader.h \
    refs.h \
    updatechecker.h \
    msgbox.h

FORMS    += mainwindow.ui \
    aboutdialog.ui \
    checksumgenerator.ui

RESOURCES += qt_resource.qrc
