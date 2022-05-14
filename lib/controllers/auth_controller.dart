import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:rider/components/progress_dialog.dart';
import 'package:rider/services/auth_services.dart';
import 'package:rider/views/auth_view.dart';
import 'package:rider/views/home.dart';

import '../models/status.dart';
import '../services/device_services.dart';
import '../views/register_device_view.dart';

class AuthController extends GetxController {

  late final AuthServices _authServices;

  User? _rider;

  Error? _error;

  bool loading = false;

  User? get rider => _rider;

  Error? get error => _error;

  @override
  void onInit() async {
    _authServices = AuthServices();
    _authMonitor();
    super.onInit();
  }

  setLoading(bool loading) {
    this.loading = loading;
  }

  Future<dynamic> signIn(String username, String password) async {
    Get.dialog(const ProgressDialog(status: 'Please wait...'));
    /*var response = await AuthServices().createToken(username, password);
    if (response is Success) {
      _rider = response.response as User;
    } else if (response is Failure) {
      return Error(code: response.code, message: response.errorResponse);
    }*/
  }

  Future<dynamic> signOut() async {
    var response = await AuthServices().signOut();
    if (response is Success) {
      _rider = null;
    } else if (response is Failure) {
      return Error(code: response.code, message: response.errorResponse);
    }
  }

  Future<dynamic> getCurrentUser() async {
    Object? response = await AuthServices().currentRider();

    if (response is Success) {
      _rider = response.response as User;
      return rider;
    } else if (response is Failure) {
      return Error(code: response.code, message: response.errorResponse);
    }
  }

  Future<void> _authMonitor() async {
    _authServices.authStream().listen((User? user) async {
      if(user == null){
        bool _isRegistered = await DeviceServices.instance.isRegistered();
        if (!_isRegistered) {
          Get.offAll(() => const RegisterDevice(),
            transition: Transition.fadeIn,
            duration: const Duration(seconds: 1),
          );
        } else {
          Get.offAll(() => AuthView(),
            transition: Transition.fadeIn,
            duration: const Duration(seconds: 1),
          );
        }
      } else {
        _rider = user;
        Get.offAll(() => HomeView(),
          transition: Transition.fadeIn,
          duration: const Duration(seconds: 1),
        );
      }
    });
  }

}
