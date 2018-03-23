import QtQuick 2.0
import QtQml 2.2
/*使用Canvas，实现一个像素风的画图区域
  整体大小是420*520 */
Rectangle {
    id: drawBoardRoot;
    width: 420;
    height: 520;
    property int pixelSize: 14           //28x28网格，每一格的边长
    property int totalSize: 392          //网格总大小，14x28
    Rectangle{
        id:clearBtn
        color:"white"
        width: 140
        height: 40
        radius: 20
        anchors.left: drawBoardRoot.left
        anchors.top:drawBoardRoot.top
        anchors.leftMargin: 50
        anchors.topMargin: 30
        border.color: "gray"
        border.width: 2
        Text {
            id: clear
            text: "清除"
            anchors.centerIn: parent
        }
        MouseArea{
            anchors.fill:parent
            onPressed: {
                drawBoard.allowClear = true
                drawBoard.requestPaint()
                clearBtn.color = "lightgray"
            }
            onReleased: {
                drawBoard.allowClear = false
                sender.reset()
                clearBtn.color = "white"
            }
        }
    }

    Rectangle{
        id:sendBtn
        color:"white"
        width: 140
        height: 40
        radius: 20
        anchors.right: drawBoardRoot.right
        anchors.top:drawBoardRoot.top
        anchors.rightMargin: 50
        anchors.topMargin: 30
        border.color: "gray"
        border.width: 2
        Text {
            id: send
            text: "发送"
            anchors.centerIn: parent
        }

        MouseArea{
            anchors.fill:parent
            onClicked: {
                if(sender.isOpenSuccess()){
                    sender.sendNum()
                }
                else{
                    if(sender.openPort()){
                        send.text = "发送"
                        sender.sendNum()
                    }
                }
            }
            onPressed: {
                sendBtn.color = "lightgray"
            }
            onReleased: {
                sendBtn.color = "white"
            }
        }
    }
    Loader {
        id: drawBoardBgLoader
        anchors.bottom: drawBoardRoot.bottom;
        anchors.left: drawBoardRoot.left
        source: "qrc:/DrawBoard.qml"
    }
    Rectangle {
        id: drawAreaRec
        width: drawBoardRoot.totalSize
        height: drawBoardRoot.totalSize
        anchors.bottom: drawBoardRoot.bottom
        anchors.left: drawBoardRoot.left
        border.color: "black"
        border.width: 1
        color: "transparent"
        Canvas{
            id:drawBoard
            width: drawBoardRoot.totalSize
            height: drawBoardRoot.totalSize
            anchors.bottom: drawAreaRec.bottom
            anchors.left: drawAreaRec.left
            property real lastX
            property real lastY
            property bool allowClear: false
            onPaint: {
                var ctx = getContext('2d')
                ctx.lineWidth = 1
                ctx.strokeStyle = "black"
                ctx.fillStyle = "black"
                ctx.beginPath()
                ctx.rect(drawArea.originX-14, drawArea.originY-14, 42, 42)
                ctx.fill()
                ctx.stroke()
                if(allowClear){
                    ctx.clearRect(0, 0, drawBoard.width, drawBoard.height)
                }
            }
        }
        MouseArea {
            id: drawArea
            anchors.fill: parent
            cursorShape: Qt.CrossCursor
            property int originX
            property int originY
            property int xChange: 14
            property int yChange: 14
            property int lastX: 0
            property int lastY: 0
            onPressed: {
                mouseIcon.visible = true
            }
            onReleased: {
                mouseIcon.visible = false
            }
            onPositionChanged: {
                xChange = mouseX - lastX
                yChange = mouseY - lastY
                if(xChange > 13 || yChange > 13 || xChange < -13 || yChange < -13) {
                    originX = mouseX - (mouseX%14) + 1
                    originY = mouseY - (mouseY%14) + 1
                    drawBoard.requestPaint()
                    sender.addPoints(originX, originY)
                    xChange = 0
                    yChange = 0
                    lastX = mouseX
                    lastY = mouseY
                }
            }
        }
        Image {
            id: mouseIcon;
            source: "qrc:/mouseIcon.png"
            scale: 0.9333
            visible: false
            x: drawArea.mouseX - 21
            y: drawArea.mouseY - 21
        }
    }
    Component.onCompleted: {
        if(!sender.isOpenSuccess()){
            send.text = "打开串口并发送"
        }
    }
}
