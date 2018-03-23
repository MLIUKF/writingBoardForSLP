#include <QSerialPort>
#include "sender.h"

Sender::Sender() {
    reset();
    openFailed.setText("Failed to open port 'COM3', please try again.");
    openPort();
}


Sender::~Sender() {
    port.close();
}

bool Sender::openPort(){
    port.setPortName("COM3");
    port.setBaudRate(QSerialPort::Baud9600);
    if (!port.open(QIODevice::ReadWrite)) {
        openFailed.exec();
        qDebug() << "Failed to open port COM3";
        openPortSuccess = false;
        return false;
    }
    else{
        qDebug() << "open port success";
        openPortSuccess = true;
        return true;
    }
    return false;
}

void Sender::addPoints(int x, int y) {
    points.enqueue(x);
    points.enqueue(y);
}

void Sender::sendNum() {
    changeImage();
    port.write(message);
}

void Sender::changeImage() {
    int x, y, row, column;
    while(!points.isEmpty()){
        x = points.dequeue();
        y = points.dequeue();
        row = int(y/14)+2;
        column = int(x/14)+2;
        for(int i = -1; i < 2; i++){
            for(int j = -1; j < 2; j++){
                pointsColor[row+i][column+j] = true;
            }
        }
    }
    bool temp[784];        //将二维的矩阵变为一维的，方便后面操作
    for(int i = 2; i < 30; i++){
        for(int j = 2; j < 30; j++){
            temp[28*(i-2)+j-2] = pointsColor[i][j];
        }
    }
    for(int i = 0; i < 98; i++){  //将每八个像素转换为一个byte表示
        message[i] = 0;
        for(int j = 0; j < 8; j++){
            if(temp[8*i+j]){
                message[i] = message[i] + (1 << (7-j));
            }
        }
    }
}

void Sender::reset() {
    for(int i=0; i<32; i++){
        for(int j=0; j<32; j++){
            pointsColor[i][j] = false;
        }
    }
    while(!points.isEmpty()){
        points.dequeue();
    }
}

bool Sender::isOpenSuccess(){
    return openPortSuccess;
}
