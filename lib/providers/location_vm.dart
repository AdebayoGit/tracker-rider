import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:location/location.dart';
import 'package:rider/services/log_services.dart';
import 'package:rider/services/trip_services.dart';

import '../models/status.dart';

class LocationViewModel extends ChangeNotifier{

  final Location _location = Location();

  LocationViewModel(){
    //getPermission();
    _location.enableBackgroundMode(enable: true);
    _location.changeSettings(accuracy: LocationAccuracy.navigation);
  }

  bool? _locationEnabled;

  bool _loading = false;

  bool _onTrip = false;

  bool _paused = false;

  late LocationData _currentLocation;

  List<Map<String, dynamic>> _logs = [];

  late StreamSubscription<LocationData> _locationStream;

  late String _tripId;

  final TripServices _trips = TripServices();


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

  Future<void> getPermission() async {
    bool _serviceEnabled = await _location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await _location.requestService();
      if(_serviceEnabled){
        return;
      } else {
        SystemChannels.platform.invokeMethod<void>('SystemNavigator.pop', true);
      }
    }
  }

  Future<void> getCurrentLocation() async{
    setLocation(await _location.getLocation());
  }

  Future<Failure?> startTrip([String? remark]) async {
    Failure? fail;
    _paused = false;
    if(!_onTrip){
      Object response = await _trips.createTrip(_currentLocation, remark);
      if(response is Success){
        _tripId = response.response as String;
      } else {
        fail = response as Failure;
        return fail;
      }
      _onTrip = true;
    }
    _locationStream = _location.onLocationChanged.listen((LocationData data) async {
      if (!_paused) {
        var response = await _trips.updateTrip(_tripId, data);
        if(response is Map){
          _logs.add(response as Map<String, dynamic>);
        }
        setLocation(data);
      }
    });
    return fail;
  }

  void pauseTrip([String? remark]) async{
    _paused = true;
    Failure? fail = await _trips.pauseTrip(_tripId, remark, _currentLocation);
    _locationStream.pause();
  }

  void stopTrip(String? url, [String? remark]) async{
    _paused = true;
    Failure? fail = await _trips.stopTrip(_tripId, remark ?? '', url ?? '', _currentLocation);
    var encoded = json.encode(_logs);
    FileManager.writeToLogFile(encoded);
    _locationStream.cancel();
  }

  void getLocationUpdates(){
    _location.onLocationChanged.listen((LocationData data) {
      setLocation(data);
    });
  }
}