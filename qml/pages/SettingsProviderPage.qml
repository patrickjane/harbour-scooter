import QtQuick 2.0
import Sailfish.Silica 1.0

import "../util"

Page {
   property string provider
   property string account
   property var scooters

   id: settingsPageProvider
   allowedOrientations: Orientation.Portrait

   Component.onCompleted: {
      scooters.onProfile.connect(function(provider, profile) {

         if (profile)
            pageStack.push(Qt.resolvedUrl("../dialogs/ProfilePage.qml"), { provider: provider, profile: profile })
      })

      scooters.onLoginStatusChanged.connect(function(providerName, loggedIn, account) {
         if (providerName === provider) {
            settingsPageProvider.account = !loggedIn ? "" : (account && account.length ? account : "")
         }
      })
   }

   PageHeader {
      id: header
      title: HelperFunctions.capitalize(provider) + " " + qsTr("settings")
   }

   SilicaFlickable {
      anchors.left: parent.left
      anchors.right: parent.right
      anchors.bottom: parent.bottom
      anchors.top: header.bottom
      clip: true

      Column {
         width: parent.width
         spacing: Theme.paddingLarge

         Text {
            anchors.right: parent.right
            anchors.rightMargin: Theme.paddingLarge
            color: Theme.highlightColor
            font.pointSize: Theme.fontSizeSmall
            text: HelperFunctions.capitalize(provider)
         }

         Text {
            anchors.left: parent.left
            anchors.leftMargin: Theme.paddingLarge
            color: Theme.highlightColor
            text: qsTr("General")
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
            text: descriptionForProvider(provider)
         }

         Text {
            anchors.left: parent.left
            anchors.leftMargin: Theme.paddingLarge
            color: Theme.highlightColor
            text: qsTr("Account")
            font.pointSize: Theme.fontSizeMedium
         }

         Label {
            anchors.left: parent.left
            anchors.leftMargin: Theme.paddingLarge
            text: account || qsTr("Not logged in")
            font.pointSize: Theme.fontSizeExtraSmall
         }

         Button {
            id: buttonLogin
            width: parent.width * 0.3
            anchors.horizontalCenter: parent.horizontalCenter
            text: account && qsTr("Logout") || qsTr("Login")

            onClicked: {
               if (account) {
                  scooters.logout(provider)
               } else {
                  var dialog = pageStack.push(Qt.resolvedUrl("../dialogs/LoginDialog.qml"), {
                                                 provider: provider,
                                                 scooters: scooters,
                                                 providerHasConfirmation: true
                                              })
               }
            }
         }

         ValueButton {
            id: profileButton
            width: parent.width
            value: account
                   ? qsTr("Show profile")
                   : qsTr("Log in to show profile")
            enabled: account
            valueColor: account ? Theme.highlightColor : Theme.darkSecondaryColor

            onClicked: {
               scooters.getProfile(provider)
            }
         }
      }
   }

   function descriptionForProvider(provider) {
      switch (provider) {
      case "bird":
         return qsTr("Access to electric scooters provided by Bird (see https://www.bird.co). Existing account with associated payment information is needed. This app does not support creating accounts or changing payment information.")
      }

      return qsTr("No description available")
   }
}
