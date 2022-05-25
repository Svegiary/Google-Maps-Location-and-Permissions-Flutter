import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:async';
import 'package:location/location.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Google Map Integration',
      theme: ThemeData(
        useMaterial3: true,
        
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Google Map Integration'),
    );
  }
}

class Gmap extends StatefulWidget {
  const Gmap({ Key? key }) : super(key: key);
  

  @override
  State<Gmap> createState() => _GmapState();

}

class _GmapState extends State<Gmap> {

  late Future<LatLng> futureUserLocation ; //promised not null on runtime
  Completer<GoogleMapController> _controller = Completer();
  

  final LatLng _greece = const LatLng(37.983810, 23.727539); 
  LatLng _userLocation = const LatLng(37.983810, 23.727539);


  Future<LatLng> askPermissionAndGetLocation() async{ 
    /*
      The documentation of many permission/location packages , recommends asking for permissions 
      after you have checked if the user has already granted them:
      -------------------------------------------------------------------------
      // var status = await Permission.location.status; <========= (added this)  
      // if(status.isDenied){                                                    
      //   if(await Permission.location.request().isGranted){
      //     LocationData l = await Location().getLocation();
      //     setState((){
      //       _userLocation = LatLng(l.latitude!, l.longitude!);
      //     });
      //     return _userLocation;import 'package:flutter/services.dart' show rootBundle;

      Then when location.request() is called , the user has not granted permission to the previous dialog , so 
      the second one is never displayed (can not ask for two permissions at once)

      When the user grants permission , the value is never saved in this current state and requires a rebuild 
      of the widget

    */
     if(await Permission.locationWhenInUse.serviceStatus.isEnabled){       
        if(await Permission.location.request().isGranted){ //if the permission is not granted , request it and if it is granted
          LocationData l = await Location().getLocation(); //get user Location
          setState((){
            _userLocation = LatLng(l.latitude!, l.longitude!); //updating _userLocation 
          });
          return _userLocation; // returns value so that futureUserLocation is updated and futureBuilder rebuilds our map
        }       
     }
     return Future.error("Location services disabled or restricted");
  }

  Future<void> centerLocation()async{
    final GoogleMapController controller = await _controller.future; //gets the current controller 
    CameraPosition userCamera = CameraPosition( //establishes new camera position
            target: _userLocation,
            zoom: 14.0,
          );

    CameraUpdate moveTo =  CameraUpdate.newCameraPosition(userCamera);    
    controller.animateCamera(moveTo); //moves to the new location 
  }

  @override
  void initState() {
    super.initState();    
    futureUserLocation = askPermissionAndGetLocation();
  }  

  @override
  Widget build(BuildContext context){
    return Scaffold(
      
      body: FutureBuilder<LatLng>( // future builder so that it creates a map before asking for permission
        future: futureUserLocation, // listens for future location value
        builder: ( context , AsyncSnapshot<LatLng> snapshot){
          Widget g;
          if(snapshot.hasData){   // if it has data          
            g = GoogleMap(  //create a google map with myLocationEnabled true
                  /*
                  It does not actually create a new map and the initialCameraPosition property
                  does not move the camera. It refreshes the existing map , with the now myLocationEnabled property 
                  set to true
                  */
                  onMapCreated: (GoogleMapController controller){ 
                    _controller.complete(controller);                  
                  },
                  myLocationEnabled:true,
                  initialCameraPosition: CameraPosition(
                    target: _userLocation,
                    zoom: 14.0,
                  ),
                  zoomControlsEnabled: false, //dont show zoom buttons
                  compassEnabled: false,                
                  myLocationButtonEnabled: false,
                );
                centerLocation(); //and then go to the user's location         
          }else if(snapshot.hasError){ //if it has error create a map with the default starting position
            g = GoogleMap(
                onMapCreated: (GoogleMapController controller){
                  _controller.complete(controller);
                },
                myLocationEnabled:false, //it has to be false , explained later
                initialCameraPosition: CameraPosition(
                  target: _greece,
                  zoom: 6.1,
                ),
                zoomControlsEnabled: false, //dont show zoom buttons
                compassEnabled: false, 
                
                myLocationButtonEnabled: false,
              );            
          }else{
            g = GoogleMap(
                onMapCreated: (GoogleMapController controller){
                  _controller.complete(controller);
                  
                },
                myLocationEnabled:false, //it has to be false 
                /*
                If this is set to true , then the map will be built before the user 
                has granted permission. The myLocationEnabled property will silently fail. 
                For it to be enabled again the whole widget has to be rebuilt (quick reload , quick restart)
                If we set it to false now , it will not fail and once we get the permission we want we can enable 
                the property        

                */
                initialCameraPosition: CameraPosition(
                  target: _greece,
                  zoom: 6.1,
                ),
                zoomControlsEnabled: false, //dont show zoom buttons
                compassEnabled: false,                 
                myLocationButtonEnabled: false,
              );            
          }
          return g;
        }
      ),      
        floatingActionButton:           
          FloatingActionButton(
              onPressed: () {centerLocation(); }, 
              
              backgroundColor: Colors.indigoAccent,
              enableFeedback: true,
              child: const Icon(Icons.location_on,
                  size: 27, color: Colors.white)),
        
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);  

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigoAccent,
        title: Text(widget.title , style: TextStyle(color: Colors.white)),
        centerTitle: true,
      ),
      body: const Gmap(),
      
    );
  }
}
