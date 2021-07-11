import QtQuick 2.0
import Sailfish.Silica 1.0
import QtLocation 5.0
import QtPositioning 5.2

import MapboxMap 1.0

import Scooter 1.0

import "../util"
import "../dialogs"

Page {
   property var scooterList: []
   property var activeRide: scooters.activeRide
   property var selectedScooter

   id: page
   allowedOrientations: Orientation.Portrait

   Disclaimer {
      id: disclaimer
      visible: !cfgDisclaimerAccepted.value
   }

   Scooters {
      id: scooters

      onScootersChanged: {
         scooterList = scooters
         updateScooters(scooters)
      }

      onAreasChanged: {
         updateAreas(provider, areas)
      }

      onNetworkError: {
         Notify.notify(qsTr("Network error"), error)
      }

      onError: {
         Notify.notify(HelperFunctions.capitalize(providerName) + " " + qsTr("error"), error)
      }

      onNotify: {
         Notify.notify(title + " (" + HelperFunctions.capitalize(providerName) + ")", message)
      }

      onActiveRideChanged: {
         page.activeRide = ride
         activeRideInfo.reset()

         if (ride) {
            Notify.notify(qsTr("Ride"), qsTr("Ride started"))
            page.selectedScooter = null
         } else {
            if (!error || !error.length)
               Notify.notify(qsTr("Ride"), qsTr("Ride stopped"))
            else
               Notify.notify(qsTr("Ride") + " " + qsTr("error"), error)

            if (rideInfo.length) {
               var rideInfoObj;

               try {
                  rideInfoObj = JSON.parse(rideInfo)
               } catch (e) {
                  console.log("Failed to parse rideInfo JSON", e)
               }

               rideSummary.rideInfo = rideInfoObj
            }
         }
      }

      onScooterScanned: {
         if (!scooter)
            return

         page.selectedScooter = scooter
         scooterInfo.mode = "unlock"
      }

      onReady: {
         reloadScootersAtCurrentPosition()
         reloadAreasAtCurrentPosition()
      }

      function reloadScootersAtCurrentPosition() {
         if (positionSource.position.latitudeValid && positionSource.position.longitudeValid) {
            scooters.reloadScooters(positionSource.position.coordinate, 300)
            lastReloadCoordinate = QtPositioning.coordinate(positionSource.position.coordinate.latitude, positionSource.position.coordinate.longitude)
         }
      }

      function reloadAreasAtCurrentPosition() {
         if (positionSource.position.latitudeValid && positionSource.position.longitudeValid) {
            scooters.reloadAreas(positionSource.position.coordinate, 300)
         }
      }

      property var lastReloadCoordinate: undefined
   }

   ActiveRideInfo {
      id: activeRideInfo
      ride: page.activeRide

      onEndRide: function() {
         scooters.stopRide(positionSource.position.coordinate)
      }
   }

   RideSummary {
      id: rideSummary
   }

   ScooterInfo {
      id: scooterInfo
      scooter: page.selectedScooter

      onRing: function(scooter) {
         scooters.ringScooter(scooter.provider, scooter.mapId, positionSource.position.coordinate)
      }

      onUnlock: function(scooter) {
         scooters.startRide(scooter.provider, scooter.unlockId, positionSource.position.coordinate)
      }
   }

   PositionSource {
      id: positionSource
      updateInterval: 3000
      active: true
      onPositionChanged: {
         if (!positionSource.position.latitudeValid || !positionSource.position.longitudeValid)
            return

         updateLocation(positionSource.position.coordinate, accuracy || 400)

         var distance = lastCoordinate && lastCoordinate.distanceTo(position.coordinate) || -1

         if (accuracy > 20 || lastCoordinate === undefined || !!page.activeRide) {
            lastCoordinate = QtPositioning.coordinate(positionSource.position.coordinate.latitude, positionSource.position.coordinate.longitude)
            map.center = position.coordinate
         }

         var reloadDistance = scooters.lastReloadCoordinate && scooters.lastReloadCoordinate.distanceTo(position.coordinate) || -1

         if (reloadDistance >= 50 || scooters.lastReloadCoordinate === undefined)
            scooters.reloadScootersAtCurrentPosition()
      }

      Component.onCompleted: {
         if (positionSource.position.latitudeValid && positionSource.position.longitudeValid)
            lastCoordinate = QtPositioning.coordinate(positionSource.position.coordinate.latitude, positionSource.position.coordinate.longitude)
      }

      property var lastCoordinate: undefined
      property int accuracy: position.verticalAccuracyValid && position.horizontalAccuracyValid && (Math.round(Math.max(position.verticalAccuracy, position.horizontalAccuracy))) || 0
   }

   EditButton {
      id: scanButton
      anchors.horizontalCenter: parent.horizontalCenter
      anchors.bottom: parent.bottom
      anchors.bottomMargin: parent.width*0.1
      enabled: !page.activeRide && !disclaimer.visible

      pIcon: "qrc:///graphics/qrcode_bk.png"
      pClicked: function() {
         pageStack.push(Qt.resolvedUrl("../dialogs/ScanPage.qml"), { scooters: scooters, positionSource: positionSource })
      }
   }

   EditButton {
      id: menuButton
      anchors.top: parent.top
      anchors.topMargin: parent.width * 0.1
      anchors.right: parent.right
      anchors.rightMargin: parent.width*0.1
      enabled: !page.activeRide && !disclaimer.visible

      pIcon: "image://theme/icon-m-menu?" + Theme.darkPrimaryColor
      pClicked: function() {
         pageStack.push(Qt.resolvedUrl("./SettingsPage.qml"), { scooters: scooters })
      }
   }

   EditButton {
      id: centerButton
      anchors.left: parent.left
      anchors.leftMargin: parent.width*0.1
      anchors.bottom: parent.bottom
      anchors.bottomMargin: parent.width*0.1

      pIcon: "image://theme/icon-m-whereami?" + Theme.darkPrimaryColor
      pClicked: function() {
         if (positionSource.position.latitudeValid && positionSource.position.longitudeValid)
            map.center = positionSource.position.coordinate
      }
   }

   MapboxMap {
      id: map
      anchors.fill: parent
      zoomLevel: 16.0
      minimumZoomLevel: 10
      maximumZoomLevel: 20
      pixelRatio: 3.0
      accessToken: cfgMapApiKey.value && cfgMapApiKey.value.toString() || "invalidkey"
      cacheDatabaseMaximalSize: 20*1024*1024
      cacheDatabasePath: "/tmp/mbgl-cache.db"
      styleUrl: "mapbox://styles/mapbox/outdoors-v10"

      Component.onCompleted: {
         initLayers();

         if (positionSource.position.latitudeValid && positionSource.position.longitudeValid)
            center = positionSource.position.coordinate
         else
            center = QtPositioning.coordinate(-27.5, 153.1)
      }

      MapboxMapGestureArea {
         id: area
         map: map
         anchors.fill: parent
         activeClickedGeo: true

         onClicked: {
            page.selectedScooter = null
         }

         onClickedGeo: {
            var selectedScooter = null;

            if (page.activeRide)
               return

            scooters.scooters.forEach(function(scooter) {
               var dlon = (geocoordinate.longitude - scooter.coordinate.longitude) / degLonPerPixel;
               var dlat = (geocoordinate.latitude - scooter.coordinate.latitude) / degLatPerPixel;
               var dist2 = dlon*dlon + dlat*dlat;

               if (dist2 < map.pixelRatio*map.pixelRatio*900 && (!selectedScooter || selectedScooter.dist2 > dist2)) {
                  selectedScooter = { 'scooter': scooter, 'dist2': dist2 };
               }
            });

            if (selectedScooter) {
               page.selectedScooter = selectedScooter.scooter
               scooterInfo.mode = "show"
            }
         }
      }
   }

   function updateScooters(scooters) {
      var coords = scooters.map(function(c) { return c.coordinate })
      var names = scooters.map(function(c) { return HelperFunctions.capitalize(c.provider) })

      map.updateSourcePoints("scooter-source", coords, names);
   }

   function updateLocation(coord, accuracy) {
      map.updateSource("location",
                       {"type": "geojson",
                          "data": {
                             "type": "Feature",
                             "geometry": {
                                "type": "Point",
                                "coordinates": [coord.longitude, coord.latitude]
                             }
                          }
                       })
   }

   function updateAreas(provider, areas) {
      var coordinates = []
      var what = areas || []

      what.forEach(function(newArea) {
         var coords = newArea.polygon.map(function(p) { return p.coordinate })
         coordinates.push(coords)
      })

      map.updateSource("no-parking-zone", { 'type': 'geojson', 'data': { 'type': 'Feature', 'geometry': { 'type': 'Polygon', 'coordinates': coordinates }}});
   }

   function initLayers(lon, lat) {

      // position

      map.addSource("location", {"type": "geojson", "data": { "type": "Feature", "geometry": { "type": "Point", "coordinates": positionSource.position.coordinate }}})
      map.addLayer("location-uncertainty", {"type": "circle", "source": "location"}, "waterway-label")
      map.setPaintProperty("location-uncertainty", "circle-radius", 10)
      map.setPaintProperty("location-uncertainty", "circle-color", "#87cefa")
      map.setPaintProperty("location-uncertainty", "circle-opacity", 0.25)

      map.addLayer("location-case", {"type": "circle", "source": "location"}, "waterway-label")
      map.setPaintProperty("location-case", "circle-radius", 7)
      map.setPaintProperty("location-case", "circle-color", "white")
      map.addLayer("location", {"type": "circle", "source": "location"}, "waterway-label")
      map.setPaintProperty("location", "circle-radius", 3)
      map.setPaintProperty("location", "circle-color", "blue")

      // scooter POIs

      map.addSourcePoints("scooter-source", []);
      map.addImagePath("scooter-image", ":/graphics/scooter_marker_128.png");
      map.addLayer("scooter-layer", {"type": "symbol", "source": "scooter-source"});
      map.setLayoutProperty("scooter-layer", "icon-allow-overlap", true);
      map.setLayoutProperty("scooter-layer", "icon-anchor", "bottom");
      map.setLayoutProperty("scooter-layer", "icon-image", "scooter-image");
      map.setLayoutProperty("scooter-layer", "icon-size", 1.0 / map.pixelRatio);
      map.setLayoutProperty("scooter-layer", "text-anchor", "top");
      map.setLayoutProperty("scooter-layer", "text-optional", true);
      map.setLayoutProperty("scooter-layer", "text-size", 10);
      map.setLayoutProperty("scooter-layer", "text-field", "{name}");

      // no-parking zones (currently NOT provider-dependent)

      map.addSource('no-parking-zone', { 'type': 'geojson', 'data': { 'type': 'Feature', 'geometry': { 'type': 'Polygon', 'coordinates': [] }}});
      map.addLayer('no-parking-zone', {"type": "fill", "source": 'no-parking-zone'})
      map.setPaintProperty('no-parking-zone', "fill-color", '#FF0000')
      map.setPaintProperty('no-parking-zone', "fill-opacity", 0.5)
   }
}
