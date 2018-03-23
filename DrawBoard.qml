import QtQuick 2.0

Grid {
    id: drawBoard;
    width: drawBoardRoot.totallSize
    height: drawBoardRoot.totalSize;
    columns: 28;
    rows: 28;
    Repeater {
        model: 784;      //28x28
        Rectangle {
            width: drawBoardRoot.pixelSize;
            height: drawBoardRoot.pixelSize;
            border.color: "#DADADA";
            border.width: 1;
            color: "white"
        }
    }
}
