import QtQuick 2.6
import Sailfish.Silica 1.0

Rectangle {
   property var pClicked
   property var pIcon
   property int buttonSize: 128
   property double buttonIconRatio: 0.6

   id: root
   z: 100
   width: buttonSize
   height: buttonSize
   radius: 8

   border.width: 1
   border.color: "#cdcdcd"

   Button {
      id: editButton
      anchors.fill: parent
      icon.sourceSize.height: buttonSize * buttonIconRatio
      icon.sourceSize.width: buttonSize * buttonIconRatio
      icon.source: root.pIcon
      icon.color: "black"

      onClicked: {
         root.pClicked()
      }
   }
}
