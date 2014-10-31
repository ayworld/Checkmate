#-------------------------------------------------
#
# Project created by QtCreator 2014-10-30T19:21:40
#
#-------------------------------------------------

QT       += core gui network

greaterThan(QT_MAJOR_VERSION, 4): QT += widgets

TARGET = CheckmateUpdater
TEMPLATE = app


SOURCES += main.cpp\
    filedownloader.cpp \
    updater.cpp

HEADERS  += \
    filedownloader.h \
    updater.h

RESOURCES += \
    updater.qrc

RC_FILE = updater.rc
