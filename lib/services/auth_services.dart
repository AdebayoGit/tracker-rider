import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rider/models/rider.dart';
import 'package:rider/models/status.dart';
import 'package:rider/services/device_services.dart';

class AuthServices {
  late FirebaseAuth _auth;
  late FirebaseFirestore _store;
  late FirebaseFunctions _functions;
  late CollectionReference _ridersCollection;
  late DeviceServices _device;

  AuthServices() {
    _auth = FirebaseAuth.instance;
    _store = FirebaseFirestore.instance;
    _functions = FirebaseFunctions.instance;
    _ridersCollection = _store.collection('riders');
    _device = DeviceServices.instance;

  }

  Future<Object?> currentDriver (String uid) async {
      try {
        return _ridersCollection.doc(uid).get().then((value) {
          return Success(response: Driver.fromSnapshot(value));
        });
      } on Exception catch (e) {
        return Failure(code: "100", errorResponse: e as String);
      }
    }

  Future<Object> createToken(String username, String password) async {
    try {
      HttpsCallable callable = _functions.httpsCallable('signin');
      return await callable.call(<String, dynamic>{
        'username': username,
        'password': password,
      }).then((value) => signIn(value.data["token"]));
    } on FirebaseFunctionsException catch (e) {
      return Failure(code: e.code, errorResponse: e.message as String);
    } catch (e) {
      return Failure(code: e.toString(), errorResponse: "Unknown Error");
    }
  }

  Future<Object> signIn(String customToken) async {
    try {
      User user = await _auth.signInWithCustomToken(customToken).then((value) => value.user!);
      return Success(response: user);
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

  Stream<User?> authStream() {
    return _auth.authStateChanges();
  }
}
