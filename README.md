# Google Maps Flutter Integration

A quickstart project that : 
- Requests Location Permission from the user
- If the user grants the permission :
  - It zooms in the user's location
- If they decline access 
  - It zooms in a default location
- When they press a floatingActionButton , it points the camera in their location   
### Use your own Google Maps API Key inside `/android/src/main/AndroidManifest.xml` file !
#### Only tested on Android (Emulator & Real Device)

## Demo
<img src="/demo.gif" width="284.2105" height="600"/>


## Why?
It is an extremely important feature for many map based apps and ,despite that, there are not many tutorials. This is a more complete integration that uses the futureBuilder to update the map after the location has been granted.
Moreover , when I myself tried asking for permissions I encountered problems with the documentation of many packages and I found that , at least in my case, their tutorials did not work. Explained in the comments of the source code.

## Packages Used
- [google_maps_flutter](https://pub.dev/packages/google_maps_flutter)
- [location](https://pub.dev/packages/location)
- [permission_handler](https://pub.dev/packages/permission_handler)

## Any advice/correction is encouraged. I am still new to Flutter and I want to learn. I hope this repo helps someone else as well

