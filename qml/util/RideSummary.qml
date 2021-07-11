import QtQuick 2.0
import Sailfish.Silica 1.0

import "../util"

Rectangle {
   property var rideInfo

   id: rideSummary
   anchors.verticalCenter: parent.verticalCenter
   anchors.horizontalCenter: parent.horizontalCenter
   width: parent.width * 0.8
   height: childrenRect.height
   visible: !!rideInfo

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
            width: 64
            height: 64
            source: "qrc:///graphics/scooter.png"
            anchors.verticalCenter: parent.verticalCenter
         }

         Text {
            anchors.verticalCenter: parent.verticalCenter
            font.pointSize: Theme.fontSizeLarge
            color: "#232323"
            text: rideInfo && HelperFunctions.capitalize(rideInfo.provider) || ""
         }
      }

      Text {
         anchors.horizontalCenter: parent.horizontalCenter
         font.pointSize: Theme.fontSizeExtraSmall
         color: "#232323"
         text: rideInfo && rideInfo.cancelledAt
               ? qsTr("Ride has been cancelled")
               : qsTr("Ride completed!")
      }

      Rectangle {
         color: "transparent"
         width: 50
         height: 15
      }

      Row {
         anchors.horizontalCenter: parent.horizontalCenter
         spacing: Theme.paddingMedium
         visible: !rideInfo || !rideInfo.cancelledAt

         Text {
            anchors.verticalCenter: parent.verticalCenter
            font.pointSize: Theme.fontSizeExtraSmall
            font.bold: true
            color: "#232323"
            text: qsTr("Duration") + ": "
         }

         Text {
            anchors.verticalCenter: parent.verticalCenter
            font.pointSize: Theme.fontSizeExtraSmall
            color: "#232323"
            text: rideInfo && rideInfo.duration || ""
         }
      }

      Row {
         anchors.horizontalCenter: parent.horizontalCenter
         spacing: Theme.paddingMedium
         visible: !rideInfo || !rideInfo.cancelledAt

         Text {
            anchors.verticalCenter: parent.verticalCenter
            font.pointSize: Theme.fontSizeExtraSmall
            font.bold: true
            color: "#232323"
            text: qsTr("Distance") + ": "
         }

         Text {
            anchors.verticalCenter: parent.verticalCenter
            font.pointSize: Theme.fontSizeExtraSmall
            color: "#232323"
            text: rideInfo && rideInfo.distance || ""
         }
      }

      Row {
         anchors.horizontalCenter: parent.horizontalCenter
         spacing: Theme.paddingMedium
         visible: !rideInfo || !rideInfo.cancelledAt

         Text {
            anchors.verticalCenter: parent.verticalCenter
            font.pointSize: Theme.fontSizeExtraSmall
            font.bold: true
            color: "#232323"
            text: qsTr("Cost") + ": "
         }

         Text {
            anchors.verticalCenter: parent.verticalCenter
            font.pointSize: Theme.fontSizeExtraSmall
            font.strikeout: true
            color: "#232323"
            text: rideInfo && rideInfo.costRegular || ""
            visible: rideInfo && rideInfo.costRegular || false
         }

         Text {
            anchors.verticalCenter: parent.verticalCenter
            font.pointSize: Theme.fontSizeExtraSmall
            color: "#232323"
            text: rideInfo && rideInfo.cost || ""
         }
      }

      Button {
         anchors.horizontalCenter: parent.horizontalCenter
         color: "black"
         text: qsTr("Close")
         width: (scooterInfo.width -2*Theme.paddingLarge) / 2 - Theme.paddingMedium
         onClicked: {
            rideSummary.rideInfo = null
            //rideSummary.visible = false
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
