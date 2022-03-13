import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:location/location.dart';
import 'package:rider/services/device_services.dart';

import '../models/status.dart';
import '../utils/app_constants.dart';
import 'log_services.dart';

class TripServices {
  late final DeviceServices _device = DeviceServices.instance;
  late final FirebaseFirestore _store = FirebaseFirestore.instance;

  late final CollectionReference _trips = _store.collection('trips');

  static List<Map<String, dynamic>> _logs = [];


  Future<Object> createTrip(LocationData locationData, [String? remark]) async {
    try {
      String? username = await _device.getUsername();
      Map<String, dynamic> location = <String, dynamic>{
        'location': GeoPoint(locationData.longitude!, locationData.latitude!),
        'time': locationData.time,
        'direction': locationData.heading,
        'speed': locationData.speed,
        'remark': remark ?? '',
      };
      String tripId = username! + locationData.time.toString();
      _trips.doc(tripId).set({
        'riderId': username,
        'start': location,
        'currentLocation': location,
        'pauses': [],
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
      Map<String, dynamic> pause = <String, dynamic>{
        'location': GeoPoint(locationData.longitude!, locationData.latitude!),
        'time': locationData.time,
        'direction': locationData.heading,
        'remark': remark ?? '',
      };
      _trips.doc(id).get().then((DocumentSnapshot doc) {
        List<dynamic> pauses = doc['pauses'];
        pauses.add(pause);
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

  Future<Failure?> stopTrip(String id, String remark, String url, LocationData locationData) async {
    try {
      Map<String, dynamic> stop = <String, dynamic>{
        'location': GeoPoint(locationData.longitude!, locationData.latitude!),
        'time': locationData.time,
        'direction': locationData.heading,
        'remark': remark,
      };
      _trips.doc(id).get().then((DocumentSnapshot doc) {
        doc.reference.update({
          'stop': stop,
          'video_url': url,
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

  Future<Object?> updateTrip(String id, LocationData locationData) async {
    Map<String, String> location = <String, String>{
      'longitude': locationData.longitude!.toString(),
      'latitude': locationData.latitude!.toString(),
      'time': locationData.time.toString(),
      'direction': locationData.heading.toString(),
      'speed': locationData.speed.toString(),
    };
    try {
        _trips.doc(id).update({
          'currentLocation': {
            'location': GeoPoint(locationData.longitude!, locationData.latitude!),
            'time': locationData.time,
            'direction': locationData.heading,
            'speed': locationData.speed,
          },
        });
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
}
