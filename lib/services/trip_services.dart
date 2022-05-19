import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:location/location.dart';

import '../models/status.dart';
import '../utils/app_constants.dart';

class TripServices {

  final FirebaseFirestore _store = FirebaseFirestore.instance;

  final FirebaseAuth _auth = FirebaseAuth.instance;

  late final CollectionReference _trips = _store.collection('trips');

  Object createTrip(LocationData locationData, [String? remark]) {
    try {
      String username = _auth.currentUser?.uid ?? '';
      String tripId = username + DateTime.fromMillisecondsSinceEpoch(locationData.time!.toInt()).toString();
      _trips.doc(tripId).set({
        'riderId': username,
        'start': createLocationInfo(location: locationData),
        'pauses': [],
        'initial remarks': remark,
      });
      return Success(response: tripId);
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
