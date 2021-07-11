import QtQuick 2.0
import Sailfish.Silica 1.0
import QtMultimedia 5.2
import QZXing 3.1

import "../util"

Page {
   property bool popped: false
   property var scooters
   property var positionSource

   id: dialog

   PageHeader { title: qsTr("Scan QR code") }

   Camera {
      id: camera
      focus {
         focusMode: Camera.FocusContinuous
         focusPointMode: Camera.FocusPointCenter
      }
   }

   Rectangle {
      width: parent.width * 0.8
      height: parent.width * 0.8
      anchors.horizontalCenter: parent.horizontalCenter
      anchors.verticalCenter: parent.verticalCenter
      color: "transparent"

      VideoOutput {
         id: videoOutput
         anchors.fill: parent
         source: camera
         filters: [ videoFilter ]
         autoOrientation: false
      }
   }

   QZXingFilter {
      id: videoFilter
      decoder {
         imageSourceFilter: QZXing.SourceFilter_ImageNormal
         enabledDecoders: QZXing.DecoderFormat_QR_CODE
         tryHarder: true
         tryHarderType: QZXing.TryHarderBehaviour_Rotate | QZXing.TryHarderBehaviour_ThoroughScanning

         onTagFound: {
            if (popped)
               return;

            popped = true
            pageStack.pop()
            handleScannedCode(tag)
         }
      }
   }

   function handleScannedCode(code) {
      var idAndProvider= extractidAndProvider(code)

      if (!idAndProvider) {
         Notify.notify(qsTr("Ride"), qsTr("Code not recognized/provider not supported"))
         return
      }

      scooters.scanScooter(idAndProvider[0], idAndProvider[1], positionSource.position.coordinate, function(err, scooter) {
         console.log("Loading single scooter:", err, JSON.stringify(scooter || {}))
      })
   }

   function extractidAndProvider(code) {
      if (code.indexOf("https://ride.bird.co/") === 0)
         return ["bird", code.replace("https://ride.bird.co/", "")]

      return
   }
}
