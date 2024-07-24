import 'dart:async';
import 'dart:convert';
import 'dart:ui' as ui;
import 'package:bus_karo/data/bus_data.dart';
import 'package:bus_karo/data/bus_stop_data.dart';
import 'package:bus_karo/models/bus_stop.dart';
import 'package:bus_karo/widgets/bus_information.dart';
import 'package:bus_karo/widgets/permissions_denied.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import '../models/bus.dart';




class HomeScreenMap extends StatefulWidget {
  const HomeScreenMap({super.key});

  @override
  State<HomeScreenMap> createState() {
    return _HomeScreenMapState();
  }
}

class _HomeScreenMapState extends State<HomeScreenMap> {

  bool isLocationPermissionsGranted = false;
  bool isLoading=true;
  CameraPosition initialCamPosition = const CameraPosition(target: LatLng(23.2026,72.5838), zoom: 14);
  Completer<GoogleMapController> mapController = Completer();
  double? userCurrentLat;
  double? userCurrentLng;
  final Set<Marker> _mapMarkers = {};
  late final String mapTheme;


  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(), targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!.buffer.asUint8List();
  }


  void _openBusInformationOverlay(Bus bus)
  {
    showModalBottomSheet(
        context: context,
        useSafeArea: true,
        isScrollControlled: true,
        isDismissible: true,
        //backgroundColor: const Color.fromRGBO(153, 254, 255,1),
        builder: (context) => BusInformation(bus: bus,),
    );
  }


 void setMarkersForMap() async
 {

   availableBuses.clear();
   availableBusStops.clear();

   final busResponse = await http.get(Uri.parse('https://ap-south-1.aws.neurelo.com/rest/Buses'), headers: {"X-API-KEY": "neurelo_9wKFBp874Z5xFw6ZCfvhXSWjn5HaGax0iEIv7FlN0VhmOVVtFbJEXJBsgFnFGucZ++OTzYmBZ2xlTwkG3Xbt80xHUKdR788dvKiF8ipMZKSmIXyEJU7NAgrMIZ7wbDmQhq8RNfLKr5CuLxMTzqxgqsFHBDd70swCInlghCPJj8GgZubiiqnMNhcw1AXkJACn_bF9SeH4Sv8OeECAqt8ONQKXFxJvnErwoo6bL+2rAnXk="});
   final busResponseBody = await jsonDecode(busResponse.body);
   final busesMapList = await busResponseBody['data'];

   final busStopResponse = await http.get(Uri.parse('https://ap-south-1.aws.neurelo.com/rest/BusStops'), headers: {"X-API-KEY": "neurelo_9wKFBp874Z5xFw6ZCfvhXSWjn5HaGax0iEIv7FlN0VhmOVVtFbJEXJBsgFnFGucZ++OTzYmBZ2xlTwkG3Xbt80xHUKdR788dvKiF8ipMZKSmIXyEJU7NAgrMIZ7wbDmQhq8RNfLKr5CuLxMTzqxgqsFHBDd70swCInlghCPJj8GgZubiiqnMNhcw1AXkJACn_bF9SeH4Sv8OeECAqt8ONQKXFxJvnErwoo6bL+2rAnXk="});
   final busStopResponseBody = await jsonDecode(busStopResponse.body);
   final busStopsMapList = await busStopResponseBody['data'];

   for(final bus in busesMapList)
     {
       availableBuses.add(
         Bus(
             busUID: bus['busUID'],
             busNumberPlate: bus['busNumberPlate'],
             currentNumberOfPassenger: bus['currentNumberOfPassenger'],
             totalPassengerCapacity: bus['totalPassengerCapacity'],
             currentLatitude: bus['currentLatitude'],
             currentLongitude: bus['currentLongitude'],
             driverName: bus['driverName'],
             temporaryNotification: bus['temporaryNotification'],
             busRouteStart: bus['busRouteStart'],
             busRouteEnd: bus['busRouteEnd'],
       ));
     }

   for(final busStop in busStopsMapList)
     {
       availableBusStops.add(
         BusStop(
           busStopName: busStop['busStopName'],
           busStopLat: busStop['busStopLat'],
           busStopLng: busStop['busStopLng'],
           busStopUID: busStop['busStopUID']
         )
       );
     }

   for(int i=0; i<availableBuses.length; i++)
     {
       double passengerDensity = availableBuses[i].currentNumberOfPassenger/availableBuses[i].totalPassengerCapacity;
       final Uint8List markerIcon;
       if(passengerDensity <= 0.3)
         {
           markerIcon = await getBytesFromAsset("lib/assets/map_icons/busGreenMapIcon.png", 130);
         }
       else if(passengerDensity > 0.3 && passengerDensity <=0.7)
         {
           markerIcon = await getBytesFromAsset("lib/assets/map_icons/busOrangeMapIcon.png", 130);
         }
       else
         {
           markerIcon = await getBytesFromAsset("lib/assets/map_icons/busRedMapIcon.png", 130);
         }

       _mapMarkers.add(Marker(
           markerId: MarkerId(availableBuses[i].busUID),
           position: LatLng(availableBuses[i].currentLatitude, availableBuses[i].currentLongitude),
           visible: true,
           draggable: false,
           icon: BitmapDescriptor.fromBytes(markerIcon),
           onTap: () {
             _openBusInformationOverlay(availableBuses[i]);
           },
         )
       );
     }

   final Uint8List markerIcon = await getBytesFromAsset("lib/assets/map_icons/busstopMapIcon.png", 170);
   for(int i=0; i<availableBusStops.length; i++)
     {
       _mapMarkers.add(Marker(
           markerId: MarkerId(availableBusStops[i].busStopUID),
           visible: true,
           draggable: false,
           position: LatLng(availableBusStops[i].busStopLat, availableBusStops[i].busStopLng),
           icon: BitmapDescriptor.fromBytes(markerIcon),
           infoWindow: InfoWindow(title: "${availableBusStops[i].busStopName} Bus Stop"),
         )
       );
     }
   setState(() {});
 }


  void doInitialNecessarySetup() async
  {
    bool serviceEnabled;
    LocationPermission permission;


    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await Geolocator.openLocationSettings();
      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if(!serviceEnabled){
          isLocationPermissionsGranted=false;
          setState(() {
            isLoading=false;
          });
      }
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
          isLocationPermissionsGranted=false;
          setState(() {
            isLoading=false;
          });
      }
    }

    if (permission == LocationPermission.deniedForever) {
       await Geolocator.openAppSettings();
       permission = await Geolocator.checkPermission();
       if(permission == LocationPermission.denied || permission == LocationPermission.deniedForever)
         {
           isLocationPermissionsGranted=false;
           setState(() {
             isLoading=false;
           });
         }
    }

    if((permission == LocationPermission.always || permission == LocationPermission.whileInUse) && await Geolocator.isLocationServiceEnabled())
      {
        DefaultAssetBundle.of(context).loadString("lib/assets/map_theme/default_theme.json").then((value) {mapTheme = value;});
        final position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.best);
        setMarkersForMap();
        setState(()  {
          userCurrentLat = position.latitude;
          userCurrentLng = position.longitude;
          isLocationPermissionsGranted=true;
          isLoading=false;
        });
      }
  }


  @override
  void initState() {
    doInitialNecessarySetup();
    Timer.periodic(const Duration(seconds: 6), (timer) {
      setMarkersForMap();
    });
    super.initState();
  }


  @override
  Widget build(BuildContext context) {

    return
      isLocationPermissionsGranted
        ?
    GoogleMap(
      myLocationButtonEnabled: true,
      mapToolbarEnabled: false,
      myLocationEnabled: true,
      initialCameraPosition: initialCamPosition,
      trafficEnabled: true,
      markers: _mapMarkers,

      onMapCreated: (controller) {
        mapController.complete(controller);
        controller.setMapStyle(mapTheme);
        controller.moveCamera(CameraUpdate.newCameraPosition(CameraPosition(target: LatLng(userCurrentLat!,userCurrentLng!), zoom: 14)));
      },

    ) : (isLoading ? const Center(child : CircularProgressIndicator()) : const PermissionsDenied());

  }
}
