import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:rider/services/location_services.dart';

class AppViewModel extends ChangeNotifier{

  static AppViewModel? _instance;

  AppViewModel._();

  static AppViewModel get instance => _instance ??= AppViewModel._();

  bool? _locationEnabled;

  late bool _loading = false;

  late LocationData _currentLocation;

  AppViewModel();

  bool? get locationEnabled => _locationEnabled;

  bool get loading => _loading;

  LocationData get currentLocation => _currentLocation;

  void setLoading(bool value){
    _loading = value;
    notifyListeners();
  }

  void setLocation(LocationData newLocation){
    _currentLocation = newLocation;
    notifyListeners();
  }

  /*void getPermission() async {
    _locationEnabled = await LocationServices.getLocationPermission();
  }*/

  Future<void> getCurrentLocation() async{
    setLocation(await LocationServices().getCurrentLocation());
    notifyListeners();
  }

  void getLocationUpdates(){
    LocationServices().getLocationStream().onData((LocationData data) {
      setLocation(data);
      notifyListeners();
    });
  }

}