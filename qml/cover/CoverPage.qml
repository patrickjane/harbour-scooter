import QtQuick 2.0
import Sailfish.Silica 1.0

import "../util"

CoverBackground {
   property var started

   id: cover

   Image {
      property int imgSize: parent.width - Theme.paddingMedium

      id: imageLoadingBackgroundImage
      anchors.centerIn: parent
      width: imgSize
      height: imgSize
      opacity: 0.15
      source: "qrc:///icons/256x256/harbour-scooter.png"
      asynchronous: true
      fillMode: Image.PreserveAspectFit
      sourceSize.width: imgSize
      sourceSize.height: imgSize
   }

   Rectangle {
      anchors.verticalCenter: parent.verticalCenter
      anchors.horizontalCenter: parent.horizontalCenter
      width: parent.width
      height: childrenRect.height
      color: "transparent"
      visible: cover.started || false
      z: 100

      Column {
         anchors.top: parent.top
         anchors.horizontalCenter: parent.horizontalCenter
         width: parent.width
         spacing: Theme.paddingLarge
         visible: cover.started || false

         Text {
            anchors.horizontalCenter: parent.horizontalCenter
            font.pointSize: Theme.fontSizeSmall
            wrapMode: Text.WordWrap
            text: qsTr("Ride active")
            visible: cover.started || false
         }

         Text {
            id: textFieldDuration
            anchors.horizontalCenter: parent.horizontalCenter
            font.pointSize: Theme.fontSizeSmall
            wrapMode: Text.WordWrap
            text: "00:00:00"
            visible: cover.started || false
         }
      }
   }

   Timer {
      id: timerRideDisplay
      interval: 1000
      repeat: true
      running: cover.started || false

      onTriggered: {
         if (cover.started)
            textFieldDuration.text = HelperFunctions.toElapsed((new Date().getTime() - cover.started.getTime())/1000)
         else
            textFieldDuration.text = ""
      }
   }
}
