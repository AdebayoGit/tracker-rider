import 'package:location/location.dart';

class LocationServices{

  static final LocationServices _instance = LocationServices._();

  Location location = Location();

  late bool _serviceEnabled;

  late PermissionStatus _permissionGranted;

  LocationServices._();

  factory LocationServices() {
    return _instance;
  }

  Future<void> checkLocationPermission() async {
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        checkLocationPermission();
      }
    }
    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        checkLocationPermission();
      }
    }
    ///Todo: add distance filter
    location.changeSettings(accuracy: LocationAccuracy.high, interval: 60000, distanceFilter: 50);
    location.enableBackgroundMode(enable: true);
  }

  Future<LocationData> getCurrentLocation() async {
    return location.getLocation();
  }

  Stream<LocationData> listenForLocationUpdates() {
    return location.onLocationChanged;
  }
}