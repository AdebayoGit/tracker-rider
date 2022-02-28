
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:password/password.dart';
import 'package:rider/models/rider.dart';
import 'package:rider/models/status.dart';
import 'package:rider/services/device_services.dart';

import '../utils/app_constants.dart';

class AuthServices {
  late FirebaseAuth _auth;
  late FirebaseFirestore _firestore;
  late CollectionReference _ridersCollection;
  late PBKDF2 _algorithm;
  late DeviceServices _device;

  AuthServices() {
    _auth = FirebaseAuth.instance;
    _algorithm = PBKDF2();
    _firestore = FirebaseFirestore.instance;
    _ridersCollection = _firestore.collection('riders');
    _device = DeviceServices.instance;
  }

  Future<Object?> currentRider () async {
    String? username = await DeviceServices.instance.getUsername();
    if(username == null){
      return null;
    } else {
      return _ridersCollection.doc(username).get().then((value) {
        return Success(response: Rider.fromSnap(value));
      });
    }
  }

  Future<Object> signIn(String username, String password) async {
    try {
      User? user = _auth.currentUser;
      if(user == null){
        await _auth.signInAnonymously();
      }
      return verifyPassword(username, password);
    } on FirebaseAuthException catch (e) {
      return Failure(code: e.code, errorResponse: e.message as String);
    }
  }

  Future<Object> signUp(String name, String username, String password) async {
    final String hash = Password.hash(password, _algorithm);
    String vehicleId = await DeviceServices.instance.getVehicleId();
    try {
      await _auth.signInAnonymously();
      _ridersCollection.doc(username).set({
        'name': name,
        'username': username,
        'password': hash,
        'created': DateTime.now(),
        'registrationVehicle': vehicleId,
        'lastLogin': '',
        'currentVehicle': vehicleId,
      });
      return Success(response: 'Successfully Registered User');
    } on FirebaseAuthException catch (e) {
      return Failure(code: e.code, errorResponse: e.message as String);
    }
  }

  Future<Object> signOut() async {
    try {
      await _auth.signOut();
      await _device.removeDriverFromDevice();
      return Success(response: '');
    } on FirebaseAuthException catch (e) {
      return Failure(code: e.code, errorResponse: e.message as String);
    }
  }

  Future<Object> verifyPassword(String username, String password) async {
    String passwordHash;
    try {
      return _ridersCollection.doc(username).get().then((value) async {
        passwordHash = value['password'];
        if (Password.verify(password, passwordHash)) {
          _ridersCollection.doc(username).update({
            'currentVehicle': await _device.getVehicleId(),
            'lastLogin': DateTime.now(),
          });
          DeviceServices.instance.addDriverToDevice(username);
          return Success(response: Rider.fromSnap(value));
        }
        return Failure(code: AppConstants.invalidResponse,
            errorResponse: 'Wrong Password');
      }, onError: (error){
        return Failure(code: AppConstants.invalidResponse,
            errorResponse: 'User not found');
      }).onError((error, stackTrace) => Failure(code: AppConstants.invalidResponse,
          errorResponse: 'User not found'));
    } on HttpException {
      return Failure(code: AppConstants.noInternet, errorResponse: 'No Internet Connection');
      } on SocketException {
      return Failure(code: AppConstants.noInternet, errorResponse: 'No Internet Connection');
      } on FormatException {
      return Failure(code: AppConstants.invalidFormat, errorResponse: 'Invalid Format');
      } catch (e) {
        return Failure(code: AppConstants.unknownError, errorResponse: 'Unknown Error');
      }
  }
}
