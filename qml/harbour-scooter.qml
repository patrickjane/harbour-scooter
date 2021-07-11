import QtQuick 2.0
import Sailfish.Silica 1.0
import Nemo.Configuration 1.0

import "pages"

import Scooter 1.0

ApplicationWindow {
   id: rootWindow

   ConfigurationValue {
      id: cfgMapApiKey
      key: "/harbour-scooter/mapApiKey"
   }
   ConfigurationValue {
      id: cfgDisclaimerAccepted
      key: "/harbour-scooter/disclaimerAccepted"
      defaultValue: false
   }

   initialPage: Component { MapPage { id: mapPage } }
   cover: Qt.resolvedUrl("cover/CoverPage.qml")
   allowedOrientations: defaultAllowedOrientations
}
