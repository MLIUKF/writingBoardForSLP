//#include <QGuiApplication>
#include <QApplication>
#include <QQmlApplicationEngine>
#include <QSerialPort>
#include <QString>
#include <QTextStream>
#include <QtQml>
#include "sender.h"

int main(int argc, char *argv[])
{
    //QGuiApplication app(argc, argv);
    QApplication app(argc, argv);

    QQmlApplicationEngine engine;
    engine.rootContext()->setContextProperty("sender" , new Sender);
    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));

    return app.exec();
}
