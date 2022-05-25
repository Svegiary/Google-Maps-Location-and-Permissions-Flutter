# Google Maps Flutter Integration

A quickstart project that : 
- Requests Location Permission from the user
- If the user grants the permission :
  - It zooms in the user's location
- If they decline access 
  - It zooms in a default location   
### Use your own Google Maps API Key inside the ***pubspec.yaml*** file !
#### Only tested on Android (Emulator & Real Device)

## Why?
It is an extremely important feature for many map based apps and ,despite that, there are not many tutorials. This is a more complete integration that uses the futureBuilder to update the map after the location has been granted.
Moreover , when I myself tried asking for permissions I encountered problems with the documentation of many packages and I found that , at least in my case, their tutorials did not work. Explained in the comments of the source code.

## Packages Used
- [google_maps_flutter](https://pub.dev/packages/google_maps_flutter)
- [location](https://pub.dev/packages/location)
- [permission_handler](https://pub.dev/packages/permission_handler)


