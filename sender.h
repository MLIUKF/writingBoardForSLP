#ifndef SENDER_H
#define SENDER_H

#include <QObject>
#include <QSerialPort>
#include <QDebug>
#include <QQueue>
#include <QMessageBox>

class Sender : public QObject
{
    Q_OBJECT

public:

    Sender();
    ~Sender();

public slots:
    void sendNum();
    void addPoints(int x, int y); //把所有调用过drawBoard.requestPaint()的点加入队列
    void reset();
    void changeImage();           //根据队列points中的点的坐标改变pointsColor
    bool openPort();
    bool isOpenSuccess();
private:
    QQueue<int> points;
    QSerialPort port;
    QByteArray message;
    bool pointsColor[32][32];     //32x32的矩阵，true代表黑色，false代表白色
    bool openPortSuccess = false;
    QMessageBox openFailed;
};

#endif // SENDER_H
