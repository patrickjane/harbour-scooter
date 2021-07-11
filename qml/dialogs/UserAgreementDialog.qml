import QtQuick 2.0
import Sailfish.Silica 1.0

import "../util"

Dialog {
   property string provider
   property string agreement

   Column {
      anchors.fill: parent
      spacing: 10

      DialogHeader { title: HelperFunctions.capitalize(provider) + " " + qsTr("login") }

      Text {
         textFormat: Text.RichText
         text: agreement

         font.pointSize: Theme.fontSizeTiny
      }
   }
}
