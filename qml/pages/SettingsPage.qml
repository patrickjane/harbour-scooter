import QtQuick 2.0
import Sailfish.Silica 1.0

import "../util"
import "../dialogs"

Page {
   property var scooters

   id: settingsPage
   allowedOrientations: Orientation.Portrait

   PageHeader {
      id: header
      title: qsTr("Settings")
   }

   SilicaFlickable {
      anchors.left: parent.left
      anchors.right: parent.right
      anchors.top: header.bottom
      anchors.bottom: parent.bottom

      contentHeight: colItems.childrenRect.height
      contentWidth: parent.width
      clip: true

      Column {
         id: colItems
         width: parent.width
         spacing: Theme.paddingLarge

         Text {
            anchors.right: parent.right
            anchors.rightMargin: Theme.paddingLarge
            color: Theme.highlightColor
            font.pointSize: Theme.fontSizeSmall
            text: qsTr("General")
         }

         Text {
            anchors.left: parent.left
            anchors.leftMargin: Theme.paddingLarge
            color: Theme.highlightColor
            text: "Mapbox API Key"
            font.pointSize: Theme.fontSizeMedium
         }

         Text {
            anchors.left: parent.left
            anchors.leftMargin: Theme.paddingLarge
            anchors.right: parent.right
            anchors.rightMargin: Theme.paddingLarge

            font.pointSize: Theme.fontSizeTiny
            color: Theme.primaryColor

            wrapMode: Text.WordWrap
            text: qsTr("Mapbox requires a valid account and associated API key. After generating the key, please add it in the field below and restart the app. To create an API key, consult the following article:")
         }

         LinkedLabel {
            anchors.left: parent.left
            anchors.leftMargin: Theme.paddingLarge
            anchors.right: parent.right
            anchors.rightMargin: Theme.paddingLarge
            defaultLinkActions: true
            onLinkActivated: {
            }

            font.pointSize: Theme.fontSizeTiny
            text: "https://docs.mylistingtheme.com/article/how-to-generate-a-mapbox-api-key/"
         }

         TextArea {
            id: textAreaMapboxApiKey
            anchors.left: parent.left
            anchors.leftMargin: Theme.paddingLarge
            text: cfgMapApiKey.value && cfgMapApiKey.value.toString() || ""
            onTextChanged: cfgMapApiKey.value = text
         }

         Text {
            anchors.right: parent.right
            anchors.rightMargin: Theme.paddingLarge
            color: Theme.highlightColor
            font.pointSize: Theme.fontSizeSmall
            text: qsTr("Providers")
         }

         Repeater {
            model: scooters.getSupportedProviders() || []

            delegate: Column {
               width: parent.width
               spacing: Theme.paddingMedium

               property bool loggedIn: !!scooters.isLoggedIn(modelData)

               Text {
                  anchors.left: parent.left
                  anchors.leftMargin: Theme.paddingLarge
                  color: Theme.highlightColor
                  text: HelperFunctions.capitalize(modelData)
                  font.pointSize: Theme.fontSizeMedium
               }

               TextSwitch {
                    id: activationSwitch
                    text: loggedIn
                          ? qsTr("Logged in")
                          : qsTr("Not logged in")
                    enabled: false
                    checked: loggedIn
                }

               ValueButton {
                  id: profileButton
                  width: parent.width
                  value: qsTr("Settings")
                  valueColor: Theme.highlightColor

                  onClicked: {
                     pageStack.push(Qt.resolvedUrl("./SettingsProviderPage.qml"), { provider: modelData, scooters: scooters, account: scooters.getAccountId(modelData) })
                  }
               }
            }


         }
      }
   }
}
