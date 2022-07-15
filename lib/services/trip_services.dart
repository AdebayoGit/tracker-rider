import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:location/location.dart';

import '../models/status.dart';
import '../utils/app_constants.dart';

class TripServices {

  final FirebaseFirestore _store = FirebaseFirestore.instance;

  final FirebaseAuth _auth = FirebaseAuth.instance;

  late final CollectionReference _trips = _store.collection('riders/${_auth.currentUser?.uid}/trips');

  Future<Object> createTrip(LocationData locationData, [String? remark]) async {
    try {
      return await _trips.add({
        'createdAt': DateTime.fromMillisecondsSinceEpoch(locationData.time!.toInt()).toString(),
        'start': createLocationInfo(location: locationData),
        'stop': null,
        'pauses': [],
        'initial remarks': remark,
      }).then((value) => Success(response: value.id));
    } on HttpException {
      return Failure(
          code: AppConstants.noInternet,
          errorResponse: 'No Internet Connection');
    } on SocketException {
      return Failure(
          code: AppConstants.noInternet,
          errorResponse: 'No Internet Connection');
    } on FormatException {
      return Failure(
          code: AppConstants.invalidFormat, errorResponse: 'Invalid Format');
    } catch (e) {
      return Failure(
          code: AppConstants.unknownError, errorResponse: 'Unknown Error');
    }
  }

  Future<Failure?> pauseTrip(String id, String? remark, LocationData locationData) async {
    try {
      _trips.doc(id).get().then((DocumentSnapshot doc) {
        List<dynamic> pauses = doc['pauses'];
        pauses.add({
          'location': createLocationInfo(location: locationData),
          'remark': remark,
        });
        doc.reference.update({
        'pauses': pauses,
        });
      });
      return null;
    } on HttpException {
      return Failure(
          code: AppConstants.noInternet,
          errorResponse: 'No Internet Connection');
    } on SocketException {
      return Failure(
          code: AppConstants.noInternet,
          errorResponse: 'No Internet Connection');
    } on FormatException {
      return Failure(
          code: AppConstants.invalidFormat, errorResponse: 'Invalid Format');
    } catch (e) {
      return Failure(
          code: AppConstants.unknownError, errorResponse: 'Unknown Error');
    }
  }

  Object? stopTrip(String tripId, LocationData locationData) {
    try {
      _trips.doc(tripId).set({
        'stop': createLocationInfo(location: locationData),
        // 'final remarks': remark,
      });
      return null;
    } on HttpException {
      return Failure(
          code: AppConstants.noInternet,
          errorResponse: 'No Internet Connection');
    } on SocketException {
      return Failure(
          code: AppConstants.noInternet,
          errorResponse: 'No Internet Connection');
    } on FormatException {
      return Failure(
          code: AppConstants.invalidFormat, errorResponse: 'Invalid Format');
    } catch (e) {
      return Failure(
          code: AppConstants.unknownError, errorResponse: 'Unknown Error');
    }
  }

  Future<Object?> addLocation(String tripId, Map<String, dynamic> location) async {
    try {
      _trips.doc(tripId).collection('locations').add(location);
      return location;
    } on HttpException {
      return Failure(
          code: AppConstants.noInternet,
          errorResponse: 'No Internet Connection');
    } on SocketException {
      return Failure(
          code: AppConstants.noInternet,
          errorResponse: 'No Internet Connection');
    } on FormatException {
      return Failure(
          code: AppConstants.invalidFormat, errorResponse: 'Invalid Format');
    } catch (e) {
      return Failure(
          code: AppConstants.unknownError, errorResponse: 'Unknown Error');
    }
  }

  Future<String?> checkForUncompletedTrips() async {
    QuerySnapshot snap = await _trips.orderBy('createdAt').limitToLast(1).get();
    for (var i in snap.docs){
      if (i['stop'] == null){
        return i.id;
      } else {
        return null;
      }
    }
    return null;
  }

  Map<String, dynamic> createLocationInfo({required LocationData location}) {
    return <String, dynamic>{
      'location': GeoPoint(location.longitude!, location.latitude!),
      'time': DateTime.fromMillisecondsSinceEpoch(location.time!.toInt()),
      'direction': location.heading,
      'speedInfo': {'speed': location.speed, 'accuracy': location.speedAccuracy},
      'altitude': location.altitude,

    };
  }
}
