import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rider/components/progress_dialog.dart';
import 'package:rider/services/auth_services.dart';
import 'package:rider/utils/app_theme.dart';
import 'package:rider/views/auth_view.dart';

import '../components/sign_out_dialog.dart';
import '../helpers/presence.dart';
import '../helpers/response.dart';
import '../main.dart';
import '../models/driver.dart';
import '../models/status.dart';

import '../services/driver_services.dart';
import '../views/custom_navigator.dart';

class AuthController extends GetxController {
  late final AuthServices _services;

  late final DriverServices _driverServices;

  late final Presence presence;

  late Driver? driver;

  @override
  void onInit() async {
    _services = AuthServices();
    _driverServices = DriverServices.instance;
    presence = Presence.instance;
    _authMonitor();
    super.onInit();
  }

  Future<void> signIn(String username, String password) async {
    Get.dialog(const ProgressDialog(status: 'Please wait...'),
        barrierDismissible: false);
    var response = await _services.createToken(username, password);
    if (response is Failure) {
      ResponseHelpers.showSnackbar(response.response.toString());
    }
  }

  Future<void> signOut() async {
    ResponseHelpers.showProgressDialog("Please wait...");
    Get.back();
    await Get.dialog(
      SignOutDialog(
        yes: () async {
          Status status = await _services.signOut();
          if(status is Success){
            await presence.signedOut(driver!.username);
            ResponseHelpers.showSnackbar(status.response.toString());
            RootWidget.restartApp(Get.context!);
          } else {
            ResponseHelpers.showSnackbar('Unable to sign out');
          }
        },
        no: () => Get.back(),
      ),
      barrierDismissible: false,
    );
  }

  Future<void> _authenticatedUserRoutine(String userId) async {
    bool online = await presence.checkForMultipleAuth(userId);
    if (online) {
      await _services.signOut();
      Get.showSnackbar(GetSnackBar(
          messageText: snacky(),
          duration: const Duration(seconds: 2),
          backgroundColor: Colors.transparent),
      );
      RootWidget.restartApp(Get.context!);
    } else {
      presence.updateUserPresence(userId);
      Get.offAll(() => const CustomNavigator(),
        transition: Transition.fadeIn,
        duration: const Duration(seconds: 1),
      );
    }
  }

  Future<void> _getDriverForAuthUser(String userId) async {
    Status status = await _driverServices.getCurrentDriver(id: userId);
    if (status is Success){
      driver = status.response as Driver;
      await _authenticatedUserRoutine(userId);
    } else {
      _services.signOut();
      await presence.signedOut(userId);
      ResponseHelpers.showSnackbar(status.response.toString());
      RootWidget.restartApp(Get.context!);
    }
  }

  Future<void> _authMonitor() async {
    _services.authStream().listen((User? user) async {
      if (user == null) {
        Get.offAll(
          () => AuthView(),
          transition: Transition.fadeIn,
          duration: const Duration(seconds: 1),
        );
      } else {
        await _getDriverForAuthUser(user.uid);
      }
    });
  }

  Widget snacky() => Container(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25.0),
          color: AppTheme.primaryColor,
        ),
        child: const Text("User already logged in !!!", style: TextStyle(color: AppTheme.nearlyWhite),),
      );
}
