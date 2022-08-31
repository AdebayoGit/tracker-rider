import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:location/location.dart';

import '../models/status.dart';
import '../utils/app_constants.dart';
import 'driver_services.dart';

class TripServices {

  late final FirebaseFirestore _store ;

  late final CollectionReference _trips;

  late final DriverServices _driverServices;

  TripServices(){
    _store = FirebaseFirestore.instance;

    _trips = _store.collection('trips');

    _driverServices = Get.find<DriverServices>();
  }

  Future<Object> createTrip(LocationData locationData, [String? remark]) async {
    try {
      String userId = _driverServices.user.uid;
      String tripId = '$userId ${DateTime.now().millisecondsSinceEpoch}';
      return await _trips.doc(tripId).set({
        'createdAt': DateTime.fromMillisecondsSinceEpoch(locationData.time!.toInt()).toString(),
        'createdBy': userId,
        'start': createLocationInfo(location: locationData),
        'stop': null,
        'status': 'in progress',
        'pauses': [],
        'initial remarks': remark,
      }).then((value){
        _driverServices.recordDriverLastTrip(tripId);
        return Success(response: tripId);
      });
    } on HttpException {
      return Failure(
          code: AppConstants.noInternet,
          response: 'No Internet Connection');
    } on SocketException {
      return Failure(
          code: AppConstants.noInternet,
          response: 'No Internet Connection');
    } on FormatException {
      return Failure(
          code: AppConstants.invalidFormat, response: 'Invalid Format');
    } catch (e) {
      return Failure(
          code: AppConstants.unknownError, response: 'Unknown Error');
    }
  }

  Future<Status?> pauseTrip(String id, String? remark, LocationData locationData) async {
    try {
      Map<String, dynamic> location = createLocationInfo(location: locationData);
      await _trips.doc(id).update({
        'status': 'paused',
        'pauses': FieldValue.arrayUnion([{
          'location': location,
          'remark': remark,
        }])
      });
      return null;
    } on HttpException {
      return Failure(
          code: AppConstants.noInternet,
          response: 'No Internet Connection');
    } on SocketException {
      return Failure(
          code: AppConstants.noInternet,
          response: 'No Internet Connection');
    } on FormatException {
      return Failure(
          code: AppConstants.invalidFormat, response: 'Invalid Format');
    } catch (e) {
      return Failure(
          code: AppConstants.unknownError, response: 'Unknown Error');
    }
  }

  Status? stopTrip(String tripId, LocationData locationData) {
    try {
      _trips.doc(tripId).update({
        'status': 'completed',
        'stop': createLocationInfo(location: locationData),
        // 'final remarks': remark,
      });
      return null;
    } on HttpException {
      return Failure(
          code: AppConstants.noInternet,
          response: 'No Internet Connection');
    } on SocketException {
      return Failure(
          code: AppConstants.noInternet,
          response: 'No Internet Connection');
    } on FormatException {
      return Failure(
          code: AppConstants.invalidFormat, response: 'Invalid Format');
    } catch (e) {
      return Failure(
          code: AppConstants.unknownError, response: 'Unknown Error');
    }
  }

  Future<Object> addLocation(String tripId, Map<String, dynamic> location) async {
    try {
      _trips.doc(tripId).collection('locations').add(location);
      return location;
    } on HttpException {
      return Failure(
          code: AppConstants.noInternet,
          response: 'No Internet Connection');
    } on SocketException {
      return Failure(
          code: AppConstants.noInternet,
          response: 'No Internet Connection');
    } on FormatException {
      return Failure(
          code: AppConstants.invalidFormat, response: 'Invalid Format');
    } catch (e) {
      return Failure(
          code: AppConstants.unknownError, response: 'Unknown Error');
    }
  }

  Future<String?> checkForUncompletedTrips() async {

    String? lastTripId = _driverServices.driver!.lastTrip;

    if(lastTripId == ''){
      return null;
    } else {
      return await _trips.doc(lastTripId).get().then((DocumentSnapshot doc){
        if (doc['status'] != 'completed'){
          return doc.id;
        } else {
          return null;
        }
      });
    }
  }

  Map<String, dynamic> createLocationInfo({required LocationData location}) {
    return <String, dynamic>{
      'location': GeoPoint(location.latitude!, location.longitude!),
      'time': DateTime.fromMillisecondsSinceEpoch(location.time!.toInt()),
      'direction': location.heading,
      'speedInfo': {'speed': location.speed, 'accuracy': location.speedAccuracy},
      'altitude': location.altitude,
    };
  }
}
