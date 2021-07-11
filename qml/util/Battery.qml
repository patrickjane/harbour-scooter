import QtQuick 2.0

Rectangle {
   property double batteryLevel: 0.7

   id: battery
   anchors.verticalCenter: parent.verticalCenter
   width: 65
   height: 30
   color: "transparent"

   Rectangle {
      color: "transparent"
      border.width: 1
      border.color: "#232323"

      anchors.left: parent.left
      anchors.top: parent.top
      anchors.bottom: parent.bottom
      width: parent.width-5

      Rectangle {
         anchors.left: parent.left
         anchors.leftMargin: 1
         anchors.top: parent.top
         anchors.topMargin: 1
         anchors.bottom: parent.bottom
         anchors.bottomMargin: 1

         width: (parent.width-2) * batteryLevel
         height: 30
         color: batteryLevel > 0.5 ? "green" : (batteryLevel > 0.3 ? "orange" : "red")
      }
   }

   Rectangle {
      anchors.right: parent.right
      anchors.verticalCenter: parent.verticalCenter
      height: 10
      width: 5
      color: "#232323"
   }
}
