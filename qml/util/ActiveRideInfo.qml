import QtQuick 2.0
import Sailfish.Silica 1.0

import "../util"

Rectangle {
   property bool needConfirm: true
   property var onEndRide
   property var ride

   function reset() {
      needConfirm = true

      if (ride)
         textRideDuration.text = HelperFunctions.toElapsed((new Date().getTime() - ride.started.getTime())/1000)
      else
         textRideDuration.text = ""
   }

   id: activeRideInfo
   anchors.top: menuButton.bottom
   anchors.topMargin: Theme.paddingLarge
   anchors.horizontalCenter: parent.horizontalCenter
   width: parent.width * 0.8
   height: childrenRect.height
   visible: !!ride
   radius: 8
   z: 200

   border.width: 1
   border.color: "#cdcdcd"

   Column {
      anchors.top: parent.top
      anchors.topMargin: Theme.paddingLarge
      anchors.horizontalCenter: parent.horizontalCenter
      width: parent.width - 2*Theme.paddingLarge
      spacing: Theme.paddingLarge

      Row {
         anchors.horizontalCenter: parent.horizontalCenter
         spacing: Theme.paddingLarge

         Image {
            width: 48
            height: 48
            source: "qrc:///graphics/scooter.png"
            anchors.verticalCenter: parent.verticalCenter
         }

         Text {
            id: textRideProvider
            anchors.verticalCenter: parent.verticalCenter
            font.pointSize: Theme.fontSizeExtraSmall
            color: "#232323"
            text: !ride ? "?" : HelperFunctions.capitalize(ride.provider)
         }

         Text {
            id: textRideDuration
            anchors.verticalCenter: parent.verticalCenter
            font.pointSize: Theme.fontSizeExtraSmall
            color: "#232323"
            text: "00:00:00"
         }
      }

      Row {
         spacing: Theme.paddingMedium
         anchors.horizontalCenter: parent.horizontalCenter

         Button {
            color: "black"
            text: needConfirm
                  ? qsTr("End ride")
                  : qsTr("Confirm end")
            onClicked: {
               if (needConfirm){
                  needConfirm = false
                  timerResetEndRide.start()
               } else {
                  onEndRide()
               }
            }
         }
      }

      Rectangle {
         id: spacer
         color: "transparent"
         width: parent.width
         height: Theme.paddingLarge
      }
   }

   Timer {
      id: timerRideDisplay
      interval: 1000
      repeat: true
      running: !!ride

      onTriggered: {
         if (ride)
            textRideDuration.text = HelperFunctions.toElapsed((new Date().getTime() - ride.started.getTime())/1000)
         else
            textRideDuration.text = ""
      }
   }

   Timer {
      id: timerResetEndRide
      interval: 7000
      repeat: false
      running: false

      onTriggered: {
         needConfirm = true
      }
   }
}
