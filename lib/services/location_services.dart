import 'dart:async';

import 'package:flutter/services.dart';
import 'package:location/location.dart';

class LocationServices{
  static Location location = Location();

  LocationServices(){
    location.enableBackgroundMode(enable: true);
  }

  static Future<void> getLocationPermission() async {
    bool _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if(_serviceEnabled){
        return;
      } else {
        SystemChannels.platform.invokeMethod<void>('SystemNavigator.pop', true);
      }
    }
  }

  static Future<LocationData> getCurrentLocation() async {
    LocationData _locationData = await location.getLocation();
    return _locationData;
  }

  static StreamSubscription<LocationData> getLocationStream(){
    StreamSubscription<LocationData> locationData = location.onLocationChanged.listen((LocationData currentLocation){});
    return locationData;
  }
}