import QtQuick 2.0
import Sailfish.Silica 1.0

import "../util"

Rectangle {
   property var scooter
   property var mode: "unlock"
   property var onRing
   property var onMissing
   property var onUnlock

   id: scooterInfo
   anchors.verticalCenter: parent.verticalCenter
   anchors.horizontalCenter: parent.horizontalCenter
   width: parent.width * 0.8
   height: childrenRect.height

   visible: !!scooter
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
         spacing: Theme.paddingLarge * 2

         Image {
            width: 64
            height: 64
            source: "qrc:///graphics/scooter.png"
            anchors.verticalCenter: parent.verticalCenter
         }

         Text {
            anchors.verticalCenter: parent.verticalCenter
            font.pointSize: Theme.fontSizeLarge
            color: "#232323"
            text: scooterInfo.scooter && HelperFunctions.capitalize(scooterInfo.scooter.provider) || ""
         }
      }

      Text {
         anchors.horizontalCenter: parent.horizontalCenter

         font.pointSize: Theme.fontSizeTiny
         wrapMode: Text.WordWrap
         width: parent.width

         color: "#232323"
         text: scooterInfo.scooter && scooterInfo.scooter.priceString || ""
      }

      Row {
         spacing: Theme.paddingMedium
         anchors.horizontalCenter: parent.horizontalCenter

         Battery {
            batteryLevel: scooterInfo.scooter && (scooterInfo.scooter.battery / 100) || 0
         }

         Text {
            anchors.verticalCenter: parent.verticalCenter
            font.pointSize: Theme.fontSizeTiny
            color: "#232323"
            text: scooterInfo.scooter && (Math.floor(scooterInfo.scooter.range / 1000) + "km") || ""
         }

         Image {
            source: "image://theme/icon-m-device-lock?" + Theme.darkPrimaryColor
            width: 64
            height: 64
            visible: scooterInfo.scooter ? (scooterInfo.scooter.captive || !scooterInfo.scooter.available) : false
         }
      }

      Row {
         spacing: Theme.paddingMedium
         anchors.horizontalCenter: parent.horizontalCenter

         Button {
            color: "black"
            text: qsTr("Ring")
            width: (scooterInfo.width -2*Theme.paddingLarge) / 2 - Theme.paddingMedium
            visible: scooterInfo.mode == "show"
            onClicked: onRing(scooterInfo.scooter)
         }
//         Button {
//            color: "black"
//            text: qsTr("Missing")
//            width: (scooterInfo.width -2*Theme.paddingLarge) / 2 - Theme.paddingMedium
//            visible: scooterInfo.mode == "show"
//            onClicked: onMissing(scooterInfo.scooter)
//         }
         Button {
            color: "black"
            text: scooterInfo.scooter && (!scooterInfo.scooter.available || scooterInfo.scooter.captive)
                  ? (scooterInfo.scooter.captive ? qsTr("Captive") : qsTr("Not available"))
                  : qsTr("Unlock")
            width: (scooterInfo.width -2*Theme.paddingLarge) / 2 - Theme.paddingMedium
            visible: scooterInfo.mode == "unlock"
            enabled: scooterInfo.scooter && (!scooterInfo.scooter.captive && scooterInfo.scooter.available) || false
            onClicked: onUnlock(scooterInfo.scooter)
         }
      }

      Rectangle {
         id: spacer
         color: "transparent"
         width: parent.width
         height: Theme.paddingLarge
      }
   }
}
