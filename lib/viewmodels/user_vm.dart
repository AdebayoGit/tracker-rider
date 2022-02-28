import 'package:flutter/material.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:rider/services/auth_services.dart';
import 'package:rider/views/auth_view.dart';

import '../models/rider.dart';
import '../models/status.dart';
import '../services/device_services.dart';
import '../views/home.dart';
import '../views/register_device_view.dart';
import '../views/splash_view.dart';
import 'app_vm.dart';

class UserViewModel extends ChangeNotifier {
  Rider? _rider;

  Error? _error;

  bool loading = false;

  dynamic _initView = const SplashView();

  Rider? get rider => _rider;

  get initView => _initView;

  set rider(Rider? rider) {
    _rider = rider;
    notifyListeners();
  }

  set initView(var initView) {
    _initView = initView;
    notifyListeners();
  }

  Error? get error => _error;

  UserViewModel() {}

  setLoading(bool loading) {
    this.loading = loading;
    notifyListeners();
  }

  Future<dynamic> signIn(String username, String password) async {
    var response = await AuthServices().signIn(username, password);
    if (response is Success) {
      rider = response.response as Rider;
      await AppViewModel.instance.getCurrentLocation();
    } else if (response is Failure) {
      return Error(code: response.code, message: response.errorResponse);
    }
  }

  Future<dynamic> signOut() async {
    var response = await AuthServices().signOut();
    if (response is Success) {
      rider = null;
    } else if (response is Failure) {
      return Error(code: response.code, message: response.errorResponse);
    }
  }

  Future<dynamic> getCurrentUser() async {
    Object? response = await AuthServices().currentRider();

    if (response is Success) {
      rider = response.response as Rider;
      return rider;
    } else if (response is Failure) {
      return Error(code: response.code, message: response.errorResponse);
    }
  }

  Future<void> getInitView() async {
    bool _isRegistered = await DeviceServices.instance.isRegistered();
    if (!_isRegistered) {
      initView = const RegisterDevice();
    } else {
      initView = const AuthView();
    }
  }
}
