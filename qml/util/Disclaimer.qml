import QtQuick 2.0
import Sailfish.Silica 1.0

import "../util"

Rectangle {
   id: appDisclaimer
   anchors.verticalCenter: parent.verticalCenter
   anchors.horizontalCenter: parent.horizontalCenter
   width: parent.width * 0.8
   height: childrenRect.height

   visible: false
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
            text: "Scooters"
         }
      }

      Text {
         anchors.horizontalCenter: parent.horizontalCenter
         font.pointSize: Theme.fontSizeMedium
         wrapMode: Text.WordWrap
         width: parent.width

         color: "#232323"
         text: qsTr("USE AT YOUR OWN RISK")
      }

      Text {
         anchors.horizontalCenter: parent.horizontalCenter
         font.pointSize: Theme.fontSizeTiny
         wrapMode: Text.WordWrap
         width: parent.width

         color: "#232323"
         text: qsTr("This app is provided 'AS-IS' and with NO WARRANTIES. The app makes use of undocumented APIs of scooter providers, errors are therefore to be expected. The author of the app can not be held responsible for costs caused by the usage of the app.")
      }

      Button {
         anchors.horizontalCenter: parent.horizontalCenter

         color: "black"
         text: qsTr("Accept")
         width: (scooterInfo.width -2*Theme.paddingLarge) / 2 - Theme.paddingMedium
         onClicked: {
            cfgDisclaimerAccepted.value = true
            appDisclaimer.visible = false
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
