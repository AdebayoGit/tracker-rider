import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rider/services/auth_services.dart';

import '../models/status.dart';

class UserViewModel extends ChangeNotifier {
  late final User? _user;

  Error? _error;

  bool loading = false;

  User? get user => _user;

  Error? get error => _error;

  UserViewModel(){
    getUser();
  }

  setLoading(bool loading) {
    loading = loading;
    notifyListeners();
  }

  Future<void> signIn() async {
    setLoading(true);
    if(_user != null){
      setLoading(false);
    } else {
      var response = await AuthServices.signIn();
      if (response is Success) {
        UserCredential userCredential = response.response as UserCredential;
        _user = userCredential.user!;
      } else if (response is Failure) {
        Error error = Error(code: response.code, message: response.errorResponse);
        _error = error;
      }
      setLoading(false);
    }
  }

  void getUser(){
    _user = FirebaseAuth.instance.currentUser!;
  }
}
