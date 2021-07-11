# Scooter

## Overview
This app aims to provide support for unlocking/riding electric scooters on SailfishOS. While the app is built as multi-provider app, currently, only *Bird* (see https://www.bird.co) is supported.

<img title="Screenshot" alt="Screenshot" width="300" src="screenshots/screenshot.png">

## Features

The app provides the following features:

- Log into an existing *Bird* account using E-Mail/confirmation code
- Show profile details
- Show scooter locations and restricted areas on a map
- Ring scooter
- Unlock scooter / start ride by scanning the QR code on the scooter
- Show pending/active rides which have not yet been stopped

The app will be able to load existing/still active rides when the app is closed / opened again.

The official *Bird* app (iOS/Android) will be able to "see" rides which have been started with this app. As such, the official app can be used to stop rides in case of errors/issues with this app.

## Supported providers

Currenlty supported:
- *Bird* (https://www.bird.co)


Other scooter providers have been contacted asking for support/documentation of their APIs. The app is built with mulit-provider support in mind, as such, it will be an easy task to add other providers in the future, once the API is known / documentation is available.

## Known issues / restrictions

Since the app is built without official documentation of APIs, several cases/features have not yet occured (and are thus not tested), or are simply missing in the app:

- parking in restricted zones
- using of voucher codes
- displaying active vouchers or discount codes

Furthermore, it is currently not possible to display pricing information with the correct locale, before starting a ride. As a result, the pricing information is displayed in USD.

The app *should*, however, always display the correct pricing information when the ride has ended (in local currency).

For unknown error situations, the app should be able to report error information which can be forwarded to the developer for analysis.


## Disclaimer
Since the app uses undocumented APIs of *Bird*, there might be errors while using the app. As a result, a second device running Android/iOS and the official *Bird* app should be available, to

# Copyright notice

<div>Icons made by <a href="https://www.freepik.com" title="Freepik">Freepik</a> from <a href="https://www.flaticon.com/" title="Flaticon">www.flaticon.com</a></div>
    
This app uses the [qzxing](https://github.com/ftylitak/qzxing/) / [zxing](https://github.com/zxing/zxing) libraries for scanning QR codes.