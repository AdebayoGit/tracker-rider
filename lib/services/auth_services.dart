import 'dart:async';

import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rider/models/status.dart';
import 'package:rider/services/device_services.dart';

class AuthServices {
  late FirebaseAuth _auth;

  late FirebaseFunctions _functions;

  late DeviceServices _device;

  AuthServices() {
    _auth = FirebaseAuth.instance;

    _functions = FirebaseFunctions.instance;

    _device = DeviceServices.instance;

  }

  String get driversId => _auth.currentUser!.uid;

  Future<Status> createToken(String username, String password) async {
    try {
      HttpsCallable callable = _functions.httpsCallable('signin');
      return await callable.call(<String, dynamic>{
        'username': username,
        'password': password,
      }).then((value) => signIn(value.data["token"]));
    } on FirebaseFunctionsException catch (e) {
      return Failure(code: e.code, response: e.message as String);
    } catch (e) {
      return Failure(code: e.toString(), response: "Unknown Error");
    }
  }

  Future<Status> signIn(String customToken) async {
    try {
      User user = await _auth.signInWithCustomToken(customToken).then((value) => value.user!);
      return Success(response: user);
    } on FirebaseAuthException catch (e) {
      return Failure(code: e.code, response: e.message as String);
    }
  }

  Future<Status> signOut() async {
    try {
      await _auth.signOut();
      await _device.removeDriverFromDevice();
      return Success(response: 'User signed out successfully!');
    } on FirebaseAuthException catch (e) {
      return Failure(code: e.code, response: e.message as String);
    }
  }

  Stream<User?> authStream() {
    return _auth.authStateChanges();
  }
}
