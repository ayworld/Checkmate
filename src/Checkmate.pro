#-------------------------------------------------
#
# Project created by QtCreator 2014-08-24T01:18:56
#
#-------------------------------------------------

QT       += core gui network

greaterThan(QT_MAJOR_VERSION, 4): QT += widgets

TARGET = Checkmate
TEMPLATE = app

RC_FILE = icon.rc

SOURCES += main.cpp\
        mainwindow.cpp \
    validationthread.cpp \
    aboutdialog.cpp \
    filedownloader.cpp \
    checksumgenerator.cpp

HEADERS  += mainwindow.h \
    validationthread.h \
    aboutdialog.h \
    filedownloader.h \
    checksumgenerator.h

FORMS    += mainwindow.ui \
    aboutdialog.ui \
    checksumgenerator.ui

RESOURCES += \
    gear_icon_resource.qrc