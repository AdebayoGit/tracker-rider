import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:rider/services/location_services.dart';

class AppViewModel extends ChangeNotifier{
  bool? _locationEnabled;

  late bool _loading = false;

  late LocationData _currentLocation;

  AppViewModel(){

  }

  bool? get locationEnabled => _locationEnabled;

  bool get loading => _loading;

  LocationData get currentLocation => _currentLocation;

  void setLoading(bool value){
    _loading = value;
    notifyListeners();
  }

  void setLocation(LocationData newLocation){
    _currentLocation = newLocation;
  }

  /*void getPermission() async {
    _locationEnabled = await LocationServices.getLocationPermission();
  }*/

  Future<void> getCurrentLocation() async{
    setLoading(true);
    setLocation(await LocationServices.getCurrentLocation());
    setLoading(false);
  }

  void getLocationUpdates(){
    LocationServices.getLocationStream().onData((LocationData data) {
      setLocation(data);
      notifyListeners();
    });
  }

}