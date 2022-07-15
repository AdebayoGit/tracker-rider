import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rider/components/progress_dialog.dart';
import 'package:rider/services/auth_services.dart';
import 'package:rider/utils/app_theme.dart';
import 'package:rider/views/auth_view.dart';

import '../helpers/presence.dart';
import '../helpers/response.dart';
import '../models/driver.dart';
import '../models/status.dart';

import '../views/custom_navigator.dart';

class AuthController extends GetxController {
  late final AuthServices _authServices;

  late final Presence presence;

  late User _user;

  late Driver driver;

  User? get user => _user;

  @override
  void onInit() async {
    _authServices = AuthServices();
    presence = Presence.instance;
    _authMonitor();
    super.onInit();
  }

  Future<dynamic> signIn(String username, String password) async {
    Get.dialog(const ProgressDialog(status: 'Please wait...'),
        barrierDismissible: false);
    var response = await _authServices.createToken(username, password);
    if (response is Success) {
      _user = response.response as User;
    } else if (response is Failure) {
      return Error(code: response.code, message: response.errorResponse);
    }
  }

  Future<dynamic> signOut() async {
    var response = await AuthServices().signOut();
    await presence.signedOut(_user.uid);
    if (response is Success) {
      ResponseHelpers.showSnackbar("Sign out successful");
    } else if (response is Failure) {
      ResponseHelpers.showSnackbar(response.errorResponse.toString());
    }
  }

  Future<void> _authenticatedUserRoutine(User user) async {
    bool online = await presence.checkForMultipleAuth(user.uid);
    if (online) {
      signOut();
      Get.showSnackbar(GetSnackBar(
          messageText: snacky(),
          duration: const Duration(seconds: 2),
          backgroundColor: Colors.transparent));
    } else {
      _user = user;
      presence.updateUserPresence(user.uid);
      Get.offAll(() => const CustomNavigator(),
        transition: Transition.fadeIn,
        duration: const Duration(seconds: 1),
      );
    }
  }

  Future<void> _authMonitor() async {
    _authServices.authStream().listen((User? user) async {

      if (user == null) {
        Get.offAll(
          () => const AuthView(),
          transition: Transition.fadeIn,
          duration: const Duration(seconds: 1),
        );
      } else {
        await _authenticatedUserRoutine(user);
      }
    });
  }

  Widget snacky() => Container(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25.0),
          color: AppTheme.primaryColor,
        ),
        child: const Text("User already logged in !!!"),
      );
}
