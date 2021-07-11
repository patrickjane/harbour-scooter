import QtQuick 2.0
import Sailfish.Silica 1.0

import "../util"

Dialog {
   property string provider
   property var scooters
   property bool providerHasConfirmation
   property bool confirmNeeded: false
   readonly property var regExMail: /^(([^<>()\[\]\\.,;:\s@"]+(\.[^<>()\[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/

   id: loginDialog
   canAccept: false

   function handleConfirmNeeded(aProvider) {
      scooters.onConfirmLoginNeeded.disconnect(handleConfirmNeeded)
      confirmNeeded = true
   }

   function handleLoginChanged(aProvider, loggedIn) {
      scooters.onLoginStatusChanged.disconnect(handleLoginChanged)

      Notify.notify(HelperFunctions.capitalize(aProvider), loggedIn ? qsTr("Login successful") : qsTr("Login failed"), !loggedIn)

      if (aProvider === provider && loggedIn) {
         canAccept = true
         accept()
      }
   }

   Column {
      width: parent.width
      spacing: 10

      DialogHeader { title: HelperFunctions.capitalize(provider) + " " + qsTr("login") }

      Label {
         anchors.left: parent.left
         anchors.leftMargin: Theme.paddingLarge
         text: titleForProvider(provider)
         font.pointSize: Theme.fontSizeExtraSmall
      }

      TextField {
         id: loginField
         width: parent.width
         placeholderText: placeholderForProvider(provider)
      }

      Button {
         id: buttonLogin
         width: parent.width * 0.3
         anchors.horizontalCenter: parent.horizontalCenter
         text: qsTr("Login")
         enabled: loginField.text.length && validateInput(loginField.text) && !confirmNeeded

         onClicked: {
            scooters.onConfirmLoginNeeded.connect(handleConfirmNeeded)
            scooters.login(provider, loginField.text)
         }
      }

      Rectangle {
         width: parent.width
         height: Theme.paddingLarge
         color: "transparent"
      }

      Text {
         anchors.horizontalCenter: parent.horizontalCenter
         anchors.leftMargin: Theme.paddingLarge
         anchors.rightMargin: Theme.paddingLarge

         color: Theme.secondaryHighlightColor
         text: qsTr("Check mail account for confirmation code")
         font.pointSize: Theme.fontSizeTiny
         wrapMode: Text.WordWrap

         visible: providerHasConfirmation && confirmNeeded
      }

      Rectangle {
         width: parent.width
         height: Theme.paddingLarge
         color: "transparent"
      }

      Label {
         anchors.left: parent.left
         anchors.leftMargin: Theme.paddingLarge
         visible: providerHasConfirmation
         text: qsTr("Confirmation code")
         font.pointSize: Theme.fontSizeExtraSmall
      }

      TextField {
         id: confirmationField
         width: parent.width
         placeholderText: qsTr("Enter confirmation")
         enabled: confirmNeeded
         visible: providerHasConfirmation
      }

      Button {
         width: parent.width * 0.3
         anchors.horizontalCenter: parent.horizontalCenter
         text: qsTr("Confirm")
         enabled: confirmNeeded && confirmationField.text.length
         visible: providerHasConfirmation

         onClicked: {
            scooters.onLoginStatusChanged.connect(handleLoginChanged)
            scooters.confirmLogin(provider, confirmationField.text)
         }
      }
   }

   function placeholderForProvider(provider) {
      if (provider === "bird")
         return qsTr("Enter email")

      return qsTr("Enter username/email")
   }

   function titleForProvider(provider) {
      if (provider === "bird")
         return qsTr("Email")

      return qsTr("Username/email")
   }

   function validateInput(input) {
      if (provider === "bird") {
         return input.match(regExMail)
      }

      return true;
   }
}
