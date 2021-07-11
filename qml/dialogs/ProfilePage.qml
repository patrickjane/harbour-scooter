import QtQuick 2.0
import Sailfish.Silica 1.0

import "../util"

Page {
   property string provider
   property var profile

   id: profileDialog

   Column {
      width: parent.width
      spacing: 10

      PageHeader { title: HelperFunctions.capitalize(provider) + " " + qsTr("profile") }

      DetailItem {
         width: parent.width
         label: qsTr("E-Mail")
         value: profile.email
      }

      DetailItem {
         label: qsTr("Registered")
         value: new Date(profile.created_at).toLocaleString(Qt.locale(profile.locale), Locale.ShortFormat)
      }

      DetailItem {
         label: qsTr("Last ride")
         value: new Date(profile.last_ride_at).toLocaleString(Qt.locale(profile.locale), Locale.ShortFormat)
      }

      DetailItem {
         label: qsTr("Ride count")
         value: profile.ride_count
      }

      DetailItem {
         label: qsTr("Free rides")
         value: profile.free_rides
      }

      DetailItem {
         label: qsTr("Balance")
         value: HelperFunctions.formatCurrency(profile.locale, profile.balances)
      }
   }
}
